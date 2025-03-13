<!--#include virtual="/common/common.asp"-->

<%
'#	============================================================================
dim tmpTrg : tmpTrg = fnReq("tmpTrg")
dim schdYN : schdYN = fnIsNull(fnReq("schdYN"),"N")
dim schdDT : schdDT = fnReq("schdDT") : if schdYN = "N" or schdDT = "" then schdDT = fnDateToStr(now,"yyyy-mm-dd hh:nn:ss") end if
dim tit : tit = fnReq("tit")
dim msg : msg = fnReq("msg")
dim snd_num : snd_num = fnReq("snd_num")


'#	============================================================================
'#	중복대상자처리 : Start
sql = " select * from ( "
if dbType = "mssql" then
	sql = sql & " 	select (select top 1 TMP_NO from TMP_CALLTRG with(nolock) where AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' and TMP_NUM1 = trg.TMP_NUM1) as NO "
elseif dbType = "mysql" then
	sql = sql & " 	select (select TMP_NO from TMP_CALLTRG with(nolock) where AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' and TMP_NUM1 = trg.TMP_NUM1 limit 0, 1) as NO "
end if
sql = sql & " 		, TMP_NUM1 as TMP_NUM1, count(*) as CNT from TMP_CALLTRG as trg with(nolock) where AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
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

'#	전송 기본정보 생성
dim clGB : clGB = "V"
dim clUpIdx : clUpIdx = 0
dim msgIdx : msgIdx = 0
dim clMethod : clMethod = 0
dim clTry : clTry = 1
dim clRsvYN : clRsvYN = schdYN
dim clRsvDT : clRsvDT = schdDT
dim clMedia1 : clMedia1 = 1
dim clMedia2 : clMedia2 = 0
dim clMedia3 : clMedia3 = 0
dim clSMS : clSMS = "0"
dim clVMS : clVMS = "1"
dim clFMS : clFMS = "0"
dim clSndNum1 : clSndNum1 = snd_num
dim clSndNum2 : clSndNum2 = ""
dim clSndNum3 : clSndNum3 = ""
dim clTit : clTit = tit
dim clSMSMsg : clSMSMsg = ""
dim clVMSMsg : clVMSMsg = msg
dim clVMSPlay : clVMSPlay = dftVMSPlay
dim clARSAnswTime : clArsAnswTime = 0
dim	TTS_pitch			:	TTS_pitch			=	fnReq("TTS_pitch")		: if TTS_pitch = "" then TTS_pitch = dftTTSPitch end if
dim	TTS_speed			:	TTS_speed			=	fnReq("TTS_speed")		: if TTS_speed = "" then TTS_speed = dftTTSSpeed end if
dim	TTS_volume		:	TTS_volume		=	fnReq("TTS_volume")		: if TTS_volume = "" then TTS_volume = dftTTSVolume end if
dim	TTS_sformat		:	TTS_sformat		=	fnReq("TTS_sformat")	: if TTS_sformat = "" then TTS_sformat = dftTTSFormat end if

dim clCode
if dbType = "mssql" then
	clCode = fnDBVal("TBL_CALL","count(*)","convert(varchar(10),CL_RSVDT,121) = '" & fnDateToStr(now,"yyyy-mm-dd") & "' and CL_GB = '" & clGB & "'")
elseif dbType = "mysql" then
	clCode = fnDBVal("TBL_CALL","count(*)","convert(CL_RSVDT, char(10)) = '" & fnDateToStr(now,"yyyy-mm-dd") & "' and CL_GB = '" & clGB & "'")
end if
clCode = clng(clCode) + 1
clCode = right("00" & clCode,3)
clCode = "VMSyymmdd" & clCode
clCode = fnDateToStr(clRsvDT,clCode)

'#	전송 기본정보 생성
sql = " insert into TBL_CALL ( "
sql = sql & " 	CL_UPIDX, CL_CODE, AD_IDX, MSG_IDX, CL_GB, CL_METHOD, CL_TRY1, CL_RSVYN, CL_RSVDT "
sql = sql & " 	, CL_MEDIA1, CL_MEDIA2, CL_MEDIA3, CL_SMSGB, CL_VMSGB, CL_FMSGB, CL_SNDNUM1, CL_SNDNUM2, CL_SNDNUM3 "
sql = sql & " 	, CL_TIT, CL_SMSMSG, CL_VMSMSG, CL_FMSMSG, CL_SMSSPLIT, CL_VMSPLAY, CL_ARSANSWYN, CL_ARSANSWTIME, CL_STEP "
sql = sql & " 	, CL_TTSPITCH, CL_TTSSPEED, CL_TTSVOLUME, CL_TTSFORMAT "
sql = sql & " ) values ( "
sql = sql & " 	" & clUpIdx & ", '" & clCode & "', " & ss_userIdx & ", " & msgIdx & ", '" & clGB & "', " & clMethod & ", " & clTry & ", '" & clRsvYN & "', '" & clRsvDT & "' "
sql = sql & " 	, '" & clMedia1 & "', '" & clMedia2 & "', '" & clMedia3 & "', '" & clSMS & "', '" & clVMS & "', '" & clFMS & "', '" & clSndNum1 & "', '" & clSndNum2 & "', '" & clSndNum3 & "' "
sql = sql & " 	, '" & clTit & "', '" & clSMSMsg & "', '" & clVMSMsg & "', '', 0, " & clVMSPlay & ", 'N', " & clARSAnswTime & ", 0 "
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
sql = sql & " from TMP_CALLFILE where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
call execSql(sql)

'#	Target
sql = " insert into TBL_CALLTRG (CL_IDX, CLT_NO, CLT_SORT, AD_IDX, CLT_NM, CLT_NUM1, CLT_NUM2, CLT_NUM3, CLT_TIT, CLT_SMSMSG, CLT_VMSMSG, CLT_FMSMSG, CLT_SVRID) "
sql = sql & " select " & clIdx & ", TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM" & clMedia1 & ", '', '', '" & clTit & "', '', '" & clVMSMsg & "', '', 1 "
sql = sql & " from TMP_CALLTRG where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
call execSql(sql)

'#	임시 대상자 및 파일 삭제
call execProc("usp_delTmpTrg",array(0, ss_userIdx, svr_remoteAddr))
call execProc("usp_delTmpFile",array(0, ss_userIdx, svr_remoteAddr))

dim cdStatus

dim vmsMediaCnt : vmsMediaCnt = 1

clVMSMsg = replace(clVMSMsg,"<br>"," ")

dim ttsFile : ttsFile = fnCreateTTS("/TTS", clCode, clVMSMsg, TTS_pitch, TTS_speed, TTS_volume, TTS_sformat, 2)
dim ttsFileWav : ttsFileWav = fnCreateTTS("/TTS/wav", clCode, clVMSMsg, TTS_pitch, TTS_speed, TTS_volume, 545, 2)

for i = 1 to vmsMediaCnt
	
	for ii = 1 to clTry
		
		if i = 1 and ii = 1 then
			cdStatus = 3031
		else
			cdStatus = 3030
		end if
		
		sql = " insert into TBL_CALLTRG_VMS (CL_IDX, CLT_NO, CLT_SORT, CLTV_RSVDT, CLTV_MEDIA, CLTV_TRY, CLTV_NUM, CLTV_STATUS, CD_STATUS, CD_RESULT, CD_ERROR, CLTV_NO) "
		sql = sql & " select CL_IDX, CLT_NO, CLT_SORT, '" & clRsvDT & "', " & i & ", " & ii & ", CLT_NUM1, 0, " & cdStatus & ", 9001, 0, " & (clTry * (i-1) + ii) & " "
		sql = sql & " from TBL_CALLTRG with(nolock) where CL_IDX = " & clIdx & " and CLT_NUM1 is not null "
		response.write	sql
		call execSql(sql)
		
	next
	
next

sql = " update TBL_CALL set CL_STEP = 1 where CL_IDX = " & clIdx & " "
call execSql(sql)

dim resultUrl
dim strLogTit, strLogMsg
resultUrl = "vmsList"
strLogTit = "음성전송요청 <" & clTit & ">"

strLogMsg = "Code : " & clCode
call subSetLog(ss_userIdx, 8002, strLogTit, strLogMsg, "")
'#	============================================================================

response.write	"<script>alert('전송요청이 완료되었습니다.');top.location.reload();</script>"
%>