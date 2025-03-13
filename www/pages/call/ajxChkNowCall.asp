<!--#include virtual="/common/common.asp"-->

<%
dim rsvYN	: rsvYN	= fnReq("rsvYN")
dim rsvDate	: rsvDate	= fnReq("rsvDate")
dim rsvHH	: rsvHH	= fnReq("rsvHH")
dim rsvNN	: rsvNN	= fnReq("rsvNN")

dim rsvDT
if rsvYN = "Y" then
	rsvDT	= rsvDate & " " & right("0" & rsvHH, 2) & ":" & right("0" & rsvNN, 2) & ":00"
else
	rsvDT = fnDateToStr(now, "yyyy-mm-dd hh:nn:ss")
end if

dim strMsg

sql = " select dbo.ufn_getNowCall(" & ss_userIdx & ",'" & rsvYN & "','" & rsvDT & "') "
'response.write	sql
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
if not rs.eof then
	strMsg	= rs(0)
end if
rsClose()

response.write	strMsg
%>