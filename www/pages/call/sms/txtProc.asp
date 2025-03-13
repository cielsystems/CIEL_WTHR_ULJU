<!--#include virtual="/common/common.asp"-->

<%
'#	============================================================================
dim cutSms	: cutSms	= fnIsNull(fnReq("cutSms"),"N")
dim txtGb		: txtGb		= fnReq("txtGb")
dim tmpTrg	: tmpTrg	= fnReq("tmpTrg")
dim schdYN	: schdYN	= fnIsNull(fnReq("schdYN"),"N")
dim schdDT	: schdDT	= fnReq("schdDT")
dim tit			: tit			= fnReq("tit")
dim msg			: msg			= fnReq("msg")
dim snd_num	: snd_num	= fnReq("snd_num")
'#	============================================================================


'#	============================================================================
'#	중복대상자처리 : Start
sql = " select * from ( "
if dbType = "mssql" then
	sql = sql & " 	select (select top 1 TMP_NO from TMP_CALLTRG with(nolock) where AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' and TMP_NUM1 = trg.TMP_NUM1) as NO "
elseif dbType = "mysql" then
	sql = sql & " 	select (select TMP_NO from TMP_CALLTRG with(nolock) where AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' and TMP_NUM1 = trg.TMP_NUM1 limit 0, 1) as NO "
end if
sql = sql & " 		, TMP_NUM1, count(*) as CNT from TMP_CALLTRG as trg with(nolock) where AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
sql = sql & " 	group by TMP_NUM1 "
sql = sql & " ) as tbl "
sql = sql & " where CNT > 1; "
arrRs = execSqlRs(sql)
if isarray(arrRs) then
	arrRc2 = ubound(arrRs,2)
else
	arrRc2 = -1
end if

for i = 0 to arrRc2
	sql = " delete from TMP_CALLTRG where AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' and TMP_NUM1 = '" & arrRs(1,i) & "' and TMP_NO <> " & arrRs(0,i) & " "
	call execSql(sql)
next
'#	중복대상자처리 : End
'#	===========================================================================


'#	============================================================================
dim trgCnt		: trgCnt = 0
dim msgCnt		: msgCnt = 1
dim sendCnt		: sendCnt = 0
dim myCnt			: myCnt = 0
	
dim cltsGB, clSMSSplit
dim tmpMsg	: tmpMsg = replace(msg,"<br>",Chr(13))
dim nByte		: nByte = 0

dim splitYN : splitYN = cutSms

arrRs = execProcRs("usp_listTmpFile", array(0, ss_userIdx, svr_remoteAddr, "S", 1, 999999))
if isarray(arrRs) then
	arrRc2 = ubound(arrRs,2)
else
	arrRc2 = -1
end if

'#	============================================================================
'#	전송건수 확인 : Start

cltsGB = "S"
arrRs = execProcRs("usp_listTmpFile", array(0, ss_userIdx, svr_remoteAddr, "S", 1, 999999))
if isarray(arrRs) then
	arrRc2 = ubound(arrRs,2)
else
	arrRc2 = -1
end if

if arrRc2 > -1 then
	cltsGB = "M"
elseif fnByte(tmpMsg) > 90 then
	cltsGB = "L"
else
	cltsGB = "S"
end if

clSMSSplit = 0
dim nChr, tmpByte, splitMsg

dim msgByte	: msgByte	= fnByte(tmpMsg)

'#	140바이트
dim splitCnt	: splitCnt	= cstr(msgByte / 2000)
splitCnt = -(int(-(splitCnt)))

redim splitMsg(splitCnt)

for i = 1 to len(tmpMsg)
	nChr = mid(tmpMsg,i,1)
	if inStrRev(server.URLEncode(nChr),"%") > 1 then
		tmpByte = 2
	elseif asc(nChr) > 0 and asc(nChr) < 255 then
		tmpByte = 1
	else
		tmpByte = 2
	end if
	'response.write	clSMSSplit & ":" & nChr & "(" & nByte & ") = " & splitMsg(clSMSSplit) & "<br />"
	if nByte + tmpByte < 2001 then
		splitMsg(clSMSSplit) = splitMsg(clSMSSplit) & nChr
		nByte = nByte + tmpByte
	else
		clSMSSplit = clSMSSplit + 1
		nByte = tmpByte
		splitMsg(clSMSSplit) = splitMsg(clSMSSplit) & nChr
	end if
next

msgCnt = clSMSSplit + 1

sql = " select count(*) from TMP_CALLTRG as tmp left join NTBL_ADDR as ad on (tmp.TMP_IDX = ad.ADDR_INDX) "
sql = sql & " where tmp.AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'  "
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
trgCnt = clng(rs(0))
rsClose()

sendCnt = trgCnt * msgCnt


'#	전송건수 확인 : End
'#	============================================================================


'#	============================================================================
'#	사용가능건수 확인 : Start
sql = " select dbo.ufn_getUserCntAll(" & ss_userIdx & ",'" & cltsGB & "'), dbo.ufn_getUserCntUse(" & ss_userIdx & ",'" & cltsGB & "') "
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
myCnt = clng(rs(0)) - clng(rs(1))
rsClose()
'#	사용가능건수 확인 : End
'#	============================================================================


'#	============================================================================
if smsUseCntYN = "Y" and myCnt < sendCnt then
	
	'#	============================================================================
	'#	사용가능건수가 전송건수보다 작으면
	'#	============================================================================
	response.write	"<script>alert('사용가능한 " & cltsGB & "MS 건수가 부족합니다.\n(사용가능건수:" & myCnt & " / 보낼건수:" & sendCnt & ")');parent.fnLoadingE();</script>"
	'#	============================================================================
	
else
	
	dim n_schdDT : n_schdDT = schdDT : if n_schdDT = "" then n_schdDT = fnDateToStr(now, "yyyy-mm-dd hh:nn:ss") end if
	dim n_method : n_method = "111"
	dim n_try : n_try = 3
	
	'#	============================================================================
	'#	사용가능건수가 전송건수보다 크거나 같으면
	'#	============================================================================
	'#	전송 기본정보 생성
	
	dim clUpIdx : clUpIdx = 0
	dim msgIdx : msgIdx = 0
	dim clGB : clGB = "S"
	dim clMethod : clMethod = 1
	dim clTry : clTry = 3
	dim clRsvYN : clRsvYN = schdYN
	dim clRsvDT : clRsvDT = n_schdDT
	dim clMedia1 : clMedia1 = 1
	dim clMedia2 : clMedia2 = 0
	dim clMedia3 : clMedia3 = 0
	dim clSMS : clSMS = "1"
	dim clVMS : clVMS = "0"
	dim clFMS : clFMS = "0"
	dim clSndNum1 : clSndNum1 = snd_num
	dim clSndNum2 : clSndNum2 = snd_num
	dim clSndNum3 : clSndNum3 = ""
	dim clTit : clTit = tit
	dim clSMSMsg : clSMSMsg = msg
	dim clVMSMsg : clVMSMsg = ""
	dim clVMSPlay : clVMSPlay = 0
	dim clARSAnswTime : clArsAnswTime = 0
	dim TTS_pitch : TTS_pitch = 0
	dim TTS_speed : TTS_speed = 0
	dim TTS_volume : TTS_volume = 0
	dim TTS_sformat : TTS_sformat = 0
	
	dim clCode
	if dbType = "mssql" then
		clCode = fnDBVal("TBL_CALL","count(*)","convert(varchar(10),CL_RSVDT,121) = '" & fnDateToStr(now,"yyyy-mm-dd") & "' and CL_GB = '" & clGB & "'")
	elseif dbType = "mysql" then
		clCode = fnDBVal("TBL_CALL","count(*)","convert(CL_RSVDT, char(10)) = '" & fnDateToStr(now,"yyyy-mm-dd") & "' and CL_GB = '" & clGB & "'")
	end if
	clCode = clng(clCode) + 1
	clCode = right("00" & clCode,3)
	clCode = "SMSyymmdd" & clCode
	clCode = fnDateToStr(clRsvDT,clCode)
	
	'#	============================================================================
	'#	사용가능건수가 전송건수보다 크거나 같으면
	'#	============================================================================
	'#	전송 기본정보 생성
	sql = " insert into TBL_CALL ( "
	sql = sql & " 	CL_UPIDX, CL_CODE, AD_IDX, MSG_IDX, CL_GB, CL_METHOD, CL_TRY1, CL_RSVYN, CL_RSVDT "
	sql = sql & " 	, CL_MEDIA1, CL_MEDIA2, CL_MEDIA3, CL_SMSGB, CL_VMSGB, CL_FMSGB, CL_SNDNUM1, CL_SNDNUM2, CL_SNDNUM3 "
	sql = sql & " 	, CL_TIT, CL_SMSMSG, CL_VMSMSG, CL_FMSMSG, CL_SMSSPLIT, CL_VMSPLAY, CL_ARSANSWYN, CL_ARSANSWTIME, CL_STEP "
	sql = sql & " 	, CL_TTSPITCH, CL_TTSSPEED, CL_TTSVOLUME, CL_TTSFORMAT "
	sql = sql & " ) values ( "
	sql = sql & " 	" & clUpIdx & ", '" & clCode & "', " & ss_userIdx & ", " & msgIdx & ", '" & clGB & "', " & clMethod & ", " & clTry & ", '" & clRsvYN & "', '" & clRsvDT & "' "
	sql = sql & " 	, '" & clMedia1 & "', '" & clMedia2 & "', '" & clMedia3 & "', '" & clSMS & "', '" & clVMS & "', '" & clFMS & "', '" & clSndNum1 & "', '" & clSndNum2 & "', '" & clSndNum3 & "' "
	sql = sql & " 	, '" & clTit & "', '" & clSMSMsg & "', '" & clVMSMsg & "', '', " & clSMSSplit & ", " & clVMSPlay & ", 'N', " & clARSAnswTime & ", 0 "
	sql = sql & " 	, '" & TTS_pitch & "', '" & TTS_speed & "', '" & TTS_volume & "', '" & TTS_sformat & "' "
	sql = sql & " ) "
	call execSql(sql)
	
	dim clIdx
	if dbType = "mssql" then
		clIdx = fnDBVal("TBL_CALL", "top 1 CL_IDX", "AD_IDX = " & ss_userIdx & " and CL_GB = '" & clGB & "' and CL_TIT = '" & clTit & "' order by CL_IDX desc")
	elseif dbType = "mysql" then
		clIdx = fnDBVal("TBL_CALL", "CL_IDX", "AD_IDX = " & ss_userIdx & " and CL_GB = '" & clGB & "' and CL_TIT = '" & clTit & "' order by CL_IDX desc limit 0, 1")
	end if
	
	'#	File
	sql = " insert into TBL_CALLFILE (CL_IDX, CLF_GB, CLF_NO, CLF_SORT, CLF_DPNM, CLF_PATH, CLF_FILE, CLF_PAGE) "
	sql = sql & " select " & clIdx & ", TMP_GB, TMP_NO, TMP_SORT, TMP_DPNM, TMP_PATH, TMP_FILE, TMP_PAGE "
	sql = sql & " from TMP_CALLFILE with(nolock) where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
	call execSql(sql)
	
	'#	Target
	sql = " insert into TBL_CALLTRG (CL_IDX, CLT_NO, CLT_SORT, AD_IDX, CLT_NM, CLT_NUM1, CLT_NUM2, CLT_NUM3, CLT_TIT, CLT_SMSMSG, CLT_VMSMSG, CLT_FMSMSG, CLT_SVRID) "
	sql = sql & " select " & clIdx & ", TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM" & clMedia1 & " "
	if cint(clMedia2) > 0 then		'=	2차전송매체를 선택한 경우
		sql = sql & ", TMP_NUM" & clMedia2
	else
		sql = sql & ", '' "
	end if
	if cint(clMedia3) > 0 then		'= 3차전송매체를 선택한 경우
		sql = sql & ", TMP_NUM" & clMedia3
	else
		sql = sql & ", '' "
	end if
	sql = sql & " , '" & clTit & "', '" & clSMSMsg & "', '" & clVMSMsg & "', '', (TMP_NO % 3) + 1  "
	sql = sql & " from TMP_CALLTRG with(nolock) where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
	call execSql(sql)
	
	'#	임시 대상자 및 파일 삭제
	call execProc("usp_delTmpTrg",array(0, ss_userIdx, svr_remoteAddr))
	call execProc("usp_delTmpFile",array(0, ss_userIdx, svr_remoteAddr))
	
	dim cdStatus
	
	'#	==========================================================================
	'#	대상처리
	
	'#	==========================================================================
	'#	기본 140바이트
	
	clSMSSplit = 0
	nByte = 0
	splitCnt	= cstr(msgByte / 2000)
	splitCnt = -(int(-(splitCnt)))
	
	redim splitMsg(splitCnt)
	for i = 1 to len(tmpMsg)
		nChr = mid(tmpMsg,i,1)
		if inStrRev(server.URLEncode(nChr),"%") > 1 then
			tmpByte = 2
		elseif asc(nChr) > 0 and asc(nChr) < 255 then
			tmpByte = 1
		else
			tmpByte = 2
		end if
		'response.write	"<div>" & nChr & "(" & asc(nChr) & "/" & nByte & "):" & splitMsg(clSMSSplit) & "(" & fnByte(splitMsg(clSMSSplit)) & ")</div>"
		if nByte + tmpByte < 2001 then
			splitMsg(clSMSSplit) = splitMsg(clSMSSplit) & nChr
			nByte = nByte + tmpByte
		else
			clSMSSplit = clSMSSplit + 1
			nByte = tmpByte
			splitMsg(clSMSSplit) = splitMsg(clSMSSplit) & nChr
		end if
	next
	
	dim splitRsvDT	: splitRsvDT	= clRsvDT
	
	'response.write	clSMSSplit & "/" & fnByte(tmpMsg)
	
	for i = 0 to clSMSSplit
		
		if i > 0 then
			splitRsvDT	= dateAdd("s", 20, splitRsvDT)	'= 분할전송시 20초 씩 대기시간추가
		end if
		
		'#	==========================================================================
		sql = " insert into TBL_CALLTRG_SMS (CL_IDX, CLT_NO, CLT_SORT, CLTS_GB, CLTS_RSVDT, CLTS_SNDNUM, CLTS_RCVNUM, CLTS_TIT, CLTS_MSG, CLTS_STATUS, CD_STATUS, CD_RESULT, CD_ERROR, CLTS_SPLITNO) "
		sql = sql & " select CL_IDX, CLT_NO, CLT_SORT, '" & cltsGB & "'  "
		if clSMS = "1" then				'= 문자를 1차로 전송할 경우
				cdStatus = 3031
			sql = sql & "		, '" & fnDateToStr(splitRsvDT,"yyyy-mm-dd hh:nn:ss") & "' "
		elseif clSMS = "2" then		'= 문자를 2차로 전송할 경우(음성미응답자 문자전송의 경우) : 10시간을 추가하고 음성전송이 완료된 시점에 시간을 업데이트 해주어 음성전송 완료시 바로 전송되도록한다.
			cdStatus = 3030
			sql = sql & "		, '" & fnDateToStr(dateadd("d",1,splitRsvDT),"yyyy-mm-dd hh:nn:ss") & "' "
		end if
		sql = sql & " 	, '" & clSndNum1 & "', CLT_NUM1, CLT_TIT, '" & splitMsg(i) & "', 0, " & cdStatus & ", 9001, 0 , " & i+1 & " "
		sql = sql & " from TBL_CALLTRG as clt left join NTBL_ADDR as ad on (clt.AD_IDX = ad.ADDR_INDX) "
		sql = sql & " where CL_IDX = " & clIdx & " "
		'#	==========================================================================
		
		response.write	"<div><h2>Insert TBL_CALLTRG_SMS : 140</h2><div>" & sql & "</div></div>"
		call execSql(sql)
			
	next
	'#	==========================================================================
	
		
	'#	Web에서 전송시 문자일괄전송 [2016.08.30|오태근]
	'if ss_userIdx = 1 then
		response.write	"exec usp_SMSSetNuri " & clIDx & ""
		call execProc("usp_SMSSetNuri", array(clIdx))
	'end if
	
	sql = " update TBL_CALL set CL_STEP = 1 where CL_IDX = " & clIdx & " "
	response.write	sql
	call execSql(sql)
	
	dim resultUrl
	dim strLogTit, strLogMsg
	resultUrl = "smsList"
	strLogTit = "문자전송요청 <" & clTit & ">"
	
	strLogMsg = "Code : " & clCode
	call subSetLog(ss_userIdx, 8002, strLogTit, strLogMsg, "")
	'#	============================================================================
	
	response.write	"<script>alert('중복번호를 제외한 총 " & sendCnt & "건 전송요청완료!');top.location.reload();</script>"
	
end if
'#	============================================================================
%>