<!--#include virtual="/common/common.asp"-->

<%
dim clGB : clGB = fnReq("clGB")
dim msgIdx : msgIdx = fnReq("msgIdx")

dim SMSYN : SMSYN = "N"
dim VMSYN : VMSYN = "N"
if clGB = "E" then
	SMSYN = "Y"
	VMSYN = "Y"
elseif clGB = "S" then
	SMSYN = "Y"
elseif clGB = "V" then
	VMSYN = "Y"
end if

dim SMSMsg, VMSMsg

'#	메시지 내용 불러오기
sql = " select MSG_SMS, MSG_VMS from TBL_MSG with(nolock) where MSG_IDX = " & msgIdx & " "
dim msgInfo : msgInfo = execSqlArrVal(sql)
if isarray(msgInfo) then
	SMSMsg = msgInfo(0)
	VMSMsg = msgInfo(1)
end if

'#	메시지 파일을 임시파일에 추가
dim tmpNo : tmpNo = fnDBMax("TMP_CALLFILE","TMP_NO","CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
dim tmpSort : tmpSort = fnDBMax("TMP_CALLFILE","TMP_SORT","CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
tmpNo = cint(tmpNo) + 1
tmpSort = cint(tmpSort) + 1

sql = " insert into TMP_CALLFILE (CL_IDX, AD_IDX, AD_IP, TMP_GB, TMP_NO, TMP_SORT, TMP_DPNM, TMP_PATH, TMP_FILE, TMP_PAGE) "
sql = sql & " select 0, " & ss_userIdx & ", '" & svr_remoteAddr & "', MSGF_GB, MSGF_NO + " & tmpNo & ", MSGF_SORT + " & tmpSort & ", MSGF_DPNM, MSGF_PATH, MSGF_FILE, MSGF_PAGE "
sql = sql & " from TBL_MSGFILE with(nolock) "
sql = sql & " where MSG_IDX = " & msgIdx & " "
call execSql(sql)
%>

<script>
	<% if SMSYN = "Y" then %>
		top.fnSMSLoadFile();
		top.fnSetSMSMsg('<%=replace(SMSMsg,chr(13)&chr(10),"\n")%>');
	<% end if %>
	<% if VMSYN = "Y" then %>
		top.fnVMSLoadFile();
		top.fnSetVMSMsg('<%=replace(VMSMsg,chr(13)&chr(10),"\n")%>');
	<% end if %>
	top.fnCloseLayer();
</script>