<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<%
dim scdlGubn, scdlType, scdlValu, scdlSDT, scdlEDT, scdlMethod, scdlMedia, scdlTry
dim scdlSMSGB, scdlVMSGB, scdlTit, scdlSMSMsg, scdlVMSMsg, scdlSMSMsgAdd, scdlVMSMsgAdd, scdlVMSPlay, scdlARSAnswYN, scdlARSAnswTime, scdlAnswDTMF
dim scdlSndNum1, scdlSndNum2, scdlAddVMSMsgText, scdlStat

dim scdlIndx	: scdlIndx	= fnIsNull(nFnReq("scdlIndx", 0), 0)

scdlGubn = "E"

scdlMethod	= dftMethod
scdlMedia	= dftMedia
scdlTry		= dftTry

'#	발신번호 : 발신번호는 개인의 발신번호를 먼저 사용한다.
scdlSndNum1 = fnIsNull(fnDBVal("NTBL_USER", "dbo.nufn_getSndNum('V', USER_INDX)", "USER_INDX = '" & ss_userIndx & "'"), dftSndNum)
scdlSndNum2 = fnIsNull(fnDBVal("NTBL_USER", "dbo.nufn_getSndNum('S', USER_INDX)", "USER_INDX = '" & ss_userIdx & "'"), dftSndNum)

scdlStat = 0

if scdlIndx > 0 then
	
	set rs = server.createobject("adodb.recordset")
	set cmd = server.createobject("adodb.command")
	with cmd

		.activeconnection = strDBConn
		.commandtext = "nusp_infoScdl"
		.commandtype = adCmdStoredProc
		
		.parameters.append .createParameter("@scdlIndx",	adInteger,	adParamInput,		0)
		
		.parameters("@scdlIndx")			= scdlIndx
		
		set rs = .execute
		
	end with
	set cmd = nothing
	
	if not rs.eof then
		scdlGubn         	= rs("SCDL_GUBN")
		scdlType         	= rs("SCDL_TYPE")
		scdlValu         	= rs("SCDL_VALU")
		scdlSDT          	= rs("SCDL_SDT")
		scdlEDT          	= rs("SCDL_EDT")
		scdlMethod       	= fnIsNull(rs("SCDL_METHOD"), dftMethod)
		scdlMedia        	= array(fnIsNull(rs("SCDL_MEDIA1"), dftMedia(0)), fnIsNull(rs("SCDL_MEDIA2"), dftMedia(1)), fnIsNull(rs("SCDL_MEDIA3"), dftMedia(2)))
		scdlTry          	= array(fnIsNull(rs("SCDL_TRY1"), dftTry(0)), fnIsNull(rs("SCDL_TRY2"), dftTry(1)), fnIsNull(rs("SCDL_TRY3"), dftTry(2)))
		scdlSMSGB        	= rs("SCDL_SMSGB")
		scdlVMSGB        	= rs("SCDL_VMSGB")
		scdlTit          	= rs("SCDL_TIT")
		scdlSMSMsg       	= rs("SCDL_SMSMSG")
		scdlVMSMsg       	= rs("SCDL_VMSMSG")
		scdlSMSMsgAdd    	= rs("SCDL_SMSMSGADD")
		scdlVMSMsgAdd    	= rs("SCDL_VMSMSGADD")
		scdlVMSPlay      	= rs("SCDL_VMSPLAY")
		scdlARSAnswYN    	= rs("SCDL_ARSANSWYN")
		scdlARSAnswTime  	= rs("SCDL_ARSANSWTIME")
		scdlAnswDTMF     	= rs("SCDL_ANSWDTMF")
		scdlSndNum1      	= rs("SCDL_SNDNUM1")
		scdlSndNum2      	= rs("SCDL_SNDNUM2")
		scdlAddVMSMsgText	= rs("SCDL_ADDVMSMSGTEXT")
		scdlStat					= rs("SCDL_STAT")
	end if
	set rs = nothing
	
end if

scdlSDT	= fnIsNull(scdlSDT, now)
scdlEDT	= fnIsNull(scdlEDT, dateAdd("d", 1, now))

dim scdlSDate, scdlSHour, scdlSMint
dim scdlEDate, scdlEHour, scdlEMint

scdlSDate	= fnDateToStr(scdlSDT, "yyyy-mm-dd")
scdlSHour	= fnDateToStr(scdlSDT, "hh")
scdlSMint	= fnDateToStr(scdlSDT, "nn")

scdlEDate	= fnDateToStr(scdlEDT, "yyyy-mm-dd")
scdlEHour	= fnDateToStr(scdlEDT, "hh")
scdlEMint	= fnDateToStr(scdlEDT, "nn")
%>

<div id="popBody">
	
	<form name="frm" method="post" action="pop_scdlProc.asp" target="popProcFrame" onsubmit="return false;">
		
		<input type="hidden" name="proc" value="" />
		<input type="hidden" name="scdlIndx" value="<%=scdlIndx%>" />
		<input type="hidden" name="scdlGubn" value="<%=scdlGubn%>" />
		
		<div class="tabs">
			
			<ul class="tabsMenu">
				<li id="tabsMenu_1" onclick="fnSelTab(1)">기본정보</li>
				<li id="tabsMenu_2" onclick="fnSelTab(2)">전송내용(문자/음성)</li>
				<li id="tabsMenu_3" onclick="fnSelTab(3)">스케줄내역</li>
				<div class="aR pdA05"><button class="btn btn_sm bg_olive" onclick="fnOpenMesg()">불러오기</button></div>
				<div class="clr"></div>
			</ul>
			<div class="clr"></div>
			
			<div class="tabsContBox">
				
				<div id="tabs-1" class="tabsCont">
					
					<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
						<colgroup>
							<col width="10%" />
							<col width="20%" />
							<col width="10%" />
							<col width="*" />
							<col width="10%" />
							<col width="10%" />
						</colgroup>
						<tr>
							<th>반복</th>
							<td>
								<select name="scdlType">
									<option value="">::: 선택 :::</option>
									<option value="H" <% if scdlType = "H" then %>selected<% end if %>>시간</option>
									<option value="D" <% if scdlType = "D" then %>selected<% end if %>>일</option>
									<option value="W" <% if scdlType = "W" then %>selected<% end if %>>주</option>
									<option value="M" <% if scdlType = "M" then %>selected<% end if %>>월</option>
								</select>
								<select name="scdlValu">
									<option value="">::: 선택 :::</option>
								</select>
								반복
							</td>
							<th>기간</th>
							<td>
								<input type="text" name="scdlSDate" value="<%=scdlSDate%>" size="10" />
								<select name="scdlSHour">
									<%
									for i = 0 to 23
										response.write	"<option value=""" & right("0" & i, 2) & """"
										if right("0" & i, 2) = scdlSHour then
											response.write	" selected "
										end if
										response.write	">" & right("0" & i, 2) & "시</option>"
									next
									%>
								</select>
								<select name="scdlSMint">
									<%
									for i = 0 to 60 step 5
										response.write	"<option value=""" & right("0" & i, 2) & """"
										if right("0" & i, 2) = scdlSMint then
											response.write	" selected "
										end if
										response.write	">" & right("0" & i, 2) & "분</option>"
									next
									%>
								</select> 부터
								<input type="text" name="scdlEDate" value="<%=scdlEDate%>" size="10" />
								<select name="scdlEHour">
									<%
									for i = 0 to 23
										response.write	"<option value=""" & right("0" & i, 2) & """"
										if right("0" & i, 2) = scdlEHour then
											response.write	" selected "
										end if
										response.write	">" & right("0" & i, 2) & "시</option>"
									next
									%>
								</select>
								<select name="scdlEMint">
									<%
									for i = 0 to 60 step 5
										response.write	"<option value=""" & right("0" & i, 2) & """"
										if right("0" & i, 2) = scdlEMint then
											response.write	" selected "
										end if
										response.write	">" & right("0" & i, 2) & "분</option>"
									next
									%>
								</select> 까지
							</td>
							<th>사용여부</th>
							<td>
								<label><input type="radio" name="scdlStat" value="0" <% if scdlStat = "0" then %>checked<% end if %> />사용</label>
								<label><input type="radio" name="scdlStat" value="9" <% if scdlStat = "9" then %>checked<% end if %> />미사용</label>
							</td>
						</tr>
					</table>
					
					<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
						<colgroup>
							<col width="10%" />
							<col width="*" />
						</colgroup>
						<tr>
							<th>제목</th>
							<td class="bld"><input type="text" name="scdlTit" size="80" value="<%=scdlTit%>" /></td>
						</tr>
						<tr>
							<th>전송방법</th>
							<td>
								<div style="line-height:25px;background:#efefef;border:2px solid red;padding:5px;font-size:15px;font-weight:bold;">
									<%
									dim strMethod
									for i = 0 to ubound(arrCallMethod)
										'if i <> 1 then
											strMethod = arrCallMethod(i)
											response.write	"<span><input type=""radio"" name=""scdlMethod"" value=""" & i & """"
											if cstr(i) = cstr(scdlMethod) then
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
											<input type="text" id="scdlARSAnswTime" name="scdlARSAnswTime" value="<%=scdlARSAnswTime%>" size="4" class="aR" />분
											간 응답대기
											<% if ARSAnswTimeUseYN = "Y" then %>
												, <span style="color:blue">문자응답은 비상호출 시작후 60분 까지 가능</span>
											<% end if %>
										</div>
									<% else %>
										<input type="hidden" id="scdlARSAnswTime" name="scdlARSAnswTime" value="0" />
									<% end if %>
								</div>
							</td>
						</tr>
						<tr>
							<th>전송매체(음성)</th>
							<td>
								<%
								dim callMediaCnt	: callMediaCnt	= ubound(arrCallMedia)
								for i = 1 to 3
									response.write	i & "차 : "
									response.write	"<select name=""scdlMedia" & i & """>"
									if i = 1 then
										callMediaCnt = 1
									else
										callMediaCnt	= ubound(arrCallMedia)
										response.write	"	<option value=""0"">::::: 선택 ::::::</option>"
									end if
									for ii = 1 to callMediaCnt
										response.write	"	<option value=""" & ii & """"
										if cInt(scdlMedia(i-1)) = cInt(ii) then
											response.write	" selected "
										end if
										response.write	">" & arrCallMedia(ii) & "</option>"
									next
									response.write	"</select> "
									response.write	"<select name=""scdlTry" & i & """>"
									for ii = 1 to 5
										response.write	"<option value=""" & ii & """"
										if cInt(scdlTry(i-1)) = cInt(ii) then
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
							<td>
								문자 : <input type="text" name="scdlSndNum2" value="<%=scdlSndNum2%>" /> &nbsp;&nbsp;&nbsp;
								음성 : <input type="text" name="scdlSndNum1" value="<%=scdlSndNum1%>" />
								음성응답DTMF : 
								<select id="scdlAnswDTMF" name="scdlAnswDTMF">
									<%
									for i = 0 to ubound(arrAnswDtmf)
										response.write	"<option value=""" & arrAnswDtmf(i) & """"
										if scdlAnswDTMF = arrAnswDtmf(i) then
											response.write	" selected "
										end if
										response.write	">" & arrAnswDtmfName(i) & "</option>"
									next
									%>
								</select>
							</td>
						</tr>
						<tr>
							<th>대상그룹<div class="mgT05"><button class="btn btn_sm bg_blue" onclick="fnTrgtGrupOpen()">그룹설정</button></div></th>
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
													><%=scdlSMSMsg%></textarea>
												</div>
											</td>
										</tr>
									</table>
								</div>
								<% if ARSAnswUSEYN = "Y" then %>
									<div style="margin:5px 0;padding:3px;background:#eeeeee;border:1px solid #cccccc;">
										<input type="checkbox" name="addSMSMsg" value="Y" <% if scdlSMSMsgAdd = "Y" then %>checked<% end if %> onclick="fnSMSMsgAdd(this)" />
										<%=strSMSAddMSg%>
									</div>
								<% else %>
									<input type="hidden" name="addSMSMsg" value="N" />
								<% end if %>
								<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
									<tr>
										<td>
											<img id="btnEmt" class="imgBtn" src="<%=pth_pubImg%>/btn/phn_btn_emt.png" />
											<% if smsFileUP = "Y" then %>
												<img class="imgBtn" src="<%=pth_pubImg%>/btn/phn_btn_file.png" onclick="fnSMSAddFileOpen()" />
											<% end if %>
										</td>
										<td class="aR"><span id="smsByte" class="bld">0</span> Byte</td>
									</tr>
								</table>
								<% if smsSplitUseYN = "Y" then %>
									<div style="margin-top:5px;" class="aR colBlue">
										<input type="checkbox" name="splitYN" value="Y" <% if dftSMSSplit = "Y" then %>checked<% end if %> onclick="fnChkByte('SMSMsg')" />	단문(SMS)으로 분할 전송
									</div>
								<% else %>
									<input type="hidden" name="splitYN" value="N" />
								<% end if %>
							</td>
							<td>
								<div style="border-left:1px solid #cccccc;height:360px;margin-left:30px;"></div>
							</td>
							<td valign="top">
								<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:0 0 5px;">
									<tr>
										<td>음성입력</td>
										<!--<td class="aR"><img class="imgBtn" src="<%=pth_pubImg%>/btn/olive_call2.png" onclick="fnCallMsg()" /></td>-->
									</tr>
								</table>
								<div style="background:url(/images/tts_bg_light.png);width:500px;height:300px;">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td>
												<div style="width:488px;height:265px;border:1px solid #cccccc;overflow-x:hidden;overflow-y:scroll;margin:25px 5px 10px 5px;">
													<textarea id="VMSMsg" name="VMSMsg" style="width:468px;height:250px;margin:5px;background:none;overflow:hidden;border:0;"
														onkeypress="fnChkByte('VMSMsg');" onkeydown="fnChkByte('VMSMsg');" onkeyup="fnChkByte('VMSMsg');"
													><%=scdlVMSMsg%></textarea>
												</div>
											</td>
										</tr>
									</table>
								</div>
								<div style="margin:5px 0;padding:3px;background:#eeeeee;border:1px solid #cccccc;">
									<input type="checkbox" name="addVMSMsg" value="Y" <% if scdlVMSMsgAdd = "Y" then %>checked<% end if %> onclick="fnVMSMsgAdd(this)" /> 
									<input type="text" name="scdlAddVMSMsgText" size="70" />
								</div>
								<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:5px 0 10px;">
									<tr>
										<td></td>
										<td class="aR"><span id="vmsByte" class="bld">0</span> Byte</td>
									</tr>
								</table>
								<div style="margin-top:5px;" class="aR colBlue"><img class="imgBtn" src="<%=pth_pubImg%>/btn/green_prevLit.png" onclick="fnVMSPreLit()" /></div>
							</td>
						</tr>
					</table>
					
				</div>
				
				<div id="tabs-3" class="tabsCont">
					
					<div class="scrollBox" style="height:400px;">
						<table border="0" cellpadding="0" cellspacing="1" class="tblList">
							<colgroup>
								<col width="100px" />
								<col width="*" />
								<col width="100px" />
							</colgroup>
							<tr>
								<th>회차</th>
								<th>일시</th>
								<th>상태</th>
							</tr>
							<%
							set rs = server.createobject("adodb.recordset")
							set cmd = server.createobject("adodb.command")
							with cmd

								.activeconnection = strDBConn
								.commandtext = "nusp_listScdlRedy"
								.commandtype = adCmdStoredProc
								
								.parameters.append .createParameter("@scdlIndx",	adInteger,	adParamInput,	0)
								
								.parameters("@scdlIndx")	= scdlIndx
								
								set rs = .execute
								
							end with
							set cmd = nothing
							if not rs.eof then
								arrRs		= rs.getRows
								arrRc2	= ubound(arrRs, 2)
							else
								arrRc2	= -1
							end if
							set rs = nothing
							
							for i = 0 to arrRc2
								response.write	"<tr>"
								response.write	"	<td class=""aC"">" & arrRs(0, i) & "</td>"
								response.write	"	<td class=""aC"">" & arrRs(1, i) & "</td>"
								response.write	"	<td class=""aC"">"
								if arrRs(2, i) = 0 then 
									response.write	"<span class=""color_green"">대기</span>"
								elseif arrRs(2, i) = 4 then
									response.write	"<span class=""color_gray"">취소</span>"
								elseif arrRs(2, i) = 5 then
									response.write	"<span class=""color_blue"">완료</span>"
								end if
								response.write	"</td>"
								response.write	"</tr>"
							next
							%>
						</table>
					</div>
					
				</div>
				
			</div>
			
		</div>
		
	</form>
	
	<div class="aC" style="margin-top:10px;">
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_red_del.png" onclick="fnDel()" />
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_blue_save.png" onclick="fnSave()" />
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	var nTab = 1;
	
	$(function(){
		
		fnSelTab(nTab);
		
		//	스케줄
		fnLoadScdlType('<%=scdlType%>');
		$('select[name=scdlValu] option[value=<%=scdlValu%>]').prop('selected', true);
		$('select[name=scdlType]').change(function(){
			var scdlType = $(this).val();
			fnLoadScdlType(scdlType);
		});
		
		//	전송방법
		fnSelClMethod(<%=scdlMethod%>);
		$('input[name=scdlMethod]').bind('click',function(){
			if($(this).val() == 4 || $(this).val() == 3){
				$('input[name=scdlARSAnswTime]').prop('disabled',false);
			}else{
				$('input[name=scdlARSAnswTime]').prop('disabled',true);
			}
			fnSelClMethod($(this).val());
		});
		
		//	DTMF
		fnVMSMsgAdd('');
		$('#scdlAnswDTMF').change(function(){
			fnVMSMsgAdd('');
		});
		
		fnTrgtGrupLoad();
		
	});
	
	function fnLoadScdlType(scdlType){
		var strSValu	= 0;
		var strEValu	= 0;
		var strValu = '';
		var arrWeek	= ['일','월','화','수','목','금','토'];
		if(scdlType == 'H'){
			strSValu	= 1;
			strEValu	= 24;
			strValu	= '시간 주기';
		}else if(scdlType == 'D'){
			strSValu	= 1;
			strEValu = 32;
			strValu	= '일 주기';
		}else if(scdlType == 'W'){
			strEValu	= 7;
			strValu	= '요일 마다';
		}else if(scdlType == 'M'){
			strSValu	= 1;
			strEValu	= 32;
			strValu	= '일 마다';
		}
		$('select[name=scdlValu] option').remove();
		$('select[name=scdlValu]').append('<option value="">::: 선택 :::</option>');
		for(var i = strSValu; i < strEValu; i++){
			if(scdlType == 'W'){
				var strRow = '<option value="'+i+'">'+arrWeek[i]+strValu+'</option>';
			}else{
				var strRow = '<option value="'+i+'">'+i+strValu+'</option>';
			}
			$('select[name=scdlValu]').append(strRow);
		}
	}
	
	function fnSelTab(n){
		nTab = n;
		$('.tabsCont').css('display','none');
		$('#tabs-'+n).css('display','block');
		$('.tabsMenu li').removeClass('on');
		$('#tabsMenu_'+n).addClass('on');
	}
	
	function fnSelClMethod(m){
		if(m == 4 || m == 3){
			$('input[name=scdlARSAnswTime]').prop('disabled',false);
		}else{
			$('input[name=scdlARSAnswTime]').prop('disabled',true);
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
		fnPop('pop_scdlRelForm.asp?scdlIndx=<%=scdlIndx%>', 'trgtGrup', 0, 0, 400, 500, 'N');
	}
	
	function fnTrgtGrupReset(){
		$('#trgtGrup li').remove();
	}
	
	function fnTrgtGrupLoad(){
		fnTrgtGrupReset();
		$.ajax({
			url	: 'ajxScdlTrgtGrup.asp',
			type	: 'POST',
			data	: 'scdlIndx=<%=scdlIndx%>',
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
					strTimeReg	= '<span class="color_olive">(발송가능시간적용)</span>';
				}else{
					strTimeReg	= '<span class="color_purple">(발송가능시간무시)</span>';
				}
				strRow	= '<li id="trgtGrup_'+arrVal[0]+'"><b>'+arrVal[1]+'</b>'
				+'<input type="hidden" name="grupIndx" value="'+arrVal[0]+'" />'
				/*+'<input type="hidden" name="applyWorkingHour" value="'+arrVal[3]+'" />'*/
				+' <span class="color_teal">'+arrVal[2]+'명</span>'/* '+strTimeReg*/
				+' <a href="javascript:fnTrgtGrupDel('+arrVal[0]+')"><img src="<%=pth_pubImg%>/icons/cross.png" /></a></li>';
				$('#trgtGrup').append(strRow);
			}
		}else if(proc == 'del'){
		}
	}
	
	function fnTrgtGrupDel(indx){
		$('#trgtGrup_'+indx).remove();
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
		var dtmf = $('#scdlAnswDTMF :selected').text();
		var addMsg = '<%=strVMSAddMsg%>'.replace('{[DTMF]}', dtmf);
		if(dtmf == '바로응답'){
			addMsg = '';
		}
		$('input[name=scdlAddVMSMsgText]').val(addMsg);
	}
	
	function fnSave(){
		if(fnNumberCheck($('input[name=scdlARSAnswTime]').val()) == true){
			if(parseInt($('input[name=scdlARSAnswTime]').val()) < 0 || parseInt($('input[name=scdlARSAnswTime]').val()) > 600){
				fnSelTab(1);
				alert('응답대기시간은 1분에서 600분까지만 설정 가능합니다.');$('input[name=scdlARSAnswTime]').focus();return false;
			}
		}else{
			fnSelTab(1);
			alert('응답대기시간은 숫자만 입력해 주세요.');$('input[name=scdlARSAnswTime]').focus();return false;
		}
		if($('#trgtGrup li').length == 0){
			fnSelTab(1);
			alert('대상그룹을 설정해 주세요.');return false;
		}
		if($('input[name=scdlMethod]:checked').val() != '1'){
			if($('input[name=scdlSndNum1]').val() == ''){
				fnSelTab(1);
				alert('음성발신번호를 입력해 주세요.');$('input[name=scdlSndNum1]').focus();return false;
			}
			if($('input[name=scdlSndNum1]').val().length > 12){
				fnSelTab(1);
				alert('발신번호는 12자리까지 입력가능합니다.');$('input[name=scdlSndNum1]').focus();return false;
			}
			if($('#VMSMsg').val() == ''){
				fnSelTab(2);
				alert('음성전송 내용을 입력하세요.');$('#VMSMsg').focus();return false;
			}
		}
		if($('input[name=scdlMethod]:checked').val() != '0'){
			if($('input[name=scdlSndNum2]').val() == ''){
				fnSelTab(1);
				alert('문자발신번호를 입력해 주세요.');$('input[name=scdlSndNum2]').focus();return false;
			}
			if($('input[name=scdlSndNum2]').val().length > 12){
				fnSelTab(1);
				alert('발신번호는 12자리까지 입력가능합니다.');$('input[name=scdlSndNum2]').focus();return false;
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
	
	function fnOpenMesg(){
		fnPop('/pages/public/pop_getMesg.asp', 'mesgList', 0, 0, 800, 600, 'N');
	}
	
	function fnGetMesg(tit, sms, vms){
		$('input[name=scdlTit]').val(tit);
		$('textarea[name=SMSMsg]').val(sms);
		$('textarea[name=VMSMsg]').val(vms);
	}
	
</script>