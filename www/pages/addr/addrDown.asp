<!--#include virtual="/common/common.asp"-->

<%
dim listGubn	: listGubn	= fnIsNull(nFnReq("listGubn",	1),			"A")
dim grupIndx	: grupIndx	= fnIsNull(nFnReq("grupIndx",	0),			0)
dim schKey		: schKey		= fnIsNull(nFnReq("schKey",		10),		"")
dim schVal		: schVal		= fnIsNull(nFnReq("schVal",		50),		"")
dim page			: page			= fnIsNull(nFnReq("page",			0),			1)
dim pageSize	: pageSize	= fnIsNull(nFnReq("pageSize",	0),			g_pageSize)
dim addrCode	: addrCode	= fnIsNull(nFnReq("addrCode",	4000),	"")

page	= 1
pageSize	= 999999

'response.write	" exec nusp_listAddr '" & grupGubn & "', " & grupIndx & ", '" & schKey & "', '" & schVal & "', " & page & ", " & pageSize & ", '" & addrCode & "', " & ss_userIndx & ", '" & svr_remoteAddr & "' "

set rs = server.createobject("adodb.recordset")
set cmd = server.createobject("adodb.command")
with cmd

	.activeconnection = strDBConn
	.commandtext = "nusp_listAddr"
	.commandtype = adCmdStoredProc
	
	.parameters.append .createParameter("@listGubn",	adVarchar,			adParamInput,		2)
	.parameters.append .createParameter("@grupIndx",	adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@schKey",		adVarchar,	adParamInput,		50)
	.parameters.append .createParameter("@schVal",		adVarchar,	adParamInput,		50)
	.parameters.append .createParameter("@page",			adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@pageSize",	adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@addrCode",	adVarchar,	adParamInput,		4000)
	.parameters.append .createParameter("@userIndx",	adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@userIP",		adVarchar,	adParamInput,		20)
	
	.parameters("@listGubn")	= listGubn
	.parameters("@grupIndx")	= grupIndx
	.parameters("@schKey")		= schKey
	.parameters("@schVal")		= schVal
	.parameters("@page")			= page
	.parameters("@pageSize")	= pageSize
	.parameters("@addrCode")	= addrCode
	.parameters("@userIndx")	= ss_userIndx
	.parameters("@userIP")		= svr_remoteAddr
	
	set rs = .execute
	
end with
set cmd = nothing

if not rs.eof then
	arrRs		= rs.getRows
	arrRc1	= ubound(arrRs, 1)
	arrRc2	= ubound(arrRs, 2)
	rowCnt	= arrRs(0,0)
else
	arrRc2	= -1
	rowCnt	= 0
end if
set rs = nothing

dim fileName	: fileName	= "download_" & fnDateToStr(now, "yyyymmddhhnnss") & ".csv"

dim fso, objFile

set fso	= server.createObject("scripting.fileSystemObject")
set objFile	= fso.createTextFile(server.mapPath("\data\addr\down") & "\" & fileName, true)

dim arrAddrDnHeader : arrAddrDnHeader = array("부서(그룹)1","부서(그룹)2","부서(그룹)3","부서(그룹)4","부서(그룹)5"_
	,"이름",arrCallMedia(1),arrCallMedia(2),arrCallMedia(3),"메모","분류코드")

dim nArrGrup, nArrGrupSub, nGrup(5)
dim nName, nNum1, nNum2, nNum3, nMemo, nAddrCode

objFile.write	"* 구분기호(탭)으로 분리된 CSV 파일입니다." & chr(13)

for i = 0 to ubound(arrAddrDnHeader)
	objFile.write	"" & arrAddrDnHeader(i) & "	"
next
objFile.write chr(13)

for i = 0 to arrRc2
	
	nArrGrup	= split(fnIsNull(arrRs(9, i), ""), "^")
	if ubound(nArrGrup) > 0 then
		nArrGrupSub	= split(fnIsNull(nArrGrup(0), ""), "|")
		for ii = 0 to ubound(nArrGrupSub)
			nGrup(ii)	= nArrGrupSub(ii)
		next
	end if
	
	objFile.write	"" & fnIsNull(nGrup(1), "") & "	"
	objFile.write	"" & fnIsNull(nGrup(2), "") & "	"
	objFile.write	"" & fnIsNull(nGrup(3), "") & "	"
	objFile.write	"" & fnIsNull(nGrup(4), "") & "	"
	objFile.write	"" & fnIsNull(nGrup(5), "") & "	"
	
	objFile.write	"" & fnIsNull(arrRs(5, i), "") & "	"
	objFile.write	"" & fnIsNull(arrRs(6, i), "") & "	"
	objFile.write	"" & fnIsNull(arrRs(7, i), "") & "	"
	objFile.write	"" & fnIsNull(arrRs(8, i), "") & "	"
	objFile.write	"" & fnIsNull(arrRs(11, i), "") & "	"
	objFile.write	"" & replace(replace(fnIsNull(arrRs(10, i), ""), "[", ""), "] ", ">") & "	"

	if i < arrRc2 then
		objFile.write chr(13)
	end if
	
next

set objFile = nothing
set fso = nothing

call subSetLog(ss_userIdx, 8004, "주소록다운로드", fileName, "")

response.redirect	"/data/addr/down/" & fileName

'response.write	"<a href=""/data/addr/down/" & fileName & """>" & fileName & "</a>"
%>