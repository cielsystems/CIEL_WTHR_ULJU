<%
dim dbConn

' 데이터 베이스 오픈
sub dbOpen()
    set dbConn = Server.CreateObject("ADODB.Connection")
    dbConn.Open (strDBconn)

    call subWebLog("INFO. dbOpen() - [" & strDbConn & "]")
end sub

' 데이터 베이스 닫기
sub dbClose()
    set dbConn = nothing
    call subWebLog("INFO. dbClose()")
end sub

' 트랜잭션 시작
sub dbBeginTrans()
    dbConn.BeginTrans()
    call subWebLog("INFO. dbBeginTrans()")
end sub

' 트랜잭션 커밋
sub dbCommit()
    dbConn.CommitTrans()
    call subWebLog("INFO. dbCommit()")
end sub

' 트랜잭션 롤백
sub dbRollback()
    dbConn.RollbackTrans()
    call subWebLog("INFO. dbRollback()")
end sub

sub dbCmdOpen(query)
	set cmd = server.createObject("adodb.command")
	cmd.activeConnection = dbConn
	cmd.commandType = adCmdText
	cmd.commandText = query
	cmd.CommandTimeout = 0

    call subWebLog("INFO. dbCmdOpen([" & query & "])")
end sub

sub dbCmdClose()
	set cmd = nothing
    call subWebLog("INFO. dbCmdClose()")
end sub
%>

<%
' 쿼리 실행
sub dbExecSql(query)
    dbCmdOpen(query)
    cmd.execute
    dbCmdClose()
end sub

' 쿼리 RS 반환
sub dbExecSqlRs(query)
    dim tmpRs
    dbCmdOpen(query)
    set rs = cmd.execute
    dbCmdClose()
	if not rs.eof then
		tmpRs = rs.getRows
	end if
	rsClose()
	dbExecSqlRs = tmpRs
end sub

sub dbExecSqlArrVal(query)
	dim tmpRs, tmpRc, rtnRs
    dbCmdOpen(query)
    set rs = cmd.execute
    dbCmdClose()
	if not rs.eof then
		tmpRs = rs.getRows
		tmpRc = ubound(tmpRs,1)
	else
		tmpRc = -1
	end if
	rsClose()
	redim rtnRs(tmpRc)
	for t = 0 to tmpRc
		rtnRs(t) = tmpRs(t,0)
	next
	dbExecSqlArrVal = rtnRs
end sub

function dbDBVal(query)
	dim tmpVal
	dbCmdOpen(query)
	set rs = cmd.execute
	dbCmdClose()
	if not rs.eof then
		tmpVal = rs(0)
	end if
	rsClose()
	dbDBVal = tmpVal
end function

function dbExecProc(procName, arrParams)
	dim tmpCmd, tempLoop, strParam
	
	set tmpCmd = server.createobject("adodb.command")
	with tmpCmd
		.activeconnection = dbConn
		.commandtext = procName
		.commandtype = adCmdStoredProc
		strParam = ""
		for tempLoop = 0 to ubound(arrParams)
			.parameters.append .createParameter("@" & arrParams(tempLoop)(0), _
				arrParams(tempLoop)(1), adParamInput, arrParams(tempLoop)(2), _
				arrParams(tempLoop)(3))
			if tempLoop > 0 then
				strParam = strParam & ", "
			end if
			strParam = strParam & "[[" & arrParams(tempLoop)(0) & "], "
			strParam = strParam & arrParams(tempLoop)(1) & ", "
			strParam = strParam & arrParams(tempLoop)(2) & ", "
			strParam = strParam & "[" & arrParams(tempLoop)(3) & "]]"
		next
		.parameters.append .createParameter("@retn", adInteger,	adParamOutput, 0)
		.parameters("@retn") = 0
		call subWebLog("INFO. dbExecProc([" & procName & "], [" & strParam & "])")
		.execute
		retn = .parameters("@retn")
		call subWebLog("INFO. dbExecProc([" & procName & "], [" & strParam & "]) - [" & retn & "]")
	end with
	set tmpCmd = nothing
	dbExecProc	= retn
end function
%>

<%
' 에러 반환
sub jsonResErr(errCode)
    call jsonResErrMsg(errCode, getErrMsg(errCode))
end sub

sub jsonResErrMsg(errCode, errMsg)
    dim jsonObj
    set jsonObj = new aspJSON

	jsonObj.data.Add "resCode", errCode
	jsonObj.data.Add "resMsg", errMsg
	jsonObj.data.Add "data", null

    response.ContentType = "application/json"
	response.write jsonObj.JSONoutput()
end sub

sub jsonResData(data)
    dim jsonObj
    set jsonObj = new aspJSON

	jsonObj.data.Add "resCode", NO_ERROR
	jsonObj.data.Add "resMsg", getErrMsg(NO_ERROR)
	jsonObj.data.Add "data", data

    response.ContentType = "application/json"
	response.write jsonObj.JSONoutput()
end sub
%>