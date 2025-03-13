<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/public/sha/sha256.asp"-->

<%
dim proc	: proc	= fnIsNull(fnReq("proc"), "")

dim userIndx	: userIndx	= fnIsNull(fnReq("userIndx"), 0)
dim userGubn	: userGubn	= fnIsNull(fnReq("userGubn"), 0)
dim userStep	: userStep	= fnIsNull(fnReq("userStep"), "0")
dim userID		: userID		= fnIsNull(fnReq("userID"), "")
dim userPW
dim userName	: userName	= fnIsNull(fnReq("userName"), "")
dim userNum1	: userNum1	= fnIsNull(fnReq("userNum1"), "")
dim userNum2	: userNum2	= fnIsNull(fnReq("userNum2"), "")
dim userNum3	: userNum3	= fnIsNull(fnReq("userNum3"), "")
dim grupIndx	: grupIndx	= fnIsNull(fnReq("grupIndx"), "")


userPW	= sha256(dftPass)

'response.write	"exec nusp_procUser '" & proc & "', " & userIndx & ", " & userGubn & ", '" & userStep & "', '" & userID & "', '" & userPW & "', '" & userName & "', '" & userNum1 & "', '" & userNum2 & "', '" & userNum3 & "', '" & grupIndx & "'"

set cmd = server.createobject("adodb.command")
with cmd

	.activeconnection = strDBConn
	.commandtext = "nusp_procUser"
	.commandtype = adCmdStoredProc
	
	.parameters.append .createParameter("@proc",			adChar,			adParamInput,		1)
	.parameters.append .createParameter("@userIndx",	adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@userGubn",	adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@userStep",	adChar,			adParamInput,		1)
	.parameters.append .createParameter("@userID",		adVarchar,	adParamInput,		50)
	.parameters.append .createParameter("@userPW",		adVarchar,	adParamInput,		255)
	.parameters.append .createParameter("@userName",	adVarchar,	adParamInput,		50)
	.parameters.append .createParameter("@userNum1",	adVarchar,	adParamInput,		20)
	.parameters.append .createParameter("@userNum2",	adVarchar,	adParamInput,		20)
	.parameters.append .createParameter("@userNum3",	adVarchar,	adParamInput,		20)
	.parameters.append .createParameter("@grupIndx",	adVarchar,	adParamInput,		8000)
	.parameters.append .createParameter("@retn",			adInteger,	adParamOutput,	0)
	
	.parameters("@proc")			= proc
	.parameters("@userIndx")	= userIndx
	.parameters("@userGubn")	= userGubn
	.parameters("@userStep")	= userStep
	.parameters("@userID")		= userID
	.parameters("@userPW")		= userPW
	.parameters("@userName")	= userName
	.parameters("@userNum1")	= userNum1
	.parameters("@userNum2")	= userNum2
	.parameters("@userNum3")	= userNum3
	.parameters("@grupIndx")	= replace(grupIndx, " ", "")
	.parameters("@retn")			= 0
	
	.execute
	
	retn	= .parameters("@retn")
	
end with
set cmd = nothing

dim strProc
if proc = "A" then
	strProc	= "추가"
	response.write	"0|추가되었습니다.|" & retn
elseif proc = "S" or proc = "E" then
	strProc	= "저장"
	response.write	"0|저장되었습니다.|" & retn
elseif proc = "D" then
	strProc	= "삭제"
	response.write	"0|삭제되었습니다.|" & retn
elseif proc = "IDCheck" then
	response.write	"0|" & strMesg & "|" & retn
elseif proc = "PWReset" then
	strProc	= "비밀번호초기화"
	response.write	"0|비밀번호가 초기화되었습니다.|" & retn
end if

if proc <> "IDCheck" then
	call subSetLog(ss_userIdx, 8006, "사용자" & strProc, "userIndx : " & userIndx & "", "")
end if
%>