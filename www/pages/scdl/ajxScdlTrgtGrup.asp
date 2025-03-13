<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/config_noti.asp"-->

<%
dim scdlIndx	: scdlIndx	= fnIsNull(fnReq("scdlIndx"), 0)

set rs = server.createobject("adodb.recordset")
set cmd = server.createobject("adodb.command")
with cmd

	.activeconnection = strDBConn
	.commandtext = "nusp_listScdlTrgt"
	.commandtype = adCmdStoredProc
	
	.parameters.append .createParameter("@scdlIndx",	adInteger,	adParamInput,	0)
	
	.parameters("@scdlIndx")	= scdlIndx
	
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