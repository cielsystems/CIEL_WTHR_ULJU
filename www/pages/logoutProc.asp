<!--#include virtual="/common/common.asp"-->

<%
dim gb : gb = fnReq("gb")

'sql = " update TBL_LIVE set OUT_DT = getdate() where AD_IDX = " & ss_userIdx & " and IN_IP = '" & svr_remoteAddr & "' and OUT_DT is null "
'call execSql(sql)

if ss_userIdx <> "" then
	call subSetLog(ss_userIdx, 8001, ss_userId & "(" & ss_userNm & ")님 로그아웃", "", "")
end if

response.cookies("ss_userIdx") = ""
response.cookies("ss_userId") = ""
response.cookies("ss_userNm") = ""

session.abandon
%>

<script>
	<% if gb = "adm" then %>
		top.opener.location.reload();
		top.window.close()
	<% else %>
		top.location.href = '/pages/loginForm.asp';
	<% end if %>
</script>