<!--#include virtual="/common/common.asp"-->

<%
dim userGubn	: userGubn	= fnIsNull(fnReq("userGubn"), 0)
dim schKey		: schKey		= fnIsNull(fnReq("schKey"), "")
dim schVal		: schVal		= fnIsNull(fnReq("schVal"), "")
dim page			: page			= fnIsNull(fnReq("page"), 1)
dim pageSize	: pageSize	= fnIsNull(fnReq("pageSize"), g_pagesize)

'response.write	" exec nusp_listUser '" & userGubn & "', '" & schKey & "', '" & schVal & "', " & page & ", " & pageSize & ", " & ss_userIndx & ", '" & svr_remoteAddr & "' "

set rs = server.createobject("adodb.recordset")
set cmd = server.createobject("adodb.command")
with cmd

	.activeconnection = strDBConn
	.commandtext = "nusp_listUser"
	.commandtype = adCmdStoredProc
	
	.parameters.append .createParameter("@userGubn",	adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@schKey",		adVarchar,	adParamInput,		50)
	.parameters.append .createParameter("@schVal",		adVarchar,	adParamInput,		50)
	.parameters.append .createParameter("@page",			adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@pageSize",	adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@userIndx",	adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@userIP",		adVarchar,	adParamInput,		20)
	
	.parameters("@userGubn")	= userGubn
	.parameters("@schKey")		= schKey
	.parameters("@schVal")		= schVal
	.parameters("@page")			= page
	.parameters("@pageSize")	= pageSize
	.parameters("@userIndx")	= ss_userIndx
	.parameters("@userIP")		= svr_remoteAddr
	
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
		'#	사용자 구분
		if ii = 3 then
			response.write	fnPrintUserGubn(arrRs(ii, i))
		elseif ii = 6 then
			response.write	fnPrintUserStep(arrRs(ii, i))
		else
			response.write	arrRs(ii, i)
		end if
		if ii < arrRc1 then
			response.write	"]|["
		end if
	next
	if i < arrRc2 then
		response.write	"}|{"
	end if
next
%>
