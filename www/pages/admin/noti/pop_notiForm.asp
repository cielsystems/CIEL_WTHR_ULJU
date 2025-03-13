<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<!--#include virtual="/common/config_noti.asp"-->

<%
dim ruleID, warnVarCode, areaCode, areaName, warnStressCode, commandCode, timeRef, delayTime
dim textTemplate, voiceTemplate, workingHourFrom, workingHourTo, discardWhenSleep
dim clMethod, clARSAnswTime, clMedia, clTry, clSndNum1, clSndNum2, clAnswDTMF, clSMSMsgAdd, clVMSMsgAdd, clVMSPlay, clARSAnswYN, autoUseYN

ruleID	= fnIsNull(fnReq("ruleID"), 0)

delayTime					= 0
discardWhenSleep	= "Y"
workingHourFrom		= 6
workingHourTo			= 23

if ruleID > 0 then
	
	set rs = server.createobject("adodb.recordset")
	set cmd = server.createobject("adodb.command")
	with cmd

		.activeconnection = strDBConn
		.commandtext = "nusp_infoNoti"
		.commandtype = adCmdStoredProc
		
		.parameters.append .createParameter("@ruleID",	adInteger,	adParamInput,		0)
		
		.parameters("@ruleID")			= ruleID
		
		set rs = .execute
		
	end with
	set cmd = nothing
	
	if not rs.eof then
		warnVarCode     	= rs("warnVarCode")
		areaCode        	= rs("areaCode")
		areaName        	= rs("areaName")
		warnStressCode  	= rs("warnStressCode")
		commandCode     	= rs("commandCode")
		timeRef         	= rs("timeRef")
		delayTime       	= rs("delayTime")
		textTemplate    	= rs("textTemplate")
		voiceTemplate   	= rs("voiceTemplate")
		workingHourFrom 	= rs("workingHourFrom")
		workingHourTo   	= rs("workingHourTo")
		discardWhenSleep	= rs("discardWhenSleep")
		clMethod        	= fnIsNull(rs("CL_METHOD"), 0)
		clARSAnswTime   	= fnIsNull(rs("CL_ARSANSWTIME"), dftARSAnswTime)
		clMedia         	= array(fnIsNull(rs("CL_MEDIA1"), dftMedia(0)), fnIsNull(rs("CL_MEDIA2"), dftMedia(1)), fnIsNull(rs("CL_MEDIA3"), dftMedia(2)))
		clTry           	= array(fnIsNull(rs("CL_TRY1"), dftTry(0)), fnIsNull(rs("CL_TRY2"), dftTry(1)), fnIsNull(rs("CL_TRY3"), dftTry(2)))
		clSndNum1       	= rs("CL_SNDNUM1")
		clSndNum2       	= rs("CL_SNDNUM2")
		clAnswDTMF				= rs("CL_ANSWDTMF")
		clSMSMsgAdd				= rs("CL_SMSMSGADD")
		clVMSMsgAdd				= rs("CL_VMSMSGADD")
		clVMSPlay					= rs("CL_VMSPLAY")
		clARSAnswYN				= rs("CL_ARSANSWYN")
		autoUseYN			= rs("autoUseYN")
	end if
	set rs = nothing
	
	'sql = " select "
	'sql = sql & " 	warnVarCode, areaCode, areaName, warnStressCode, commandCode, timeRef, delayTime "
	'sql = sql & " 	, textTemplate, voiceTemplate, workingHourFrom, workingHourTo, discardWhenSleep "
	'sql = sql & " 	, CL_METHOD, CL_ARSANSWTIME, CL_MEDIA1, CL_MEDIA2, CL_MEDIA3, CL_TRY1, CL_TRY2, CL_TRY3, CL_SNDNUM1, CL_SNDNUM2, CL_ANSWDTMF "
	'sql = sql & " 	, CL_SMSMSGADD, CL_VMSMSGADD, CL_VMSPLAY, CL_ARSANSWYN "
	'sql = sql & " from " & ntDBPrev & "TBL_NotiRuleSet with(nolock) "
	'sql = sql & " where ruleID = " & ruleID & " "
	''response.write	sql
	'cmdOpen(sql)
	'set rs = cmd.execute
	'cmdClose()
	'if not rs.eof then
	'	warnVarCode     	= rs("warnVarCode")
	'	areaCode        	= rs("areaCode")
	'	areaName        	= rs("areaName")
	'	warnStressCode  	= rs("warnStressCode")
	'	commandCode     	= rs("commandCode")
	'	timeRef         	= rs("timeRef")
	'	delayTime       	= rs("delayTime")
	'	textTemplate    	= rs("textTemplate")
	'	voiceTemplate   	= rs("voiceTemplate")
	'	workingHourFrom 	= rs("workingHourFrom")
	'	workingHourTo   	= rs("workingHourTo")
	'	discardWhenSleep	= rs("discardWhenSleep")
	'	clMethod        	= fnIsNull(rs("CL_METHOD"), 0)
	'	clARSAnswTime   	= fnIsNull(rs("CL_ARSANSWTIME"), dftARSAnswTime)
	'	clMedia         	= array(fnIsNull(rs("CL_MEDIA1"), dftMedia(0)), fnIsNull(rs("CL_MEDIA2"), dftMedia(1)), fnIsNull(rs("CL_MEDIA3"), dftMedia(2)))
	'	clTry           	= array(fnIsNull(rs("CL_TRY1"), dftTry(0)), fnIsNull(rs("CL_TRY2"), dftTry(1)), fnIsNull(rs("CL_TRY3"), dftTry(2)))
	'	clSndNum1       	= rs("CL_SNDNUM1")
	'	clSndNum2       	= rs("CL_SNDNUM2")
	'	clAnswDTMF				= rs("CL_ANSWDTMF")
	'	clSMSMsgAdd				= rs("CL_SMSMSGADD")
	'	clVMSMsgAdd				= rs("CL_VMSMSGADD")
	'	clVMSPlay					= rs("CL_VMSPLAY")
	'	clARSAnswYN				= rs("CL_ARSANSWYN")
	'end if
	'rsClose()
	
	dftMethod	= clMethod
	dftARSAnswTime	= clARSAnswTime
	dftMedia	= clMedia
	dftTry	= clTry
	
end if
%>

<div id="popBody">
	
	<form name="frm" method="post" action="pop_notiProc.asp" target="popProcFrame" onsubmit="return false;">
		
		<input type="hidden" name="proc" />
		<input type="hidden" name="ruleID" value="<%=ruleID%>" />
		
		<div class="tabs">
			
			<ul class="tabsMenu">
				<li id="tabsMenu_1" onclick="fnSelTab(1)">기본정보</li>
				<li id="tabsMenu_2" onclick="fnSelTab(2)">전송내용(문자/음성)</li>
				<div class="clr"></div>
			</ul>
			<div class="clr"></div>
			
			<div class="tabsContBox">
				
				<div id="tabs-1" class="tabsCont">
					
					<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
						<colgroup>
							<col width="10%" />
							<col width="15%" />
							<col width="10%" />
							<col width="15%" />
							<col width="10%" />
							<col width="15%" />
							<col width="10%" />
							<col width="15%" />
						</colgroup>
						<tr>
							<th>종류</th>
							<td>
								<select name="warnVarCode">
									<option value="">::: 선택 :::</option>
									<%
									for ntCateLoop = 0 to ntCateRc
										response.write	"<option value=""" & ntCateRs(0, ntCateLoop) & """"
										if warnVarCode = ntCateRs(0, ntCateLoop) then
											response.write	" selected "
										end if
										response.write	">" & ntCateRs(1, ntCateLoop) & "</option>"
									next
									%>
								</select>
							</td>
							<th>지역</th>
							<td>
								<select name="areaCode" class="ntCate ntCateA">
									<option value="">::: 선택 :::</option>
									<%
									for ntAreaLoop = 0 to ntAreaRc
										if ntAreaRs(1, ntAreaLoop) = "N" or ntAreaRs(1, ntAreaLoop) = "S" then
											response.write	"<option value=""" & ntAreaRs(0, ntAreaLoop) & """"
											if areaCode = ntAreaRs(0, ntAreaLoop) then
												response.write	" selected "
											end if
											response.write	">" & ntAreaRs(3, ntAreaLoop) & "</option>"
										end if
									next
									%>
								</select>
								<input class="ntCate ntCateB" type="text" name="areaName" value="<%=areaName%>" />
								<input class="ntCate ntCateC" type="text" name="areaName" value="<%=areaName%>" />
								<!--
								<select name="areaCode" class="ntCate ntCateC">
									<option value="">::: 선택 :::</option>
									<%
									for ntAreaLoop = 0 to ntAreaRc
										if ntAreaRs(1, ntAreaLoop) = "S" then
											response.write	"<option value=""" & ntAreaRs(0, ntAreaLoop) & """"
											if areaCode = ntAreaRs(0, ntAreaLoop) then
												response.write	" selected "
											end if
											response.write	">" & ntAreaRs(3, ntAreaLoop) & "</option>"
										end if
									next
									%>
								</select>
								-->
								<input class="ntCate ntCateD" type="text" name="areaName" value="<%=areaName%>" />
							</td>
							<th>단계</th>
							<td>
								<select name="warnStressCode" class="ntCate ntCateA">
									<option value="">::: 선택 :::</option>
									<%
									for ntRankLoop = 0 to ntRankRc
										response.write	"<option value=""" & ntRankRs(0, ntRankLoop) & """"
										if warnStressCode = ntRankRs(0, ntRankLoop) then
											response.write	" selected "
										end if
										response.write	">" & ntRankRs(1, ntRankLoop) & "</option>"
									next
									%>
								</select>
								<select name="warnStressCode" class="ntCate ntCateB">
									<option value="">::: 선택 :::</option>
									<%
									for ntRankLoop = 1 to ntRankRc
										response.write	"<option value=""" & ntRankRs(0, ntRankLoop) & """"
										if warnStressCode = ntRankRs(0, ntRankLoop) then
											response.write	" selected "
										end if
										response.write	">" & ntRankRs(1, ntRankLoop) & "</option>"
									next
									%>
								</select>
								<select name="warnStressCode" class="ntCate ntCateC">
									<option value="">::: 선택 :::</option>
									<%
									for ntRankLoop = 2 to ntRankRc
										response.write	"<option value=""" & ntRankRs(0, ntRankLoop) & """"
										if warnStressCode = ntRankRs(0, ntRankLoop) then
											response.write	" selected "
										end if
										response.write	">" & ntRankRs(1, ntRankLoop) & "</option>"
									next
									%>
								</select>
								<select name="warnStressCode" class="ntCate ntCateD">
									<option value="">::: 선택 :::</option>
									<%
									for ntRankLoop = 1 to ntRankRc
										response.write	"<option value=""" & ntRankRs(0, ntRankLoop) & """"
										if warnStressCode = ntRankRs(0, ntRankLoop) then
											response.write	" selected "
										end if
										response.write	">" & ntRankRs(1, ntRankLoop) & "</option>"
									next
									%>
								</select>
							</td>
							<th>발표코드</th>
							<td>
								<select name="commandCode" class="ntCate ntCateA">
									<option value="">::: 선택 :::</option>
									<%
									for ntTypeLoop = 0 to ntTypeRc
										response.write	"<option value=""" & ntTypeRs(0, ntTypeLoop) & """"
										if commandCode = ntTypeRs(0, ntTypeLoop) then
											response.write	" selected "
										end if
										response.write	">" & ntTypeRs(1, ntTypeLoop) & "</option>"
									next
									%>
								</select>
								<select name="commandCode" class="ntCate ntCateB">
									<option value="">::: 선택 :::</option>
									<%
									for ntTypeLoop = 0 to 1
										response.write	"<option value=""" & ntTypeRs(0, ntTypeLoop) & """"
										if commandCode = ntTypeRs(0, ntTypeLoop) then
											response.write	" selected "
										end if
										response.write	">" & ntTypeRs(1, ntTypeLoop) & "</option>"
									next
									%>
								</select>
								<select name="commandCode" class="ntCate ntCateC">
									<option value="">::: 선택 :::</option>
									<%
									for ntTypeLoop = 0 to 0
										response.write	"<option value=""" & ntTypeRs(0, ntTypeLoop) & """"
										if commandCode = ntTypeRs(0, ntTypeLoop) then
											response.write	" selected "
										end if
										response.write	">" & ntTypeRs(1, ntTypeLoop) & "</option>"
									next
									%>
								</select>
								<select name="commandCode" class="ntCate ntCateD">
									<option value="">::: 선택 :::</option>
									<%
									for ntTypeLoop = 0 to 1
										response.write	"<option value=""" & ntTypeRs(0, ntTypeLoop) & """"
										if commandCode = ntTypeRs(0, ntTypeLoop) then
											response.write	" selected "
										end if
										response.write	">" & ntTypeRs(1, ntTypeLoop) & "</option>"
									next
									%>
								</select>
							</td>
						</tr>
						<tr>
							<th>통보시각</th>
							<td>
								<select name="timeRef">
									<option value="">::: 선택 :::</option>
									<%
									for ntTimeLoop = 0 to ubound(ntTimeRs)
										response.write	"<option value=""" & ntTimeRs(ntTimeLoop)(0) & """"
										if timeRef = ntTimeRs(ntTimeLoop)(0) then
											response.write	" selected "
										end if
										response.write	">" & ntTimeRs(ntTimeLoop)(1) & "</option>"
									next
									%>
								</select>
							</td>
							<th>예약</th>
							<td colspan="5">
								<label><input type="radio" name="delayTimeChek" value="N" <% if delayTime = 0 then %>checked<% end if %> /> 즉시</label>
								<label><input type="radio" name="delayTimeChek" value="Y" <% if delayTime <> 0 then %>checked<% end if %> /> 예약</label>
								<input type="text" name="delayTime" size="4" value="<%=delayTime%>" <% if delayTime = 0 then %>readonly<% end if %> />분 후
							</td>
						</tr>
						<tr>
							<th>발송가능시간</th>
							<td colspan="5">
								<select name="workingHourFrom">
									<%
									for i = 0 to 23
										response.write	"<option value=""" & i & """"
										if workingHourFrom = i then
											response.write	" selected "
										end if
										response.write	">" & i & "</option>"
									next
									%>
								</select> 시 00분 ~
								<select name="workingHourTo">
									<%
									for i = 0 to 23
										response.write	"<option value=""" & i & """"
										if workingHourTo = i then
											response.write	" selected "
										end if
										response.write	">" & i & "</option>"
									next
									%>
								</select> 시 59분
							</td>
							<th>자동여부</th>
							<td>
								<label><input type="radio" name="autoUseYN" value="Y" <% if autoUseYN = "Y" then %>checked<% end if %> /> 사용</label>
								<label><input type="radio" name="autoUseYN" value="N" <% if autoUseYN = "N" then %>checked<% end if %> /> 미사용</label>
							</td>
							<!--
							<th>시간외발생메시지</th>
							<td colspan="3">
								<label><input type="radio" name="discardWhenSleep" value="Y" <% if discardWhenSleep = "Y" then %>checked<% end if %> /> 무시</label>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<label><input type="radio" name="discardWhenSleep" value="N" <% if discardWhenSleep = "N" then %>checked<% end if %> /> 발송 가능시간대로 예약</label>
							</td>
							-->
						</tr>
						<tr>
							<th>전송방법</th>
							<td colspan="7">
								<div style="line-height:25px;background:#efefef;border:2px solid red;padding:5px;font-size:15px;font-weight:bold;">
									<%
									dim strMethod
									for i = 0 to ubound(arrCallMethod)
										'if i <> 1 then
											strMethod = arrCallMethod(i)
											response.write	"<span><input type=""radio"" name=""clMethod"" value=""" & i & """"
											if cstr(i) = cstr(dftMethod) then
												response.write	" checked "
											end if
											response.write	"/>"
											strMethod = replace(strMethod,"문자","<span class=""colBlue"">문자</span>")
											strMethod = replace(strMethod,"음성","<span class=""colRed"">음성</span>")
											strMethod = replace(strMethod,"(미응답자)","<span class=""colGray"">(미응답자)</span>")
											response.write	strMethod
											if ARSAnswUSEYN = "Y" then
												if i = 1 or i = 2 then
													response.write	"<span class=""fnt11"">[문자응답불가]</span>"
												elseif i = 4 or i = 3 then
													response.write	"[문자응답가능]"
												end if
											end if
											response.write	"</span>"
											if i = 2 then
												response.write	"<br /><div style=""margin:5px 0;border-top:1px solid #cccccc;""></div>"
											elseif i < 4 then
												response.write	"&nbsp;&nbsp;&nbsp;&nbsp;"
											end if
										'end if
									next
									%>
									<% if ARSAnswUSEYN = "Y" then %>
										<div id="answTime" class="colOrange bld" style="margin-top:2px;padding-top:2px;font-size:14px;">
											문자 전송완료 후
											<input type="text" id="clARSAnswTime" name="clARSAnswTime" value="<%=dftARSAnswTime%>" size="4" class="aR" />분
											간 응답대기
											<% if ARSAnswTimeUseYN = "Y" then %>
												, <span style="color:blue">문자응답은 비상호출 시작후 60분 까지 가능</span>
											<% end if %>
										</div>
									<% else %>
										<input type="hidden" id="clARSAnswTime" name="clARSAnswTime" value="0" />
									<% end if %>
								</div>
							</td>
						</tr>
						<tr>
							<th>전송매체(음성)</th>
							<td colspan="7">
								<%
								dim callMediaCnt	: callMediaCnt	= ubound(arrCallMedia)
								for i = 1 to 3
									response.write	i & "차 : "
									response.write	"<select name=""clMedia" & i & """>"
									if i = 1 then
										callMediaCnt = 1
									else
										callMediaCnt	= ubound(arrCallMedia)
										response.write	"	<option value=""0"">::::: 선택 ::::::</option>"
									end if
									for ii = 1 to callMediaCnt
										response.write	"	<option value=""" & ii & """"
										if cInt(dftMedia(i-1)) = cInt(ii) then
											response.write	" selected "
										end if
										response.write	">" & arrCallMedia(ii) & "</option>"
									next
									response.write	"</select> "
									response.write	"<select name=""clTry" & i & """>"
									for ii = 1 to 5
										response.write	"<option value=""" & ii & """"
										if cInt(dftTry(i-1)) = cInt(ii) then
											response.write	" selected "
										end if
										response.write	">" & ii & "회</option>"
									next
									response.write	"</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
								next
								%>
							</td>
						</tr>
						<tr>
							<th>발신번호</th>
							<td colspan="7">
								문자 : <input type="text" name="clSndNum2" value="<%=clSndNum2%>" /> &nbsp;&nbsp;&nbsp;
								음성 : <input type="text" name="clSndNum1" value="<%=clSndNum1%>" />
								음성응답DTMF : 
								<select id="clAnswDTMF" name="clAnswDTMF">
									<%
									for i = 0 to ubound(arrAnswDtmf)
										response.write	"<option value=""" & arrAnswDtmf(i) & """"
										if clAnswDTMF = arrAnswDtmf(i) then
											response.write	" selected "
										end if
										response.write	">" & arrAnswDtmfName(i) & "</option>"
									next
									%>
								</select>
							</td>
						</tr>
						<tr>
							<th>대상그룹
								<div class="mgT05"><button class="btn btn_sm bg_blue" onclick="fnTrgtGrupOpen()">그룹설정</button></div>
								<!--<div class="mgT05"><button class="btn btn_sm bg_purple" onclick="fnTrgtView()">대상보기</button></div>-->
							</th>
							<td colspan="7">
								<div class="scrollBox" style="height:90px">
									<ul class="itemList" id="trgtGrup"></ul>
								</div>
							</td>
						</tr>
					</table>
					
				</div>
				
				<div id="tabs-2" class="tabsCont">
					
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<colgroup>
							<col width="250px" />
							<col width="*" />
							<col width="500px" />
						</colgroup>
						<tr>
							<td valign="top">
								<div style="margin:2px 0 5px 0;"><img id="SMSMsgTypeIcon" src="<%=pth_pubImg%>/phn_btn_sms_on.png" /> 문자메시지입력</div>
								<div style="background:url(/images/phone_bg_light.png);width:250px;height:300px;">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td>
												<div style="width:238px;height:265px;border:1px solid #cccccc;overflow-x:hidden;overflow-y:scroll;margin:25px 5px 10px 5px;">
													<div id="smsFileView"></div>
													<textarea id="SMSMsg" name="SMSMsg" style="width:218px;height:250px;margin:5px;background:none;overflow:hidden;border:0;"
														onkeypress="fnChkByte('SMSMsg');" onkeydown="fnChkByte('SMSMsg');" onkeyup="fnChkByte('SMSMsg');"
													><%=textTemplate%></textarea>
												</div>
											</td>
										</tr>
									</table>
								</div>
								<% if ARSAnswUSEYN = "Y" then %>
									<div style="margin:5px 0;padding:3px;background:#eeeeee;border:1px solid #cccccc;">
										<input type="checkbox" name="addSMSMsg" value="Y" <% if clSMSMsgAdd = "Y" then %>checked<% end if %> onclick="fnSMSMsgAdd(this)" />
										<%=strSMSAddMSg%>
									</div>
								<% else %>
									<input type="hidden" name="addSMSMsg" value="N" />
								<% end if %>
								<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
									<tr>
										<td>
											<button class="btn btn_sm bg_teal" onclick="fnKeywordOpen(event,'SMSMsg')">키워드선택</button>
										</td>
										<td class="aR"><span id="smsByte" class="bld">0</span> Byte</td>
									</tr>
								</table>
								<input type="hidden" name="splitYN" value="N" />
							</td>
							<td>
								<div style="border-left:1px solid #cccccc;height:360px;margin-left:30px;"></div>
							</td>
							<td valign="top">
								<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:0 0 5px;">
									<tr>
										<td>음성입력</td>
										<td class="aR"></td>
									</tr>
								</table>
								<div style="background:url(/images/tts_bg_light.png);width:500px;height:300px;">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td>
												<div style="width:488px;height:265px;border:1px solid #cccccc;overflow-x:hidden;overflow-y:scroll;margin:25px 5px 10px 5px;">
													<textarea id="VMSMsg" name="VMSMsg" style="width:468px;height:250px;margin:5px;background:none;overflow:hidden;border:0;"
														onkeypress="fnChkByte('VMSMsg');" onkeydown="fnChkByte('VMSMsg');" onkeyup="fnChkByte('VMSMsg');"
													><%=VoiceTemplate%></textarea>
												</div>
											</td>
										</tr>
									</table>
								</div>
								<div style="margin:5px 0;padding:3px;background:#eeeeee;border:1px solid #cccccc;">
									<input type="checkbox" name="addVMSMsg" value="Y" <% if clVMSMsgAdd = "Y" then %>checked<% end if %> onclick="fnVMSMsgAdd(this)" /> 
									<input type="text" name="addVMSMsgText" value="<%=strVMSAddMsg%>" size="70" />
								</div>
								<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:5px 0 10px;">
									<tr>
										<td>
											<!--<button class="btn btn_sm bg_teal" onclick="fnKeywordOpen(event,'VMSMsg')">키워드선택</button>-->
										</td>
										<td class="aR"><span id="vmsByte" class="bld">0</span> Byte</td>
									</tr>
								</table>
								<div style="margin-top:5px;" class="aR colBlue"><img class="imgBtn" src="<%=pth_pubImg%>/btn/green_prevLit.png" onclick="fnVMSPreLit()" /></div>
							</td>
						</tr>
					</table>
					
				</div>
				
			</div>
			
		</div>
		
	</form>
	
	<div class="aC" style="margin-top:10px;">
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_red_del.png" onclick="fnDel()" />
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_blue_save.png" onclick="fnSave()" />
	</div>
	
</div>

<style type="text/css">
	#msgKeywordBox	{position:absolute;border:1px solid #ccc;background-color:#fff;padding:10px;display:none;}
	#msgKeywordBox	h3	{}
	#msgKeywordBox	ul	{list-style-type:none;padding:0;margin:10px 0 0 0;}
	#msgKeywordBox	ul	li	{display:inline-block;margin:5px 5px 5px 0;}
</style>

<div id="msgKeywordBox">
	<h3>메시지 키워드 선택 <span style="float:right;"><img onclick="fnKeywordClose()" class="imgBtn" src="<%=pth_pubImg%>/icons/cross.png" /></span></h3>
	<ul>
		<li class=""><button class="btn btn_sm bg_orange">발표시각</button></li>
		<li class=""><button class="btn btn_sm bg_orange">발효시각</button></li>
		<li class=""><button class="btn btn_sm bg_orange">특보종류</button></li>
		<li class=""><button class="btn btn_sm bg_orange">특보강도</button></li>
		<li class=""><button class="btn btn_sm bg_orange">발표코드</button></li>
		<br />
		<li class="ntCate ntCateA"><button class="btn btn_sm bg_purple">지역이름</button></li>
		<br />
		<li class="ntCate ntCateC"><button class="btn btn_sm bg_blue">지진발생시각</button></li>
		<li class="ntCate ntCateC"><button class="btn btn_sm bg_blue">진앙(위도)</button></li>
		<li class="ntCate ntCateC"><button class="btn btn_sm bg_blue">진앙(경도)</button></li>
		<li class="ntCate ntCateC"><button class="btn btn_sm bg_blue">진앙(위치)</button></li>
		<li class="ntCate ntCateC"><button class="btn btn_sm bg_blue">규모</button></li>
		<br />
		<li class="ntCate ntCateD"><button class="btn btn_sm bg_blue">지진발생시각</button></li>
		<li class="ntCate ntCateD"><button class="btn btn_sm bg_blue">진앙(위도)</button></li>
		<li class="ntCate ntCateD"><button class="btn btn_sm bg_blue">진앙(경도)</button></li>
		<li class="ntCate ntCateD"><button class="btn btn_sm bg_blue">진앙(위치)</button></li>
		<li class="ntCate ntCateD"><button class="btn btn_sm bg_blue">규모</button></li>
		<li class="ntCate ntCateD"><button class="btn btn_sm bg_green">해일-해당지역</button></li>
		<li class="ntCate ntCateD"><button class="btn btn_sm bg_green">해일-발표내용</button></li>
		<li class="ntCate ntCateD"><button class="btn btn_sm bg_green">해일-당부사항</button></li>
	</ul>
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script type="text/javascript">
	
	var nTab = 1;
	
	var warnVarCode = '';
	var cateCode = '';
	
	var msgTrg;
	
	$(function(){
		
		fnSelTab(nTab);
		
		//	종류선택
		$('.ntCate').prop('disabled', true);
		$('.ntCate').css('display', 'none');
		fnSelCate();
		$('select[name=warnVarCode]').change(function(){
			fnSelCate();
		});
		
		//	즉시/예약
		$('input[name=delayTimeChek]').click(function(){
			if($(this).val() == 'N'){
				$('input[name=delayTime]').val(0);
				$('input[name=delayTime]').prop('readonly', true);
			}else{
				$('input[name=delayTime]').prop('readonly', false);
			}
		});
		
		//	전송방법
		fnSelClMethod(<%=dftMethod%>);
		$('input[name=clMethod]').bind('click',function(){
			if($(this).val() == 4 || $(this).val() == 3){
				$('input[name=clARSAnswTime]').prop('disabled',false);
			}else{
				$('input[name=clARSAnswTime]').prop('disabled',true);
			}
			fnSelClMethod($(this).val());
		});
		
		//	DTMF
		fnVMSMsgAdd('');
		$('#clAnswDTMF').change(function(){
			fnVMSMsgAdd('');
		});
		
		fnTrgtGrupLoad();
		
		//	Keyword
		$('#msgKeywordBox ul li button').click(function(){
			var cursorPositionS = msgTrg.prop("selectionStart");
			var cursorPositionE = msgTrg.prop("selectionEnd");
			console.log(cursorPositionS+'/'+cursorPositionE);
			var msg = msgTrg.val();
			var beforeMsg = msg.substring(0, cursorPositionS);
			var afterMsg	= msg.substring(cursorPositionE, msg.length);
			var addKey = '$' + $(this).text() + '$';
			msgTrg.val(beforeMsg + addKey + afterMsg);
		});
		
	});
	
	function fnSelTab(n){
		nTab = n;
		$('.tabsCont').css('display','none');
		$('#tabs-'+n).css('display','block');
		$('.tabsMenu li').removeClass('on');
		$('#tabsMenu_'+n).addClass('on');
	}
	
	//	종류선택
	function fnSelCate(){
		warnVarCode = $('select[name=warnVarCode]').val();
		cateCode = '';
		if(warnVarCode < 9121){						// 기상특보
			cateCode = 'A';
		}else if(warnVarCode == 9121){		// 지진
			cateCode = 'C';
		}else if(warnVarCode == 9122){		// 지진해일
			cateCode = 'D';
		}else if(warnVarCode == 9131 || warnVarCode == 9132){		// 미세먼지, 초미세먼지
			cateCode = 'B';
		}
		$('.ntCate').prop('disabled', true);
		$('.ntCate').css('display', 'none');
		$('.ntCate'+cateCode).prop('disabled', false);
		$('.ntCate'+cateCode).css('display', 'inline-block');
	}
	
	function fnSelClMethod(m){
		if(m == 4 || m == 3){
			$('input[name=clARSAnswTime]').prop('disabled',false);
		}else{
			$('input[name=clARSAnswTime]').prop('disabled',true);
		}
		if(m == 0){					// 음성만
		}else if(m == 1){		// 문자만
		}else if(m == 2){		// 음성+문자
		}else if(m == 3){		// 음성후문자
		}else if(m == 4){		// 문자후음성
		}
	}
	
	//	대상그룹
	function fnTrgtGrupOpen(){
		fnPop('pop_notiRelForm.asp?ruleID=<%=ruleID%>', 'trgtGrup', 0, 0, 400, 500, 'N');
	}
	
	function fnTrgtGrupReset(){
		$('#trgtGrup li').remove();
	}
	
	function fnTrgtGrupLoad(){
		fnTrgtGrupReset();
		$.ajax({
			url	: 'ajxNotiTrgtGrup.asp',
			type	: 'POST',
			data	: 'ruleID=<%=ruleID%>',
			success	: function(rslt){
				if(rslt.length > 0){
					fnTrgtGrupProc('add', rslt);
				}
			},
			fail	: function(rslt){
				alert('오류가 발생했습니다.');
			}
		});
	}
	
	function fnTrgtGrupProc(proc, args){
		if(proc == 'add'){
			var arrRslt	= args.split('}|{');
			var arrVal, strRow, strTimeReg;
			for(var i = 0; i < arrRslt.length; i++){
				arrVal	= arrRslt[i].split(']|[');
				if(arrVal[3] == 'Y'){
					strTimeReg	= '';//'<span class="color_olive">(발송가능시간적용)</span>';
				}else{
					strTimeReg	= '';//'<span class="color_purple">(발송가능시간무시)</span>';
				}
				strRow	= '<li id="trgtGrup_'+arrVal[0]+'"><b>'+arrVal[1]+'</b>'
				+'<input type="hidden" name="notiGroupID" value="'+arrVal[0]+'" />'
				+'<input type="hidden" name="applyWorkingHour" value="'+arrVal[3]+'" />'
				+' <span class="color_teal">'+arrVal[2]+'명</span> '+strTimeReg
				+' <a href="javascript:fnTrgtGrupDel('+arrVal[0]+')"><img src="<%=pth_pubImg%>/icons/cross.png" /></a></li>';
				$('#trgtGrup').append(strRow);
			}
		}else if(proc == 'del'){
		}
	}
	
	function fnTrgtGrupDel(indx){
		$('#trgtGrup_'+indx).remove();
	}
	
	function fnTrgtView(){
		fnPop('pop_notiTrgtView.asp?ruleID=<%=ruleID%>', 'trgtView', 0, 0, 800, 500, 'N');
	}
	
	function fnVMSMsgAdd(trg){
		var dtmf = $('select[name=clAnswDTMF] :selected').text();
		var addMsg = '<%=strVMSAddMsg%>'.replace('{[DTMF]}', dtmf);
		if(dtmf == '바로응답'){
			addMsg = '';
		}
		$('input[name=addVMSMsgText]').val(addMsg);
	}
	
	function fnKeywordOpen(e, trg){
		var posX = e.pageX;
		var posY = e.pageY;
		$('#msgKeywordBox').css({'top':posY+'px','left':posX+'px','display':'block'});
		msgTrg = $('#'+trg);
	}
	function fnKeywordClose(){
		$('#msgKeywordBox').css({'display':'none'});
	}
	
	function fnChkByte(trg){
		var h = 250;
		if(trg == 'SMSMsg'){
			$('#smsByte').html(fnByte($('#SMSMsg').val()));
			var splitNo = fnSplit($('#SMSMsg').val());
			if(fnByte($('#SMSMsg').val()) > 2000){
				alert('문자는 최대 2000bytes까지 가능합니다.');
			}
			if(fnByte($('#SMSMsg').val()) > 90 || splitNo > 2){
				$('input[name=splitYN]').prop('checked',false);
				$('input[name=splitYN]').prop('disabled',true);
				$('#SMSMsgTypeIcon').prop('src','<%=pth_pubImg%>/phn_btn_lms_on.png');
			}else{
				$('input[name=splitYN]').prop('disabled',false);
				if($('input[name=splitYN]').prop('checked') == true || fnByte($('#SMSMsg').val()) < 91){
					$('#SMSMsgTypeIcon').prop('src','<%=pth_pubImg%>/phn_btn_sms_on.png');
				}else{
					$('#SMSMsgTypeIcon').prop('src','<%=pth_pubImg%>/phn_btn_lms_on.png');
				}
			}
		}else if(trg == 'VMSMsg'){
			$('#vmsByte').html(fnByte($('#VMSMsg').val()));
		}
		fnAutoHeight(trg,h);
	}
	
	function fnAutoHeight(trg,h){	// textarea 높이조정
		var trg = eval('document.all.'+trg);
		var nHeight = trg.scrollHeight;
		if(nHeight > h){
			trg.style.height = (24+trg.scrollHeight)+"px";
		}
	}
	
	function fnSMSMsgAdd(trg){
		var addStr = '\n<%=strSMSAddMsg%>';
		var nSMSMsg = $('#SMSMsg').val();
		if($(trg).prop('checked') == true){
			if(nSMSMsg.indexOf(addStr) > -1){
			}else{
				nSMSMsg = nSMSMsg+addStr;
			}
		}else{
			nSMSMsg = nSMSMsg.replace(addStr,'');
		}
		$('#SMSMsg').val(nSMSMsg);
		fnChkByte('SMSMsg');
	}
	
	function fnVMSMsgAdd(trg){
		var dtmf = $('#clAnswDTMF :selected').text();
		var addMsg = '<%=strVMSAddMsg%>'.replace('{[DTMF]}', dtmf);
		if(dtmf == '바로응답'){
			addMsg = '';
		}
		$('input[name=addVMSMsgText]').val(addMsg);
	}
	
	function fnSave(){
		if($('select[name=warnVarCode]').val().length < 4){
			alert('종류를 선택하세요.');$('select[name=warnVarCode]').focus();return false;
		}
		if(cateCode == 'A' || cateCode == 'C'){
			if($('.ntCate'+cateCode+'[name=areaCode]').val().length < 4){
				alert('지역을 선택하세요.');$('.ntCate'+cateCode+'[name=areaCode]').focus();return false;
			}
		}else{
			if($('.ntCate'+cateCode+'[name=areaName]').val().length < 4){
				alert('지역을 입력하세요.');$('.ntCate'+cateCode+'[name=areaName]').focus();return false;
			}
		}
		if($('.ntCate'+cateCode+'[name=warnStressCode]').val().length < 4){
			alert('단계를 선택하세요.');$('.ntCate'+cateCode+'[name=warnStressCode]').focus();return false;
		}
		if($('.ntCate'+cateCode+'[name=commandCode]').val().length < 4){
			alert('발표코드를 선택하세요.');$('.ntCate'+cateCode+'[name=commandCode]').focus();return false;
		}
		if($('select[name=timeRef]').val().length < 1){
			alert('통보시각을 선택하세요.');$('select[name=timeRef]').focus();return false;
		}
		if(fnNumberCheck($('input[name=clARSAnswTime]').val()) == true){
			if(parseInt($('input[name=clARSAnswTime]').val()) < 0 || parseInt($('input[name=clARSAnswTime]').val()) > 600){
				fnSelTab(1);
				alert('응답대기시간은 1분에서 600분까지만 설정 가능합니다.');$('input[name=clARSAnswTime]').focus();return false;
			}
		}else{
			fnSelTab(1);
			alert('응답대기시간은 숫자만 입력해 주세요.');$('input[name=clARSAnswTime]').focus();return false;
		}
		if($('#trgtGrup li').length == 0){
			fnSelTab(1);
			alert('대상그룹을 설정해 주세요.');return false;
		}
		if($('input[name=clMethod]:checked').val() != '1'){
			if($('input[name=clSndNum1]').val() == ''){
				fnSelTab(1);
				alert('음성발신번호를 입력해 주세요.');$('input[name=clSndNum1]').focus();return false;
			}
			if($('input[name=clSndNum1]').val().length > 12){
				fnSelTab(1);
				alert('발신번호는 12자리까지 입력가능합니다.');$('input[name=clSndNum1]').focus();return false;
			}
			if($('#VMSMsg').val() == ''){
				fnSelTab(2);
				alert('음성전송 내용을 입력하세요.');$('#VMSMsg').focus();return false;
			}
		}
		if($('input[name=clMethod]:checked').val() != '0'){
			if($('input[name=clSndNum2]').val() == ''){
				fnSelTab(1);
				alert('문자발신번호를 입력해 주세요.');$('input[name=clSndNum2]').focus();return false;
			}
			if($('input[name=clSndNum2]').val().length > 12){
				fnSelTab(1);
				alert('발신번호는 12자리까지 입력가능합니다.');$('input[name=clSndNum2]').focus();return false;
			}
			if($('#SMSMsg').val() == ''){
				fnSelTab(2);
				alert('문자전송 내용을 입력하세요.');$('#SMSMsg').focus();return false;
			}
			if(fnByte($('#SMSMsg').val()) > 2000){
				fnSelTab(2);
				alert('문자는 최대 2000bytes까지 가능합니다.');$('#SMSMsg').focus();return false;
			}
		}
		$('input[name=proc]').val('S');
		document.frm.submit();
	}
	
	function fnDel(){
		if(confirm('삭제하시겠습니까?')){
			$('input[name=proc]').val('D');
			document.frm.submit();
		}
	}
	
</script>