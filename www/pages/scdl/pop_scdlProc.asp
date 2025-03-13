<!--#include virtual="/common/common.asp"-->

<%
dim proc	: proc	= fnIsNull(nFnReq("proc", 4), "")

dim scdlIndx	: scdlIndx	= fnIsNull(nFnReq("scdlIndx", 0), 0)

dim scdlGubn         	: scdlGubn         	= fnIsNull(nFnReq("scdlGubn", 1), "")
dim scdlType         	: scdlType         	= fnIsNull(nFnReq("scdlType", 1), "")
dim scdlValu         	: scdlValu         	= fnIsNull(nFnReq("scdlValu", 0), 0)
dim scdlSDate					: scdlSDate					= fnIsNull(nFnReq("scdlSDate", 10), fnDateToStr(now, "yyyy-mm-dd"))
dim scdlSHour					: scdlSHour					= fnIsNull(nFnReq("scdlSHour", 2), fnDateToStr(now, "hh"))
dim scdlSMint					: scdlSMint					= fnIsNull(nFnReq("scdlSMint", 2), fnDateToStr(now, "nn"))
dim scdlEDate					: scdlEDate					= fnIsNull(nFnReq("scdlEDate", 10), fnDateToStr(dateAdd("d", 1, now), "yyyy-mm-dd"))
dim scdlEHour					: scdlEHour					= fnIsNull(nFnReq("scdlEHour", 2), fnDateToStr(dateAdd("d", 1, now), "hh"))
dim scdlEMint					: scdlEMint					= fnIsNull(nFnReq("scdlEMint", 2), fnDateToStr(dateAdd("d", 1, now), "nn"))
dim scdlSDT          	: scdlSDT          	= scdlSDate & " " & scdlSHour & ":" & scdlSMint & ":00"
dim scdlEDT          	: scdlEDT          	= scdlEDate & " " & scdlEHour & ":" & scdlEMint & ":00"
dim scdlMethod       	: scdlMethod       	= fnIsNull(nFnReq("scdlMethod", 0), 0)
dim scdlMedia        	: scdlMedia        	= array(fnIsNull(nFnReq("scdlMedia1", 0), 0), fnIsNull(nFnReq("scdlMedia2", 0), 0), fnIsNull(nFnReq("scdlMedia3", 0), 0))
dim scdlTry          	: scdlTry          	= array(fnIsNull(nFnReq("scdlTry1", 0), 0), fnIsNull(nFnReq("scdlTry2", 0), 0), fnIsNull(nFnReq("scdlTry3", 0), 0))
dim scdlSMSGB        	: scdlSMSGB        	= fnIsNull(nFnReq("scdlSMSGB", 1), "0")
dim scdlVMSGB        	: scdlVMSGB        	= fnIsNull(nFnReq("scdlVMSGB", 1), "0")
dim scdlTit          	: scdlTit          	= fnIsNull(nFnReq("scdlTit", 100), "")
dim scdlSMSMsg       	: scdlSMSMsg       	= fnIsNull(nFnReq("SMSMsg", 2000), "")
dim scdlVMSMsg       	: scdlVMSMsg       	= fnIsNull(nFnReq("VMSMsg", 4000), "")
dim scdlSMSMsgAdd    	: scdlSMSMsgAdd    	= fnIsNull(nFnReq("addSMSMsg", 1), "N")
dim scdlVMSMsgAdd    	: scdlVMSMsgAdd    	= fnIsNull(nFnReq("addVMSMsg", 1), "N")
dim scdlVMSPlay      	: scdlVMSPlay      	= fnIsNull(nFnReq("scdlVMSPlay", 0), 1)
dim scdlARSAnswYN    	: scdlARSAnswYN    	= fnIsNull(nFnReq("scdlARSAnswYN", 1), "Y")
dim scdlARSAnswTime  	: scdlARSAnswTime  	= fnIsNull(nFnReq("scdlARSAnswTime", 0), 0)
dim scdlAnswDTMF     	: scdlAnswDTMF     	= fnIsNull(nFnReq("scdlAnswDTMF", 1), "")
dim scdlSndNum1      	: scdlSndNum1      	= fnIsNull(nFnReq("scdlSndNum1", 20), "")
dim scdlSndNum2      	: scdlSndNum2      	= fnIsNull(nFnReq("scdlSndNum2", 20), "")
dim scdlAddVMSMsgText	: scdlAddVMSMsgText	= fnIsNull(nFnReq("scdlAddVMSMsgText", 100), "")
dim scdlStat					: scdlStat					= fnIsNull(nFnReq("scdlStat", 0), 0)

dim grupIndx	: grupIndx	= fnIsNull(nFnReq("grupIndx", 4000), "")

'response.write	" exec nusp_procScdl '" & proc & "', " & scdlIndx & ", '" & scdlGubn & "', '" & scdlType & "', " & scdlValu & " "
'response.write	"	, '" & scdlSDT & "', '" & scdlEDT & "', " & scdlMethod & ", " & scdlMedia(0) & ", " & scdlMedia(1) & ", " & scdlMedia(2) & " "
'response.write	" , " & scdlTry(0) & ", " & scdlTry(1) & ", " & scdlTry(2) & ", '" & scdlSMSGB & "', '" & scdlVMSGB & "', '" & scdlTit & "' "
'response.write	" , '" & scdlSMSMsg & "', '" & scdlVMSMsg & "', '" & scdlSMSMsgAdd & "', '" & scdlVMSMsgAdd & "', " & scdlVMSPlay & " "
'response.write	" , '" & scdlARSAnswYN & "', " & scdlARSAnswTime & ", '" & scdlAnswDTMF & "', '" & scdlSndNum1 & "', '" & scdlSndNum2 & "' "
'response.write	" , '" & scdlAddVMSMsgText & "', " & scdlStat & ", '" & replace(grupIndx, " ", "") & "', " & ss_userIndx & ", '" & svr_remoteAddr & "' "
'response.end

set cmd = server.createobject("adodb.command")
with cmd

	.activeconnection = strDBConn
	.commandtext = "nusp_procScdl"
	.commandtype = adCmdStoredProc
	
	.parameters.append .createParameter("@proc",							adChar,			adParamInput,		1)
	
	.parameters.append .createParameter("@scdlIndx",					adInteger,					adParamInput,		0)
	.parameters.append .createParameter("@scdlGubn",					adChar,							adParamInput,		1)
	.parameters.append .createParameter("@scdlType",					adChar,							adParamInput,		1)
	.parameters.append .createParameter("@scdlValu",					adInteger,					adParamInput,		0)
	.parameters.append .createParameter("@scdlSDT",						adDate,							adParamInput,		20)
	.parameters.append .createParameter("@scdlEDT",						adDate,							adParamInput,		20)
	.parameters.append .createParameter("@scdlMethod",				adUnsignedTinyInt,	adParamInput,		0)
	.parameters.append .createParameter("@scdlMedia1",				adUnsignedTinyInt,	adParamInput,		0)
	.parameters.append .createParameter("@scdlMedia2",				adUnsignedTinyInt,	adParamInput,		0)
	.parameters.append .createParameter("@scdlMedia3",				adUnsignedTinyInt,	adParamInput,		0)
	.parameters.append .createParameter("@scdlTry1",					adUnsignedTinyInt,	adParamInput,		0)
	.parameters.append .createParameter("@scdlTry2",					adUnsignedTinyInt,	adParamInput,		0)
	.parameters.append .createParameter("@scdlTry3",					adUnsignedTinyInt,	adParamInput,		0)
	.parameters.append .createParameter("@scdlSMSGB",					adChar,							adParamInput,		1)
	.parameters.append .createParameter("@scdlVMSGB",					adChar,							adParamInput,		1)
	.parameters.append .createParameter("@scdlTit",						adVarchar,					adParamInput,		100)
	.parameters.append .createParameter("@scdlSMSMsg",				adVarchar,					adParamInput,		2000)
	.parameters.append .createParameter("@scdlVMSMsg",				adVarchar,					adParamInput,		4000)
	.parameters.append .createParameter("@scdlSMSMsgAdd",			adChar,							adParamInput,		1)
	.parameters.append .createParameter("@scdlVMSMsgAdd",			adChar,							adParamInput,		1)
	.parameters.append .createParameter("@scdlVMSPlay",				adUnsignedTinyInt,	adParamInput,		0)
	.parameters.append .createParameter("@scdlARSAnswYN",			adChar,							adParamInput,		1)
	.parameters.append .createParameter("@scdlARSAnswTime",		adInteger,					adParamInput,		0)
	.parameters.append .createParameter("@scdlAnswDTMF",			adChar,							adParamInput,		1)
	.parameters.append .createParameter("@scdlSndNum1",				adVarchar,					adParamInput,		20)
	.parameters.append .createParameter("@scdlSndNum2",				adVarchar,					adParamInput,		20)
	.parameters.append .createParameter("@scdlAddVMSMsgText",	adVarchar,					adParamInput,		100)
	.parameters.append .createParameter("@scdlStat",					adUnsignedTinyInt,	adParamInput,		0)

	.parameters.append .createParameter("@grupIndx",					adVarchar,					adParamInput,		4000)
	
	.parameters.append .createParameter("@userIndx",					adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@userIP",						adVarchar,	adParamInput,		20)
	
	.parameters.append .createParameter("@retn",							adInteger,	adParamOutput,	0)
	
	
	.parameters("@proc")							= proc
	
	.parameters("@scdlIndx")					= scdlIndx
	.parameters("@scdlGubn")					= scdlGubn
	.parameters("@scdlType")					= scdlType
	.parameters("@scdlValu")					= scdlValu
	.parameters("@scdlSDT")						= scdlSDT
	.parameters("@scdlEDT")						= scdlEDT
	.parameters("@scdlMethod")				= scdlMethod
	.parameters("@scdlMedia1")				= scdlMedia(0)
	.parameters("@scdlMedia2")				= scdlMedia(1)
	.parameters("@scdlMedia3")				= scdlMedia(2)
	.parameters("@scdlTry1")					= scdlTry(0)
	.parameters("@scdlTry2")					= scdlTry(1)
	.parameters("@scdlTry3")					= scdlTry(2)
	.parameters("@scdlSMSGB")					= scdlSMSGB
	.parameters("@scdlVMSGB")					= scdlVMSGB
	.parameters("@scdlTit")						= scdlTit
	.parameters("@scdlSMSMsg")				= scdlSMSMsg
	.parameters("@scdlVMSMsg")				= scdlVMSMsg
	.parameters("@scdlSMSMsgAdd")			= scdlSMSMsgAdd
	.parameters("@scdlVMSMsgAdd")			= scdlVMSMsgAdd
	.parameters("@scdlVMSPlay")				= scdlVMSPlay
	.parameters("@scdlARSAnswYN")			= scdlARSAnswYN
	.parameters("@scdlARSAnswTime")		= scdlARSAnswTime
	.parameters("@scdlAnswDTMF")			= scdlAnswDTMF
	.parameters("@scdlSndNum1")				= scdlSndNum1
	.parameters("@scdlSndNum2")				= scdlSndNum2
	.parameters("@scdlAddVMSMsgText")	= scdlAddVMSMsgText
	.parameters("@scdlStat")					= scdlStat

	.parameters("@grupIndx")					= replace(grupIndx, " ", "")

	.parameters("@userIndx")	= ss_userIndx
	.parameters("@userIP")		= svr_remoteAddr
	
	.parameters("@retn")			= 0
	
	.execute
	
	retn	= .parameters("@retn")
	
end with
set cmd = nothing	

if scdlMethod <> "1" then

	dim	TTS_pitch			:	TTS_pitch			=	fnIsNull(fnReq("TTS_pitch"),dftTTSPitch)
	dim	TTS_speed			:	TTS_speed			=	fnIsNull(fnReq("TTS_speed")	,dftTTSSpeed)
	dim	TTS_volume		:	TTS_volume		=	fnIsNull(fnReq("TTS_volume"),dftTTSVolume)
	dim	TTS_sformat		:	TTS_sformat		=	fnIsNull(fnReq("TTS_sformat"),dftTTSFormat)

	scdlVMSMsg = replace(scdlVMSMsg,"<br>"," ")
	
	scdlAnswDTMF = fnReInject(scdlAnswDTMF)
	
	if scdlAnswDTMF = "X" then
		scdlVMSMsg = scdlVMSMsg & " 수신하신분은 아무버튼을 눌러주세요."
	elseif scdlAnswDTMF = "*" or scdlAnswDTMF = "#" then
		scdlVMSMsg = scdlVMSMsg & " 수신하신분은 " &  scdlAnswDTMF & "번을 눌러주세요."
	elseif scdlAnswDTMF = "0" or scdlAnswDTMF = "1" or scdlAnswDTMF = "2" or scdlAnswDTMF = "3" or scdlAnswDTMF = "4" or scdlAnswDTMF = "5" or scdlAnswDTMF = "6"  or scdlAnswDTMF = "7" or scdlAnswDTMF = "8" or scdlAnswDTMF = "9" then
		scdlVMSMsg = scdlVMSMsg & " 수신하신분은 " &  scdlAnswDTMF & "번을 눌러주세요."
	end if
		
	scdlVMSMsg = "<pause=""1000"">" & scdlVMSMsg
	dim ttsFile : ttsFile = fnCreateTTS("/TTS", "SCDL" & retn, fnReInject(scdlVMSMsg), TTS_pitch, TTS_speed, TTS_volume, TTS_sformat, 2)
	response.write	ttsFile
	dim ttsFileWav : ttsFileWav = fnCreateTTS("/TTS/wav", "SCDL" & retn, fnReInject(scdlVMSMsg), TTS_pitch, TTS_speed, TTS_volume, 545, 2)
	
end if
%>

<script type="text/javascript">
	
	<% if proc = "S" then %>
		alert('저장되었습니다.');
		top.fnLoadPage(top.page);
		parent.location.href = 'pop_scdlForm.asp?scdlIndx=<%=retn%>';
	<% elseif proc = "D" then %>
		alert('삭제되었습니다.');
		top.location.reload();
	<% end if %>
	
</script>