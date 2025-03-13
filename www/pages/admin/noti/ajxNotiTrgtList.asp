<!--#include virtual="/common/common.asp"-->

<%
dim ruleID	: ruleID	= fnIsNull(nFnReq("ruleID", 0), 0)

dim schKey		: schKey		= fnIsNull(nFnReq("schKey",		10),		"")
dim schVal		: schVal		= fnIsNull(nFnReq("schVal",		50),		"")
dim page			: page			= fnIsNull(nFnReq("page",			0),			1)
dim pageSize	: pageSize	= fnIsNull(nFnReq("pageSize",	0),			g_pageSize)


set rs = server.createobject("adodb.recordset")
set cmd = server.createobject("adodb.command")
with cmd

	.activeconnection = strDBConn
	.commandtext = "nusp_listTrgt"
	.commandtype = adCmdStoredProc
	
	.parameters.append .createParameter("@type",	adVarchar,	adParamInput,		4)
	.parameters.append .createParameter("@indx",	adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@schKey",		adVarchar,	adParamInput,		50)
	.parameters.append .createParameter("@schVal",		adVarchar,	adParamInput,		50)
	.parameters.append .createParameter("@page",			adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@pageSize",	adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@userIndx",			adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@userIP",				adVarchar,	adParamInput,		20)
	
	.parameters("@type")		= "noti"
	.parameters("@indx")		= ruleID
	.parameters("@schKey")		= schKey
	.parameters("@schVal")		= schVal
	.parameters("@page")			= page
	.parameters("@pageSize")	= pageSize
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