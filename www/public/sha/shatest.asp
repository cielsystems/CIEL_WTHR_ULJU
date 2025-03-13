<!--#include file="sha256.asp"-->

<%
dim strVal : strVal = request.form("strVal")
dim strSha
if len(strVal) > 0 then
	strSha = sha256(strVal)
end if
%>

<html>
<body>
	<form name="frm" method="post" action="" target="">
		<textarea name="strVal" rows="5" cols="50"><%=strVal%></textarea>
		<input type="submit" />
		<textarea name="strSha" rows="5" cols="50"><%=strSha%></textarea>
	</form>
</body>
</html>