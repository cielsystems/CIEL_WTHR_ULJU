
<%
function fnPrintUserGubn(userGubn)
	
	dim tmpLoop, tmpVal
	
	for tmpLoop = 0 to ubound(arrUserGubn)
		if arrUserGubn(tmpLoop)(0) = userGubn then
			tmpVal	= "<span class=""color_" & arrUserGubn(tmpLoop)(2) & """>" & arrUserGubn(tmpLoop)(1) & "</span>"
			exit for
		end if
	next
	
	fnPrintUserGubn	= tmpVal
end function

function fnPrintUserStep(userStep)
	
	dim tmpLoop, tmpVal
	
	for tmpLoop = 0 to ubound(arrUserStep)
		if arrUserStep(tmpLoop)(0) = cInt(userStep) then
			tmpVal	= "<span class=""color_" & arrUserStep(tmpLoop)(2) & """>" & arrUserStep(tmpLoop)(1) & "</span>"
			exit for
		end if
	next
	
	fnPrintUserStep	= tmpVal
end function
%>

<%
function fnCreateTTSSToBinary(intClIdx, strFilePath, strFileName)

	'dim ttsFile	: ttsFile	= server.mapPath("\") & strFilePath
	dim ttsFile	: ttsFile	= strFilePath
	
	response.write	ttsFile
	
	dim ttsBinary
	
	dim stream
	set stream = server.createObject("adodb.stream")
	stream.type = adTypeBinary
	stream.open
	stream.Position = 0
	stream.loadFromFile ttsFile
	ttsBinary = stream.read
	set stream = nothing

	Set Cmd = Server.CreateObject("ADODB.Command")

	With Cmd

		.ActiveConnection = strDBConn
		.CommandType = adCmdStoredProc
		.CommandText = "usp_filecreate"
		.Parameters.Append .CreateParameter("@fileName", adVarChar, adParamInput, 500, strFileName)
		.Parameters.Append .CreateParameter("@fileBinary", adVarBinary, adParamInput, LenB(ttsBinary), ttsBinary)
		.Execute
		
	End With
	Set Cmd = Nothing
	
	fnCreateTTSSToBinary = "Y"
	
end function

sub subTopCont()
	
	dim tmpCallCnt : tmpCallCnt = fnDBVal("TBL_CALL","count(*)","USEYN = 'Y' and CL_STEP in (0,1,2,3) and CL_GB = 'E'")
	
	if cint(tmpCallCnt) > 0 then
		response.write	"<div class=""aR colBlue"">현재 <b class=""colRed"">" & tmpCallCnt & "</b>건의 비상발령이 발령중입니다.</div>"
	else
		response.write	"<div class=""aR colGray"">발령중인 비상발령이 없습니다.</div>"
	end if
	
	if ubound(arrDftSvr) <> ubound(arrSvr) then
		response.write	"<div class=""aR colRed"">발령서버에 장애가 발생했습니다! 시스템관리자에게 문의하세요</div>"
	end if
	
end sub

sub subLeftBanner()
	
	response.write	"<ul class=""leftBn"">"
	''if mnCD = "0103" then
		dim tmpSql
		'tmpSql = " select "
		'tmpSql = tmpSql & "  dbo.ufn_getUserCntAll(AD_IDX, 'S'), dbo.ufn_getUserCntUse(AD_IDX, 'S') "
		'tmpSql = tmpSql & " 	, dbo.ufn_getUserCntAll(AD_IDX, 'L'), dbo.ufn_getUserCntUse(AD_IDX, 'L') "
		'tmpSql = tmpSql & " 	, dbo.ufn_getUserCntAll(AD_IDX, 'M'), dbo.ufn_getUserCntUse(AD_IDX, 'M') "
		'tmpSql = tmpSql & " from TBL_ADDR where AD_IDX = " & ss_userIdx & " "
		tmpSql = " select "
		tmpSql = tmpSql & "  dbo.ufn_getUserCntAll(USER_INDX, 'S'), dbo.ufn_getUserCntUse(USER_INDX, 'S') "
		tmpSql = tmpSql & " 	, dbo.ufn_getUserCntAll(USER_INDX, 'L'), dbo.ufn_getUserCntUse(USER_INDX, 'L') "
		tmpSql = tmpSql & " 	, dbo.ufn_getUserCntAll(USER_INDX, 'M'), dbo.ufn_getUserCntUse(USER_INDX, 'M') "
		tmpSql = tmpSql & " from NTBL_USER where USER_INDX = " & ss_userIdx & " "
		dim tmpInfo : tmpInfo = execSqlArrVal(tmpSql)
		response.write	"	<li><div style=""margin-bottom:15px;padding-bottom:5px;border-bottom:1px solid #cccccc;"">"
		response.write	"		<div style=""border:1px solid #999999;padding:5px;margin-bottom:5px;background:#eeeeee;"">문자잔여건수</div>"
		response.write	"		<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0"">"
		response.write	"			<colgroup>"
		response.write	"				<col width=""41px"" />"
		response.write	"				<col width=""*"" />"
		response.write	"			</colgroup>"
		response.write	"			<tr>"
		response.write	"				<th><img src=""" & pth_pubImg & "/phn_btn_sms_on.png"" /></th>"
		response.write	"				<td class=""aR fnt11"">"
		response.write	"<span class=""colGreen"">" & formatNumber(tmpInfo(0),0) & "</span>"
		response.write	" - <span class=""colRed"">" & formatNumber(tmpInfo(1),0) & "</span>"
		response.write	" = <span class=""fnt13 bld colBlue"">" & formatNumber(clng(tmpInfo(0))-clng(tmpInfo(1)),0) & "</span></td>"
		response.write	"			</tr>"
		response.write	"			<tr><td colspan=""2""><div style=""border-top:1px solid #cccccc;;margin-top:3px;padding-top:3px;""></td></tr>"
		response.write	"			<tr>"
		response.write	"				<th><img src=""" & pth_pubImg & "/phn_btn_lms_on.png"" /></th>"
		response.write	"				<td class=""aR fnt11"">"
		response.write	"<span class=""colGreen"">" & formatNumber(tmpInfo(2),0) & "</span>"
		response.write	" - <span class=""colRed"">" & formatNumber(tmpInfo(3),0) & "</span>"
		response.write	" = <span class=""fnt13 bld colBlue"">" & formatNumber(clng(tmpInfo(2))-clng(tmpInfo(3)),0) & "</span></td>"
		response.write	"			</tr>"
		'response.write	"			<tr><td colspan=""2""><div style=""border-top:1px solid #cccccc;;margin-top:3px;padding-top:3px;""></td></tr>"
		'response.write	"			<tr>"
		'response.write	"				<th><img src=""" & pth_pubImg & "/phn_btn_mms_on.png"" /></th>"
		'response.write	"				<td class=""aR fnt11"">"
		'response.write	"<span class=""colGreen"">" & formatNumber(tmpInfo(4),0) & "</span>"
		'response.write	" - <span class=""colRed"">" & formatNumber(tmpInfo(5),0) & "</span>"
		'response.write	" = <span class=""fnt13 bld colBlue"">" & formatNumber(clng(tmpInfo(4))-clng(tmpInfo(5)),0) & "</span></td>"
		'response.write	"			</tr>"
		response.write	"		</table>"
		response.write	"	</div></li>"
	'end if
	'response.write	"	<li><a href=""/data/menual.pptx""><img class=""imgBtn"" src=""" & pth_sitImg & "/bn01.png"" /></a></li
	'response.write	"	<li><a href=""javascript:fnBanner();""><img class=""imgBtn"" src=""" & pth_sitImg & "/bn01.png"" /></a></li>"
	'response.write	"	<li><a href=""http://www.mgov.go.kr"" target=""_blank""><div style=""border:3px solid #999999;background:#eeeeee;padding:5px;text-decoration:none;"">모바일정부 요금확인</div></a></li>"
	response.write	"</ul>"
end sub

function fnCreateTTS(cPATH, sFILE, cTEXT, sPTCH, sSPED, sVLMN, sFRMT, rtnType)
	
	dim sLANG : sLANG = 0
	dim sSPEK : sSPEK = 0
	dim cEXTS, cFULL, cURLS
	
	select case sFRMT
		case 273, 274, 275, 276
			cEXTS = "pcm"
		case 277
			cEXTS = "vox"
		case 289, 290, 291, 292
			cEXTS = "wav"
		case 305, 306, 307, 308
			cEXTS = "au"
		case 529, 530, 531, 532
			cEXTS = "pcm"
		case 533
			cEXTS = "vox"
		case 545, 546, 547, 548
			cEXTS = "wav"
		case 561, 562, 563, 564
			cEXTS = "au"
		case 321, 577
			cEXTS = "ogg"
		case 4385, 4386, 4641, 4642
			cEXTS = "asf"
	end select
	
	cFULL = server.mapPath("\") & cPATH & "/" & sFILE & "." & cEXTS
	cURLS = "http://" & siteUrl & cPATH & "/" & sFILE & "." & cEXTS
	cURLS = cPATH & "/" & sFILE & "." & cEXTS
  
	dim TTS
	dim uRETN
	
	'#	HCILab Power TTS	------------------------------------------------------------------------------------
	set TTS = server.createObject( "PTTSNetCom.Server" )
	uRETN = TTS.PTTSNET_FILE(dftTTSHost, dftTTSPort, 300, 600, cTEXT, cFULL, sLANG, sSPEK, sFRMT, sPTCH, sSPED, sVLMN, 0, -1, -1 )
	set TTS = nothing
	'#	Power TTS	------------------------------------------------------------------------------------
	
	'#	Core TTS	------------------------------------------------------------------------------------
	'set tts = server.createObject("CoreTtsCOM.ItsInterface")
	'uRETN = tts.CreateTtsFile(dftTTSHost, dftTTSPost, cFULL, cTEXT, "0")
	'uRETN = tts.VOICE_FILE(dftTTSHost, dftTTSPost, "10", cTEXT, cFULL, "1", "3", "3", "1.0", "0")
	'set tts = nothing
	'#	Core TTS	------------------------------------------------------------------------------------
	
	dim tmp
	
	select case rtnType
		case 0 : tmp = sFILE & "." & cEXTS & "|" & cFULL & "|" & cURLS
		case 1 : tmp = sFILE & "." & cEXTS	'= File Name
		case 2 : tmp = cFULL								'= File Full Path & Name
		case 3 : tmp = cURLS								'= File Url
	end select
	
	fnCreateTTS = tmp
	
end function
%>

<%
'# =====================================================================================
'# 에러 한글 출력
sub SetEucKR()
	session.CodePage = 949
	response.Charset = "euc-kr"
	response.ContentType = "text/html; charset=euc-kr"
end sub


function LPad(str, lenth, ch)
	dim x : x = 0
	if lenth > len(str) then x = lenth - len(str)
	LPad = String(x, ch) & str
end function

function RPad(str, lenth, ch)
	dim x : x = 0
	if lenth > len(str) then x = lenth - len(str)
	RPad = str & String(x, ch)
end function

%>