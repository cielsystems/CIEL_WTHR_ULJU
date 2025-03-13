<!--#include virtual="/common/common.asp"-->

<%
dim proc : proc = fnReq("proc")

dim msgIdx		: msgIdx		= fnIsNull(fnReq("msgIdx"),0)
dim cdMsgTP1	: cdMsgTP1	= fnReq("cdMsgTP1")
dim cdMsgTP2	: cdMsgTP2	= fnReq("cdMsgTP2")
dim msgPermit	: msgPermit	= fnIsNull(fnReq("msgPermit"),"N")
dim msgTit		: msgTit		= fnReq("msgTit")
dim msgVMS		: msgVMS		= fnReq("VMSMsg")
dim msgSMS		: msgSMS		= fnReq("SMSMsg")
dim msgFMS		: msgFMS		= fnReq("FMSMsg")

dim msgGB
select case cdMsgTP1
	case 2001 : msgGB = "E"
	case 2002 : msgGB = "A"
	case 2003 : msgGB = "N"
end select

dim gb				: gb				= fnReq("gb")
dim no				: no				= fnReq("no")

response.write	"<script>"

if proc = "F" then
	
	sql = " delete from TMP_MSGFILE where AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' and TMP_GB = '" & gb & "' and TMP_NO = " & no & " "
	call execSql(sql)
	
	call subSetLog(ss_userIdx, 8003, "메시지 파일삭제", "", "")
	
	response.write	"	top.fn" & uCase(gb) & "MSLoadFile();"
	
else
	
	call execProc("usp_setMsg", array(proc, msgIdx, msgGB, cdMsgTP2, msgPermit, 0, "", msgTit, msgSMS, msgVMS, msgFMS, ss_userIdx, svr_remoteAddr))
	
	call subSetLog(ss_userIdx, 8003, "메시지관리 <" & msgTit & ">", msgIdx, "")
	
	response.write	"	alert('처리되었습니다.');"
	response.write	"	top.location.href = 'msgList.asp';"
	
end if

response.write	"</script>"
%>