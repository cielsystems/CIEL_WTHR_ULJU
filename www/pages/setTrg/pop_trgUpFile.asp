<!--#include virtual="/common/common.asp"-->

<%
dim strPath	: strPath = fnCreatePath("/data/addr")

fileUpOpen(strPath)

dim arrFiles	: arrFiles	= array("upfile")
dim strFile		: strFile		= fnGetUpFiles(strPath, arrFiles)

response.write	"<div>strFile : " & strFile & "</div>"

dim arrForms	: arrForms	= array("proc", "oldAddrDel")
dim strForm		: strForm		= fnGetUpValues(arrForms)

response.write	"<div>strForm : " & strForm & "</div>"

fileUpClose()

dim arrForm : arrForm = split(strForm,"}|{")
dim proc, oldAddrDel
dim arrVal
for i = 0 to ubound(arrForm)
	arrVal = split(arrForm(i),"]|[")
	if arrVal(0) = "proc" then
		proc	= arrVal(1)
	elseif arrVal(0) = "oldAddrDel" then
		oldAddrDel	= arrVal(1)
	end if
next

response.write	"<div>proc : " & proc & "/oldAddrDel : " & oldAddrDel & "</div>"

dim arrFile : arrFile = split(strFile,"]|[")
dim strOrgnFile	: strOrgnFile	= arrFile(0)
dim strRealFile	: strRealFile	= arrFile(1)

response.write	"<div>strOrgnFile	: " & strOrgnFile & "</div>"
response.write	"<div>strRealFile	: " & strRealFile & "</div>"

dim fileExt : fileExt = mid(strRealFile, instrrev(strRealFile, ".")+1, len(strRealFile))

response.write	"<div>fileExt : " & fileExt & "</div>"

if fileExt = "xls" or fileExt = "xlsx" then
	response.write	"ok"
else
	response.write	"<script type=""text/javascript"">"
	response.write	"	parent.fnFileUpChek('', 0);"
	response.write	"	alert('xls, xlsx 파일만 업로드 가능합니다.');"
	response.write	"</script>"
	
	response.write	"<div>Delete File : " & "/data/addr/" & strRealFile & "</div>"
	
	retn	= fnDeleteFile("/data/addr/" & strRealFile)
	
	response.write	"<div>Delete : " & retn & "</div>"
	
	response.end
end if

response.write	"<div>strPath : " & strPath & "</div>"

strPath = replace(strPath,"//","/")
strPath = replace(strPath,"/","\")

response.write	"<div>strPath : " & strPath & "</div>"

'#	xls, xlsx 파일 업로드
dim strXlsConn, xlsConn
if fileExt = "xls" then
	strXlsConn = "provider=Microsoft.Jet.OLEDB.4.0;data source=" & strPath & "\" & strRealFile & ";extended properties=""excel 8.0;HDR=yes;IMEX=1;"";"
elseif fileExt = "xlsx" then
	strXlsConn = "provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & strPath & "\" & strRealFile & ";extended properties=""excel 12.0 Xml;HDR=yes;IMEX=1"";"
end if

set xlsConn = server.CreateObject("adodb.connection")
xlsConn.open strXlsConn

dim oAdox, oTable, sheetName
set oAdox = CreateObject("ADOX.Catalog")
oAdox.activeConnection = strXlsConn
for each oTable in oAdox.Tables
	sheetName = oTable.Name
	exit for
next
set oAdox = nothing

dim xlsRs, dataRs, dataRc1, dataRc2, dataLoop1, dataLoop2
sql = " select * from [" & sheetName & "] "
set xlsRs = server.createObject("adodb.recordset")
xlsRs.open sql, xlsConn, adOpenStatic, adLockReadOnly
if not xlsRs.eof then
	dataRs	= xlsRs.getRows
	dataRc1	= ubound(dataRs, 1)
	dataRc2	= ubound(dataRs, 2)
else
	dataRc2	= -1
end if
xlsRs.close()
xlsConn.close()
set xlsRs = nothing
set xlsConn = nothing

dim limtCnt	: limtCnt	= 1000

if dataRc2 + 1 > limtCnt then
	
	response.write	"<script type=""text/javascript"">"
	response.write	"	parent.fnFileUpChek('', 0);"
	response.write	"	alert('최대 업로드 건수는 " & formatNumber(limtCnt, 0) & "건 입니다.(현재:" & (dataRc2 + 1) & "건)\n" & formatNumber(limtCnt, 0) & "건 이하로 분할해 업로드 해주세요.');"
	response.write	"</script>"
	
	response.write	"<div>Delete File : " & "/data/addr/" & strRealFile & "</div>"
	
	retn	= fnDeleteFile("/data/addr/" & strRealFile)
	
	response.write	"<div>Delete : " & retn & "</div>"
	
	response.end
	
end if

'#	================================================================================================
'#	Data Loop
'#	------------------------------------------------------------------------------------------------
dim dataCnt		: dataCnt		= 0
dim allData		: allData		= ""
dim chekEror	: chekEror	= false
dim strMesg
dim nData, nLine
dim arrViewData(3, 4)

for dataLoop2 = 0 to dataRc2
	
	nLine	= dataLoop2 + 1
	
	for dataLoop1 = 0 to 3
		allData	= allData	& trim(dataRs(dataLoop1, dataLoop2))
	next
	
	if len(allData) > 0 then
		
		dataCnt	= dataCnt + 1
		
		for dataLoop1 = 0 to 3
			
			nData	= fnIsNull(dataRs(dataLoop1, dataLoop2), "")
			nData	= replace(nData, chr(10), " ")
			nData	= trim(nData)
			nData	= fnInject(nData)
			
			'#	휴대폰번호 확인
			if dataLoop1 = 1 then
				if len(nData) = 0 then
					chekEror	= true
					strMesg	= nLine & "번째 데이터에 휴대폰번호가 없습니다."
					exit for
				end if
				if fnChkMobileNum(nData) = false then
					chekEror	= true
					strMesg	= nLine & "번째 데이터에 휴대폰번호가 형식에 맞지 않습니다.(" & nData & ")"
					exit for
				end if
			end if
			
			if dataLoop2 < 5 then
				arrViewData(dataLoop1, dataLoop2)	= nData
			end if
			
		next
		
	end if
	
next
'#	================================================================================================

response.write	"<div>chekEror : " & chekEror & "</div>"
response.write	"<div>strMesg : " & strMesg & "</div>"

if chekEror = true then
	
	response.write	"<script type=""text/javascript"">"
	response.write	"	parent.fnFileUpChek('', 0);"
	response.write	"	alert('" & strMesg & "');"
	response.write	"</script>"
	
	response.write	"<div>Delete File : " & "/data/addr/" & strRealFile & "</div>"
	
	retn	= fnDeleteFile("/data/addr/" & strRealFile)
	
	response.write	"<div>Delete : " & retn & "</div>"
	
	response.end
	
elseif chekEror = false then
	
	response.write	"<script type=""text/javascript"">"
	response.write	"	parent.fnFileUpChek('" & strRealFile & "', " & dataCnt & ");"
	for i = 0 to ubound(arrViewData, 2)
		response.write	"parent.fnViewData('"
		for ii = 0 to ubound(arrViewData, 1)
			response.write	"" & arrViewData(ii, i) & ""
			if ii < ubound(arrViewData, 1) then
				response.write	"]|["
			end if
		next
		response.write	"');"
	next
	response.write	"</script>"
	
end if
%>