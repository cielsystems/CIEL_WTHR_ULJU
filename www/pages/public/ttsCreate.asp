<!--#include virtual="/common/common.asp"-->

<%
dim VMSMsg : VMSMsg = fnReq("VMSMsg")
if VMSMsg = "" then VMSMsg = fnReq("msg") end if

dim ttsFile : ttsFile = fnDateToStr(now, "PREV_yyyymmddhhnnss")

'dim cFULL : cFULL = server.mapPath("\") & "/data/tts/" & ttsFile & ".wav"
'dim cURLS : cURLS = "http://" & siteUrl & "/data/tts/" & ttsFile & ".wav"
'
'VMSMsg = "테스트입니다."
'
'dim tts, uRETN
'set tts = server.createObject("CoreTtsCOM.TtsInterface")
'uRETN = tts.VOICE_FILE(dftTTSHost, dftTTSPost, "10", VMSMsg, cFULL, "1", "3", "3", "1.0", "0")
'uRETN = tts.VOICE_FILE("10.100.1.69", "20010", "10", VMSMsg, cFULL, "8", "3", "3", "1.0", "0")
'uRETN = tts.VOICE_FILE("10.100.1.73", "20000", "10", VMSMsg, cFULL, "8", "3", "3", "1.0", "0")
'uRETN = tts.VOICE_FILE(dftTTSHost, dftTTSPort, "10", VMSMsg, cFULL, "8", "3", "3", "1.0", "0")
'set tts = nothing

'cURLS = "/data/tts/" & ttsFile & ".wav"
'response.write	cURLS

dim tts : tts = fnCreateTTS("/TTS", ttsFile, VMSMsg, 100, 100, 100, 545, 3)
'dim tts : tts = fnCreateTTS("/TTS", ttsFile, VMSMsg, 100, 100, 100, 291, 3) '삼성보드 팩스용 wav

response.write	tts
%>

<html>
<body>
	<object width="100%" height="70" classid="clsid:22d6f312-b0f6-11d0-94ab-0080c74c7e95">
		<param name="filename" value="<%=tts%>" />
		<param name="autostart" value="1" />
		<param name="showstatusbar" value="1" />
	</object>
</body>
</html>