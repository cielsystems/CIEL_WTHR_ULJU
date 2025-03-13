<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/public/sha/sha256.asp"-->

<%
dim loginID : loginID = nFnReq("loginID", 50)
dim loginPW : loginPW = nFnReq("loginPW", 255)

'loginPW = sha256(loginPW)

session("userIdx") = ""
session("userId") = ""

'response.write	"USEYN = 'Y' and USER_ID = '" & loginID & "' and USER_PW = '" & loginPW & "'"
'response.end

dim userIndx, userId, userName, userGubn

set rs = server.createobject("adodb.recordset")
set cmd = server.createobject("adodb.command")
with cmd

	.activeconnection = strDBConn
	.commandtext = "nusp_userLogin"
	.commandtype = adCmdStoredProc
	
	.parameters.append .createParameter("@userID",	adVarchar,	adParamInput,		50)
	.parameters.append .createParameter("@userPW",	adVarchar,	adParamInput,		255)
	
	.parameters("@userID")	= loginID
	.parameters("@userPW")	= loginPW
	
	set rs = .execute
	
end with
set cmd = nothing

if not rs.eof then
	userIndx	= rs("USER_INDX")
	userId		= rs("USER_ID")
	userName	= rs("USER_NAME")
	userGubn	= rs("USER_GUBN")
else
	userIndx	= 0
end if
set rs = nothing

'arrCols = array("USER_INDX", "USER_ID", "USER_NAME", "USER_GUBN")
'dim loginInfo : loginInfo = fnDBArrVal("NTBL_USER", arrCols, "USEYN = 'Y' and USER_ID = '" & loginID & "' and USER_PW = '" & loginPW & "'")
'if isarray(loginInfo) and ubound(loginInfo) > -1 then
'	userIndx	= loginInfo(0)
'	userId		= loginInfo(1)
'	userName	= loginInfo(2)
'	userGubn	= loginInfo(3)
'else
'	userIndx	= 0
'end if
'rsClose()

if userIndx > 0 then
	
	call subSetLog(userIndx, 8001, userId & "(" & userName & ")님 로그인성공", "", "")
	
	session("ss_userIdx") = userIndx
	session("ss_userId") = userId
	session("ss_userNm") = userName
	
	response.cookies("loginID") = loginID
	response.cookies("loginID").expires = dateadd("d", 365, now)
	
	response.cookies("ss_userIdx") = userIndx
	response.cookies("ss_userId") = userId
	response.cookies("ss_userNm") = userName
	
	sql = " select top 1 MN_LNKURL "
	sql = sql & " from TBL_MENU "
	sql = sql & " where USEYN = 'Y' and MN_GB = 'U' and (CD_USERGB = 0 or CD_USERGB >= (select USER_GUBN from NTBL_USER where USER_INDX = " & userIndx & ")) "
	sql = sql & " order by MN_UPCODE, MN_SORT asc "
	cmdOpen(sql)
	set rs = cmd.execute
	cmdClose()
	if not rs.eof then
		firstPage	= "/pages" & rs(0)
	end if
	rsClose()
	
	response.write	"<script type=""text/javascript"">"
	response.write	"	location.href = '" & firstPage & "';"
	response.write	"</script>"
	
else
	
	call subSetLog(0, 8001, "로그인실패", "로그인실패(" & loginID & "/" & loginPW & ")", "")
	
	response.write	"<script type=""text/javascript"">"
	response.write	"	alert('아이디또는 비밀번호가 일치하지 않습니다.');"
	response.write	"	location.href = 'loginForm.asp';"
	response.write	"</script>"
	
end if
%>