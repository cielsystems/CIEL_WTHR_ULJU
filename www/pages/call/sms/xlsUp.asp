<!--#include virtual="/common/common.asp"-->

<%
dim strPath : strPath = fnCreatePath("/data/addr")

fileUpOpen(strPath)

dim arrFiles : arrFiles = array("xlsUp")
dim strFile : strFile = fnGetUpFiles(strPath, arrFiles)

dim arrForms : arrForms = array("xlsUpGb")
dim strForm : strForm = fnGetUpValues(arrForms)

fileUpClose()

dim arrFile : arrFile = split(strFile,"]|[")
strFile = arrFile(1)

dim arrForm : arrForm = split(strForm,"}|{")
dim xlsUpGb
dim arrVal
for i = 0 to ubound(arrForm)
	arrVal = split(arrForm(i),"]|[")
	if i = 0 then
		xlsUpGb = arrVal(1)
	end if
next

dim fileExt : fileExt = mid(strFile,instrrev(strFile,".")+1,len(strFile))

if fileExt = "xls" or fileExt = "xlsx" then
	response.write	"ok"
else
	response.write	"<script>"
	response.write	"	alert('xls, xlsx 파일만 업로드 가능합니다.');"
	response.write	"</script>"
	response.end
end if

strPath = replace(strPath,"//","/")
strPath = replace(strPath,"/","\")

'#	xls, xlsx 파일 업로드
dim strXlsConn, xlsConn
if fileExt = "xls" then
	strXlsConn = "provider=Microsoft.Jet.OLEDB.4.0;data source=" & strPath & "\" & strFile & ";extended properties=""excel 8.0;HDR=yes;IMEX=1;"";"
elseif fileExt = "xlsx" then
	strXlsConn = "provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & strPath & "\" & strFile & ";extended properties=""excel 12.0 Xml;HDR=yes;IMEX=1"";"
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

dim xlsRs
sql = " select * from [" & sheetName & "] "
set xlsRs = server.createObject("adodb.recordset")
xlsRs.open sql, xlsConn, adOpenStatic, adLockReadOnly
if not xlsRs.eof then
	arrRs = xlsRs.getRows
	arrRc1 = ubound(arrRs,1)
	arrRc2 = ubound(arrRs,2)
else
	arrRc2 = -1
end if
xlsRs.close()
xlsConn.close()
set xlsRs = nothing
set xlsConn = nothing

if arrRc2 > 999 then
	response.write	"<script>alert('죄송합니다.\n한번에 1,000건 이상 업로드 하실 수 없습니다.\n1,000건 이하로 분할해서 업로드 해주시기 바랍니다.');</script>"
	response.end
end if

dim upTit, upMsg
if xlsUpGb = "2" then
	upTit = arrRs(2,0)
	upMsg = arrRs(3,0)
end if

'#	Data Check & Create Script
dim checkYN : checkYN = "Y"
dim strScript : strScript = ""
for i = 0 to arrRc2
	
	'#	이름열 길이
	if fnByte(arrRs(0,i)) > 100 then
		checkYN = "N"
		response.write	"<script>alert('" & i+1 & "번째 이름열의 길이가 너무 깁니다.\n100Byte이하로 수정 후 다시 업로드 해주세요.');</script>"
		exit for
	end if
	
	'#	휴대폰
	if len(arrRs(1,i)) > 0 then
		if fnChkMobileNum(arrRs(1,i)) = false then
			checkYN = "N"
			response.write	"<script>alert('" & i+1 & "번째열의 휴대폰번호가 형식에 맞지 않습니다.\n수정 후 다시 업로드 해주세요.\n(" & arrRs(1,i) & ")');</script>"
			exit for
		end if
	end if
	
next

if checkYN = "Y" then
	
	dim grpCD : grpCD = fnDBMax("TBL_GRP", "GRP_CODE", "1=1")
	'response.write	grpCode
	dim grpSort : grpSort = fnDBMax("TBL_GRP", "GRP_SORT", "GRP_GB = 'P' and GRP_UPCODE = 5")
	grpSort = clng(grpSort) + 1
	dim tmpCD : tmpCD = fnDBMax("TBL_GRP", "GRP_CODE", "1=1")
	grpCD = tmpCD + 1
	
	dim grpNM : grpNM = ss_userId & "_" & fnDateToStr(now,"yyyymmddhhnnss")
	
	sql = " insert into TBL_GRP (GRP_CODE, GRP_UPCODE, GRP_GB, GRP_DEPTH, AD_IDX, GRP_SORT, GRP_NM) "
	sql = sql & " values (" & grpCD & ", 5, 'P', 1, " & ss_userIdx & ", " & grpSort & ", '" & grpNM & "') "
	call execSql(sql)

	for i = 0 to arrRc2
		sql = " insert into TBL_ADDR (AD_GB, CD_USERGB, GRP_CODE, AD_ID, AD_PW, AD_NO, AD_DFTNUM, AD_NM, AD_NUM1, AD_ETC1, AD_ETC2) values ( "
		sql = sql & " 'A', 1010, " & grpCD & ", '', '', '', 1 "
		for ii = 0 to arrRc1
			if ii = 1 then
				'sql = sql & ",dbo.pi_ENCRPART('" & replace(arrRs(ii,i),"-","") & "',4)"
				sql = sql & ",'" & replace(arrRs(ii,i),"-","") & "'"
			else
				sql = sql & ",'" & arrRs(ii,i) & "'"
			end if
		next
		if xlsUpGb = "2" then
			sql = sql & ""
		else
			sql = sql & " ,null, null "
		end if
		sql = sql & ") "
		response.write	sql
		call execSql(sql)
	next
	
	call subSetLog(ss_userIdx, 8004, "주소록연락처 업로드 (" & arrRc2+1 &"건)", "grpCD : " & grpCD & "", "")
	
	dim maxNo : maxNo = fnDBVal("TMP_CALLTRG", "isnull(max(TMP_NO),0)", "AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
	maxNo = clng(maxNo) + 1
	
	sql = " insert into TMP_CALLTRG (AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_TIT, TMP_SMSMSG) "
	sql = sql & " select " & ss_userIdx & ", '" & svr_remoteAddr & "', ROW_NUMBER() over(order by AD_IDX) + " & maxNo & ", ROW_NUMBER() over(order by AD_IDX) + " & maxNo & ", AD_IDX, AD_NM, AD_NUM1 "
	if xlsUpGb = "2" then
		sql = sql & " 	, AD_ETC1, AD_ETC2 "
	else
		sql = sql & " 	, NULL, NULL "
	end if
	sql = sql & " from TBL_ADDR with(nolock) where GRP_CODE = " & grpCD & " "
	
	'response.write	sql
	call execSql(sql)
	
	response.write	"<script>"
	response.write	"	alert('총 " & arrRc2+1 & "건의 연락처가 업로드 되었습니다.');"
	response.write	"	top.fnLoadTrg();"
	if xlsUpGb = "2" then
		response.write	"top.document.frm.tit.value='" & upTit & "';"
		response.write	"top.document.frm.msg.value='" & upMsg & "';"
		response.write	"top.fnCheckByteSMS(top.document.frm.msg);"
	end if
	response.write	"	top.document.xlsFrm.reset();"
	response.write	"</script>"
	
else
	
	response.write	"<script>"
	response.write	"	top.document.xlsFrm.reset();"
	response.write	"</script>"
	
end if
%>