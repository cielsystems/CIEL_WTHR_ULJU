<!--#include virtual="/common/common.asp"-->

<%
'#	================================================================================================
'#	기본값
dim clUpIdx				: clUpIdx				= fnIsNull(fnReq("clUpIdx"),0)
dim	clGB					:	clGB					=	fnReq("clGB")
dim msgIdx				: msgIdx				= fnIsNull(fnReq("msgIdx"),0)
dim	clTit					:	clTit					=	fnReq("clTit")
dim	rsvYN					:	rsvYN					=	fnReq("rsvYN")
dim	rsvDate				:	rsvDate				=	fnReq("rsvDate")
dim	rsvHH					:	rsvHH					=	fnReq("rsvHH")
dim	rsvNN					:	rsvNN					=	fnReq("rsvNN")
dim	rsvSS					:	rsvSS					=	fnReq("rsvSS")
dim	clMethod			:	clMethod			=	fnReq("clMethod")
dim clARSAnswTime	: clARSAnswTime	= fnIsNull(fnReq("clARSAnswTime"),0)
dim clMedia				: clMedia				= array(fnIsNull(fnReq("clMedia1"),0), fnIsNull(fnReq("clMedia2"),0), fnIsNull(fnReq("clMedia3"),0))
dim clTry					: clTry					= array(fnIsNull(fnReq("clTry1"),0), fnIsNull(fnReq("clTry2"),0), fnIsNull(fnReq("clTry3"),0))
dim clSndNum1			: clSndNum1			= fnReq("clSndNum1")
dim clSndNum2			: clSndNum2			= fnReq("clSndNum2")
dim clSndNum3			: clSndNum3			= fnReq("clSndNum3")

dim clAnswDTMF		: clAnswDTMF		= fnReq("clAnswDTMF")

dim ruleID				: ruleID				= fnIsNull(fnReq("ruleID"), 0) 

'#	문자
dim	SMSMsg				:	SMSMsg				=	fnReq("SMSMsg")
dim splitYN				: splitYN				= fnReq("splitYN")

'#	음성
dim	VMSMsg				:	VMSMsg				=	fnReq("VMSMsg")
dim	TTS_pitch			:	TTS_pitch			=	fnIsNull(fnReq("TTS_pitch"),dftTTSPitch)
dim	TTS_speed			:	TTS_speed			=	fnIsNull(fnReq("TTS_speed")	,dftTTSSpeed)
dim	TTS_volume		:	TTS_volume		=	fnIsNull(fnReq("TTS_volume"),dftTTSVolume)
dim	TTS_sformat		:	TTS_sformat		=	fnIsNull(fnReq("TTS_sformat"),dftTTSFormat)
dim TTS_play			: TTS_play			= fnIsNull(fnReq("TTS_play"),2)
dim TTS_sformatNM
for i = 0 to ubound(arrTTSFormat)
	if cstr(arrTTSFormat(i)) = cstr(TTS_sformat) then
		TTS_sformatNM = arrTTSFormatNm(i)
		exit for
	end if
next

dim addSMSMsg : addSMSMsg = fnIsNull(fnReq("addSMSMsg"),"N")
dim addVMSMsg : addVMSMsg = fnIsNull(fnReq("addVMSMsg"),"N")
dim addVMSMsgText	: addVMSMsgText	= fnIsNull(fnReq("addVMSMsgText"), "")
if addVMSMsg = "Y" then
	VMSMsg	= VMSMsg	& " " & addVMSMsgText
end if

dim clRetSendYN	: clRetSendYN	= fnIsNull(fnReq("clRetSendYN"),"N")

'#	예약일시
dim rsvDT
if rsvYN = "Y" then
	rsvDT = rsvDate & " " & right("0" & rsvHH,2) & ":" & right("0" & rsvNN,2) & ":" & right("0" & rsvSS,2)
else
	rsvDT = fnDateToStr(now, "yyyy-mm-dd hh:nn:ss")
end if

dim clRsvYN : clRsvYN = rsvYN
dim clRsvDT : clRsvDT = rsvDT
'#	================================================================================================

dim scdlType	: scdlType	= fnIsNull(fnReq("scdlType"), "")
dim scdlValu	: scdlValu	= fnIsNull(fnReq("scdlValu"), 0)
dim scdlSDT		: scdlSDT		= fnIsNull(fnReq("scdlSDate"), fnDateToStr(now, "yyyy-mm-dd"))
	scdlSDT	= scdlSDT	& " " & fnIsNull(fnReq("scdlSHour"), fnDateToStr(now, "hh")) & ":" & fnIsNull(fnReq("scdlSMint"), fnDateToStr(now, "nn")) & ":00"
dim scdlEDT		: scdlEDT		= fnIsNull(fnReq("scdlEDate"), fnDateToStr(now, "yyyy-mm-dd"))
	scdlEDT	= scdlEDT	& " " & fnIsNull(fnReq("scdlEHour"), fnDateToStr(now, "hh")) & ":" & fnIsNull(fnReq("scdlEMint"), fnDateToStr(now, "nn")) & ":00"

dim scdlReg		: scdlReg		= fnIsNull(fnReq("scdlReg"), "N")

'#	================================================================================================
'#	음성전송 Print
sub emrConfirmVMS()

	if clMethod <> 1 then
		
		response.write	"<h3>음성전송</h3>"
		
		arrRs = execProcRs("usp_listTmpFile", array(0, ss_userIdx, svr_remoteAddr, "V", 1, 999999))
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
			if fnByte(SMSMsg) > 90 then
				if splitYN = "Y" then
					response.write	"단문(SMS)으로 분할 전송"
				else
					response.write	"장문(LMS) 한건으로 전송>"
				end if
			else
				response.write	"단문(SMS) 한건 전송"
			end if
		end if
		
		response.write	")</h3>"
		
		response.write	"<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0"">"
		response.write	"<colgroup>"
		response.write	"	<col width=""33%"" />"
		response.write	"	<col width=""33%"" />"
		response.write	"	<col width=""*"" />"
		response.write	"</colgroup>"
		
		if fnByte(tmpMsg) > 90 and splitYN = "Y" then
			
			dim nChr, tmpByte, splitMsg(99)
			for i = 1 to len(tmpMsg)
				nChr = mid(tmpMsg,i,1)
				if asc(nChr) <> 10 then
					if inStrRev(server.URLEncode(nChr),"%") > 1 then
						tmpByte = 2
					elseif asc(nChr) > 0 and asc(nChr) < 255 then
						tmpByte = 1
					else
						tmpByte = 2
					end if
					'response.write	splitNo & ":" & nChr & "(" & asc(nChr) & ")(" & nByte & ") = " & splitMsg(splitNo) & "(" & fnByte(splitMsg(splitNo)) & ")<br />"
					if nByte + tmpByte < 91 then
						splitMsg(splitNo) = splitMsg(splitNo) & nChr
						nByte = nByte + tmpByte
					else
						splitNo = splitNo + 1
						nByte = tmpByte
						splitMsg(splitNo) = splitMsg(splitNo) & nChr
					end if
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
	
	<form name="frm" method="post" action="callProcNew.asp" target="popProcFrame">
		
		<input type="hidden" name="clUpIdx" value="<%=clUpIdx%>" />
		<input type="hidden" name="clGB" value="<%=clGB%>" />
		<input type="hidden" name="msgIdx" value="<%=msgIdx%>" />
		<input type="hidden" name="clTit" value="<%=clTit%>" />
		<input type="hidden" name="clRsvYN" value="<%=clRsvYN%>" />
		<input type="hidden" name="clRsvDT" value="<%=clRsvDT%>" />
		<input type="hidden" name="clMethod" value="<%=clMethod%>" />
		<input type="hidden" name="clARSAnswTime" value="<%=clARSAnswTime%>" />
		<input type="hidden" name="clMedia1" value="<%=clMedia(0)%>" />
		<input type="hidden" name="clMedia2" value="<%=clMedia(1)%>" />
		<input type="hidden" name="clMedia3" value="<%=clMedia(2)%>" />
		<input type="hidden" name="clTry1" value="<%=clTry(0)%>" />
		<input type="hidden" name="clTry2" value="<%=clTry(1)%>" />
		<input type="hidden" name="clTry3" value="<%=clTry(2)%>" />
		<input type="hidden" name="clSndNum1" value="<%=clSndNum1%>" />
		<input type="hidden" name="clSndNum2" value="<%=clSndNum2%>" />
		<input type="hidden" name="clSndNum3" value="<%=clSndNum3%>" />
		<input type="hidden" name="addSMSMsg" value="<%=addSMSMsg%>" />
		<input type="hidden" name="addVMSMsg" value="<%=addVMSMsg%>" />
		<input type="hidden" name="clRetSendYN" value="<%=clRetSendYN%>" />
		<input type="hidden" name="clAnswDTMF" value="<%=clAnswDTMF%>" />
		
		<input type="hidden" name="ruleID" value="<%=ruleID%>" />
		
		<div class="tabs">
			<ul class="tabsMenu">
				<% for i = 0 to ubound(arrClMethod) %>
					<li id="tabsMenu_<%=i+1%>" onclick="fnTabMenu(<%=i+1%>)"><%=arrClMethod(i)%>내용</li>
				<% next %>
				<li id="tabsMenu_3" onclick="fnTabMenu(3)">대상확인</li>
				<% if scdlReg = "Y" then %>
					<li id="tabsMenu_4" onclick="fnTabMenu(4)">스케줄확인</li>
				<% end if %>
				<div class="clr"></div>
			</ul>
			<div class="tabsContBox">
				<div id="tabs-1" class="tabsCont">
					<div style="height:470px;overflow-x:hidden;overflow-y:scroll;">
						
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
					<div style="height:470px;overflow-x:hidden;overflow-y:scroll;">
						
						<%
						if clMethod = 1 or clMEthod = 4 then
							call emrConfirmVMS()
						else
							call emrConfirmSMS()
						end if
						%>
						
					</div>
				</div>
				<div id="tabs-3" class="tabsCont">
					<div style="height:470px;overflow-x:hidden;overflow-y:scroll;">
						<div class="listSchBox">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td></td>
									<td class="aR">
										총 <b><span id="cntAll">0</span></b>명
									</td>
								</tr>
							</table>
						</div>
						<%
						arrListHeader = array("번호","이름")
						for i = 1 to ubound(arrCallMedia)
							redim Preserve arrListHeader(ubound(arrListHeader) + 1)
							arrListHeader(ubound(arrListHeader)) = arrCallMedia(i) & "번호"
						next
						redim Preserve arrListHeader(ubound(arrListHeader) + 1)
						arrListHeader(ubound(arrListHeader)) = "삭제"
						arrListWidth = array("80px","*","140px","140px","140px","80px")
						
						call subListTable("listTbl")
						%>
					</div>
				</div>
				<% if scdlReg = "Y" then %>
					<div id="tabs-4" class="tabsCont">
		
						<b><%=scdlSDT%></b> 부터 <b><%=scdlEDT%></b> 까지
						
						<%
						dim scdlPrid, scdlCont
						dim strScdl, scdlFirstDT, scdlSql
						select case scdlType
							case "H"
								response.write	"<b>" & scdlValu & "시간</b> 마다"
								scdlPrid	= dateDiff("h", scdlSDT, scdlEDT)
								scdlCont	= 0
								for i = 0 to scdlPrid step scdlValu
									scdlCont = scdlCont + 1
									scdlFirstDT = fnIsNull(scdlFirstDT, fnDateToStr(dateAdd("h", i, scdlSDT), "yyyy-mm-dd hh:nn:ss"))
									strScdl	= strScdl	& "<tr><td class=""aC"">" & scdlCont & "</td><td class=""aC"">" & fnDateToStr(dateAdd("h", i, scdlSDT), "yyyy-mm-dd hh:nn") & "</td></tr>"
									if len(scdlSql) > 0 then
										scdlSql = scdlSql & ","
									end if
									scdlSql = scdlSql & " (" & ss_userIndx & ", '" & svr_remoteAddr & "', 0, 0, " & scdlCont & ", '" & fnDateToStr(dateAdd("h", i, scdlSDT), "yyyy-mm-dd hh:nn") & "') "
								next
								response.write	"(" & scdlPrid & "시간 동안 <b>총 : " & scdlCont & "회</b> 반복)"
							case "D"
								response.write	"<b>" & scdlValu & "일</b> 마다"
								scdlPrid	= dateDiff("d", scdlSDT, scdlEDT)
								scdlCont	= 0
								for i = 0 to scdlPrid step scdlValu
									if dateAdd("d", i, scdlSDT) < dateAdd("s", 1, scdlEDT) then
										scdlCont = scdlCont + 1
										scdlFirstDT = fnIsNull(scdlFirstDT, fnDateToStr(dateAdd("d", i, scdlSDT), "yyyy-mm-dd hh:nn:ss"))
										strScdl	= strScdl	& "<tr><td class=""aC"">" & scdlCont & "</td><td class=""aC"">" & fnDateToStr(dateAdd("d", i, scdlSDT), "yyyy-mm-dd hh:nn") & "</td></tr>"
										if len(scdlSql) > 0 then
											scdlSql = scdlSql & ","
										end if
										scdlSql = scdlSql & " (" & ss_userIndx & ", '" & svr_remoteAddr & "', 0, 0, " & scdlCont & ", '" & fnDateToStr(dateAdd("d", i, scdlSDT), "yyyy-mm-dd hh:nn") & "') "
									end if
								next
								response.write	"(" & scdlPrid & "일 동안 <b>총 : " & scdlCont & "회</b> 반복)"
							case "W"
								response.write	"<b>매주 " & weekDayName(scdlValu + 1) & "</b> 마다"
								scdlPrid	= dateDiff("d", scdlSDT, scdlEDT)
								scdlCont	= 0
								for i = 0 to scdlPrid
									if weekDay(dateAdd("d", i, scdlSDT)) = scdlValu + 1 and dateAdd("d", i, scdlSDT) < dateAdd("s", 1, scdlEDT) then
										scdlCont = scdlCont + 1
										scdlFirstDT = fnIsNull(scdlFirstDT, fnDateToStr(dateAdd("d", i, scdlSDT), "yyyy-mm-dd hh:nn:ss"))
										strScdl	= strScdl	& "<tr><td class=""aC"">" & scdlCont & "</td><td class=""aC"">" & fnDateToStr(dateAdd("d", i, scdlSDT), "yyyy-mm-dd hh:nn") & "</td></tr>"
										if len(scdlSql) > 0 then
											scdlSql = scdlSql & ","
										end if
										scdlSql = scdlSql & " (" & ss_userIndx & ", '" & svr_remoteAddr & "', 0, 0, " & scdlCont & ", '" & fnDateToStr(dateAdd("d", i, scdlSDT), "yyyy-mm-dd hh:nn") & "') "
									end if
								next
								response.write	"(" & scdlPrid & "일 동안 <b>총 : " & scdlCont & "회</b> 반복)"
							case "M"
								response.write	"<b>매월 " & scdlValu & "일</b> 마다"
								scdlPrid	= dateDiff("d", scdlSDT, scdlEDT)
								scdlCont	= 0
								for i = 0 to scdlPrid
									if cInt(day(dateAdd("d", i, scdlSDT))) = cInt(scdlValu) and dateAdd("d", i, scdlSDT) < dateAdd("s", 1, scdlEDT) then
										scdlCont = scdlCont + 1
										scdlFirstDT = fnIsNull(scdlFirstDT, fnDateToStr(dateAdd("d", i, scdlSDT), "yyyy-mm-dd hh:nn:ss"))
										strScdl	= strScdl	& "<tr><td class=""aC"">" & scdlCont & "</td><td class=""aC"">" & fnDateToStr(dateAdd("d", i, scdlSDT), "yyyy-mm-dd hh:nn") & "</td></tr>"
										if len(scdlSql) > 0 then
											scdlSql = scdlSql & ","
										end if
										scdlSql = scdlSql & " (" & ss_userIndx & ", '" & svr_remoteAddr & "', 0, 0, " & scdlCont & ", '" & fnDateToStr(dateAdd("d", i, scdlSDT), "yyyy-mm-dd hh:nn") & "') "
									end if
								next
								response.write	"(" & scdlPrid & "일 동안 <b>총 : " & scdlCont & "회</b> 반복)"
						end select
						
						if len(scdlSql) > 0 then
							scdlSql = " insert into TMP_SCDL_ITEM (USER_INDX, USER_IP, CALL_INDX, SCDL_INDX, SCDL_NO, SCDL_DT) values " & scdlSql
							call execSql(scdlSql)
						end if
						%>
					
						<input type="hidden" name="scdlType" value="<%=scdlType%>" />
						<input type="hidden" name="scdlValu" value="<%=scdlValu%>" />
						<input type="hidden" name="scdlSDT" value="<%=scdlSDT%>" />
						<input type="hidden" name="scdlEDT" value="<%=scdlEDT%>" />
						<input type="hidden" name="scdlReg" value="<%=scdlReg%>" />
						<input type="hidden" name="scdlFirstDT" value="<%=scdlFirstDT%>" />
						
						<div style="height:440px;overflow-x:hidden;overflow-y:scroll;margin-top:10px;">
							<table border="0" cellpadding="0" cellspacing="1" class="tblList">
								<colgroup>
									<col width="140px" />
									<col width="*" />
								</colgroup>
								<tr>
									<th>회차</th>
									<th>일시</th>
								</tr>
								<%=strScdl%>
							</table>
						</div>
						
					</div>
				<% end if %>
			</div>
		</div>
		
		<div class="aR" style="margin-top:10px;">
			<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_blue_send.png" onclick="fnSend()" />
		</div>
		
	</form>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	var nTab = 1;			// 최초 선택된 Tab 번호
	
	var page = 1;
	var pageSize = 10;
	var rowCnt = 0;
	
	$(function(){
		
		fnSelTab();			// 최초 선택텝
		
		fnLoadPage(1);
		
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
	
	function fnLoadPage(p){
		page = p;
		var param = 'proc=TmpTrg&param=0]|[<%=ss_userIdx%>]|[<%=svr_remoteAddr%>]|[]|[&page='+page+'&pageSize='+pageSize;
		param = encodeURI(param);
		var list = fnGetHttp('/pages/public/ajxList.asp?'+param);
		var arrList = list.split('}|{');
		rowCnt = arrList[0];
		$('#cntAll').html(rowCnt);
		$('#listTbl tbody tr').remove();
		if(rowCnt > 0){
			var strRow, arrVal;
			for(i = 2; i < arrList.length; i++){
				arrVal = arrList[i].split(']|[');
				//	TMP_NO(2), TMP_NM(3), TMP_NUM1(4), TMP_NUM2(5), TMP_NUM3(6)
				strRow = '<tr>'
				+'	<td class="aC">'+(arrVal[0]-(pageSize*(page-1))-(i-2))+'</td>'
				+'	<td class="aC">'+arrVal[3]+'</td>'
				+'	<td class="aC">'+arrVal[4]+'</td>'
				+'	<td class="aC">'+arrVal[5]+'</td>'
				+'	<td class="aC">'+arrVal[6]+'</td>'
				+'	<td class="aC"><img class="imgBtn" src="<%=pth_pubImg%>/btn/red_del2.png" onclick="fnTmpTrgDel('+arrVal[2]+')" /></td>'
				+'</tr>';
				$('#listTbl tbody').append(strRow);
			}
		}
		$('#listPaging').html(arrList[1]);
	}
	
	function fnTmpTrgDel(no){
		popProcFrame.location.href = 'pop_addrProc.asp?proc=trgDel&no='+no;
	}
	
	function fnSend(){
		if(rowCnt == 0){
			alert('선택된 대상자가 없습니다.\n대상자를 선택해 주세요.');top.fnCloseLayer();
		}else{
			if(confirm('전송내용과 전송대상을 확인하셨습니까?\n\n대상자수가 많을경우 전송요청까지 시간이 소요될 수 있습니다.\n"전송요청이 완료되었습니다" 라는 메시지가 보일때까지 기다려 주세요.')){
				document.frm.submit();
				//top.fnLoadingS();
			}
		}
	}
	
</script>