<!--#include virtual="/common/common.asp"-->

<%
dim grupGubn	: grupGubn	= fnIsNull(fnReq("grupGubn"), "A")
dim grupIndx	: grupIndx	= fnIsNull(fnReq("grupIndx"), 0)
dim schKey		: schKey		= fnIsNull(fnReq("schKey"), "")
dim schVal		: schVal		= fnIsNull(fnReq("schVal"), "")
dim page			: page			= fnIsNull(fnReq("page"), 1)
dim pageSize	: pageSize	= fnIsNull(fnReq("pageSize"), g_pageSize)
dim addrCode	: addrCode	= fnIsNull(fnReq("addrCode"), "")

if left(grupIndx, 1)	= "N" then
	grupGubn	= grupIndx
	grupIndx	= 0
end if

set rs = server.createobject("adodb.recordset")

'response.write	" exec nusp_listAddr '" & grupGubn & "', " & grupIndx & ", '" & schKey & "', '" & schVal & "', " & page & ", " & pageSize & ", '" & addrCode & "', " & ss_userIndx & ", '" & svr_remoteAddr & "' "

set cmd = server.createobject("adodb.command")
with cmd

	.activeconnection = strDBConn
	.commandtext = "nusp_listAddr"
	.commandtype = adCmdStoredProc
	
	.parameters.append .createParameter("@grupGubn",	adChar,			adParamInput,		2)
	.parameters.append .createParameter("@grupIndx",	adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@schKey",		adVarchar,	adParamInput,		50)
	.parameters.append .createParameter("@schVal",		adVarchar,	adParamInput,		50)
	.parameters.append .createParameter("@page",			adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@pageSize",	adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@addrCode",	adVarchar,	adParamInput,		4000)
	.parameters.append .createParameter("@userIndx",			adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@userIP",				adVarchar,	adParamInput,		20)
	
	.parameters("@grupGubn")	= grupGubn
	.parameters("@grupIndx")	= grupIndx
	.parameters("@schKey")		= schKey
	.parameters("@schVal")		= schVal
	.parameters("@page")			= page
	.parameters("@pageSize")	= pageSize
	.parameters("@addrCode")	= addrCode
	.parameters("@userIndx")			= ss_userIndx
	.parameters("@userIP")				= svr_remoteAddr
	
	set rs = .execute
	
end with
set cmd = nothing

if not rs.eof then
	arrRs		= rs.getRows
	arrRc1	= ubound(arrRs, 1)
	arrRc2	= ubound(arrRs, 2)
	rowCnt	= arrRs(0,0)
else
	arrRc2	= -1
	rowCnt	= 0
end if
set rs = nothing

response.write	rowCnt & "}|{"

call subPaging()

response.write	"}|{"

for i = 0 to arrRc2
	for ii = 0 to arrRc1
		response.write	arrRs(ii, i)
		if ii < arrRc1 then
			response.write	"]|["
		end if
	next
	if i < arrRc2 then
		response.write	"}|{"
	end if
next
%>