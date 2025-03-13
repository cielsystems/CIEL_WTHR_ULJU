<!--#include virtual="/common/common.asp"-->

<%
dim gb : gb = fnReq("gb")

dim tit	: tit	= fnReq("tit")
dim msg	: msg	= fnReq("SMSMsg")
dim sndNum	: sndNum	= fnReq("sndNum")

if gb = "1" then
	
	sql = " update TMP_MCRTRG set TMP_GB = (case when datalength(TMP_MSG) > 80 then 'L' else 'S' end) "
	sql = sql & " 	, TMP_CMPTIT = TMP_TIT, TMP_CMPMSG = TMP_MSG "
	sql = sql & " where AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
	call execSql(sql)
	
elseif gb = "2" then
	
	function fnReplaceMcr(strVal, mcrNm, mcrNum, mcr1, mcr2, mcr3)
		
		dim tmp	: tmp	= strVal
		
		if isnull(tmp) = false then
			tmp = replace(tmp, "$Name", mcrNm)
			tmp = replace(tmp, "$Number", mcrNum)
			tmp = replace(tmp, "$1", mcr1)
			tmp = replace(tmp, "$2", mcr2)
			tmp = replace(tmp, "$3", mcr3)
		else
			tmp = ""
		end if
		
		fnReplaceMcr = tmp
		
	end function
	
	sql = " select TMP_NO, TMP_NM, TMP_NUM, TMP_MCRVAL1, TMP_MCRVAL2, TMP_MCRVAL3 from TMP_MCRTRG with(nolock) where AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
	cmdOpen(sql)
	set rs = cmd.execute
	cmdClose()
	if not rs.eof then
		arrRs = rs.getRows
		arrRc2 = ubound(arrRs,2)
	else
		arrRc2 = -1
	end if
	rsClose()
	
	dim tmpTit, tmpMsg, tmpGB
	
	for i = 0 to arrRc2
		
		tmpTit = fnReplaceMcr(tit, arrRs(1,i), arrRs(2,i), arrRs(3,i), arrRs(4,i), arrRs(5,i))
		tmpMsg = fnReplaceMcr(msg, arrRs(1,i), arrRs(2,i), arrRs(3,i), arrRs(4,i), arrRs(5,i))
		
		sql = " update TMP_MCRTRG set TMP_CMPTIT = '" & tmpTit & "', TMP_CMPMSG = '" & tmpMsg & "', TMP_GB = '" & tmpGB & "' where AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' and TMP_NO = " & arrRs(0,i) & " "
		call execSql(sql)
		
	next
	
end if

dim clRsvDT : clRsvDT = fnDateToStr(now, "yyyy-mm-dd hh:nn:ss")

dim clCode
clCode = fnDBVal("TBL_CALL","count(*)","convert(varchar(10),CL_RSVDT,121) = '" & fnDateToStr(now,"yyyy-mm-dd") & "' and CL_GB = 'S'")
clCode = clng(clCode) + 1
clCode = right("00" & clCode,3)
clCode = "SMSyymmdd" & clCode
clCode = fnDateToStr(clRsvDT,clCode)

'#	전송 기본정보 생성
sql = " insert into TBL_CALL ( "
sql = sql & " 	CL_UPIDX, CL_CODE, AD_IDX, MSG_IDX, CL_GB, CL_METHOD, CL_TRY1, CL_RSVYN, CL_RSVDT "
sql = sql & " 	, CL_MEDIA1, CL_MEDIA2, CL_MEDIA3, CL_SMSGB, CL_VMSGB, CL_FMSGB, CL_SNDNUM1, CL_SNDNUM2, CL_SNDNUM3 "
sql = sql & " 	, CL_TIT, CL_SMSMSG, CL_VMSMSG, CL_FMSMSG, CL_SMSSPLIT, CL_VMSPLAY, CL_ARSANSWYN, CL_ARSANSWTIME, CL_STEP "
sql = sql & " 	, CL_TTSPITCH, CL_TTSSPEED, CL_TTSVOLUME, CL_TTSFORMAT "
sql = sql & " ) values ( "
sql = sql & " 	0, '" & clCode & "', " & ss_userIdx & ", 0, 'S', 1, 1, 'N', '" & clRsvDT & "' "
sql = sql & " 	, 1, 0, 0, '1', '0', '0', '" & sndNum & "', '" & sndNum & "', '" & sndNum & "' "
sql = sql & " 	, '" & tit & "', '" & msg & "', '', '', 0, 0, 'N', 0, 0 "
sql = sql & " 	, '0', '0', '0', '0' "
sql = sql & " ) "
call execSql(sql)

dim clIdx
clIdx = fnDBVal("TBL_CALL", "top 1 CL_IDX", "AD_IDX = " & ss_userIdx & " and CL_GB = 'S' and CL_TIT = '" & tit & "' order by CL_IDX desc")

sql = " insert into TBL_CALLTRG (CL_IDX, CLT_NO, CLT_SORT, AD_IDX, CLT_NM, CLT_NUM1, CLT_NUM2, CLT_NUM3, CLT_TIT, CLT_SMSMSG, CLT_VMSMSG, CLT_FMSMSG, CLT_SMSGB) "
sql = sql & " select " & clIdx & ", TMP_NO, TMP_NO, 0, TMP_NM, TMP_NUM, '', '', TMP_CMPTIT, TMP_CMPMSG, '', '', TMP_GB "
sql = sql & " from TMP_MCRTRG with(nolock) where AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
call execSql(sql)

sql = " delete from TMP_MCRTRG where AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
call execSql(sql)

sql = sql & " insert into TBL_CALLTRG_SMS (CL_IDX, CLT_NO, CLT_SORT, CLTS_GB, CLTS_RSVDT, CLTS_SNDNUM, CLTS_RCVNUM, CLTS_TIT, CLTS_MSG, CLTS_STATUS, CD_STATUS, CD_RESULT, CD_ERROR) "
sql = sql & " select CL_IDX, CLT_NO, CLT_SORT, CLT_SMSGB, '" & clRsvDT & "', '" & sndNum & "',  CLT_NUM1, CLT_TIT, CLT_SMSMSG, 0, 3031, 9001, 0 "
sql = sql & " from TBL_CALLTRG with(nolock) "
sql = sql & " where CL_IDX = " & clIdx & " "
call execSql(sql)

'#	Web에서 전송시 문자일괄전송 [2016.08.30|오태근]
'if ss_userIdx = 1 then
	call execProc("usp_SMSSetNuri", array(clIdx))
'end if

sql = " update TBL_CALL set CL_STEP = 1 where CL_IDX = " & clIdx & " "
call execSql(sql)

dim sendCnt	: sendCnt = fnDBVal("TBL_CALLTRG_SMS","count(*)","CL_IDX = " & clIdx & "")

dim resultUrl
dim strLogTit, strLogMsg
resultUrl = "smsList"
strLogTit = "대량문자전송요청 <" & tit & ">"

strLogMsg = "Code : " & clCode
call subSetLog(ss_userIdx, 8002, strLogTit, strLogMsg, "")
'#	============================================================================

response.write	"<script>alert('총 " & sendCnt & "건 전송요청완료!');top.location.reload();</script>"
%>