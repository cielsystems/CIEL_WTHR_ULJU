<!--#include virtual="/common/common.asp"-->

<%
dim file : file = request("file")

file = server.mapPath("\") & "\" & file
file = replace(file,"\\","\")
file = replace(file,"/","\")

dim fileNm : fileNm = mid(file,instrrev(file,"\")+1,len(file))

dim fso, stm
set fso = server.createObject("scripting.fileSystemObject")

if fso.fileExists(file) then
	response.contentType = "application/octet-stream"
	response.cacheControl = "public"
	response.addHeader "Content-Disposition","attachment;fileName=" & fileNm
	set stm = server.createObject("adodb.stream")
	stm.open
	stm.type = 1
	stm.loadFromFile file
	dim dn : dn = stm.read
	response.binaryWrite dn
	stm.close
	set stm = nothing
	response.write	file
else
	response.write	"<script>alert('파일이 없습니다.');</script>"
	response.write	file
end if

set fso = nothing
%>