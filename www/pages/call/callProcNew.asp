<!--#include virtual="/common/common.asp"-->

<%
dim msgIdx				: msgIdx				= fnIsNull(fnReq("msgIdx"),0)

dim clUpIdx				: clUpIdx				= fnIsNull(fnReq("clUpIdx"),0)
dim	clGB					:	clGB					=	fnReq("clGB")
dim	clTit					:	clTit					=	fnReq("clTit")
dim	clRsvYN				:	clRsvYN				=	fnReq("clRsvYN")
dim	clRsvDT				:	clRsvDT				=	fnReq("clRsvDT")
dim	clMethod			:	clMethod			=	fnReq("clMethod")
dim clARSAnswTime	: clARSAnswTime	= fnIsNull(fnReq("clARSAnswTime"),0)
dim clAnswDTMF		: clAnswDTMF		= fnReq("clAnswDTMF")
dim clMedia				: clMedia				= array(fnIsNull(fnReq("clMedia1"),0), fnIsNull(fnReq("clMedia2"),0), fnIsNull(fnReq("clMedia3"),0))
dim clTry					: clTry					= array(fnIsNull(fnReq("clTry1"),0), fnIsNull(fnReq("clTry2"),0), fnIsNull(fnReq("clTry3"),0))
dim clSndNum1			: clSndNum1			= fnReq("clSndNum1")
dim clSndNum2			: clSndNum2			= fnReq("clSndNum2")
dim clSndNum3			: clSndNum3			= fnReq("clSndNum3")

clSndNum1 = replace(clSndNum1,"-","")
clSndNum2 = replace(clSndNum2,"-","")
clSndNum3 = replace(clSndNum3,"-","")

dim	clSMSMsg			:	clSMSMsg			=	fnReq("SMSMsg")'	: clSMSMsg = replace(clSMSMsg,chr(13)&chr(10),"<br>")
dim splitYN				: splitYN				= fnIsNull(fnReq("splitYN"),"N")
dim clSMSSplit		: clSMSSplit		= fnIsNull(fnReq("splitNo"),0)

dim	clVMSMsg			:	clVMSMsg			=	fnReq("VMSMsg")'	: clVMSMsg = replace(clVMSMsg,chr(13)&chr(10),"<br>")
dim clVMSPlay			: clVMSPlay			= fnIsNull(fnReq("clVMSPlay"),dftVMSPlay)
clVMSPlay = 5
dim	TTS_pitch			:	TTS_pitch			=	fnIsNull(fnReq("TTS_pitch"),dftTTSPitch)
dim	TTS_speed			:	TTS_speed			=	fnIsNull(fnReq("TTS_speed")	,dftTTSSpeed)
dim	TTS_volume		:	TTS_volume		=	fnIsNull(fnReq("TTS_volume"),dftTTSVolume)
dim	TTS_sformat		:	TTS_sformat		=	fnIsNull(fnReq("TTS_sformat"),dftTTSFormat)
'dim TTS_play			: TTS_play			= fnIsNull(fnReq("TTS_play"),dftVMSPlay)

dim addSMSMsg : addSMSMsg = fnIsNull(fnReq("addSMSMsg"),"N")
dim addVMSMsg : addVMSMsg = fnIsNull(fnReq("addVMSMsg"),"N")

dim clRetSendYN	: clRetSendYN	= fnIsNull(fnReq("clRetSendYN"),"N")

dim ruleID	: ruleID	= fnIsNull(fnReq("ruleID"), 0)

response.write	"exec nusp_setCall '" & clGB & "', " & clUpIdx & ", " & msgIdx & ", " & clMethod & ", '" & clRsvYN & "', '" & clRsvDT & "' "
response.write	", " & clMedia(0) & ", " & clMedia(1) & ", " & clMedia(2) & ", " & clTry(0) & ", " & clTry(1) & ", " & clTry(2) & " "
response.write	", '" & clSndNum1 & "', '" & clSndNum2 & "', '" & clTit & "', '" & clSMSMsg & "', '" & clVMSMsg & "', '" & addSMSMsg & "', '" & addVMSMsg & "' "
response.write	", " & clSMSSplit & ", " & clVMSPlay & ", 'Y', " & clARSAnswTime & ", '" & clAnswDTMF & "', '" & clRetSendYN & "', 'U' "
response.write	", " & ss_userIndx & ", '" & svr_remoteAddr & "' "

'#	================================================================================================
'#	
'#	------------------------------------------------------------------------------------------------
dim clIdx

set cmd = server.createobject("adodb.command")
with cmd

	.activeconnection = strDBConn
	.commandtext = "nusp_setCall"
	.commandtype = adCmdStoredProc

	.parameters.append .createParameter("@clGB",					adChar,							adParamInput,		1)
	.parameters.append .createParameter("@clUpIdx",				adInteger,					adParamInput,		0)
	.parameters.append .createParameter("@msgIdx",				adInteger,					adParamInput,		0)
	.parameters.append .createParameter("@clMethod",			adInteger,					adParamInput,		0)
	.parameters.append .createParameter("@clRsvYN",				adChar,							adParamInput,		1)
	.parameters.append .createParameter("@clRsvDT",				adDate,							adParamInput,		20)
	.parameters.append .createParameter("@clMedia1",			adUnsignedTinyInt,	adParamInput,		0)
	.parameters.append .createParameter("@clMedia2",			adUnsignedTinyInt,	adParamInput,		0)
	.parameters.append .createParameter("@clMedia3",			adUnsignedTinyInt,	adParamInput,		0)
	.parameters.append .createParameter("@clTry1",				adUnsignedTinyInt,	adParamInput,		0)
	.parameters.append .createParameter("@clTry2",				adUnsignedTinyInt,	adParamInput,		0)
	.parameters.append .createParameter("@clTry3",				adUnsignedTinyInt,	adParamInput,		0)
	.parameters.append .createParameter("@clSndNum1",			adVarchar,					adParamInput,		20)
	.parameters.append .createParameter("@clSndNum2",			adVarchar,					adParamInput,		20)
	.parameters.append .createParameter("@clTit",					adVarchar,					adParamInput,		100)
	.parameters.append .createParameter("@clSMSMsg",			adVarchar,					adParamInput,		4000)
	.parameters.append .createParameter("@clVMSMsg",			adVarchar,					adParamInput,		4000)
	.parameters.append .createParameter("@clSMSMsgAdd",		adChar,							adParamInput,		1)
	.parameters.append .createParameter("@clVMSMsgAdd",		adChar,							adParamInput,		1)
	.parameters.append .createParameter("@clSMSSplit",		adUnsignedTinyInt,	adParamInput,		0)
	.parameters.append .createParameter("@clVMSPlay",			adUnsignedTinyInt,	adParamInput,		0)
	.parameters.append .createParameter("@clARSAnswYN",		adChar,							adParamInput,		1)
	.parameters.append .createParameter("@clARSAnswTime",	adInteger,					adParamInput,		0)
	.parameters.append .createParameter("@clAnswDTMF",		adChar,							adParamInput,		1)
	.parameters.append .createParameter("@clRetSendYN",		adChar,							adParamInput,		1)
	.parameters.append .createParameter("@clCallGubn",		adChar,							adParamInput,		1)
	.parameters.append .createParameter("@userIndx",			adInteger,					adParamInput,		0)
	.parameters.append .createParameter("@userIP",				adVarchar,					adParamInput,		20)
	.parameters.append .createParameter("@retn",					adInteger,					adParamOutput,	0)
	
	.parameters("@clGB")					= clGB
	.parameters("@clUpIdx")				= clUpIdx
	.parameters("@msgIdx")				= msgIdx
	.parameters("@clMethod")			= clMethod
	.parameters("@clRsvYN")				= clRsvYN
	.parameters("@clRsvDT")				= clRsvDT
	.parameters("@clMedia1")			= clMedia(0)
	.parameters("@clMedia2")			= clMedia(1)
	.parameters("@clMedia3")			= clMedia(2)
	.parameters("@clTry1")				= clTry(0)
	.parameters("@clTry2")				= clTry(1)
	.parameters("@clTry3")				= clTry(2)
	.parameters("@clSndNum1")			= clSndNum1
	.parameters("@clSndNum2")			= clSndNum2
	.parameters("@clTit")					= clTit
	.parameters("@clSMSMsg")			= clSMSMsg
	.parameters("@clVMSMsg")			= clVMSMsg
	.parameters("@clSMSMsgAdd")		= addSMSMsg
	.parameters("@clVMSMsgAdd")		= addVMSMsg
	.parameters("@clSMSSplit")		= clSMSSplit
	.parameters("@clVMSPlay")			= clVMSPlay
	.parameters("@clARSAnswYN")		= "Y"
	.parameters("@clARSAnswTime")	= clARSAnswTime
	.parameters("@clAnswDTMF")		= clAnswDTMF
	.parameters("@clRetSendYN")		= clRetSendYN
	.parameters("@clCallGubn")		= "U"
	
	.parameters("@userIndx")	= ss_userIndx
	.parameters("@userIP")		= svr_remoteAddr
	.parameters("@retn")			= 0
	
	.execute
	
	retn	= .parameters("@retn")
	
end with
set cmd = nothing

clIdx = retn

call execSql("update TBL_CALL set CL_CALLGUBN = 'U' where CL_IDX = " & clIdx & "")

if ruleID > 0 then
	call execSql("update TBL_CALL set ruleID = " & ruleID & " where CL_IDX = " & clIdx & "")
end if
'#	================================================================================================



dim scdlType	: scdlType	= fnIsNull(fnReq("scdlType"), 0)
dim scdlValu	: scdlValu	= fnIsNull(fnReq("scdlValu"), 0)
dim scdlSDT		: scdlSDT		= fnIsNull(fnReq("scdlSDT"), "")
dim scdlEDT		: scdlEDT		= fnIsNull(fnReq("scdlEDT"), "")
dim scdlReg		: scdlReg		= fnIsNull(fnReq("scdlReg"), "N")

dim scdlFirstDT	: scdlFirstDT	= fnIsNull(fnReq("scdlFirstDT"), scdlSDT)

if scdlReg = "Y" then
	clRsvDT	= scdlFirstDT
end if


dim clSMS : clSMS = "0"
dim clVMS : clVMS = "0"
dim clFMS : clFMS = "0"

dim clGBFull
if clGB = "E" or clGB = "W" then
	select case clMethod
		case "0"
			clVMS = "1"
		case "1"
			clSMS = "1"
		case "2"
			clSMS = "1" : clVMS = "1"
		case "3"
			clSMS = "2" : clVMS = "1"
		case "4"
			clSMS = "1" : clVMS = "2"
	end select
	clGBFull = "EMR"
elseif clGB = "S" then
	clSMS = "1"
	clGBFull = "SMS"
elseif clGB = "V" then
	clVMS = "1"
	clGBFull = "VMS"
elseif clGB = "F" then
	clFMS = "1"
	clGBFull = "FMS"
end if
'
'dim clIdx : clIdx = 0
'dim cdStatus : cdStatus = 3030
'
'dim clCnt, clCode
'if dbType = "mssql" then
'	clCnt = fnDBVal("TBL_CALL","count(*)","convert(varchar(10),CL_RSVDT,121) = '" & fnDateToStr(clRsvDT,"yyyy-mm-dd") & "' and CL_GB = '" & clGB & "'")
'elseif dbType = "mysql" then
'	clCnt = fnDBVal("TBL_CALL","count(*)","convert(CL_RSVDT, char(10)) = '" & fnDateToStr(clRsvDT,"yyyy-mm-dd") & "' and CL_GB = '" & clGB & "'")
'end if
'clCode = clng(clCnt) + 1
'clCode = right("00" & clCode,3)
'clCode = clGBFull & "yymmdd" & clCode
'clCode = fnDateToStr(clRsvDT,clCode)
'
'if cint(fnDBVal("TBL_CALL","count(*)","CL_CODE = '" & clCode & "'")) > 0 then
'	clCode = clng(clCnt) + 2
'	clCode = right("00" & clCode,3)
'	clCode = clGBFull & "yymmdd" & clCode
'	clCode = fnDateToStr(clRsvDT,clCode)
'end if
'
''#	Emr
'sql = " insert into TBL_CALL ( "
'sql = sql & " 	CL_UPIDX, CL_CODE, AD_IDX, MSG_IDX, CL_GB, CL_METHOD, CL_RSVYN, CL_RSVDT "	'8
'sql = sql & " 	, CL_MEDIA1, CL_MEDIA2, CL_MEDIA3, CL_TRY1, CL_TRY2, CL_TRY3, CL_SMSGB, CL_VMSGB, CL_FMSGB "	'9
'sql = sql & " 	, CL_SNDNUM1, CL_SNDNUM2, CL_SNDNUM3, CL_TIT, CL_SMSMSG, CL_VMSMSG, CL_FMSMSG, CL_SMSMSGADD, CL_VMSMSGADD "	'9
'sql = sql & " 	, CL_SMSSPLIT, CL_VMSPLAY, CL_ARSANSWYN, CL_ARSANSWTIME, CL_STEP "	'5
'sql = sql & " 	, CL_TTSPITCH, CL_TTSSPEED, CL_TTSVOLUME, CL_TTSFORMAT, CL_ANSWDTMF "	'5
'sql = sql & " 	, CL_RETSENDYN "
'sql = sql & " ) values ( "
'sql = sql & " 	" & clUpIdx & ", '" & clCode & "', " & ss_userIdx & ", " & msgIdx & ", '" & clGB & "', " & clMethod & ", '" & clRsvYN & "', '" & clRsvDT & "' "	'8
'sql = sql & " 	, '" & clMedia(0) & "', '" & clMedia(1) & "', '" & clMedia(2) & "', " & clTry(0) & ", " & clTry(1) & ", " & clTry(2) & ", '" & clSMS & "', '" & clVMS & "', '" & clFMS & "' "	'9
'sql = sql & " 	, '" & clSndNum1 & "', '" & clSndNum2 & "', '" & clSndNum3 & "', '" & clTit & "', '" & clSMSMsg & "', '" & clVMSMsg & "', '', '" & addSMSMsg & "', '" & addVMSMsg & "' "	'9
'sql = sql & " 	, " & clSMSSplit & ", " & clVMSPlay & ", 'Y', " & clARSAnswTime & ", 0 "	'5
'sql = sql & " 	, '" & TTS_pitch & "', '" & TTS_speed & "', '" & TTS_volume & "', '" & TTS_sformat & "', '" & clAnswDTMF & "' "	'5
'sql = sql & " 	, '" & clRetSendYN & "' "
'sql = sql & " ) "
''response.write	"<div><h2>Insert TBL_CALL</h2><div>" & sql & "</div></div>"
'call execSql(sql)
'
'if dbType = "mssql" then
'	clIdx = fnDBVal("TBL_CALL", "top 1 CL_IDX", "AD_IDX = " & ss_userIdx & " and CL_GB = '" & clGB & "' and CL_TIT = '" & clTit & "' order by CL_IDX desc")
'elseif dbType = "mysql" then
'	clIdx = fnDBVal("TBL_CALL", "CL_IDX", "AD_IDX = " & ss_userIdx & " and CL_GB = '" & clGB & "' and CL_TIT = '" & clTit & "' order by CL_IDX desc limit 0, 1")
'end if
'
''#	File
'sql = " insert into TBL_CALLFILE (CL_IDX, CLF_GB, CLF_NO, CLF_SORT, CLF_DPNM, CLF_PATH, CLF_FILE, CLF_PAGE) "
'sql = sql & " select " & clIdx & ", TMP_GB, TMP_NO, TMP_SORT, TMP_DPNM, TMP_PATH, TMP_FILE, TMP_PAGE "
'sql = sql & " from TMP_CALLFILE where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
''response.write	"<div><h2>Insert TBL_CALLFILE</h2><div>" & sql & "</div></div>"
'call execSql(sql)
'
''#	Target
'sql = " insert into TBL_CALLTRG (CL_IDX, CLT_NO, CLT_SORT, AD_IDX, CLT_NM, CLT_NUM1, CLT_NUM2, CLT_NUM3, CLT_TIT, CLT_SMSMSG, CLT_VMSMSG, CLT_FMSMSG, CLT_SVRID) "
'sql = sql & " select " & clIdx & ", TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, replace(TMP_NUM" & clMedia(0) & ",'-','') "
'if cint(clMedia(1)) > 0 then		'=	2차전송매체를 선택한 경우
'	sql = sql & ", replace(TMP_NUM" & clMedia(1) & ",'-','') "
'else
'	sql = sql & ", '' "
'end if
'if cint(clMedia(2)) > 0 then		'= 3차전송매체를 선택한 경우
'	sql = sql & ", replace(TMP_NUM" & clMedia(2) & ",'-','') "
'else
'	sql = sql & ", '' "
'end if
''sql = sql & " , '" & clTit & "', '" & clSMSMsg & "', '" & clVMSMsg & "', '', case when (TMP_NO % 14) >= 1 and (TMP_NO % 14) <= 4 then 1 when (TMP_NO % 14) >= 5 and (TMP_NO % 14) <= 8 then 2 when (TMP_NO % 14) >= 9 and (TMP_NO % 14) <= 12 then 3 else 4 end "
''sql = sql & " , '" & clTit & "', '" & clSMSMsg & "', '" & clVMSMsg & "', '', (TMP_NO % 3) + 1 "
'sql = sql & " , '" & clTit & "', '" & clSMSMsg & "', '" & clVMSMsg & "', '' "
'if ubound(arrDftSvr) = ubound(arrSvr) then
'	sql = sql & " , (TMP_NO % 2) + 1 "
'else
'	sql = sql & " , " & arrSvr(0) & " "
'end if
'sql = sql & " from TMP_CALLTRG where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
''response.write	"<div><h2>Insert TBL_CALLTRG</h2><div>" & sql & "</div></div>"
'call execSql(sql)
'
''#	SMS Target
'if cint(clSMS) > 0 then
'	
'	dim cltsGB
'	dim tmpMsg	: tmpMsg = replace(clSMSMsg,"<br>",Chr(13))
'	dim nByte		: nByte = 0
'	
'	cltsGB = "S"
'	arrRs = execProcRs("usp_listTmpFile", array(0, ss_userIdx, svr_remoteAddr, "S", 1, 999999))
'	if isarray(arrRs) then
'		arrRc2 = ubound(arrRs,2)
'	else
'		arrRc2 = -1
'	end if
'
'	if arrRc2 > -1 then
'		cltsGB = "M"
'	elseif fnByte(tmpMsg) > 90 then
'		cltsGB = "L"
'	else
'		cltsGB = "S"
'	end if
'	
'	dim msgByte	: msgByte	= fnByte(tmpMsg)
'	dim nChr, tmpByte, splitMsg
'	
'	'#	==========================================================================
'	'#	기본
'	
'	clSMSSplit = 0
'	dim splitCnt	: splitCnt	= cstr(msgByte / 2000)
'	splitCnt = -(int(-(splitCnt)))
'	
'	redim splitMsg(splitCnt)
'	for i = 1 to len(tmpMsg)
'		nChr = mid(tmpMsg,i,1)
'		if inStrRev(server.URLEncode(nChr),"%") > 1 then
'			tmpByte = 2
'		elseif asc(nChr) > 0 and asc(nChr) < 255 then
'			tmpByte = 1
'		else
'			tmpByte = 2
'		end if
'		'response.write	"<div>" & nChr & "(" & asc(nChr) & "/" & nByte & "):" & splitMsg(clSMSSplit) & "(" & fnByte(splitMsg(clSMSSplit)) & ")</div>"
'		if nByte + tmpByte < 2001 then
'			splitMsg(clSMSSplit) = splitMsg(clSMSSplit) & nChr
'			nByte = nByte + tmpByte
'		else
'			clSMSSplit = clSMSSplit + 1
'			nByte = tmpByte
'			splitMsg(clSMSSplit) = splitMsg(clSMSSplit) & nChr
'		end if
'	next
'	
'	dim splitRsvDT	: splitRsvDT	= clRsvDT
'	
'	'response.write	clSMSSplit & "/" & fnByte(tmpMsg)
'	
'	for i = 0 to clSMSSplit
'		
'		if i > 0 then
'			splitRsvDT	= dateAdd("s", 20, splitRsvDT)	'= 분할전송시 20초 씩 대기시간추가
'		end if
'		
'		'#	==========================================================================
'		sql = " insert into TBL_CALLTRG_SMS (CL_IDX, CLT_NO, CLT_SORT, CLTS_GB, CLTS_RSVDT, CLTS_SNDNUM, CLTS_RCVNUM, CLTS_TIT, CLTS_MSG, CLTS_STATUS, CD_STATUS, CD_RESULT, CD_ERROR, CLTS_SPLITNO) "
'		sql = sql & " select CL_IDX, CLT_NO, CLT_SORT, '" & cltsGB & "'  "
'		if clSMS = "1" then				'= 문자를 1차로 전송할 경우
'				cdStatus = 3031
'			sql = sql & "		, '" & fnDateToStr(splitRsvDT,"yyyy-mm-dd hh:nn:ss") & "' "
'		elseif clSMS = "2" then		'= 문자를 2차로 전송할 경우(음성미응답자 문자전송의 경우) : 10시간을 추가하고 음성전송이 완료된 시점에 시간을 업데이트 해주어 음성전송 완료시 바로 전송되도록한다.
'			cdStatus = 3030
'			sql = sql & "		, '" & fnDateToStr(dateadd("d",1,splitRsvDT),"yyyy-mm-dd hh:nn:ss") & "' "
'		end if
'		sql = sql & " 	, '" & clSndNum2 & "' "
'		if clMedia(0) = 1 then
'			sql = sql & " 	, CLT_NUM1 "
'		elseif clMedia(1) = 1 then
'			sql = sql & " 	, CLT_NUM2 "
'		elseif clMedia(2) = 1 then
'			sql = sql & " 	, CLT_NUM3 "
'		end if
'		sql = sql & "		, CLT_TIT, '" & splitMsg(i) & "', 0, " & cdStatus & ", 9001, 0 , " & i+1 & " "
'		sql = sql & " from TBL_CALLTRG as clt left join TBL_ADDR as ad on (clt.AD_IDX = ad.AD_IDX) "
'		sql = sql & " where CL_IDX = " & clIdx & " "
'		'#	==========================================================================
'		
'		response.write	"<div><h2>Insert TBL_CALLTRG_SMS : 140</h2><div>" & sql & "</div></div>"
'		call execSql(sql)
'			
'	next
'	'#	==========================================================================
'	
'end if
'
''#	VMS Target
if cint(clVMS) > 0 then
	
	clVMSMsg = replace(clVMSMsg,"<br>"," ")
	
	'clVMSMsg = "<pause=""2000"">" & clVMSMsg & "<pause=""500"">" & clVMSMsg & "<pause=""500"">" & clVMSMsg' & "<pause=""500"">" & clVMSMsg & "<pause=""500"">" & clVMSMsg
	clVMSMsg = "<pause=""1000"">" & clVMSMsg
	dim ttsFile : ttsFile = fnCreateTTS("/TTS", fnDBVal("TBL_CALL","CL_CODE","CL_IDX = " & clIdx & ""), fnReInject(clVMSMsg), TTS_pitch, TTS_speed, TTS_volume, TTS_sformat, 2)
	response.write	ttsFile
	dim ttsFileWav : ttsFileWav = fnCreateTTS("/TTS/wav", fnDBVal("TBL_CALL","CL_CODE","CL_IDX = " & clIdx & ""), fnReInject(clVMSMsg), TTS_pitch, TTS_speed, TTS_volume, 545, 2)
	
'	'dim ttsBinaryYN	: ttsBinaryYN	= fnCreateTTSSToBinary(clIdx, ttsFile, clCode & ".vox")
'	'response.write	ttsBinaryYN
'	
'	dim vmsMediaCnt : vmsMediaCnt = 1
'	if cint(clMedia(2)) > 0 then
'		vmsMediaCnt = 3
'	else
'		if cint(clMedia(1)) > 0 then
'			vmsMediaCnt = 2
'		end if
'	end if
'	
'	sql = ""
'	for i = 1 to vmsMediaCnt		
'		for ii = 1 to clTry(i-1)			
'			'for iii = 0 to arrRc2				
'				'sql = sql & "(" & arrRs(0,iii) & ", " & arrRs(1,iii) & ", " & arrRs(2,iii) & " "
'				sql = "exec usp_setCallTrgVMS_BAT " & clIdx 
'				if clVMS = "1" then
'					if i = 1 and ii = 1 then
'						cdStatus = 3031
'					else
'						cdStatus = 3030
'					end if
'					sql = sql & ", '" & clRsvDT & "' "
'				elseif clVMS = "2" then
'					cdStatus = 3030
'					sql = sql & ", '" & fnDateToStr(dateadd("d",1,clRsvDT),"yyyy-mm-dd hh:nn:ss") & "' "
'				end if
'				if i = 1 then
'					sql = sql & " , " & clng(ii) + ((clng(i) - 1) * (vmsMediaCnt-1)) & " "
'				elseif i = 2 then
'					sql = sql & " , " & clng(clTry(0)) + clng(ii)
'				elseif i = 3 then
'					sql = sql & " , " & clng(clTry(0)) + clng(clTry(1)) + clng(ii) & " "
'				end if
'				'sql = sql & ", " & i & ", " & ii & ", '" & arrRs(2+i,iii) & "', 0, " & cdStatus & ", 9001, 0),"
'				sql = sql & ", " & i & ", " & ii & ", 0, " & cdStatus & ""
'				response.write	sql
'				call execSql(sql)
'				
'			'next
'			
'		next
'		
'	next	
'	'sql = " insert into TBL_CALLTRG_VMS (CL_IDX, CLT_NO, CLT_SORT, CLTV_RSVDT, CLTV_NO, CLTV_MEDIA, CLTV_TRY, CLTV_NUM, CLTV_STATUS, CD_STATUS, CD_RESULT, CD_ERROR) values " & sql
'	
'	'do while right(sql,1) = ","
'	'	sql = left(sql,len(sql)-1)
'	'loop
'	
'	response.write	"<div><h2>Insert TBL_CALLTRG_VMS</h2><div>" & sql & "</div></div>"
'	'call execSql(sql)
	
end if
'
''#	FMS Target
'if cint(clFMS) > 0 then
'	
'end if
'
''#	문자후 음성에서 대상자의 휴대폰번호가 전혀 없는경우 바로 음성전송진행처리
'if clMethod = 4 then
'	dim smsTrgCnt : smsTrgCnt = fnDBVal("TBL_CALLTRG_SMS","count(*)","CL_IDX = " & clIdx & " ")
'	if clng(smsTrgCnt) = 0 then
'		sql = " update TBL_CALLTRG_VMS set CLTV_RSVDT = getdate() where CL_IDX = " & clIdx & "; "
'		sql = sql & " update TBL_CALLTRG_VMS set CD_STATUS = 3031 where CL_IDX = " & clIdx & " and CD_STATUS = 3030 and CLTV_TRY = 1 and CLTV_MEDIA = 1; "
'		call execSql(sql)
'	end if
'end if
'
''#	Web에서 전송시 문자일괄전송 [2016.08.30|오태근]
''if ss_userIdx = 1 then
'if clSMS = "1" then
'	call execProc("usp_SMSSetNuri", array(clIdx))
'end if
''end if
'
'sql = " update TBL_CALL set CL_STEP = 1 where CL_IDX = " & clIdx & " "
'call execSql(sql)

if clIdx < 0 then
	response.write	"<script type=""text/javascript"">"
	response.write	"alert('오류가발생했습니다.');"
	response.write	"</script>"
	response.end
end if

dim resultUrl
dim strLogTit, strLogMsg
select case clGB
	case "E"
		resultUrl = "emrList"
		strLogTit = "비상발령요청 <" & clTit & ">"
	case "S"
		resultUrl = "smsList"
		strLogTit = "문자전송요청 <" & clTit & ">"
	case "V"
		resultUrl = "vmsList"
		strLogTit = "음성전송요청 <" & clTit & ">"
	case "F"
		resultUrl = "fmsList"
		strLogTit = "팩스전송요청 <" & clTit & ">"
	case "W"
		resultUrl = "notiList"
		strLogTit = "기상특보요청 <" & clTit & ">"
end select

strLogMsg = "Code : " & fnDBVal("TBL_CALL", "CL_CODE", "CL_IDX = " & clIdx & "") & ", Index : " & clIdx
call subSetLog(ss_userIdx, 8002, strLogTit, strLogMsg, "")

''#	================================================================================================
''#	스케줄설정 
''#	------------------------------------------------------------------------------------------------
'if scdlReg = "Y" then
'	
'	'sql = " insert into NTBL_SCDL (SCDL_GUBN, SCDL_TYPE, SCDL_VALU, SCDL_SDT, SCDL_EDT, USER_INDX, CL_IDX) "
'	'sql = sql & " values ('" & clGB & "', '" & scdlType & "', " & scdlValu & ", '" & scdlSDT & "', '" & scdlEDT & "', " & ss_userIndx & ", " & clIdx & ") "
'	'call execSql(sql)
'	
'	sql = " exec nusp_setScdl 'A', 0, '" & clGB & "', " & scdlType & "', " & scdlValu & ", '" & scdlSDT & "', '" & scdlEDT & "', " & clIdx & ", " & ss_userIndx & ", '" & svr_remoteAddr & "' "
'	call execSql(sql)
'	
'end if
''#	================================================================================================

response.write	"<script>"
response.write	"	alert('전송요청이 완료되었습니다.');"
response.write	"	top.fnLoadingE();"
if clGB = "E" or clGB = "W" then
	response.write	"	top.fnPop('/pages/call/pop_callMonitor.asp?clIdx=" & clIdx & "', 'callMonitor', 0, 0, 900, 600, 'no');"
	'response.write	"	var objWin = window.open('/pages/call/callMonitor.asp?clIdx=" & clIdx & "','callMonitor','top=0,left=0,width=600,height=400,scrollbars=no');"
	'response.write	"	objWin.focus();"
end if
response.write	"	top.location.href = '/pages/result/" & resultUrl & ".asp';"
response.write	"</script>"
%>