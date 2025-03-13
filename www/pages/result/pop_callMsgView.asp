<!--#include virtual="/common/common.asp"-->

<%
'#	================================================================================================
'#	기본값
dim clIdx					: clIdx					= fnReq("clIdx")

sql = " select "
sql = sql & " CL_TIT, CL_METHOD, CL_SMSMSG, CL_VMSMSG, (case when CL_SMSSPLIT > 0 then 'Y' else 'N' end) as CL_SMSSPLIT "
sql = sql & " 	, CL_VMSMSG, CL_TTSPITCH, CL_TTSSPEED, CL_TTSVOLUME, CL_TTSFORMAT, CL_VMSPLAY "
sql = sql & " from TBL_CALL with(nolock) "
sql = sql & " where CL_IDX = " & clIdx & " "
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
if not rs.eof then
	
	dim	clTit					:	clTit					=	rs("CL_TIT")
	dim	clMethod			:	clMethod			=	rs("CL_METHOD")
	
	'#	문자
	dim	SMSMsg				:	SMSMsg				=	rs("CL_SMSMSG")
	dim splitYN				: splitYN				= rs("CL_SMSSPLIT")
	
	'#	음성
	dim	VMSMsg				:	VMSMsg				=	rs("CL_VMSMSG")
	dim	TTS_pitch			:	TTS_pitch			=	fnIsNull(rs("CL_TTSpitch"),		dftTTSPitch)
	dim	TTS_speed			:	TTS_speed			=	fnIsNull(rs("CL_TTSspeed"),		dftTTSSpeed)
	dim	TTS_volume		:	TTS_volume		=	fnIsNull(rs("CL_TTSvolume"),	dftTTSVolume)
	dim	TTS_sformat		:	TTS_sformat		=	fnIsNull(rs("CL_TTSformat"),	dftTTSFormat)
	dim TTS_play			: TTS_play			= rs("CL_VMSplay")
	
end if
rsClose()

dim TTS_sformatNM
for i = 0 to ubound(arrTTSFormat)
	if cstr(arrTTSFormat(i)) = cstr(TTS_sformat) then
		TTS_sformatNM = arrTTSFormatNm(i)
		exit for
	end if
next
'#	================================================================================================

'#	================================================================================================
'#	음성전송 Print
sub emrConfirmVMS()

	if clMethod <> 1 then
		
		response.write	"<h3>음성전송</h3>"
		
		arrRs = execProcRs("usp_listCallFile", array(clIdx, "V", 1, 999999))
		if isarray(arrRs) then
			arrRc2 = ubound(arrRs,2)
		else
			arrRc2 = -1
		end if
		
		response.write	"<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0"">"
		response.write	"	<tr>"
		response.write	"		<td width=""500px"">"
		
		if arrRc2 > -1 then
			response.write	"			<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""1"" id=""vmsFileList"" style=""background:#cccccc;"">"
			for i = 0 to arrRc2
				response.write	" 			<tr>"
				response.write	" 				<td style=""background:#ffffff;padding:3px 5px;"">"
				response.write	"						<img src=""" & pth_pubImg & "/icons/speaker-volume.png"" /> " & arrRs(2,i)
				response.write	" 				</td>"
				response.write	"				</tr>"
			next
			response.write	"			</table>"
		else
			response.write	"			<div style=""background:url(/images/tts_bg_light.png);width:500px;height:300px;"">"
			response.write	"			 	<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0"">"
			response.write	"			 		<tr>"
			response.write	"			 			<td>"
			response.write	"			 				<div style=""width:488px;height:265px;border:1px solid #cccccc;overflow-x:hidden;overflow-y:scroll;margin:25px 5px 10px 5px;"">"
			response.write	"								<textarea name=""VMSMsg"" style=""display:none;"">" & VMSMsg & "</textarea>"
			response.write	"			 					<div id=""VMSMsg"" style=""width:468px;margin:5px;word-break:break-all;"">" & replace(VMSMsg,Chr(13),"<br>") & "</div>"
			response.write	"			 				</div>"
			response.write	"			 			</td>"
			response.write	"			 		</tr>"
			response.write	"			 	</table>"
			response.write	"				</div>"
			response.write	"			<div class=""aR"" style=""margin-top:5px;""><span id=""vmsByte"" class=""bld"">" & fnByte(VMSMsg) & "</span> Byte</div>"
			response.write	"		</td>"
			'response.write	"		<td width=""20px""></td>"
			'response.write	"		<td valign=""top"">"
			'response.write	"			<table border=""0"" cellpadding=""0"" cellspacing=""1"" class=""tblForm"">"
			'response.write	"				<colgroup>"
			'response.write	"					<col width=""30%"" />"
			'response.write	"					<col width=""*"" />"
			'response.write	"				</colgroup>"
			'response.write	"				<tr><th>Pitch</th><td><input type=""hidden"" name=""TTS_pitch"" value=""" & TTS_pitch & """ />" & TTS_pitch & "</td></tr>"
			'response.write	"				<tr><th>Speed</th><td><input type=""hidden"" name=""TTS_speed"" value=""" & TTS_speed & """ />" & TTS_speed & "</td></tr>"
			'response.write	"				<tr><th>Volume</th><td><input type=""hidden"" name=""TTS_volume"" value=""" & TTS_volume & """ />" & TTS_volume & "</td></tr>"
			'response.write	"				<tr><th>Format</th><td><input type=""hidden"" name=""TTS_sformat"" value=""" & TTS_sformat & """ />" & TTS_sformatNM & "(<span class=""colBlue bld"">" & fnTTSFormatToExt(TTS_sformat) & "</span>)</td></tr>"
			'response.write	"				<tr><th>Play</th><td><input type=""hidden"" name=""TTS_play"" value=""" & TTS_play & """ />" & TTS_play & "회</td></tr>"
			'response.write	"			</table>"
			'response.write	"		</td>"
		end if
		
		response.write	"	</tr>"
		response.write	"</table>"
		
	end if
	
end sub
'#	================================================================================================

'#	================================================================================================
'#	문자전송 Print
sub emrConfirmSMS()

	if clMethod <> 0 then
		
		
		response.write	"<h3>문자전송 ("
		
		dim tmpMsg	: tmpMsg = replace(SMSMsg,"<br>",Chr(13))
		dim nByte		: nByte = 0
		dim splitNo	: splitNo = 0
		
		arrRs = execProcRs("usp_listTmpFile", array(0, ss_userIdx, svr_remoteAddr, "S", 1, 999999))
		if isarray(arrRs) then
			arrRc2 = ubound(arrRs,2)
		else
			arrRc2 = -1
		end if
		
		if arrRc2 > -1 then
			response.write	"멀티메시지(MMS) 한건 전송"
		elseif fnByte(SMSMsg) > 90 then
			response.write	"장문(LMS) 한건 전송"
		else
			response.write	"단문(SMS)으로 분할 전송"
		end if
		
		response.write	")</h3>"
		
		response.write	"<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0"">"
		response.write	"<colgroup>"
		response.write	"	<col width=""33%"" />"
		response.write	"	<col width=""33%"" />"
		response.write	"	<col width=""*"" />"
		response.write	"</colgroup>"
		
		if fnByte(SMSMsg) > 2000  then
			
			dim nChr, tmpByte, splitMsg(99)
			for i = 1 to len(tmpMsg)
				nChr = mid(tmpMsg,i,1)
				if inStrRev(server.URLEncode(nChr),"%") > 1 then
					tmpByte = 2
				elseif asc(nChr) > 0 and asc(nChr) < 255 then
					tmpByte = 1
				else
					tmpByte = 2
				end if
				'response.write	splitNo & ":" & nChr & "(" & asc(nChr) & ")(" & nByte & ") = " & splitMsg(splitNo) & "(" & fnByte(splitMsg(splitNo)) & ")<br />"
				if nByte + tmpByte < 2001 then
					splitMsg(splitNo) = splitMsg(splitNo) & nChr
					nByte = nByte + tmpByte
				else
					splitNo = splitNo + 1
					nByte = tmpByte
					splitMsg(splitNo) = splitMsg(splitNo) & nChr
				end if
			next
			
			for i = 0 to splitNo
				
				if i mod 3 = 0 then
					response.write	"	<tr>"
				end if
		
				response.write	"		<td style=""padding:0 20px 0 0"">"
				response.write	"			<div style=""background:url(/images/phone_bg_light.png);width:250px;height:300px;"">"
				response.write	"				<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0"">"
				response.write	"					<tr>"
				response.write	"						<td>"
				response.write	"							<div style=""width:238px;height:265px;border:1px solid #cccccc;overflow-x:hidden;overflow-y:scroll;margin:25px 5px 10px 5px;"">"
				response.write	"								<textarea name=""SMSMsg_" & i & """ style=""display:none;"">" & splitMsg(i) & "</textarea>"
				response.write	"								<div id=""SMSMsg"" style=""width:218px;margin:5px;word-break:break-all;"">" & replace(splitMsg(i),chr(13),"<br>") & "</div>"
				response.write	"							</div>"
				response.write	"						</td>"
				response.write	"					</tr>"
				response.write	"				</table>"
				response.write	"			</div>"
				response.write	"			<div class=""aR bld"">" & fnByte(replace(splitMsg(i),"<br>",Chr(13))) & "</span> Byte</div>"
				response.write	"		</td>"
				
				if i mod 3 = 2 then
					response.write	"	</tr>"
				end if
				
			next
			
		else
			
			response.write	"	<tr>"
			
			response.write	"		<td style=""padding:0 20px 0 0"">"
			response.write	"			<div style=""background:url(/images/phone_bg_light.png);width:250px;height:300px;"">"
			response.write	"				<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0"">"
			response.write	"					<tr>"
			response.write	"						<td>"
			response.write	"							<div style=""width:238px;height:265px;border:1px solid #cccccc;overflow-x:hidden;overflow-y:scroll;margin:25px 5px 10px 5px;"">"
			response.write	"								<div id=""smsFileList"">"
			for i = 0 to arrRc2
				response.write	"									<div><img src=""/data/" & arrRs(3,i) & "/" & arrRs(4,i) & """ /></div>"
			next
			response.write	" 							</div>"
			response.write	"								<div id=""SMSMsg"" style=""width:218px;margin:5px;word-break:break-all;"">" & replace(SMSMsg,chr(13),"<br>") & "</div>"
			response.write	"							</div>"
			response.write	"						</td>"
			response.write	"					</tr>"
			response.write	"				</table>"
			response.write	"			</div>"
			response.write	"			<div class=""aR bld"" style=""width:250px;"">" & fnByte(SMSMsg) & "</span> Byte</div>"
			response.write	"		</td>"
			
			response.write	"	</tr>"
			
		end if
		
		response.write	"</table>"
		
		response.write	"<textarea name=""SMSMsg"" style=""display:none;"">" & SMSMsg & "</textarea>"
		response.write	"<input type=""hidden"" name=""splitYN"" value=""" & splitYN & """ />"
		response.write	"<input type=""hidden"" name=""splitNo"" value=""" & splitNo & """ />"
		
	end if
	
end sub
'#	================================================================================================

dim arrClMethod
if clMethod = 0 then
	arrClMethod = array("음성")
elseif clMethod = 1 then
	arrClMethod = array("문자")
elseif clMethod = 2 then
	arrClMethod = array("음성","문자")
elseif clMethod = 3 then
	arrClMethod = array("음성","문자")
elseif clMethod = 4 then
	arrClMethod = array("문자","음성")
end if
%>	

<!--#include virtual="/common/header_pop.asp"-->

<div id="popBody">
	
	<form name="frm" method="post" action="callProc.asp" target="popProcFrame">
		
		<div class="tabs">
			<ul class="tabsMenu">
				<% for i = 0 to ubound(arrClMethod) %>
					<li id="tabsMenu_<%=i+1%>" onclick="fnTabMenu(<%=i+1%>)"><%=arrClMethod(i)%>내용</li>
				<% next %>
				<div class="clr"></div>
			</ul>
			<div class="tabsContBox">
				<div id="tabs-1" class="tabsCont">
					<div style="height:400px;overflow-x:hidden;overflow-y:scroll;">
						
						<%
						if clMethod = 1 or clMEthod = 4 then
							call emrConfirmSMS()
						else
							call emrConfirmVMS()
						end if
						%>
						
					</div>
				</div>
				<div id="tabs-2" class="tabsCont">
					<div style="height:400px;overflow-x:hidden;overflow-y:scroll;">
						
						<%
						if clMethod = 1 or clMEthod = 4 then
							call emrConfirmVMS()
						else
							call emrConfirmSMS()
						end if
						%>
						
					</div>
				</div>
			</div>
		</div>
		
	</form>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	var nTab = 1;			// 최초 선택된 Tab 번호
	
	$(function(){
		
		fnSelTab();			// 최초 선택텝
		
	});
	
	function fnTabMenu(no){
		nTab = no;
		fnSelTab();
	}
	
	function fnSelTab(){
		$('.tabs .tabsMenu li').removeClass('on');
		$('.tabs .tabsContBox .tabsCont').css('display','none');
		$('.tabs .tabsMenu #tabsMenu_'+nTab).addClass('on');
		$('.tabs .tabsContBox #tabs-'+nTab).css('display','block');
	}
	
</script>