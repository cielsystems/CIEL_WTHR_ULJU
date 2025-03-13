<!--#include virtual="/common/common.asp"-->

<%
dim strPath : strPath = fnCreatePath("/data/board")

fileUpOpen(strPath)

dim arrFiles : arrFiles = array("upfile1")
dim strFile : strFile = fnGetUpFiles(strPath, arrFiles)

dim arrForms : arrForms = array("proc","cdBoardGB","bdIdx","bdTit","bdCont")
dim strForm : strForm = fnGetUpValues(arrForms)

fileUpClose()

dim arrFile : arrFile = split(strFile,"]|[")
strFile = arrFile(1)

dim arrForm : arrForm = split(strForm,"}|{")
dim arrVal
dim proc, cdBoardGB, bdIdx, bdTit, bdCont
for i = 0 to ubound(arrForm)
	arrVal = split(arrForm(i),"]|[")
	if i = 0 then
		proc = arrVal(1)
	elseif i = 1 then
		cdBoardGB = arrVal(1)
	elseif i = 2 then
		bdIdx = arrVal(1)
	elseif i = 3 then
		bdtit = arrVal(1)
	elseif i = 4 then
		bdCont = arrVal(1)
	end if
next

dim fileExt : fileExt = mid(strFile,instrrev(strFile,".")+1,len(strFile))
dim fileExtYN

if len(strFile) > 0 then
	for i = 0 to ubound(arrNonFileExt)
		if fileExt = arrNonFileExt(i) then
			fileExtYN = "N"
			exit for
		end if
	next
	if fileExtYN = "N" then
		strFile = fnDeleteFile("/data/addr/" & strFile)
		response.write	"<script>"
		response.write	"	alert('업로드할 수 없는 파일형식 입니다.');"
		response.write	"</script>"
		response.end
	end if
end if

dim bdFile01 : bdFile01 = arrFile(0) & "]|[" & arrFile(1)

dim strProc
if proc = "I" then
	
	sql = " insert into TBL_BOARD (CD_BOARDGB, AD_IDX, BD_TIT, BD_CONT, BD_FILE01) "
	sql = sql & " values (" & cdBoardGB & ", " & ss_userIdx & ", '" & bdTit & "', '" & bdCont & "', '" & bdFile01 & "') "
	
	strProc = "추가"
	
elseif proc = "U" then
	
	sql = " update TBL_BOARD set BD_TIT = '" & bdTit & "', BD_CONT = '" & bdCont & "', BD_FILE01 = '" & bdFile01 & "', UPTDT = getdate() where BD_IDX = " & bdIdx & " "
	
	strProc = "수정"
	
elseif proc = "D" then
	
	sql = " update TBL_BOARD set USEYN = 'N'', UPTDT = getdate() where BD_IDX = " & bdIdx & " "
	
	strProc = "삭제"
	
end if
response.write	sql
call execSql(sql)

call subSetLog(ss_userIdx, 8005, "게시판" & strProc, "bdIdx : " & bdIdx & "", "")
%>

<script>
	alert('<%=strProc%>되었습니다.');
	top.location.reload();
</script>