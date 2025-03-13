<!--#include virtual="/common/common.asp"-->

<%
dim svrTime	: svrTime	= fnDateToStr(now, "h:n")
response.write	svrTime
%>