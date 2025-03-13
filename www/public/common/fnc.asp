<%
'#	============================================================================
'#	fnReq(strVal)
'#	============================================================================
function fnReq(strVal)
	dim tmp : tmp = request(strVal)
	'if injectYN = "Y" then
		tmp = fnInject(tmp)
	'end if
	fnReq = tmp
end function
'#	============================================================================



'#	================================================================================================
'#	
'#	------------------------------------------------------------------------------------------------
function nFnReq(strVal, intVal)		'intVal = 0 이면 숫자, 0보다 크면 최대 length
	dim tmp	: tmp	= request(strVal)
	if len(tmp) > 0 then
		if intVal = 0 then
			if isNumeric(tmp) <> true then
				response.write	"<script type=""text/javascript"">alert('요청값의 형식이 잘못되었습니다.(1." & strVal & " = " & tmp & ")');top.history.back();</script>"
				response.end
			end if
		else
			if len(tmp) > intVal then
				response.write	"<script type=""text/javascript"">alert('요청값의 형식이 잘못되었습니다.(2." & strVal & " = " & tmp & ")');top.history.back();</script>"
				response.end
			else
				tmp	= fnInject(tmp)
			end if
		end if
	end if
	nFnReq	= tmp
end function
'#	================================================================================================



'#	================================================================================================
'#	
'#	------------------------------------------------------------------------------------------------
function nFnChekLeng(strVal, intLen)
	if len(strVal) > 0 then
		if intLen = 0 then
			if isNumeric(strVal) <> true then
				response.write	"<script type=""text/javascript"">alert('요청값의 형식이 잘못되었습니다.(1." & strVal & " = " & tmp & ")');top.history.back();</script>"
				response.end
			end if
		else
			if len(strVal) > intLen then
				response.write	"<script type=""text/javascript"">alert('요청값의 형식이 잘못되었습니다.(2." & strVal & " = " & tmp & ")');top.history.back();</script>"
				response.end
			end if
		end if
	end if
	nFnChekLeng	= fnInject(strVal)
end function
'#	================================================================================================



'#	============================================================================
'#	fnInject(strVal)
'#	============================================================================
function fnInject(strVal)
	dim tmp : tmp = strVal
	
	tmp = replace(tmp, ";", "&#59;")
	'tmp = replace(tmp, " ", "&#32;")
	'tmp = replace(tmp, "!", "&#33;")
	tmp = replace(tmp, "$", "&#36;")
	tmp = replace(tmp, "%", "&#37;")
	tmp = replace(tmp, "'", "&#39;")
	'tmp = replace(tmp, "&quot;", "&#34;")
	tmp = replace(tmp, "(", "&#40;")
	tmp = replace(tmp, ")", "&#41;")
	tmp = replace(tmp, "*", "&#42;")
	tmp = replace(tmp, "+", "&#43;")
	'tmp = replace(tmp, ",", "&#44;")
	'tmp = replace(tmp, "-", "&#45;")
	'tmp = replace(tmp, ".", "&#46;")
	tmp = replace(tmp, "/", "&#47;")
	'tmp = replace(tmp, ":", "&#58;")
	tmp = replace(tmp, "<", "&#60;")
	tmp = replace(tmp, "=", "&#61;")
	tmp = replace(tmp, ">", "&#62;")
	'tmp = replace(tmp, "?", "&#63;")
	tmp = replace(tmp, "@", "&#64;")
	
	tmp = replace(tmp, "--", "")
	tmp = replace(tmp, "/*", "")
	tmp = replace(tmp, "*/", "")
	
	tmp = replace(tmp, "<script", "")
	tmp = replace(tmp, "<iframe", "")
	
	fnInject = tmp
end function
'#	============================================================================
'#	============================================================================
'#	fnReInject(strVal)
'#	============================================================================
function fnReInject(strVal)
	dim tmp : tmp = strVal
	
	tmp = replace(tmp, "&#59;", ";")
	tmp = replace(tmp, "&#32;", " ")
	tmp = replace(tmp, "&#33;", "!")
	tmp = replace(tmp, "&#36;", "$")
	tmp = replace(tmp, "&#37;", "%")
	tmp = replace(tmp, "&#39;", "'")
	tmp = replace(tmp, "&#40;", "(")
	tmp = replace(tmp, "&#41;", ")")
	tmp = replace(tmp, "&#42;", "*")
	tmp = replace(tmp, "&#43;", "+")
	tmp = replace(tmp, "&#44;", ",")
	tmp = replace(tmp, "&#45;", "-")
	tmp = replace(tmp, "&#46;", ".")
	tmp = replace(tmp, "&#47;", "/")
	tmp = replace(tmp, "&#58;", ":")
	tmp = replace(tmp, "&#60;", "<")
	tmp = replace(tmp, "&#61;", "=")
	tmp = replace(tmp, "&#62;", ">")
	tmp = replace(tmp, "&#63;", "?")
	tmp = replace(tmp, "&#64;", "@")
	
	fnReInject = tmp
end function
'#	============================================================================


function fnURLDecode(strVal)

	dim tmpVal, strTmp
	
	if isNull(strVal) then
		fnURLDecode = ""
		exit function
	end if

	strTmp = replace(strVal, "+", " ")
	tmpVal = split(strTmp," %")
	if isArray(tmpVal) then
		if ubound(tmpVal) > -1 then
			strTmp = tmpVal(0)
			for i = 0 to ubound(tmpVal) - 1
				strTmp = strTmp & chr("&H" & left(tmpVal(i+1),2)) & right(tmpVal(i+1), len(tmpVal(i+1)) - 2)
			next
		end if
	end if

	fnURLDecode = strTmp

end function



'===================================================================================================
'#	subSetLog(intUser, intGb, strTit, strMsg, strQuery
'===================================================================================================
sub subSetLog(intUser, intGb, strTit, strMsg, strQuery)
	dim arrTmp : arrTmp = array(intUser, svr_remoteAddr, intGb, svr_url, strTit, strMsg, strQuery)
	call execProc("usp_setLog", arrTmp)
end sub
'===================================================================================================



'===================================================================================================
'#	subLoginCheck()
'===================================================================================================
sub subLoginCheck()
'if session("userIdx") = 0 then
'		response.redirect	"/pages/loginForm.asp"
'	end if
'	if session("ums_userIdx") = 0 then
'		response.redirect	"/pages/loginForm.asp"
'	end if
	if ss_userIdx = 0 then
		response.redirect	"/pages/loginForm.asp"
	end if
end sub
'===================================================================================================



'===================================================================================================
'#	fnDateToStr(strDate,strStr)
'===================================================================================================
function fnDateToStr(strDate,strStr)
	dim tmp : tmp = strStr
	if isDate(strDate) = true then
		tmp = replace(tmp,"yyyy",year(strDate))
		tmp = replace(tmp,"yy",right(year(strDate),2))
		tmp = replace(tmp,"mm",right("0" & month(strDate),2))
		tmp = replace(tmp,"dd",right("0" & day(strDate),2))
		tmp = replace(tmp,"hh",right("0" & hour(strDate),2))
		tmp = replace(tmp,"nn",right("0" & minute(strDate),2))
		tmp = replace(tmp,"ss",right("0" & second(strDate),2))
		tmp = replace(tmp,"m",month(strDate))
		tmp = replace(tmp,"d",day(strDate))
		tmp = replace(tmp,"h",hour(strDate))
		tmp = replace(tmp,"n",minute(strDate))
		tmp = replace(tmp,"s",second(strDate))
	else
		tmp = "-"
	end if
	fnDateToStr = tmp
end function
'===================================================================================================



'===================================================================================================
'#	subWebLog(strLog)
'===================================================================================================
sub subWebLog(strLog)

	if logLvl < 3 then
	
		dim nFso, nFolder, nFile, tmp
		set nFso = createObject("scripting.fileSystemObject")
		
		dim nPath
		nPath = "/data/log"
		if not nFso.folderExists(server.mapPath("\") & nPath) then
			nFolder = nFso.createFolder(server.mapPath("\") & nPath)
		else
			nFolder = server.mapPath("\") & nPath
		end if
		
		dim logFilePath : logFilePath = nFolder & "/weblog_" & fnDateToStr(date,"yyyymmdd") & ".log"
		
		if nFso.fileExists(logFilePath) then
			tmp = logFilePath
		else
			nFso.createTextFile logFilePath
		end if
		
		set nFile = nFso.openTextFile(logFilePath,8)
		nFile.writeLine("[" & fnDateToStr(now,"yyyy-mm-dd hh:nn:ss") & "] User : " & ss_userIdx & ",	IP : " & request.serverVariables("remote_addr") & ",	Page : " & request.serverVariables("url") & "	(" & strLog & ")")
		nFile.close
		set nFile = nothing
		
		set nFso = nothing
		
	end if
	
end sub
'===================================================================================================



'===================================================================================================
'#	Create File
'===================================================================================================
function fnCreateFile(strPath, strFile)
	
	dim nFso, tmp
	set nFso = createObject("scripting.fileSystemObject")
	
	if nFso.fileExists(strPath & "/" & strFile) then
		tmp = strPath & "/" & strFile
	else
		nFso.createTextFile(strPath & "/" & strFile)
	end if
	
	set nFso = nothing
	
	fnCreateFile = strPath & "/" & strFile
	
end function
'===================================================================================================



'===================================================================================================
'#	Create Path
'===================================================================================================
function fnCreatePath(strPath)
	
	dim nFso, nFolder
	set nFso = createObject("scripting.fileSystemObject")
	
	strPath = replace(strPath,"\","/")
	dim arrPath : arrPath = split(strPath,"/")
	
	dim nPath
	for i = 0 to ubound(arrPath)
		nPath = nPath & "/" & arrPath(i)
		if not nFso.folderExists(server.mapPath("\") & nPath) then
			nFolder = nFso.createFolder(server.mapPath("\") & nPath)
		end if
	next
	
	set nFso = nothing
	
	fnCreatePath = server.mapPath("\") & nPath
	
end function
'===================================================================================================



'===================================================================================================
'#	Read File
'===================================================================================================
function fnReadFile(strFilePath)
	
	dim nFso, nFile, tmp
	set nFso = createObject("scripting.fileSystemObject")
	
	strFilePath = replace(strFilePath,"/","\")
	
	if nFso.fileExists(server.mapPath("\") & strFilePath) then
		set nFile = nFso.openTextFile(server.mapPath("\") & strFilePath, 1, false, 0)
		tmp = nFile.readAll
		set nFile = nothing
	end if
	
	set nFso = nothing
	
	fnReadFile = tmp
	
end function
'===================================================================================================



'===================================================================================================
'#	Delete File
'===================================================================================================
function fnDeleteFile(strFilePath)
	
	dim nFso, tmp
	set nFso = createObject("scripting.fileSystemObject")
	
	if nFso.fileExists(server.mapPath("\") & strFilePath) then
		tmp = nFso.deleteFile(server.mapPath("\") & strFilePath)
	end if
	
	if nFso.fileExists(server.mapPath("\") & strFilePath) then
		tmp = "N"
	else
		tmp = "Y"
	end if
	set nFso = nothing
	
	fnDeleteFile = tmp
	
end function
'===================================================================================================



'===================================================================================================
'#	fnPer(intTot,intPer)
'===================================================================================================
function fnPer(intTot,intPer)
	dim tmpVal
	if intTot > 0 then
		tmpVal = intPer/intTot*100
	else
		tmpVal = 0
	end if
	fnPer = round(tmpVal,g_demical)
end function
'===================================================================================================



'===================================================================================================
'#	fnSplit(strVal,strDiv,intVal)
'===================================================================================================
function fnSplit(strVal,strDiv,intVal)
	
	dim arrVal, tmp
	
	if inStr(strVal,strDiv) then
		arrVal = split(strVal,strDiv)
		if ubound(arrVal) < intVal then
			tmp = ""
		else
			tmp = arrVal(intVal)
		end if
	else
		tmp = ""
	end if
	
	fnSplit = tmp
	
end function
'===================================================================================================



'===================================================================================================
'#	fnZero(intVal,intLen)
'===================================================================================================
function fnZero(intVal,intLen)
	
	dim tmp : tmp = cStr(intVal)
	if len(tmp) < intLen then
		tmp = string(intLen-len(tmp),"0") & tmp
	end if
	fnZero = tmp
	
end function
'===================================================================================================



'===================================================================================================
'#	fnCutStr(strOrigin, nCutLen)
'===================================================================================================
Function fnCutStr(strOrigin, nCutLen)
		
		'원본문자열길이, 반환할 문자열 임시저장
		Dim	nOriginLen, strReturnString
		
		'변수 초기화
		nOriginLen = Len(strOrigin) '원본 문자열 길이
		strReturnString = ""				'반환 문자열 초기화

		'왼쪽부터 문자열길이카운트, for문 loop용 , for 문내 문자임시 저장용
		Dim nCountLen, i, chTemp

		'변수 초기화
		nCountLen = 0			'카운트 0 초기화

		For i = 1 To nOriginLen
			'현재 인덱스(i)로 부터 한문자가져오기
			chTemp = Mid(strOrigin, i, 1)
			
			'문자의 아스키코드값이 0 ~ 255 사이이면 1byte로 간주
			If ( Asc(chTemp) > 0 ) AND ( Asc(chTemp) < 255) Then
				nCountLen = nCountLen + 1
			Else
				nCountLen = nCountLen + 2
			End	If

			'반환문자열에 문자 추가하기
			strReturnString = strReturnString	 & chTemp

			'현재문자열의 길이가 제한 길이라면
			If nCountLen >= nCutLen Then
				strReturnString = strReturnString	& ".."
				'For문 탈출~~!!
				Exit For
			End If
		Next
		
		'반환문자열	return
		fnCutStr = strReturnString

	End Function
'===================================================================================================



'===================================================================================================
'#	fnByte
'===================================================================================================
function fnByte(strVal)
	if isnull(strVal) then
		nLen = 0
	else
		strVal = replace(strVal,chr(13)&chr(10),chr(13))
		dim t, tmp
		dim nLen : nLen = 0
		for t = 1 to len(strVal)
			tmp = mid(strVal,t,1)
			'response.write	"<div>" & tmp & ":" & asc(tmp) & "(" & nLen & ")(" & server.URLEncode(tmp) & "/" & inStrRev(server.URLEncode(tmp),"%") & ")</div>"
			'if asc(tmp) < 2 then
			if inStrRev(server.URLEncode(tmp),"%") > 1 then
				nLen = nLen + 2
			elseif asc(tmp) > 0 and asc(tmp) < 255 then
				nLen = nLen + 1
			else
				nLen = nLen + 2
			end if
		next
	end if
	fnByte = nLen
end function
'===================================================================================================



'===================================================================================================
'#	fnRandomStr
'===================================================================================================
function fnRandomStr(intLen, strDiv)
	dim strRnd, tmp, tmpRtn
	select case strDiv
		case "A" : strRnd = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		case "B" : strRnd = "abcdefghijklmnopqrstuvwxyz0123456789"
		case "C" : strRnd = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		case "D" : strRnd = "abcdefghijklmnopqrstuvwxyz"
		case "E" : strRnd = "0123456789"
	end select
	randomize
	for i = 1 to intLen
		tmp = int(len(strRnd) * rnd + 1)
		tmpRtn = tmpRtn & mid(strRnd,tmp,1)
	next
	fnRandomStr = tmpRtn
end function
'===================================================================================================



'===================================================================================================
'#	DEXT Upload
'===================================================================================================
dim fileUpload, fileUpFile


sub fileUpOpen(strFilePath)
	
	set fileUpload = server.createObject("DEXT.fileupload")
	fileUpload.codePage = 65001
	fileUpload.defaultPath = strFilePath
	
end sub

function fnGetUpFiles(strFilePath, arrFileForms)
	
	dim tmpFileOrgName, tmpFileName, tmpExt, tmpFile, tmpUpload
	dim strTmp : strTmp = ""
	
	for i = 0 to ubound(arrFileForms)
		
		if len(strTmp) > 0 then
			strTmp = strTmp & "}|{"
		end if
		
		if fileUpload.form(arrFileForms(i)).fileLen > 0 then
			
			if fileUpload.form(arrFileForms(i)).fileLen then
				
				set tmpFile = fileUpload.form(arrFileForms(i))
				
				if tmpFile.fileLen > fileUploadSize then
					
					response.write	"<script type=""text/javascript"">"
					response.write	"	alert('" & fileUploadSize/1024/1024 & "Mbyte 이상의 파일은 업로드할 수없습니다.');"
					response.write	"</script>"
					response.end
				
				end if
				
				tmpFileOrgName = tmpFile.fileName
				tmpExt = mid(tmpFileOrgName,instrrev(tmpFileOrgName,".")+1,len(tmpFileOrgName))
				tmpFileName = fnDateToStr(now,"yyyymmddhhnnss_" & (i+1)) & "." & tmpExt
				tmpUpload = tmpFile.saveAs(strFilePath & "/" & tmpFileName,false)
				set tmpFile = nothing
				strTmp = strTmp & tmpFileOrgName & "]|[" & tmpFileName
				
			else
				
				strTmp = strTmp & "" & "]|[" & ""
				
			end if
			
		else
			
			strTmp = strTmp & "" & "]|[" & ""
			
		end if
		
	next
	
	fnGetUpFiles = strTmp
	 
end function

function fnGetUpValues(arrForms)
	
	dim strTmp : strTmp = ""
	
	for i = 0 to ubound(arrForms)
	
		if len(strTmp) > 0 then
			strTmp = strTmp & "}|{"
		end if
		
		strTmp = strTmp & arrForms(i) & "]|[" & fileUpload.form(arrForms(i))
		
	next
	
	fnGetUpValues = strTmp
	
end function

sub fileUpClose()

	set fileUpload = nothing
	
end sub
'===================================================================================================



'===================================================================================================
'#	sub Table
'===================================================================================================
sub subTblOpen(strClass,arrCols,arrHeader)
	
	response.write	"<table border=""0"" cellpadding=""0"" cellspacing=""1"" class=""" & strClass & """ style=""margin-top:0;"">"
	
	if isArray(arrCols) = true then
		response.write	"	<colgroup>"
		
		for i = 0 to ubound(arrCols)
			response.write	"		<col width=""" & arrCols(i) & """>"
		next
		
		response.write	"	</colgroup>"
	end if
	
	if isArray(arrHeader) = true then
		response.write	"	<tr>"
		
		for i = 0 to ubound(arrHeader)
			response.write	"		<th>" & arrHeader(i) & "</th>"
		next
		
		response.write	"	</tr>"
	end if
	
end sub

sub subTblClose()
	response.write	"</table>"
end sub
'===================================================================================================




'#	============================================================================
'#	
'#	============================================================================
function fnChkPhoneNum(strVal)
	dim tmpVal : tmpVal = replace(strVal,"-","")
	dim nRtn, tmpChar
	nRtn = true
	if len(tmpVal) > 12 or len(tmpVal) < 7 then
		'=	길이가 12보다 크거나 7보다 작으면 false (최대 : xxxx-yyyy-zzzz, 최소 : xxx-yyyy)
		nRtn = false
	else
		for t = 1 to len(tmpVal)
			tmpChar = mid(tmpVal,t,1)
			if asc(tmpChar) < 48 or asc(tmpChar) > 57 then
				nRtn = false
				exit for
			end if
		next
	end if
	fnChkPhoneNum = nRtn
end function
'#	============================================================================




'#	============================================================================
'#	
'#	============================================================================
function fnChkMobileNum(strVal)
	dim tmpVal : tmpVal = replace(strVal,"-","")
	dim nRtn, tmpChar
	nRtn = true
	if len(tmpVal) > 13 or len(tmpVal) < 10 then
		'=	길이가 13보다 크거나 10보다 작으면 false
		nRtn = false
	else
		if left(tmpVal,3) = "010" or left(tmpVal,3) = "011" or left(tmpVal,3) = "016" or left(tmpVal,3) = "017" or left(tmpVal,3) = "018" or left(tmpVal,3) = "019" then
			nRtn = true
		else
			nRtn = false
		end if
	end if
	if nRtn = true then
		for t = 1 to len(tmpVal)
			tmpChar = mid(tmpVal,t,1)
			if asc(tmpChar) < 48 or asc(tmpChar) > 57 then
				nRtn = false
				exit for
			end if
		next
	end if
	fnChkMobileNum = nRtn
end function
'#	============================================================================




'#	============================================================================
'#	
'#	============================================================================
function fnChkEmail(strVal)
  dim isValidE
  dim regEx
  
  isValidE = True
  set regEx = New RegExp
  
  regEx.IgnoreCase = False
  
  regEx.Pattern = "^[a-zA-Z\-\_][\w\.-]*[a-zA-Z0-9\-\_]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
  isValidE = regEx.Test(strVal)
  
  set regEx = nothing
  
  fnChkEmail = isValidE
end function
'#	============================================================================



'#	============================================================================
'#	subCodeSelet(strUpCD, strNm, strDftVal)
'#	============================================================================
sub subCodeSelet(strUpCD, strNm, strDftVal)
	dim tmpRs : tmpRs = execProcRs("usp_listCode",array(strUpCD))
	response.write	"<select id=""" & strNm & """ name=""" & strNm & """>"
	response.write	"	<option value=""""> ::::: 선택 ::::: </option>"
	if isarray(tmpRs) then
		for t = 0 to ubound(tmpRs,2)
			response.write	"<option value=""" & tmpRs(0,t) & """"
			if cStr(tmpRs(0,t)) = cStr(strDftVal) then
				response.write	" selected "
			end if
			response.write	">" & tmpRs(1,t) & "</option>"
		next
	end if
	response.write	"</select>"
end sub
'#	============================================================================



'#	============================================================================
'#	subListTable(strTblID)
'#	============================================================================
sub subListTable(strTblID)
	
	response.write	"<table border=""0"" cellpadding=""0"" cellspacing=""1"" id=""" & strTblID & """ class=""tblList"">"
	response.write	"	<colgroup>"
	for t = 0 to ubound(arrListWidth)
		response.write	"<col width=""" & arrListWidth(t) & """ />"
	next
	response.write	"	</colgroup>"
	response.write	"	<thead>"
	response.write	"		<tr>"
	for t = 0 to ubound(arrListHeader)
		response.write	"<th>" & arrListHeader(t) & "</th>"
	next
	response.write	"		</tr>"
	response.write	"	</thead>"
	response.write	"	<tbody>"
	response.write	"	</tbody>"
	response.write	"</table>"
	
	response.write	"<div id=""listPaging""></div>"
	
end sub
'#	============================================================================



'#	============================================================================
'#	subPaging()
'#	============================================================================
sub subPaging()

	dim pageLimit
	
	if pageSize = "" then pageSize = g_pageSize end if
	
	pageLimit = clng(rowCnt) / clng(pageSize)
	if inStr(cStr(pageLimit),".") then
		pageLimit = pageLimit + 1
	end if
	pageLimit = fix(pageLimit)
	
	dim pageBlock, pageBegin, pageEnd
	pageBlock = g_pageBlock
	pageBegin = int((page-1) / pageBlock) * pageBlock + 1
	pageEnd = int(pageBegin + pageBlock - 1)

	if pageEnd < pageLimit then
		pageEnd = pageEnd
	else
		pageEnd = pageLimit
	end if
	
	response.write	"<div id=""paging"">" & vbcrlf
	if clng(pageBegin) > 1 then
		response.write	"	<a href=""javascript:fnLoadPage(" & pageBegin-1 & ")""><img src=""" & pth_pubImg & "/icons/control-left-stop.png"" /></a>" & vbcrlf
	else
		response.write	"	<img src=""" & pth_pubImg & "/icons/control-left-stop.png"" />" & vbcrlf
	end if
	if clng(page) > 1 then
		response.write	"	<a href=""javascript:fnLoadPage(" & page-1 & ")""><img src=""" & pth_pubImg & "/icons/control-left.png"" /></a>" & vbcrlf
	else
		response.write	"	<img src=""" & pth_pubImg & "/icons/control-left.png"" />" & vbcrlf
	end if
	response.write	"	&nbsp;&nbsp;"
	for i = pageBegin to pageEnd
		if clng(page) = clng(i) then
			response.write	"	<span class=""on""><a href=""javascript:fnLoadPage(" & i & ")"">" & i & "</a></span>"
		else
			response.write	"	<span><a href=""javascript:fnLoadPage(" & i & ")"">" & i & "</a></span>"
		end if
		if i < pageEnd then
			response.write	"	&nbsp;&nbsp;|&nbsp;&nbsp;"
		end if
	next
	response.write	"	&nbsp;&nbsp;"
	if clng(page) < clng(pageLimit) then
		response.write	"	<a href=""javascript:fnLoadPage(" & page + 1 & ")""><img src=""" & pth_pubImg & "/icons/control-right.png"" /></a>" & vbcrlf
	else
		response.write	"	<img src=""" & pth_pubImg & "/icons/control-right.png"" />" & vbcrlf
	end if
	if clng(pageEnd) < clng(pageLimit) then
		response.write	"	<a href=""javascript:fnLoadPage(" & pageEnd + 1 & ")""><img src=""" & pth_pubImg & "/icons/control-right-stop.png"" /></a>" & vbcrlf
	else
		response.write	"	<img src=""" & pth_pubImg & "/icons/control-right-stop.png"" />" & vbcrlf
	end if
	response.write	"</div>"
	
end sub
'#	============================================================================
'#	============================================================================
'#	subPaging2()
'#	============================================================================
sub subPaging2(strFunc)

	dim pageLimit
	
	if pageSize = "" then pageSize = g_pageSize end if
	
	pageLimit = clng(rowCnt) / clng(pageSize)
	if inStr(cStr(pageLimit),".") then
		pageLimit = pageLimit + 1
	end if
	pageLimit = fix(pageLimit)
	
	dim pageBlock, pageBegin, pageEnd
	pageBlock = g_pageBlock
	pageBegin = int((page-1) / pageBlock) * pageBlock + 1
	pageEnd = int(pageBegin + pageBlock - 1)

	if pageEnd < pageLimit then
		pageEnd = pageEnd
	else
		pageEnd = pageLimit
	end if
	
	response.write	"<div id=""paging"">" & vbcrlf
	if clng(pageBegin) > 1 then
		response.write	"	<a href=""javascript:" & strFunc & "(" & pageBegin-1 & ")""><img src=""" & pth_pubImg & "/icons/control-left-stop.png"" /></a>" & vbcrlf
	else
		response.write	"	<img src=""" & pth_pubImg & "/icons/control-left-stop.png"" />" & vbcrlf
	end if
	if clng(page) > 1 then
		response.write	"	<a href=""javascript:" & strFunc & "(" & page-1 & ")""><img src=""" & pth_pubImg & "/icons/control-left.png"" /></a>" & vbcrlf
	else
		response.write	"	<img src=""" & pth_pubImg & "/icons/control-left.png"" />" & vbcrlf
	end if
	response.write	"	&nbsp;&nbsp;"
	for i = pageBegin to pageEnd
		if clng(page) = clng(i) then
			response.write	"	<span class=""on""><a href=""javascript:" & strFunc & "(" & i & ")"">" & i & "</a></span>"
		else
			response.write	"	<span><a href=""javascript:" & strFunc & "(" & i & ")"">" & i & "</a></span>"
		end if
		if i < pageEnd then
			response.write	"	&nbsp;&nbsp;|&nbsp;&nbsp;"
		end if
	next
	response.write	"	&nbsp;&nbsp;"
	if clng(page) < clng(pageLimit) then
		response.write	"	<a href=""javascript:" & strFunc & "(" & page + 1 & ")""><img src=""" & pth_pubImg & "/icons/control-right.png"" /></a>" & vbcrlf
	else
		response.write	"	<img src=""" & pth_pubImg & "/icons/control-right.png"" />" & vbcrlf
	end if
	if clng(pageEnd) < clng(pageLimit) then
		response.write	"	<a href=""javascript:" & strFunc & "(" & pageEnd + 1 & ")""><img src=""" & pth_pubImg & "/icons/control-right-stop.png"" /></a>" & vbcrlf
	else
		response.write	"	<img src=""" & pth_pubImg & "/icons/control-right-stop.png"" />" & vbcrlf
	end if
	response.write	"</div>"
	
end sub
'#	============================================================================
%>

<%
'#	================================================================================================
sub subAjxList(strProc, strWhr, strOrd, intPage, intPageSize)
	
	dim tmpCols, tmpFrom, tmpWhr, tmpOrd, tmpSql
	
	select case strProc
		case "msg"
			
			tmpCols = " msg.MSG_IDX, msg.AD_IDX, ufn_getAddrID(msg.AD_IDX) as ADID, msg.MSG_TP, msg.MSG_GB, ufm_getCodeName(msg.CD_MSGGB) as CDMSGGB, msg.MSG_CD, msg.MSG_TIT, msg.REGDT, msg.UPTDT "
			tmpFrom = " TBL_MSG as msg "
			tmpWhr = " USEYN = 'Y' "
			tmpOrd = " MSG_SORT asc, MSG_CD asc, MSG_TIT asc "
			
	end select
	
	if len(strWhr) > 0 then
		tmpWhr = tmpWhr & " and " & strWhr
	end if
	if len(strOrd) > 0 then
		tmpOrd = strOrd & ", " & tmpOrd
	end if
	
	rowCnt = fnDBVal("tmpFrom", "count(*)", tmpWhr)
	
	tmpSql = " select " & rowCnt & " as rowNum, " & tmpCols
	tmpSql = tmpSql & " from " & tmpFrom
	tmpSql = tmpSql & " where " & tmpWhr & " and " & strWhr
	tmpSql = tmpSql & " order by " & tmpOrd
	tmpSql = tmpSql & " limit " & intPageSize * (intPage - 1) & ", " & intPageSize
	arrRs = execSqlRs(tmpSql)
	
	if isarray(arrRs) then
		arrRc = ubound(arrRs,2)
	else
		arrRc = -1
	end if
	
end sub
'#	================================================================================================



'===================================================================================================
'#	Period to Str
'===================================================================================================
function fnPeriodToStr(strSDT, strEDT)
dim tmp
	if isDate(strSDT) and isDate(strEDT) then
		tmp = dateDiff("s",strSDT,strEDT)
		if tmp > 59 then
			if tmp > 3599 then
				tmp = fix((tmp/60)/60) & "시간 " & (fix(tmp/60) mod 60) & "분 " & (tmp mod 60) & "초"
			else
				tmp = fix(tmp/60) & "분 " & (tmp mod 60) & "초"
			end if
		else
			tmp = tmp & "초"
		end if
	else
		tmp = "-"
	end if
	fnPeriodToStr = tmp
end function

function fnPeriodToStr_seoulMetro(strSDT, strEDT)
dim tmp
	if isDate(strSDT) and isDate(strEDT) then
		tmp = dateDiff("s",strSDT,strEDT)
		if tmp > 59 then
			if tmp > 3599 then
				tmp = fix((tmp/60)/60) & "시간 " & (fix(tmp/60) mod 60) & "분 " & (tmp mod 60) & "초"
			else
				tmp = fix(tmp/60) & "분 " & (tmp mod 60) & "초"
			end if
		else
			tmp = "0분" & tmp & "초"
		end if
	else
		tmp = "-"
	end if
	fnPeriodToStr_seoulMetro = tmp
end function
'===================================================================================================


'===================================================================================================
'#	Create TextArea
'===================================================================================================
sub subTextArea(strNM, strW, strH, intLen, strVal)
	response.write	"<div  style=""width:" & strW & ";"">"
	response.write	"	<textarea id=""" & strNM & """ name=""" & strNM & """ style=""width:100%;height:" & strH & ";"""
	'response.write	" onkeypress=""fnByteMaxlength('" & strNM & "', " & intLen & ")"""
	response.write	" onkeyup=""fnByteMaxlength('" & strNM & "', " & intLen & ")"""
	'response.write	" onkeydown=""fnByteMaxlength('" & strNM & "', " & intLen & ")"""
	response.write	">" & strVal & "</textarea>"
	response.write	"	<div class=""aR fnt11 colGray""><span id=""" & strNM & "_printByte"">0</span> Byte</div>"
	response.write	"</div>"
end sub
'===================================================================================================


'===================================================================================================
'#	IsNull
'===================================================================================================
function fnIsNull(strVal, strNull)
	if isnull(strVal) or len(strVal) = 0 then
		fnIsNull = strNull
	else
		fnIsNull = strVal
	end if
end function
'===================================================================================================
%>