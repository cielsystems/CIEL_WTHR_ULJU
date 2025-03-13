<!--#include virtual="/common/common.asp"-->

<%
dim listGubn	: listGubn	= fnIsNull(nFnReq("listGubn",	2),		"G")
dim grupIndx	: grupIndx	= fnIsNull(nFnReq("grupIndx",	10),	0)
dim schKey		: schKey	= fnIsNull(nFnReq("schKey",		10),	"")
dim schVal		: schVal	= fnIsNull(nFnReq("schVal",		50),	"")
dim page		: page		= fnIsNull(nFnReq("page",		0),		1)
dim pageSize	: pageSize	= fnIsNull(nFnReq("pageSize",	0),		g_pageSize)
dim addrCode	: addrCode	= fnIsNull(nFnReq("addrCode",	4000),	"")

'response.write	" exec nusp_listAddr '" & listGubn & "', " & grupIndx & ", '" & schKey & "', '" & schVal & "', " & page & ", " & pageSize & ", '" & addrCode & "', " & ss_userIndx & ", '" & svr_remoteAddr & "' "

set rs = server.createobject("adodb.recordset")
set cmd = server.createobject("adodb.command")
with cmd

	.activeconnection = strDBConn
	.commandtext = "nusp_listAddr"
	.commandtype = adCmdStoredProc
	
	.parameters.append .createParameter("@listGubn",	adVarChar,	adParamInput,	2)
	.parameters.append .createParameter("@grupIndx",	adInteger,	adParamInput,	0)
	.parameters.append .createParameter("@schKey",		adVarchar,	adParamInput,	50)
	.parameters.append .createParameter("@schVal",		adVarchar,	adParamInput,	50)
	.parameters.append .createParameter("@page",		adInteger,	adParamInput,	0)
	.parameters.append .createParameter("@pageSize",	adInteger,	adParamInput,	0)
	.parameters.append .createParameter("@addrCode",	adVarchar,	adParamInput,	4000)
	.parameters.append .createParameter("@userIndx",	adInteger,	adParamInput,	0)
	.parameters.append .createParameter("@userIP",		adVarchar,	adParamInput,	20)
	
	.parameters("@listGubn")	= listGubn
	.parameters("@grupIndx")	= grupIndx
	.parameters("@schKey")		= schKey
	.parameters("@schVal")		= schVal
	.parameters("@page")		= page
	.parameters("@pageSize")	= pageSize
	.parameters("@addrCode")	= addrCode
	.parameters("@userIndx")	= ss_userIndx
	.parameters("@userIP")		= svr_remoteAddr
	
	set rs = .execute
	
end with
set cmd = nothing

if not rs.eof then
	arrRs	= rs.getRows
	arrRc1	= ubound(arrRs, 1)
	arrRc2	= ubound(arrRs, 2)
	rowCnt	= arrRs(0,0)
else
	arrRc2	= -1
	rowCnt	= 0
end if
set rs = nothing

sql = " nusp_listAddr " & listGubn & ", " & grupIndx & ", " & schKey & ", " & schVal & ", " & page & ", " & pageSize & ", " & addrCode & ", " & ss_userIndx & ", " & svr_remoteAddr & " "

call subSetLog(ss_userIdx, 8004, "주소록조회", sql, "")

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