<!--#include virtual="/common/common.asp"-->

<%
dim cdWork	: cdWork	= fnReq("cdWork")
dim cdRank	: cdRank	= fnReq("cdRank")
dim wrkTyp	: wrkTyp	= fnReq("wrkTyp")
dim strWrkTyp
if wrkTyp = "I" then
	strWrkTyp	= "발령"
elseif wrkTyp = "C" then
	strWrkTyp	= "해제"
end if

dim wrkIdx	: wrkIdx	= fnIsNull(fnReq("wrkIdx"),0)

dim wrkTit, wrkMethod, wrkMedia(2), wrkTry(2), wrkSndNum1, wrkSndNum2
dim wrkSMSMsg, wrkVMSMsg, wrkVMSPlay, wrkARSAnswYN, wrkARSAnswTime, wrkAnswDTMF
%>

<!--#include virtual="/common/header_pop.asp"-->

<div id="popBody">
	
	<form name="frm" method="post" action="pop_wwsProc.asp" target="popProcFrame" onsubmit="return false;">
		
		<input type="hidden" name="wrkIdx" value="<%=wrkIdx%>" />
		
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="10%" />
				<col width="*" />
				<col width="10%" />
				<col width="40%" />
			</colgroup>
			<tr>
				<th>업무구분</th>
				<td>
					<% call subCodeSelet(70, "cdWork", cdWork) %>&nbsp;
					<% call subCodeSelet(71, "cdRank", cdRank) %>&nbsp;
					<select name="wrkTyp">
						<option value="I" <% if wrkTyp = "I" then %>selected<% end if %>>발령</option>
						<option value="C" <% if wrkTyp = "C" then %>selected<% end if %>>해제</option>
					</select>
				</td>
				<th>제목</th>
				<td><input type="text" name="wrkTit" value="<%=wrkTit%>" size="40" /></td>
			</tr>
			<tr>
				<th>전송방법</th>
				<td colspan="3">
					<div style="line-height:25px;background:#efefef;border:2px solid red;padding:5px;font-size:15px;font-weight:bold;">
						<%
						dim strMethod
						for i = 0 to ubound(arrCallMethod)
							'if i <> 1 then
								strMethod = arrCallMethod(i)
								response.write	"<span><input type=""radio"" name=""clMethod"" value=""" & i & """"
								if cstr(i) = cstr(wrkMethod) then
									response.write	" checked "
								end if
								response.write	"/>"
								strMethod = replace(strMethod,"문자","<span class=""colBlue"">문자</span>")
								strMethod = replace(strMethod,"음성","<span class=""colRed"">음성</span>")
								strMethod = replace(strMethod,"(미응답자)","<span class=""colGray"">(미응답자)</span>")
								response.write	strMethod
								if i = 1 or i = 2 then
									'response.write	"<span class=""fnt11"">[문자응답불가]</span>"
								elseif i = 4 or i = 3 then
									response.write	"[문자응답가능]"
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
								<input type="hidden" name="wrkARSAnswTime" value="<%=wrkARSAnswTime%>" />
							<% else %>
								<input type="hidden" name="wrkARSAnswTime" value="<%=wrkARSAnswTime%>" />
							<% end if %>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<th>전송매체(음성)</th>
				<td colspan="3">
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
							if cInt(wrkMedia(i-1)) = cInt(ii) then
								response.write	" selected "
							end if
							response.write	">" & arrCallMedia(ii) & "</option>"
						next
						response.write	"</select> "
						response.write	"<select name=""clTry" & i & """>"
						for ii = 1 to 5
							response.write	"<option value=""" & ii & """"
							if cInt(wrkTry(i-1)) = cInt(ii) then
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
				<td colspan="3">
					문자 : <input type="text" name="wrkSndNum2" value="<%=wrkSndNum2%>" /> &nbsp;&nbsp;&nbsp;
					음성 : <input type="text" name="wrkSndNum1" value="<%=wrkSndNum1%>" />
					음성응답DTMF : 
					<select name="wrkAnswDTMF">
						<%
						for i = 0 to ubound(arrAnswDtmf)
							response.write	"<option value=""" & arrAnswDtmf(i) & """"
							if wrkAnswDTMF = arrAnswDtmf(i) then
								response.write	" selected "
							end if
							response.write	">" & arrAnswDtmfName(i) & "</option>"
						next
						%>
					</select>
				</td>
			</tr>
		</table>
		
		<div class="flexBox">
			
			<div style="width:30%">
				
				<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
					<colgroup>
						<col width="20%" />
						<col width="*" />
					</colgroup>
					<tr>
						<th>알림대상 <button class="btn btn_sm bg_purple" onclick="fnPop('pop_wwsPrevSet.asp?wrkIdx=<%=wrkIdx%>','prevSet',0,100,600,600,'N')">관리</button></th>
					</tr>
					<tr>
						<td>
							<div class="scrollBox" style="height:145px;">
								<ul class="ulListBox" id="prevList">
								</ul>
							</div>
						</td>
					</tr>
					<tr>
						<th>대상그룹 <button class="btn btn_sm bg_purple" onclick="fnPop('pop_wwsGrupSet.asp?wrkIdx=<%=wrkIdx%>','grupSet',0,100,600,600,'N')">관리</button></th>
					</tr>
					<tr>
						<td>
							<div class="scrollBox" style="height:145px;">
								<ul class="ulListBox" id="grupList">
								</ul>
							</div>
						</td>
					</tr>
				</table>
				
			</div>
			
			<div style="margin:5px 0 0 10px;">
		
				<div class="tabs">
					<ul class="tabsMenu">
						<div class="clr"></div>
					</ul>
					<div class="clr"></div>
					<div class="tabsContBox">
						
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
														><%=wrkSMSMsg%></textarea>
													</div>
												</td>
											</tr>
										</table>
									</div>
									
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
														><%=wrkVMSMsg%></textarea>
													</div>
												</td>
											</tr>
										</table>
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
					
				</div>
				
			</div>
			
		</div>
				
	</form>
		
	<div class="aC" style="margin-top:10px;">
		<% if wrkIdx > 0 then %>
			<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_red_del.png" onclick="fnDel()" />
		<% end if %>
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_blue_save.png" onclick="fnSave()" />
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	$(function(){
		
	});
	
	function fnPrevSet(proc, idx, nm ,num){
		if(proc == 'A'){
			var strRow = '<li>'
			+'<input type="hidden" name="adIdx" value="'+idx+'" />['+nm+'] <strong>'+num+'</strong> '
			+'<img class="imgBtn" src="<%=pth_pubImg%>/icons/cross.png" onclick="$(this).parent().remove()" /></li>'
			$('#prevList').append(strRow);
		}else{
			$('#prevList').find('input[name=adIdx][value='+idx+']').parent().remove();
		}
	}
	
	
	function fnDel(){
		if(confirm('삭제하시겠습니까?')){
			document.frm.proc.value = 'D';
			document.frm.submit();
		}
	}
	
	function fnSave(){
		if(document.frm.cdUserGB.value == 0){
			alert('구분을 선택하세요.');document.frm.cdUserGB.focus();return;
		}
		if(document.frm.grpCode1.value == 0){
			alert('그룹(부서)를 선택하세요.');document.frm.grpCode1.focus();return;
		}
		if(document.frm.adNM.value == ''){
			alert('이름을 입력하세요.');document.frm.adNM.focus();return;
		}
		document.frm.submit();
	}
	
</script>