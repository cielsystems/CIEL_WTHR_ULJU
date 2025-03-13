<!--#include file="cnf.asp"-->

<!--#include file="fnc_db.asp"-->

<!--#include file="fnc.asp"-->

<!--#include file="base64.asp"-->

<%
if logLvl < 1 then
	'*	Page Acces Log
	call subWebLog("Log = Page Access")
end if

dim mn : mn = fnReq("mn")
dim sn : sn = fnReq("sn")
%>