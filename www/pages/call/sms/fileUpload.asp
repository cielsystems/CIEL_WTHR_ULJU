<!--#include virtual="/common/common.asp"-->

<%
dim filePath : filePath = "/data"

dim upPath : upPath = fnCreatePath(filePath & "/tmp")

fileUpOpen(upPath)

dim arrForms : arrForms = array("proc","gb")
dim strForms : strForms = fnGetUpValues(arrForms)
dim arrForm : arrForm = split(strForms,"}|{")
dim arrFormVal
dim proc, gb
for i = 0 to ubound(arrForm)
	arrFormVal = split(arrForm(i),"]|[")
	select case arrFormVal(0)
		case "proc"	: proc = arrFormVal(1)
		case "gb"	: gb = arrFormVal(1)
	end select
next
proc = lCase(proc)

dim fileName : fileName = fileUpload.form("upfile").fileName
dim fileExt : fileExt = mid(fileName,instrrev(fileName,".")+1,len(fileName))

if gb = "mms" then

	if fileExt = "jpg" or fileExt = "jpeg" then
		response.write	"ok"
	else
		response.write	"<script>"
		response.write	"	alert('jpg 또는 jpeg 파일만 업로드 가능합니다.(" & fileExt & ")');"
		response.write	"</script>"
		response.end
	end if

end if

dim subPath : subPath = "mms" & fnDateToStr(now,"/yyyy/mm/dd")
filePath = filePath & "/" & subPath

upPath = fnCreatePath(filePath)

dim arrFiles : arrFiles = array("upFile")
dim strFile : strFile = fnGetUpFiles(upPath, arrFiles)

dim arrFile : arrFile = split(strFile,"]|[")

fileUpClose()
'#	파일업로드 : End

'#	이미지 사이즈 변경 : Start
dim imgOrg : imgOrg = "http://" & siteUrl & filePath & "/" & arrFile(1) & "?w=220"

response.write	imgOrg

dim xh, stm, imgData
set xh = createObject("MSXML2.ServerXMLHTTP")
xh.open "GET", imgOrg, false
xh.send()
imgData = xh.responseBody
set xh = nothing

set stm =createObject("ADODB.Stream")
stm.open()
stm.type=1
stm.write imgData
response.write	server.mapPath("\") & filePath & "/" & arrFile(1)
stm.saveToFile server.mapPath("\") & filePath & "/" & arrFile(1), 2
stm.close()
set  stm = Nothing
'#	이미지 사이즈 변경 : End

dim nNo : nNo = fnDBMax("TMP_CALLFILE", "TMP_NO", "CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")

dim nSort : nSort = fnDBMax("TMP_CALLFILE", "TMP_SORT", "CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
nSort = cint(nSort) + 1

sql = " insert into TMP_CALLFILE (CL_IDX, AD_IDX, AD_IP, TMP_GB, TMP_NO, TMP_SORT, TMP_DPNM, TMP_PATH, TMP_FILE, TMP_PAGE) "
sql = sql & " values (0, " & ss_userIdx & ", '" & svr_remoteAddr & "', 'S', " & nNo & ", " & nSort & ", '" & arrFile(0) & "', '" & subPath & "','" & arrFile(1) & "', 0) "
response.write	sql
call execSql(sql)

response.write	"<script>"
response.write	"top.frmFileAdd.upfile.value = '';"
response.write	"top.fnFileLoad();"
'response.write	"top.fnAddMMSFile(" & nNo & ",'" & subPath & "/" & arrFile(1) & "');"
response.write	"</script>"
%>