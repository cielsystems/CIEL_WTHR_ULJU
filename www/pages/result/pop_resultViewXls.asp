<!--#include virtual="/common/common.asp"-->

<%
dim clIdx : clIdx = fnReq("clIdx")

dim clCode : clCode = fnDBVal("TBL_CALL", "CL_CODE", "CL_IDX = " & clIdx & "")

dim fileName : fileName = clCode & ".xls"

response.cacheControl = "public"
response.charSet = "utf-8"
response.contentType = "application/vnd.ms-excel"
response.addHeader "Content-disposition","attachment;filename=" & server.URLPathEncode(fileName)

arrRs = execProcRs("usp_listCallResultTargets", array(clIdx, "0", "0", "", "", 1, 999999))
if isarray(arrRs) then
	arrRc2 = ubound(arrRs,2)
else
	arrRc2 = -1
end if

response.write	"<html>"
response.write	"<head>"
response.write	"<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"">"
response.write	"<style type=""text/css"">"
response.write	"	.txt {mso-number-format:'\@'}"
response.write	"</style>"
response.write	"</head>"
response.write	"<body>"
response.write	"<table border=""1"">"
response.write	"	<tr>"
response.write	"		<th>번호</th>"
response.write	"		<th>사번</th>"
response.write	"		<th>이름</th>"
for i = 1 to ubound(arrCallMedia)
	response.write	"		<th>" & arrCallMedia(i) & "번호</th>"
next
response.write	"		<th>시작일시</th>"
response.write	"		<th>종료일시</th>"
response.write	"		<th>문자상태</th>"
response.write	"		<th>응답여부</th>"
response.write	"	</tr>"
'//	CLT_NO(2), CLT_NM(3), CLT_SDR(4), CLT_EDT(5), CD_STATUS(6), CDSTATUSNM(7), CD_RESULT(8), CD_RESULTNM(9), CD_ERROR(10)
'//	, CDERRORNM(11), CLT_ANSWYN(12), CLT_ANSWMEDIA(13), CLT_ANSWDT(14), CD_SMSSTATUS(15), CD_VMSSTATUS(16), CLTSTATUS(17), CLT_NUM1(18), CLT_NUM2(19), CLT_NUM3(20), AD_NO(21)
for i = 0 to arrRc2
	response.write	"<tr>"
	response.write	"	<td class=""txt"">" & arrRs(0,i)-i & "</td>"
	response.write	"	<td class=""txt"">" & arrRs(21,i) & "</td>"
	response.write	"	<td class=""txt"">" & arrRs(3,i) & "</td>"
	response.write	"	<td class=""txt"">" & arrRs(18,i) & "</td>"
	response.write	"	<td class=""txt"">" & arrRs(19,i) & "</td>"
	response.write	"	<td class=""txt"">" & arrRs(20,i) & "</td>"
	response.write	"	<td class=""txt"">" & arrRs(4,i) & "</td>"
	response.write	"	<td class=""txt"">" & arrRs(5,i) & "</td>"
	
	response.write	"<td class=""txt"">"
	if arrRs(15,i) = "3031" then
		response.write	"대기"
	elseif arrRs(15,i) = "3032" then
		response.write	"진행중"
	elseif arrRs(15,i) = "3033" then
		response.write	"완료"
	elseif arrRs(15,i) = "3034" then
		response.write	"취소"
	elseif arrRs(15,i) = "3035" then
		response.write	"실패"
	end if
	response.write	"</td>"
	
	response.write	"<td class=""txt"">"
	if arrRs(12,i) = "Y" then
		if arrRs(13,i) = "S" then
			response.write "MO"
		elseif arrRs(13,i) = "V" then
			response.write "음성"
		end if
		response.write	"응답"
	else
		response.write	"미응답"
	end if
	response.write	"</td>"
	
	response.write	"</tr>"
next
response.write	"</table>"
response.write	"</body>"
response.write	"</html>"
%>