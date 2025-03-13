<!--#include virtual="/common/common.asp"-->

<%
dim msgIdx	: msgIdx	= fnIsNull(fnReq("msgIdx"), 0)

dim msgGB		: msgGB		= fnReq("msgGB")
dim cdMsgTP

if msgGB = "E" then
	cdMsgTP = 200102
elseif msgGB = "S" then
	cdMsgTP = 200301
end if

dim msgTit	: msgTit	= fnIsNull(fnReq("clTit"), "")
dim SMSMsg	: SMSMsg	= fnIsNull(fnReq("SMSMsg"), "")
dim VMSMsg	: VMSMsg	= fnIsNull(fnReq("VMSMsg"), "")
if msgGB = "S" then
	msgTit	= fnIsNull(fnReq("tit"), "")
	SMSMsg	= fnIsNull(fnReq("msg"), "")
end if

if msgIdx = 0 then
	
	sql = " insert into TBL_MSG (MSG_GB, CD_MSGTP, AD_IDX, MSG_PERMIT, MSG_SORT, MSG_TIT, MSG_SMS, MSG_VMS) "
	sql = sql & " values ('" & msgGB & "', " & cdMsgTP & ", " & ss_userIndx & ", 'N', 1, '" & msgTit & "', '" & SMSMsg & "', '" & VMSMsg & "') "
	
else
	
	sql = " update TBL_MSG set MSG_TIT = '" & msgTit & "', MSG_SMS = '" & SMSMsg & "', MSG_VMS = '" & VMSMSg & "', UPTDT = getdate() "
	sql = sql & " where MSG_IDX = " & msgIdx & " "
	
end if

if len(sql) > 0 then
	call execSql(sql)
end if

if msgIdx = 0 then
	msgIdx	= fnDBVal("TBL_MSG", "max(MSG_IDX)", "AD_IDX = " & ss_userIndx & "")
end if
%>

<script type="text/javascript">
	alert('저장되었습니다.');
	top.location.href = 'emrForm.asp?msgIdx=<%=msgIdx%>';
</script>