<!--#include virtual="/common/common.asp"-->

<%
dim strPath : strPath = fnCreatePath("/data/addr")

fileUpOpen(strPath)

dim arrFiles : arrFiles = array("xlsUp")
dim strFile : strFile = fnGetUpFiles(strPath, arrFiles)

dim arrForms : arrForms = array("clGB")
dim strForm : strForm = fnGetUpValues(arrForms)

fileUpClose()

dim arrFile : arrFile = split(strFile,"]|[")
strFile = arrFile(1)

dim arrForm : arrForm = split(strForm,"}|{")
dim clGB
dim arrVal
for i = 0 to ubound(arrForm)
	arrVal = split(arrForm(i),"]|[")
	clGB = arrVal(1)
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
	
	if clGB = "S" then
		'#	휴대폰
		if len(arrRs(1,i)) > 0 then
			if fnChkMobileNum(arrRs(1,i)) = false then
				checkYN = "N"
				response.write	"<script>alert('" & i+1 & "번째열의 휴대폰번호가 형식에 맞지 않습니다.\n수정 후 다시 업로드 해주세요.\n(" & arrRs(1,i) & ")');</script>"
				exit for
			end if
		end if
	elseif clGB = "V" then
		'#	휴대폰 or 일반전화
		if len(arrRs(1,i)) > 0 then
			if fnChkMobileNum(arrRs(1,i)) = false and fnChkPhoneNum(arrRs(1,i)) = false then
				checkYN = "N"
				response.write	"<script>alert('" & i+1 & "번째열의 기타전화번호가 형식에 맞지 않습니다.\n수정 후 다시 업로드 해주세요.\n(" & arrRs(1,i) & ")');</script>"
				exit for
			end if
		end if
	end if
	
next

if checkYN = "N" then
	'#	Data에 이상이 있을경우 중지
	response.end

elseif checkYN = "Y" then
	'#	Data에 이상이 없을경우 진행	
	
	'#	개인주소록 생성
	dim grpCD
	dim grpSort : grpSort = fnDBMax("TBL_GRP", "GRP_SORT", "GRP_GB = 'P' and GRP_UPCODE = '5' and AD_IDX = " & ss_userIdx & "")
	dim todayCnt
	if dbType = "mssql" then
		todayCnt = fnDBVal("TBL_GRP", "count(*)", "GRP_GB = 'P' and GRP_UPCODE = '5' and AD_IDX = " & ss_userIdx & " and convert(varchar(10), REGDT, 121) = '" & fnDateToStr(now, "yyyy-mm-dd") & "'")
	elseif dbType = "mysql" then
		todayCnt = fnDBVal("TBL_GRP", "count(*)", "GRP_GB = 'P' and GRP_UPCODE = '5' and AD_IDX = " & ss_userIdx & " and date_format(REGDT, '%Y-%m-%d') = '" & fnDateToStr(now, "yyyy-mm-dd") & "'")
	end if
	dim tmpCD : tmpCD = fnDBMax("TBL_GRP", "GRP_CODE", "1=1")
	grpCD = clng(tmpCD) + 1
	
	sql = " insert into TBL_GRP (GRP_CODE, GRP_UPCODE, GRP_GB, AD_IDX, GRP_SORT, GRP_NM) "
	sql = sql & " values (" & grpCD & ", 5, 'P', " & ss_userIdx & ", " & grpSort & ", '업로드_" & fnDateToStr(now, "yyyy년mm월dd일_") & (todayCnt+1) & "') "
	call execSql(sql)
	
	'#	연락처 추가
	sql = " insert into TBL_ADDR (AD_GB, CD_USERGB, GRP_CODE, AD_ID, AD_PW, AD_NM, AD_NUM1) values "
	for i = 0 to arrRc2
		sql = sql & " ('A', 1010, " & grpCD & ", '', '', '" & arrRs(0,i) & "'"
		'sql = sql & ", dbo.pi_ENCRPART('" & replace(arrRs(1,i),"-","") & "',4)) "
		sql = sql & ", '" & replace(arrRs(1,i),"-","") & "') "
		if i < arrRc2 then
			sql = sql & " , "
		end if
	next
	call execSql(sql)
	
	'#	임시대상자로 추가
	dim tmpNo : tmpNo = fnDBMax("TMP_CALLTRG","TMP_NO","CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
	tmpNo = clng(tmpNo) + 1
	
	sql = " insert into TMP_CALLTRG (CL_IDX, AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_NUM2, TMP_NUM3) "
	sql = sql & " select 0, " & ss_userIdx & ", '" & svr_remoteAddr & "', ROW_NUMBER() over(order by AD_IDX) + " & tmpNo & ", ROW_NUMBER() over(order by AD_IDX) + " & tmpNo & ", AD_IDX, AD_NM, AD_NUM1, AD_NUM2, AD_NUM3 "
	sql = sql & " from TBL_ADDR with(nolock) "
	sql = sql & " where USEYN = 'Y' and GRP_CODE = " & grpCD & " "
	
	call execSql(sql)
	
end if

dim tmpCnt : tmpCnt = fnDBVal("TMP_CALLTRG","count(*)","CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
%>

<script>
	top.trgCnt = <%=tmpCnt%>;
	top.fnTargetMsg();
	if(confirm('<%=arrRc2+1%>건의 전송대상이 추가되었습니다.\n전송대상을 더 추가하시겠습니까?')){
		parent.fnLoadingE();
	}else{
		top.fnCloseLayer();
	}
</script>