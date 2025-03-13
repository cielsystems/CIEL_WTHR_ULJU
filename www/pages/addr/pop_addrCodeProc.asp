<!--#include virtual="/common/common.asp"-->

<%
dim proc	: proc	= fnIsNull(nFnReq("proc", 4), "S")

dim addrCode			: addrCode			= fnIsNull(nFnReq("addrCode",			0),		0)
dim addrCodeUper	: addrCodeUper	= fnIsNull(nFnReq("addrCodeUper",	0),		0)
dim addrCodeGubn	: addrCodeGubn	= fnIsNull(nFnReq("addrCodeGubn",	1),		"")
dim addrCodeName	: addrCodeName	= fnIsNull(nFnReq("addrCodeName",	50),	"")
dim addrCodeSort	: addrCodeSort	= fnIsNull(nFnReq("addrCodeSort",	0),		1)

if proc <> "D" and len(addrCodeGubn) <> 1 then
	response.write	"1|Request Value Error!"
	response.end
end if

'response.write	"declare @retn int;"
'response.write	"exec nusp_procAddrCode '" & proc & "', " & addrCode & ", " & addrCodeUper & ", '" & addrCodeGubn & "', '" & addrCodeName & "', " & addrCodeSort & ", " & ss_userIndx & ", '" & svr_remoteAddr & "', @retn output;"
'response.write	"select @retn;"

set cmd = server.createobject("adodb.command")
with cmd

	.activeconnection = strDBConn
	.commandtext = "nusp_procAddrCode"
	.commandtype = adCmdStoredProc
	
	.parameters.append .createParameter("@proc",					adChar,			adParamInput,		1)
	.parameters.append .createParameter("@addrCode",			adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@addrCodeUper",	adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@addrCodeGubn",	adChar,			adParamInput,		1)
	.parameters.append .createParameter("@addrCodeName",	adVarchar,	adParamInput,		50)
	.parameters.append .createParameter("@addrCodeSort",	adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@userIndx",			adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@userIP",				adVarchar,	adParamInput,		20)
	.parameters.append .createParameter("@retn",					adInteger,	adParamOutput,	0)
	
	.parameters("@proc")					= proc
	.parameters("@addrCode")			= addrCode
	.parameters("@addrCodeUper")	= addrCodeUper
	.parameters("@addrCodeGubn")	= addrCodeGubn
	.parameters("@addrCodeName")	= addrCodeName
	.parameters("@addrCodeSort")	= addrCodeSort
	.parameters("@userIndx")			= ss_userIndx
	.parameters("@userIP")				= svr_remoteAddr
	.parameters("@retn")					= 0
	
	.execute
	
	retn	= .parameters("@retn")
	
end with
set cmd = nothing

call subSetLog(ss_userIdx, 8004, "주소록코드관리", "addrCode : " & addrCode, "")

if proc = "A" then
	response.write	"0|추가되었습니다.|" & retn
elseif proc = "S" or proc = "E" then
	response.write	"0|저장되었습니다.|" & retn
elseif proc = "D" then
	response.write	"0|삭제되었습니다.|" & retn
end if
%>