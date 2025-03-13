<!--#include virtual="/common/common.asp"-->

<%
dim proc	: proc	= fnIsNull(nFnReq("proc", 4), "")

dim ruleID          	: ruleID           = fnIsNull(nFnReq("ruleID", 0), 0)
dim warnVarCode     	: warnVarCode      = fnIsNull(nFnReq("warnVarCode", 0), 0)
dim areaCode        	: areaCode         = fnIsNull(nFnReq("areaCode", 10), "")
dim areaName        	: areaName         = fnIsNull(nFnReq("areaName", 100), "")
dim warnStressCode  	: warnStressCode   = fnIsNull(nFnReq("warnStressCode", 0), 0)
dim commandCode     	: commandCode      = fnIsNull(nFnReq("commandCode", 0), 0)
dim timeRef         	: timeRef          = fnIsNull(nFnReq("timeRef", 0), 0)
dim delayTime       	: delayTime        = fnIsNull(nFnReq("delayTime", 0), 0)
dim clMethod        	: clMethod         = fnIsNull(nFnReq("clMethod", 0), 0)
dim clARSAnswTime   	: clARSAnswTime    = fnIsNull(nFnReq("clARSAnswTime", 0), 0)
dim clMedia1        	: clMedia1         = fnIsNull(nFnReq("clMedia1", 0), 0)
dim clMedia2        	: clMedia2         = fnIsNull(nFnReq("clMedia2", 0), 0)
dim clMedia3        	: clMedia3         = fnIsNull(nFnReq("clMedia3", 0), 0)
dim clTry1          	: clTry1           = fnIsNull(nFnReq("clTry1", 0), 0)
dim clTry2          	: clTry2           = fnIsNull(nFnReq("clTry2", 0), 0)
dim clTry3          	: clTry3           = fnIsNull(nFnReq("clTry3", 0), 0)
dim clSndNum1       	: clSndNum1        = fnIsNull(nFnReq("clSndNum1", 20), "")
dim clSndNum2       	: clSndNum2        = fnIsNull(nFnReq("clSndNum2", 20), "")
dim clAnswDTMF      	: clAnswDTMF       = fnIsNull(nFnReq("clAnswDTMF", 1), "")
dim textTemplate    	: textTemplate     = fnIsNull(nFnReq("SMSMsg", 4000), "")
dim voiceTemplate   	: voiceTemplate    = fnIsNull(nFnReq("VMSMsg", 4000), "")
dim workingHourFrom 	: workingHourFrom  = fnIsNull(nFnReq("workingHourFrom", 0), 0)
dim workingHourTo   	: workingHourTo    = fnIsNull(nFnReq("workingHourTo", 0), 0)
dim discardWhenSleep	: discardWhenSleep = fnIsNull(nFnReq("discardWhenSleep", 1),"Y")
dim notiGroupID     	: notiGroupID      = fnIsNull(nFnReq("notiGroupID", 4000), "")
dim applyWorkingHour	: applyWorkingHour = fnIsNull(nFnReq("applyWorkingHour", 4000), "")

dim autoUseYN			: autoUseYN			= fnIsNull(nFnReq("autoUseYN", 1), "N")

dim clSMSMsgAdd				: clSMSMsgAdd				= fnIsNull(nFnReq("addSMSMsg", 1), "N")
dim clVMSMsgAdd				: clVMSMsgAdd				= fnIsNull(nFnReq("addVMSMsg", 1), "N")

dim addVMSMsgText	: addVMSMsgText	= fnIsNull(fnReq("addVMSMsgText"), "")

'response.write	"exec nusp_procNoti '" & proc & "', " & ruleID & ", " & warnVarCode & ", '" & areaCode & "', '" & areaName & "'"
'response.write	", " & warnStressCode & ", " & commandCode & ", " & timeRef & ", " & delayTime & ", " & clMethod & ", " & clARSAnswTime & ""
'response.write	", " & clMedia1 & ", " & clMedia2 & ", " & clMedia3 & ", " & clTry1 & ", " & clTry2 & ", " & clTry3 & ""
'response.write	", '" & clSndNum1 & "', '" & clSndNum2 & "', '" & clAnswDTMF & "', '" & clSMSMsgAdd & "', '" & clVMSMsgAdd & "', '" & textTemplate & "', '" & voiceTemplate & "'"
'response.write	", " & workingHourFrom & ", " & workingHourTo & ", '" & discardWhenSleep & "', '" & replace(notiGroupID, " ", "") & "', '" & replace(applyWorkingHour, " ", "") & "'"
'response.write	", " & ss_userIndx & ", '" & svr_remoteAddr & "'"
'response.end

set cmd = server.createobject("adodb.command")
with cmd

	.activeconnection = strDBConn
	.commandtext = "nusp_procNoti"
	.commandtype = adCmdStoredProc
	
	.parameters.append .createParameter("@proc",							adChar,			adParamInput,		1)
	
	.parameters.append .createParameter("@ruleID",						adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@warnVarCode",				adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@areaCode",					adVarchar,	adParamInput,		10)
	.parameters.append .createParameter("@areaName",					adVarchar,	adParamInput,		100)
	.parameters.append .createParameter("@warnStressCode",		adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@commandCode",				adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@timeRef",						adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@delayTime",					adInteger,	adParamInput,		0)
	
	.parameters.append .createParameter("@clMethod",					adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@clARSAnswTime",			adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@clMedia1",					adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@clMedia2",					adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@clMedia3",					adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@clTry1",						adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@clTry2",						adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@clTry3",						adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@clSndNum1",					adVarchar,	adParamInput,		20)
	.parameters.append .createParameter("@clSndNum2",					adVarchar,	adParamInput,		20)
	.parameters.append .createParameter("@clAnswDTMF",				adChar,			adParamInput,		1)
	.parameters.append .createParameter("@clSMSMsgAdd",				adChar,			adParamInput,		1)
	.parameters.append .createParameter("@clVMSMsgAdd",				adChar,			adParamInput,		1)
	
	.parameters.append .createParameter("@textTemplate",			adVarchar,	adParamInput,		4000)
	.parameters.append .createParameter("@voiceTemplate",			adVarchar,	adParamInput,		4000)
	.parameters.append .createParameter("@workingHourFrom",		adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@workingHourTo",			adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@discardWhenSleep",	adChar,			adParamInput,		1)
	
	.parameters.append .createParameter("@notiGroupID",				adVarchar,	adParamInput,		4000)
	.parameters.append .createParameter("@applyWorkingHour",	adVarchar,	adParamInput,		4000)
	
	.parameters.append .createParameter("@autoUseYN",	adChar,	adParamInput,		1)
	
	.parameters.append .createParameter("@userIndx",					adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@userIP",						adVarchar,	adParamInput,		20)
	
	.parameters.append .createParameter("@retn",							adInteger,	adParamOutput,	0)
	
	.parameters("@proc")							= proc
	
	.parameters("@ruleID")          	= ruleID
	.parameters("@warnVarCode")     	= warnVarCode
	.parameters("@areaCode")        	= areaCode
	.parameters("@areaName")        	= areaName
	.parameters("@warnStressCode")  	= warnStressCode
	.parameters("@commandCode")     	= commandCode
	.parameters("@timeRef")         	= timeRef
	.parameters("@delayTime")       	= delayTime
	
	.parameters("@clMethod")        	= clMethod
	.parameters("@clARSAnswTime")   	= clARSAnswTime
	.parameters("@clMedia1")        	= clMedia1
	.parameters("@clMedia2")        	= clMedia2
	.parameters("@clMedia3")        	= clMedia3
	.parameters("@clTry1")          	= clTry1
	.parameters("@clTry2")          	= clTry2
	.parameters("@clTry3")          	= clTry3
	.parameters("@clSndNum1")       	= clSndNum1
	.parameters("@clSndNum2")       	= clSndNum2
	.parameters("@clAnswDTMF")      	= clAnswDTMF
	.parameters("@clSMSMsgAdd")				= clSMSMsgAdd
	.parameters("@clVMSMsgAdd")				= clVMSMsgAdd
	
	.parameters("@textTemplate")    	= textTemplate
	.parameters("@voiceTemplate")   	= voiceTemplate
	.parameters("@workingHourFrom") 	= workingHourFrom
	.parameters("@workingHourTo")   	= workingHourTo
	.parameters("@discardWhenSleep")	= discardWhenSleep
	
	.parameters("@notiGroupID")     	= replace(notiGroupID, " ", "")
	.parameters("@applyWorkingHour")	= replace(applyWorkingHour, " ", "")
	
	.parameters("@autoUseYN")	= autoUseYN

	.parameters("@userIndx")	= ss_userIndx
	.parameters("@userIP")		= svr_remoteAddr
	
	.parameters("@retn")			= 0
	
	.execute
	
	retn	= .parameters("@retn")
	
end with
set cmd = nothing

if clMethod <> "1" then

	dim	TTS_pitch			:	TTS_pitch			=	fnIsNull(fnReq("TTS_pitch"),dftTTSPitch)
	dim	TTS_speed			:	TTS_speed			=	fnIsNull(fnReq("TTS_speed")	,dftTTSSpeed)
	dim	TTS_volume		:	TTS_volume		=	fnIsNull(fnReq("TTS_volume"),dftTTSVolume)
	dim	TTS_sformat		:	TTS_sformat		=	fnIsNull(fnReq("TTS_sformat"),dftTTSFormat)

	voiceTemplate = replace(voiceTemplate,"<br>"," ")
	
	if clVMSMsgAdd = "Y" then
		voiceTemplate	= voiceTemplate & " " & addVMSMsgText
	end if
		
	voiceTemplate = "<pause=""1000"">" & voiceTemplate
	dim ttsFile : ttsFile = fnCreateTTS("/TTS", "WTHR" & retn, fnReInject(voiceTemplate), TTS_pitch, TTS_speed, TTS_volume, TTS_sformat, 2)
	response.write	ttsFile
	dim ttsFileWav : ttsFileWav = fnCreateTTS("/TTS/wav", "SCDL" & retn, fnReInject(voiceTemplate), TTS_pitch, TTS_speed, TTS_volume, 545, 2)
	
end if
%>

<script type="text/javascript">
	
	<% if proc = "S" then %>
		alert('저장되었습니다.');
		top.fnLoadPage(top.page);
		parent.location.href = 'pop_notiForm.asp?ruleID=<%=retn%>';
	<% elseif proc = "D" then %>
		alert('삭제되었습니다.');
		top.location.reload();
	<% end if %>
	
</script>