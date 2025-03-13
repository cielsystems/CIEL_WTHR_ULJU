<!-- METADATA type="typelib" file="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll" -->

<%
'#	============================================================================
'#	Command Open : cmdOpen(strSql : 실행할 쿼리)
'#	call cmdOpen("select * from tbl")
'#	============================================================================
sub cmdOpen(strSql)
	'response.write	strSql
	strSql = fnSqlReplace(strSql, dbType)
	set cmd = server.createObject("adodb.command")
	cmd.activeConnection = strDBConn
	cmd.commandType = adCmdText
	cmd.commandText = strSql
	cmd.CommandTimeout = 0
	if logLvl < 2 then
		'*	All Query Log!
		call subWebLog("Query = " & strSql)
	else
		if instr(lcase(strSql),"insert ") > 0 or instr(lcase(strSql),"update ") > 0 or instr(lcase(strSql),"delete ") > 0 or instr(lcase(strSql),"call sp_") > 0 or instr(lcase(strSql),"call usp_") > 0 then
			'*	Insert, Update, Delete, Procedure Log!
			call subWebLog("Query = " & strSql)
		end if
	end if
end sub
'#	============================================================================


'#	===========================================================================
'#	
'#	===========================================================================
function fnSqlReplace(strSql, strDBType)
	dim tmpSql : tmpSql = strSql
	if strDBType = "mssql" then
		tmpSql = replace(tmpSql,"now()","getdate()")
		tmpSql = replace(tmpSql,"ifnull(","isnull(")
	elseif strDBType = "mysql" then
		tmpSql = replace(tmpSql,"getdate()","now()")
		tmpSql = replace(tmpSql,"isnull(","ifnull(")
		tmpSql = replace(tmpSql," dbo."," ")
		tmpSql = replace(tmpSql," with(nolock) "," ")
	end if
	fnSqlReplace = tmpSql
end function
'#	===========================================================================
	

'#	============================================================================
'#	Command Close : cmdClose()
'#	call cmdClose()
'#	============================================================================
sub cmdClose()
	set cmd = nothing
end sub
'#	============================================================================


'#	============================================================================
'#	RecordSet Close : rsClose()
'#	call rsClose()
'#	============================================================================
sub rsClose()
	'rs.close
	set rs = nothing
end sub
'#	============================================================================


'#	============================================================================
'#	Execute Query : execSql(strSql : 실행할 쿼리)
'#	call execSql("update tbl set b = 'b' where a = 'a'")
'#	============================================================================
sub execSql(strSql)
	cmdOpen(strSql)
	cmd.execute
	cmdClose()
end sub
'#	============================================================================


'#	============================================================================
'#	Execute Select Query & Get RecordSet : execSqlRs(strSql : 실행할 쿼리)
'#	a = execSqlRs("select * from tbl")
'#	============================================================================
function execSqlRs(strSql)
	dim tmpRs
	cmdOpen(strSql)
	set rs = cmd.execute
	cmdClose()
	if not rs.eof then
		tmpRs = rs.getRows
	end if
	rsClose()
	execSqlRs = tmpRs
end function
'#	============================================================================


'#	============================================================================
'#	Get Array Value : fnDBArrVal(strTbl : 테이블명, arrCol : 컬럼배열, strWhr : 조건절)
'#	arrCols = array("a","b","c")
'#	tmpRs = fnDBArrVal("tbl", arrCols, "a='a'")
'#	============================================================================
function execSqlArrVal(strSql)
	dim tmpRs, tmpRc, rtnRs
	'response.write	strSql
	cmdOpen(strSql)
	set rs = cmd.execute
	cmdClose()
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
	execSqlArrVal = rtnRs
end function
'#	============================================================================


'#	============================================================================
'#	Execute Procedure : execProc(strProc : 실행할 프로시져, arrParam : 파라미터 배열)
'#	arrVals = array("a","b","c")
'#	call execProc("sp_test", arrVals)
'#	============================================================================
sub execProc(strProc, arrParam)
	dim tmpSql
	if dbType = "mysql" then
		tmpSql = " call "
	elseif dbType = "mssql" then
		tmpSql = " exec "
	end if
	tmpSql = tmpSql & strProc
	if dbType = "mysql" then
		tmpSql = tmpSql & " ( "
	end if
	for t = 0 to ubound(arrParam)
		tmpSql = tmpSql & "'" & arrParam(t) & "'"
		if t < ubound(arrParam) then
			tmpSql = tmpSql & ","
		end if
	next
	if dbType = "mysql" then
		tmpSql = tmpSql & " ) "
	end if
	call execSql(tmpSql)
end sub
'#	============================================================================


'#	============================================================================
'#	Execute Procedure & Get RecordSet : execProcRs(strProc : 실행할 프로시져, arrParam : 파라미터 배열)
'#	arrVals = array("a","b","c")
'#	a = execProcRs("sp_text", arrVals)
'#	============================================================================
function execProcRs(strProc, arrParam)
	dim tmpSql, tmpRs
	if dbType = "mysql" then
		tmpSql = " call "
	elseif dbType = "mssql" then
		tmpSql = " exec "
	end if
	tmpSql = tmpSql & strProc
	if dbType = "mysql" then
		tmpSql = tmpSql & " ( "
	end if
	for t = 0 to ubound(arrParam)
		tmpSql = tmpSql & "'" & arrParam(t) & "'"
		if t < ubound(arrParam) then
			tmpSql = tmpSql & ","
		end if
	next
	if dbType = "mysql" then
		tmpSql = tmpSql & " ) "
	end if
	'response.write	tmpSql
	cmdOpen(tmpSql)
	set rs = cmd.execute
	cmdClose()
	if not rs.eof then
		tmpRs = rs.getRows
	end if
	rsClose()
	execProcRs = tmpRs
end function
'#	============================================================================


'#	============================================================================
'#	Get Array Value : fnDBArrVal(strTbl : 테이블명, arrCol : 컬럼배열, strWhr : 조건절)
'#	arrCols = array("a","b","c")
'#	tmpRs = fnDBArrVal("tbl", arrCols, "a='a'")
'#	============================================================================
function execProcArrVal(strProc, arrParam)
	dim tmpSql, tmpRs, tmpRc, rtnRs
	if dbType = "mysql" then
		tmpSql = " call "
	elseif dbType = "mssql" then
		tmpSql = " exec "
	end if
	tmpSql = tmpSql & strProc
	if dbType = "mysql" then
		tmpSql = tmpSql & " ( "
	end if
	for t = 0 to ubound(arrParam)
		tmpSql = tmpSql & "'" & arrParam(t) & "'"
		if t < ubound(arrParam) then
			tmpSql = tmpSql & ","
		end if
	next
	if dbType = "mysql" then
		tmpSql = tmpSql & " ) "
	end if
	cmdOpen(tmpSql)
	set rs = cmd.execute
	cmdClose()
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
	execProcArrVal = rtnRs
end function
'#	============================================================================


'#	============================================================================
'#	Get Value : fnDBVal(strTbl : 테이블명, strCol : 컬럼명, strWhr : 조건절)
'#	a = fnDBVal("tbl","col","a='a'")
'#	============================================================================
function fnDBVal(strTbl, strCol, strWhr)
	dim tmpVal, tmpSql
	tmpSql = " select " & strCol & " from " & strTbl & " where " & strWhr
	'response.write	tmpSql & "<br />"
	cmdOpen(tmpSql)
	set rs = cmd.execute
	cmdClose()
	if not rs.eof then
		tmpVal = rs(0)
	end if
	rsClose()
	fnDBVal = tmpVal
end function
'#	============================================================================



'#	============================================================================
'#	Get Value Max : fnDBMax(strTbl : 테이블명, strCol : 컬럼명, strWhr : 조건절)
'#	a = fnDBMax("tbl","col","a='a'")
'#	============================================================================
function fnDBMax(strTbl, strCol, strWhr)
	dim tmpVal, tmpSql
	if dbType = "mysql" then
		tmpSql = " select ifnull((select max(" & strCol & ") from " & strTbl & " where " & strWhr & "),0) "
	elseif dbType = "mssql" then
		tmpSql = " select isnull((select max(" & strCol & ") from " & strTbl & " where " & strWhr & "),0) "
	end if
	cmdOpen(tmpSql)
	set rs = cmd.execute
	cmdClose()
	if not rs.eof then
		tmpVal = rs(0)
	end if
	rsClose()
	fnDBMax = clng(tmpVal)
end function
'#	============================================================================


'#	============================================================================
'#	Get Array Value : fnDBArrVal(strTbl : 테이블명, arrCol : 컬럼배열, strWhr : 조건절)
'#	arrCols = array("a","b","c")
'#	tmpRs = fnDBArrVal("tbl", arrCols, "a='a'")
'#	============================================================================
function fnDBArrVal(strTbl, arrCol, strWhr)
	dim tmpSql, tmpRs, tmpRc, rtnRs
	tmpSql = " select "
	for t = 0 to ubound(arrCol)
		tmpSql = tmpSql & arrCol(t)
		if t < ubound(arrCol) then
			tmpSql = tmpSql & " , "
		end if
	next
	tmpSql = tmpSql & " from " & strTbl & " where " & strWhr
	cmdOpen(tmpSql)
	set rs = cmd.execute
	cmdClose()
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
	fnDBArrVal = rtnRs
end function
'#	============================================================================


'#	============================================================================
'#	Get RecordSet : fnDBRs(strTbl : 테이블명, strCols : 컬럼, strWhr : 조건절)
'#	tmpRs = fnDBRs("tbl", "a, b, c", "a='a'")
'#	============================================================================
function fnDBRs(strTbl, strCols, strWhr)
	dim tmpSql, tmpRs	
	tmpSql = " select " & strCols & " from " & strTbl & " where " & strWhr
	cmdOpen(tmpSql)
	set rs = cmd.execute
	cmdClose()
	if not rs.eof then
		tmpRs = rs.getRows
	end if
	rsClose()
	fnDBRs = tmpRs
end function
'#	============================================================================
%>


<%
'#	================================================================================================
'#	
'#	------------------------------------------------------------------------------------------------
function nFnExecProc(strProc, arrParams)
	
	dim tmpCmd, tempLoop
	
	set cmd = server.createobject("adodb.command")
	with tmpCmd
	
		.activeconnection = strDBConn
		.commandtext = strProc
		.commandtype = adCmdStoredProc
		
		for tempLoop = 0 to ubound(arrParams)
			.parameters.append .createParameter("@" & arrParams(tempLoop)(0),	arrParams(tempLoop)(1), adParamInput, arrParams(tempLoop)(2), arrParams(tempLoop)(3))
		next
		.parameters.append .createParameter("@retn",			adInteger,	adParamOutput,	0)
		
		.parameters("@retn")			= 0
		
		.execute
		
		retn	= .parameters("@retn")
		
	end with
	set tmpCmd = nothing
	
	nFnExecProc	= retn
	
end function
'#	================================================================================================
%>