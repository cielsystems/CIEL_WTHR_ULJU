<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/public/sha/sha256.asp"-->

<%
sql = " select "
sql = sql & " 	USERID, PERMIT "
sql = sql & " from users "
response.write	"<div>" & sql & "</div>"
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

dim cdUserGB, adPW, adPerEmr

for i = 0 to arrRc2
	
	if len(arrRs(1,i)) > 0 then
		cdUserGB  = 1005
		adPerEmr = "Y"
	else
		cdUserGB = 1009
		adPerEmr = "N"
	end if
	
	adPw = sha256(g_dftUserPass)
	
	sql = " insert into TBL_ADDR ( "
	sql = sql & " 	AD_GB, CD_USERGB, GRP_CODE, AD_ID, AD_PW, AD_NM "
	sql = sql & " 	, AD_PERADDR, AD_PEREMR, AD_PERSMS "
	sql = sql & " ) values ('U', " & cdUserGB & ", 1, '" & arrRs(0, i) & "', '" & adPW & "', '" & arrRs(0,i) & "' "
	sql = sql & " 	, 'M', '" & adPerEmr & "', 'Y' "
	sql = sql & " ) "
	response.write	"<div>" & sql & "</div>"
	call execSql(sql)
	
next
%>