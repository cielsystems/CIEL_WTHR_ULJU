<!--#include virtual="/common/common.asp"-->

<%
dim proc	: proc	= fnIsNull(fnReq("proc"), "")

dim grupGubn	: grupGubn	= fnIsNull(fnReq("grupGubn"), "P")

dim upFileReal	: upFileReal	= fnIsNull(fnReq("upFileReal"), "")

dim addrAdd	: addrAdd	= fnIsNull(fnReq("addrAdd"), "N")

dim strPath	: strPath	= "/data/addr/"

dim strScript

if proc = "cnl" then
	
	response.write	"<div>Delete File : " & strPath & upFileReal & "</div>"
	
	retn	= fnDeleteFile(strPath & upFileReal)
	
	response.write	"<div>Delete : " & retn & "</div>"
	
	strScript	= "top.location.reload();"
	
elseif proc = "cmp" then
	
	dim fileExt : fileExt = mid(upFileReal, instrrev(upFileReal, ".")+1, len(upFileReal))

	response.write	"<div>fileExt : " & fileExt & "</div>"
	
	strPath	= server.mapPath("\") & strPath
	
	strPath = replace(strPath,"//","/")
	strPath = replace(strPath,"/","\")

	response.write	"<div>strPath : " & strPath & "</div>"
	
	dim strXlsConn, xlsConn
	if fileExt = "xls" then
		strXlsConn = "provider=Microsoft.Jet.OLEDB.4.0;data source=" & strPath & "\" & upFileReal & ";extended properties=""excel 8.0;HDR=yes;IMEX=1;"";"
	elseif fileExt = "xlsx" then
		strXlsConn = "provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & strPath & "\" & upFileReal & ";extended properties=""excel 12.0 Xml;HDR=yes;IMEX=1"";"
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
	
	dim dataCnt		: dataCnt		= 0
	dim allData		: allData		= ""
	dim nData
	dim arrData(10)
	
	dim maxNo
	
	for dataLoop2 = 0 to dataRc2
		
		for dataLoop1 = 0 to 3
			allData	= allData	& trim(dataRs(dataLoop1, dataLoop2))
		next
		
		if len(allData) > 0 then
			
			dataCnt	= dataCnt + 1
			
			arrData(0)	= "업로드"
			arrData(1)	= ""
			arrData(2)	= ""
			arrData(3)	= ""
			arrData(4)	= ""
			
			for dataLoop1 = 0 to 3
				
				nData	= fnIsNull(dataRs(dataLoop1, dataLoop2), "")
				nData	= replace(nData, chr(10), " ")
				nData	= trim(nData)
				nData	= fnInject(nData)
				
				arrData(5 + dataLoop1)	= nData
				
			next
			
			arrData(9)	= ""
			arrData(10)	= ""
			
			maxno	= fnIsNull(fnDBVal("TMP_CALLTRG", "max(TMP_NO)", "AD_IDX = " & ss_userIndx & " and AD_IP = '" & svr_remoteAddr & "'"), 0) + 1
			
			sql = " insert into TMP_CALLTRG (CL_IDX, AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_NUM2, TMP_NUM3) values "
			sql = sql & " (0, " & ss_userIndx & ", '" & svr_remoteAddr & "', " & maxNo & ", 1, 0, '" & arrData(5) & "', '" & arrData(6) & "', '" & arrData(7) & "', '" & arrData(8) & "') "
			call execSql(sql)
			
			if addrAdd = "Y" then
				call subAddrUpload(arrData)
			end if
			
		end if
		
	next
	
	dim tmpCnt : tmpCnt = fnDBVal("TMP_CALLTRG", "count(*)", "CL_IDX = 0 and AD_IDX = " & ss_userIndx & " and AD_IP = '" & svr_remoteAddr & "'")
	
	strScript	= "top.trgCnt = " & tmpCnt & ";"
	strScript	= strScript	& "top.fnTargetMsg();"
	strScript	= strScript	& "top.fnLoadingE();"
	strScript	= strScript	& "top.fnLoadTrg();"
	strScript	= strScript	& "alert('" & dataCnt & "건의 연락처가 업로드 되었습니다.');"
	strScript	= strScript	& "top.fnCloseLayer();"
	
end if



'#	================================================================================================
'#	
'#	------------------------------------------------------------------------------------------------
sub subAddrUpload(args)
	
	response.write	"<div>grupGubn : " & grupGubn & "</div>"
	
	'#	부서(그룹)
	dim grupIndx(5), lastGrupIndx
	grupIndx(0)	= fnDBVal("NTBL_GRUP", "GRUP_INDX", "USEYN = 'Y' and GRUP_DPTH = 0 and GRUP_GUBN = '" & grupGubn & "'")
	if grupIndx(0) = 0 then
		response.write	"<script type=""text/javascript"">"
		response.write	"	alert('최상위그룹 오류 발생!\n업로드할 수 없습니다.');"
		response.write	"</script>"
		response.end
	end if
	response.write	"<div>grupIndx(0) : " & grupIndx(0) & "</div>"
	for i = 0 to 4
		if len(args(i)) > 0 then
			response.write	"<div>grupIndx(" & i & ") : uper = " & grupIndx(i) & ", name = " & args(i) & " => "
			response.write	fnDBVal("NTBL_GRUP", "GRUP_INDX", "USEYN = 'Y' and GRUP_DPTH = " & (i+1) & " and GRUP_GUBN = '" & grupGubn & "' and GRUP_UPER = " & grupIndx(i) & " and GRUP_NAME = '" & args(i) & "'")
			grupIndx(i+1)	= fnIsNull(fnDBVal("NTBL_GRUP", "GRUP_INDX", "USEYN = 'Y' and GRUP_DPTH = " & (i+1) & " and GRUP_GUBN = '" & grupGubn & "' and GRUP_UPER = " & grupIndx(i) & " and GRUP_NAME = '" & args(i) & "'"), 0)
			if grupIndx(i+1) = 0 then
				grupIndx(i+1)	= fnCreateGrup(grupGubn, grupIndx(i), args(i))
			end if
			lastGrupIndx = grupIndx(i+1)
			if oldAddrDel = "Y" then
				'sql = " exec nusp_backNDeltGrupAddr " & lastGrupIndx & ", " & ss_userIndx & ", '" & svr_remoteAddr & "'; "
				'call execSql(sql)
			end if
			response.write	"(" & lastGrupIndx & ")"
			response.write	"</div>"
		else
			exit for
		end if
	next
	
	response.write	"<div>grupIndx : " & lastGrupIndx & "</div>"
	
	'#	NTBL_ADDR INSERT
	set cmd = server.createobject("adodb.command")
	with cmd

		.activeconnection = strDBConn
		.commandtext = "nusp_procAddr"
		.commandtype = adCmdStoredProc
		
		.parameters.append .createParameter("@proc",			adChar,			adParamInput,		1)
		.parameters.append .createParameter("@addrIndx",	adInteger,	adParamInput,		0)
		.parameters.append .createParameter("@addrGubn",	adchar,			adParamInput,		1)
		.parameters.append .createParameter("@addrSync",	adVarchar,	adParamInput,		50)
		.parameters.append .createParameter("@addrSort",	adInteger,	adParamInput,		0)
		.parameters.append .createParameter("@addrName",	adVarchar,	adParamInput,		50)
		.parameters.append .createParameter("@addrNum1",	adVarchar,	adParamInput,		255)
		.parameters.append .createParameter("@addrNum2",	adVarchar,	adParamInput,		255)
		.parameters.append .createParameter("@addrNum3",	adVarchar,	adParamInput,		255)
		.parameters.append .createParameter("@addrMemo",	adVarchar,	adParamInput,		1000)
		.parameters.append .createParameter("@grupIndx",	adVarchar,	adParamInput,		4000)
		.parameters.append .createParameter("@addrCode",	adVarchar,	adParamInput,		4000)
		.parameters.append .createParameter("@userIndx",	adInteger,	adParamInput,		0)
		.parameters.append .createParameter("@userIP",		adVarchar,	adParamInput,		20)
		.parameters.append .createParameter("@retn",			adInteger,	adParamOutput,	0)
		
		.parameters("@proc")			= "S"
		.parameters("@addrIndx")	= 0
		.parameters("@addrGubn")	= grupGubn
		.parameters("@addrSync")	= "N"
		.parameters("@addrSort")	= 1
		.parameters("@addrName")	= args(5)
		.parameters("@addrNum1")	= args(6)
		.parameters("@addrNum2")	= args(7)
		.parameters("@addrNum3")	= args(8)
		.parameters("@addrMemo")	= args(9)
		.parameters("@grupIndx")	= lastGrupIndx
		.parameters("@addrCode")	= addrCodes
		.parameters("@userIndx")	= ss_userIndx
		.parameters("@userIP")		= svr_remoteAddr
		.parameters("@retn")			= 0
		
		.execute
		
		retn	= .parameters("@retn")
		
	end with
	set cmd = nothing
	
end sub
'#	================================================================================================
	
response.write	"<script type=""text/javascript"">"
response.write	strScript
response.write	"</script>"
%>