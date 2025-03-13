<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/config_noti.asp"-->

<%
dim ruleID	: ruleID	= fnIsNull(nFnReq("ruleID", 0), 0)

set rs = server.createobject("adodb.recordset")
set cmd = server.createobject("adodb.command")
with cmd

	.activeconnection = strDBConn
	.commandtext = "nusp_listNotiTrgt"
	.commandtype = adCmdStoredProc
	
	.parameters.append .createParameter("@ruleID",	adInteger,	adParamInput,		0)
	
	.parameters("@ruleID")	= ruleID
	
	set rs = .execute
	
end with
set cmd = nothing

if not rs.eof then
	arrRs		= rs.getRows
	arrRc2	= ubound(arrRs, 2)
else
	arrRc2	= -1
end if
set rs = nothing

for i = 0 to arrRc2
	response.write	arrRs(0, i) & "]|[" & arrRs(1, i) & "]|[" & arrRs(2, i) & "]|[" & arrRs(3, i)
	if i < arrRc2 then
		response.write	"}|{"
	end if
next
%>