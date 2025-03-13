<!--#include virtual="/common/common.asp"-->

<%
dim filePath : filePath = "/data"

dim upPath : upPath = fnCreatePath(filePath & "/tmp")

fileUpOpen(upPath)

dim arrForms : arrForms = array("proc","idx","flePG")
dim strForms : strForms = fnGetUpValues(arrForms)
dim arrForm : arrForm = split(strForms,"}|{")
dim arrFormVal
dim proc, idx, flePG
flePG = "0"
for i = 0 to ubound(arrForm)
	arrFormVal = split(arrForm(i),"]|[")
	select case arrFormVal(0)
		case "proc"	: proc = arrFormVal(1)
		case "idx"	: idx = arrFormVal(1)
		case "flePG"	: flePG = arrFormVal(1)
	end select
next
proc = lCase(proc)

if fileUpload.form("upFile").fileLen > fileUploadSize then
		
	response.write	"<script>"
	response.write	"	alert('" & fileUploadSize/1024/1024 & "Mbyte 이상의 파일은 업로드할 수없습니다.');"
	response.write	"</script>"
	response.end

end if

dim fileName : fileName = fileUpload.form("upFile").fileName
dim fileExt : fileExt = mid(fileName,instrrev(fileName,".")+1,len(fileName))

dim fileExtUse : fileExtUse = "N"
dim subPath

if left(proc,3) = "sms" then

	if fileExt = "jpg" or fileExt = "jpeg" then
		fileExtUse = "Y"
	end if
	
	if len(proc) = 3 then
		subPath = "mms"
	else
		subPath = "msg"
	end if
	
elseif left(proc,3) = "vms" then
	
	if fileExt = "wav" or fileExt = "pcm" or fileExt = "vox" then
		fileExtUse = "Y"
	end if
	
	if len(proc) = 3 then
		subPath = "vms"
	else
		subPath = "msg"
	end if
	
elseif left(proc,3) = "fms" then
	
	for i = 0 to ubound(arrDocFileExt)
		if arrDocFileExt(i) = fileExt then
			fileExtUse = "Y"
			exit for
		end if
	next
	for i = 0 to ubound(arrImgFileExt)
		if arrImgFileExt(i) = fileExt then
			fileExtUse = "Y"
			exit for
		end if
	next

	subPath = "fms"

end if

if fileExtUse <> "Y" then
	response.write	"<script>"
	response.write	"	alert('사용할수 없는 파일형식입니다.(" & proc & "/" & fileExt & ")');"
	response.write	"</script>"
	response.end
end if

if len(proc) = 3 then
	subPath = subPath & fnDateToStr(now,"/yyyy/mm/dd")
end if
filePath = filePath & "/" & subPath

upPath = fnCreatePath(filePath)

dim arrFiles : arrFiles = array("upFile")
dim strFile : strFile = fnGetUpFiles(upPath, arrFiles)

fileUpClose()

dim arrFile : arrFile = split(strFile,"]|[")

'#	이미지 사이즈 변경 : Start
if left(proc,3) = "sms" then
	dim imgOrg : imgOrg = "https://" & siteUrl & filePath & "/" & arrFile(1) & "?w=220"
	response.write	imgOrg
	
	dim xh, stm, imgData
	Set xh = CreateObject("MSXML2.ServerXMLHTTP")
	xh.Open "GET", imgOrg, false
	xh.Send()
	imgData = xh.ResponseBody
	Set  xh = Nothing
	
	Set stm =CreateObject("ADODB.Stream")
	stm.open()
	stm.type=1
	stm.write imgData
	response.write	server.mapPath("\") & filePath & "/" & arrFile(1)
	stm.SaveToFile server.mapPath("\") & filePath & "/" & arrFile(1), 2
	stm.close()
	Set  stm = Nothing
end if
'#	이미지 사이즈 변경 : End

dim tmpTable, tmpIdxCol
if len(proc) = 3 then
	tmpTable = "TMP_CALLFILE"
	tmpIdxCol = "CL_IDX"
else
	tmpTable = "TMP_MSGFILE"
	tmpIdxCol = "MSG_IDX"
end if

proc = uCase(left(proc,3))

dim nNo : nNo = fnDBMax(tmpTable, "TMP_NO", "" & tmpIdxCol & " = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' and TMP_GB = '" & left(proc,1) & "'")
nNo = cint(nNo) + 1

dim nSort : nSort = fnDBMax(tmpTable, "TMP_SORT", "" & tmpIdxCol & " = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' and TMP_GB = '" & left(proc,1) & "'")
nSort = cint(nSort) + 1

sql = " insert into " & tmpTable & " (" & tmpIdxCol & ", AD_IDX, AD_IP, TMP_GB, TMP_NO, TMP_SORT, TMP_DPNM, TMP_PATH, TMP_FILE, TMP_PAGE) "
sql = sql & " values (" & idx & ", " & ss_userIdx & ", '" & svr_remoteAddr & "', '" & left(proc,1) & "', " & nNo & ", " & nSort & ", '" & arrFile(0) & "', '" & subPath & "', '" & arrFile(1) & "', '" & flePG & "') "
response.write	sql
call execSql(sql)

response.write	"<script>"
response.write	"top.fn" & proc & "LoadFile();"
response.write	"top.fnCloseLayer();"
response.write	"</script>"
%>