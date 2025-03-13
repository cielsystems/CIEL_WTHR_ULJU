<!--#include virtual="/common/common.asp"-->

<%
dim proc : proc = fnReq("proc")
dim no : no = fnReq("no")
dim gb

if proc = "smsMsg" then
	
	sql = " delete from TMP_MSGFILE where AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' and TMP_GB = 'S' and TMP_NO = " & no & " "
	call execSql(sql)
	
else
	
	select case proc
		case "vms"	: gb = "V"
		case "sms"	: gb = "S"
		case "fms"	: gb = "F"
	end select
	
	sql = " delete from TMP_CALLFILE where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' and TMP_GB = '" & gb & "' and TMP_NO = " & no & " "
	call execSql(sql)
	
end if
	
proc = uCase(left(proc,3))

response.write	"<script>"
response.write	"	top.fn" & proc & "LoadFile();"
response.write	"</script>"
%>