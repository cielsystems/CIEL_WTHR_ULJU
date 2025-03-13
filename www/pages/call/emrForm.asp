<!--#include virtual="/common/common.asp"-->

<% mnCD = "0101" %>

<!--#include virtual="/common/header_htm.asp"-->

<%
dim clGB : clGB = "E"

'if fnDBVal("TBL_ADDR", "AD_PEREMR", "AD_IDX = " & ss_userIdx & "") <> "Y" then
'	response.write	"<script>alert('사용권한이 없습니다.');history.back();</script>"
'end if

'#	임시 대상자 및 파일 삭제
call execProc("usp_delTmpTrg",array(0, ss_userIdx, svr_remoteAddr))
call execProc("usp_delTmpFile",array(0, ss_userIdx, svr_remoteAddr))

'#	예약일시 값 설정
dim rsvDT : rsvDT = now
if minute(now) > 55 then
	rsvDT = fnDateToStr(dateAdd("h",1,now),"yyyy-mm-dd hh:00:00")
end if
dim rsvDate : rsvDate = fnDateToStr(rsvDT,"yyyy-mm-dd")
dim rsvHH : rsvHH = hour(rsvDT)
dim rsvNN : rsvNN = minute(rsvDT)
if right(rsvNN,1) > 4 then
	rsvNN = fix(left(rsvNN+5,1)) & "0"
else
	if len(rsvNN) > 1 then
		rsvNN = fix(left(rsvNN+5,1)) & "5"
	else
		rsvNN = 5
	end if
end if

'#	발신번호 : 발신번호는 개인의 발신번호를 먼저 사용한다.
dim clSndNum1 : clSndNum1 = fnIsNull(fnDBVal("NTBL_USER", "dbo.nufn_getSndNum('V', USER_INDX)", "USER_INDX = '" & ss_userIndx & "'"), dftSndNum)
dim clSndNum2 : clSndNum2 = fnIsNull(fnDBVal("NTBL_USER", "dbo.nufn_getSndNum('S', USER_INDX)", "USER_INDX = '" & ss_userIndx & "'"), dftSndNum)
dim clSndNum3 : clSndNum3 = fnIsNull(fnDBVal("NTBL_USER", "dbo.nufn_getSndNum('F', USER_INDX)", "USER_INDX = '" & ss_userIndx & "'"), dftSndNum)


dim msgIdx : msgIdx = fnIsNull(fnReq("msgIdx"),0)
'#	메시지
dim msgInfo, msgTit, SMSMsg, VMSMsg, FMSMsg, cdMsgTP1, cdMsgTP2, msgAdIdx
if msgIdx > 0 then
	msgInfo = fnDBArrVal("TBL_MSG", array("MSG_TIT","MSG_SMS","MSG_VMS","MSG_FMS","dbo.ufn_getCodeName(left(convert(varchar(10),CD_MSGTP),4))","dbo.ufn_getCodeName(CD_MSGTP)", "AD_IDX"), "MSG_IDX = " & msgIdx & "")
	msgTit = msgInfo(0)
	SMSMsg = msgInfo(1)
	VMSMsg = msgInfo(2)
	FMSMsg = msgInfo(3)
	cdMsgTP1 = msgInfo(4)
	cdMsgTP2 = msgInfo(5)
	msgAdIdx	= msgInfo(6)
end if

if msgIdx > 0 then
	
	'#	메시지파일을 임시파일로 복사
	sql = " insert into TMP_CALLFILE (CL_IDX, AD_IDX, AD_IP, TMP_GB, TMP_NO, TMP_SORT, TMP_DPNM, TMP_PATH, TMP_FILE, TMP_PAGE) "
	sql = sql & " select 0, " & ss_userIdx & ", '" & svr_remoteAddr & "', MSGF_GB, MSGF_NO, MSGF_SORT, MSGF_DPNM, MSGF_PATH, MSGF_FILE, MSGF_PAGE "
	sql = sql & " from TBL_MSGFILE with(nolock) "
	sql = sql & " where MSG_IDX = " & msgIdx & " "
	call execSql(sql)
	
end if

dim clSMSMsgAdd	: clSMSMsgAdd = "N"
dim clVMSMsgAdd	: clVMSMsgAdd	= "N"

'#	재전송
dim clIdx		: clIdx		= fnIsNull(fnReq("clIdx"), 0)
dim reProc	: reProc	= fnIsNull(fnReq("reProc"), "F")

if clIdx > 0 then
	'#	기본전송정보
	sql = " select MSG_IDX, CL_SNDNUM1, CL_SNDNUM2, CL_METHOD, CL_ARSANSWTIME, CL_MEDIA1, CL_MEDIA2, CL_MEDIA3, CL_TRY1, CL_TRY2, CL_TRY3 "
	sql = sql & " 	, CL_SMSMSG, CL_VMSMSG, CL_SMSSPLIT, CL_VMSPLAY, CL_TIT, CL_SMSMSGADD, CL_VMSMSGADD "
	sql = sql & " from TBL_CALL with(nolock) where CL_IDX = " & clIdx & " "
	cmdOpen(sql)
	set rs = cmd.execute
	cmdClose()
	if not rs.eof then
		msgIdx = rs(0)
		clSndNum1 = rs(1)
		clSndNum2 = rs(2)
		dftMethod = rs(3)
		dftARSAnswTime = rs(4)
		dftMedia = array(cInt(rs(5)), cInt(rs(6)), cInt(rs(7)))
		dftTry = array(cInt(rs(8)), cInt(rs(9)), cInt(rs(10)))
		SMSMsg = replace(rs(11), "<br>", chr(13))
		VMSMsg = replace(rs(12), "<br>", chr(13))
		dftSMSSplit = rs(13)
		dftVMSPlay = rs(14)
		msgTit = rs(15)
		clSMSMsgAdd = rs(16)
		clVMSMsgAdd = rs(17)
	end if
	rsClose()
	if msgIdx > 0 then
		if dbType = "mssql" then
			msgInfo = fnDBArrVal("TBL_MSG", array("dbo.ufn_getCodeName(left(convert(varchar(10),CD_MSGTP),4))","dbo.ufn_getCodeName(CD_MSGTP)"), "MSG_IDX = " & msgIdx & "")
		elseif dbType = "mysql" then
			msgInfo = fnDBArrVal("TBL_MSG", array("ufn_getCodeName(left(convert(CD_MSGTP, char(10)),4))","ufn_getCodeName(CD_MSGTP)"), "MSG_IDX = " & msgIdx & "")
		end if
		cdMsgTP1 = msgInfo(0)
		cdMsgTP2 = msgInfo(1)
	end if
	'#	대상자
	sql = " insert into TMP_CALLTRG (CL_IDX, AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_NUM2, TMP_NUM3, TMP_TIT, TMP_SMSMSG, TMP_VMSMSG, TMP_FMSMSG) "
	sql = sql & " select 0, " & ss_userIdx & ", '" & svr_remoteAddr & "', row_number() over (order by clt.CLT_NO), clt.CLT_SORT, clt.AD_IDX, clt.CLT_NM, ad.ADDR_NUM1, ad.ADDR_NUM2, ad.ADDR_NUM3, '', '', '', '' "
	sql = sql & " from TBL_CALLTRG as clt with(nolock) "
	sql = sql & " 	left join nViw_addrList as ad with(nolock) on (clt.AD_IDX = ad.ADDR_INDX) "
	sql = sql & " where clt.CL_IDX = " & clIdx & " "
	if reProc = "F" then
		sql = sql & " and clt.CLT_ANSWYN = 'N' "
	end if
	call execSql(sql)
	'#	첨부파일
	sql = " insert into TMP_CALLFILE (CL_IDX, AD_IDX, AD_IP, TMP_GB, TMP_NO, TMP_SORT, TMP_DPNM, TMP_PATH, TMP_FILE, TMP_PAGE) "
	sql = sql & " select 0, " & ss_userIdx & ", '" & svr_remoteAddr & "', CLF_GB, CLF_NO, CLF_SORT, CLF_DPNM, CLF_PATH, CLF_FILE, CLF_PAGE "
	sql = sql & " from TBL_CALLFILE with(nolock) "
	sql = sql & " where CL_IDX = " & clIdx & " "
	call execSql(sql)
end if

'#	임시대상자수
dim trgCnt : trgCnt = fnDBVal("TMP_CALLTRG", "count(*)", " CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' ")

SMSMsg = replace(SMSMsg, strSMSAddMsg, "")
VMSMsg = replace(VMSMsg, strVMSAddMsg, "")

dim clAnswDTMF	: clAnswDTMF	= "0"
%>

<div id="subPageBox">
	
	<form name="frm" method="post" action="callProc.asp" target="procFrame" onsubmit="return false;">
		
		<input type="hidden" name="clUpIdx" value="<%=clIdx%>" />
		<input type="hidden" name="clGB" value="<%=clGB%>" />
		<input type="hidden" name="msgIdx" value="<%=msgIdx%>" />
		
		<div class="">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<!--<input type="checkbox" id="clRetSendYN" name="clRetSendYN" value="Y" /> 미응답인원 팀장에게 통보하기-->
					</td>
					<td class="aR">
						<img class="imgBtn" src="<%=pth_pubImg%>/btn/purple_reset2.png" onclick="location.reload()" />
					</td>
				</tr>
			</table>
		</div>
		
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="18%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>업무구분</th>
				<td><%=cdMsgTP1%> > <%=cdMsgTP2%></td>
			</tr>
			<tr>
				<th>제목</th>
				<td class="bld"><input type="text" name="clTit" size="80" value="<%=msgTit%>" /></td>
			</tr>
			<tr>
				<th>전송일시</th>
				<td>
					<span><input type="radio" id="rsvYN" name="rsvYN" value="N" />즉시전송</span> 
					<span><input type="radio" id="rsvYN" name="rsvYN" value="Y" />예약전송</span>
					<span id="rsvBox">
						<input type="text" id="rsvDate" name="rsvDate" value="<%=rsvDate%>" size="10" readonly />
						<img class="calBtn" src="<%=pth_pubImg%>/icons/calendar-select.png" title="달력" />
						<select id="rsvHH" name="rsvHH">
							<% for i = 0 to 23 %>
								<option value="<%=i%>" <% if i = rsvHH then %>selected<% end if %>><%=i%></option>
							<% next %>
						</select>시
						<select id="rsvNN" name="rsvNN">
							<% for i = 0 to 59 step 1 %>
								<option value="<%=i%>" <% if i = cint(rsvNN) then %>selected<% end if %>><%=i%></option>
							<% next %>
						</select>분
					</span>
				</td>
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
				<td>
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
				<td>
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
		</table>
		
		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:10px 0 5px 0;">
			<colgroup>
				<col width="10px" />
				<col width="*" />
				<col width="160px" />
			</colgroup>
			<tr>
				<td></td>
				<td class="aR bld" id="targetMsg"></td>
				<td class="aR">
					<img id="trgSet" class="imgBtn" src="<%=pth_pubImg%>/btn/purple_targetSet.png" onclick="fnTargetSet()" />
					<img id="trgChk" class="imgBtn" src="<%=pth_pubImg%>/btn/red_targetChk.png" onclick="fnTargetChk()" />
				</td>
			</tr>
		</table>
		
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
												><%=SMSMsg%></textarea>
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
									<td class="aR"><img class="imgBtn" src="<%=pth_pubImg%>/btn/olive_call2.png" onclick="fnCallMsg()" /></td>
								</tr>
							</table>
							<div style="background:url(/images/tts_bg_light.png);width:500px;height:300px;">
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td>
											<div style="width:488px;height:265px;border:1px solid #cccccc;overflow-x:hidden;overflow-y:scroll;margin:25px 5px 10px 5px;">
												<textarea id="VMSMsg" name="VMSMsg" style="width:468px;height:250px;margin:5px;background:none;overflow:hidden;border:0;"
													onkeypress="fnChkByte('VMSMsg');" onkeydown="fnChkByte('VMSMsg');" onkeyup="fnChkByte('VMSMsg');"
												><%=VMSMsg%></textarea>
											</div>
										</td>
									</tr>
								</table>
							</div>
							<div style="margin:5px 0;padding:3px;background:#eeeeee;border:1px solid #cccccc;">
								<input type="checkbox" name="addVMSMsg" value="Y" <% if clVMSMsgAdd = "Y" then %>checked<% end if %> onclick="fnVMSMsgAdd(this)" /> 
								<input type="text" name="addVMSMsgText" size="70" />
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
		
		<div class="scdlBox" style="display:none;">
			
<%
dim scdlSDT	: scdlSDT	= fnIsNull(scdlSDT, now)
dim scdlEDT	: scdlEDT	= fnIsNull(scdlEDT, dateAdd("d", 1, now))

dim scdlSDate, scdlSHour, scdlSMint
dim scdlEDate, scdlEHour, scdlEMint

scdlSDate	= fnDateToStr(scdlSDT, "yyyy-mm-dd")
scdlSHour	= fnDateToStr(scdlSDT, "hh")
scdlSMint	= fnDateToStr(scdlSDT, "nn")

scdlEDate	= fnDateToStr(scdlEDT, "yyyy-mm-dd")
scdlEHour	= fnDateToStr(scdlEDT, "hh")
scdlEMint	= fnDateToStr(scdlEDT, "nn")
%>

			<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
				<colgroup>
					<col width="10%" />
					<col width="30%" />
					<col width="10%" />
					<col width="*" />
				</colgroup>
				<tr>
					<th>반복</th>
					<td>
						<select name="scdlType">
							<option value="">::: 선택 :::</option>
							<option value="H">시간</option>
							<option value="D">일</option>
							<option value="W">주</option>
							<option value="M">월</option>
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
				</tr>
			</table>
			
		</div>
		
		<div class="flexBox mgT10">
			
			<div style="width:50%">
				<!--
				<button class="btn btn_md bg_teal" onclick="fnScdlReg()">
					<input type="checkbox" name="scdlReg" value="Y" /> 스케줄등록
				</button>
				-->
				<button class="btn btn_md bg_purple" onclick="fnSaveMsg()">메시지저장</button>
				<% if msgAdIdx = ss_userIndx then %>
					<button class="btn btn_md bg_red" onclick="fnDelMsg()">메시지삭제</button>
				<% end if %>
			</div>
			
			<div class="aR" style="width:50%;">
				<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_blue_send.png" onclick="fnSend()" />
			</div>
			
		</div>
		
	</form>

</div>

<!--#include virtual="/common/footer_htm.asp"-->

<script>
	
	var trgCnt = <%=trgCnt%>;		// 선택된 전송 대상 수
	var nTab = 1;			// 최초 선택된 Tab 번호
	
	var smsFileCnt = 0;
	var vmsFileCnt = 0;
	var fmsFileCnt = 0;
	
	$(function(){
		
		$('input[name=rsvYN]').eq(0).prop('checked',true);	// 최초 전송옵션 선택
		$('#rsvBox').find('input').prop('disabled',true);
		$('#rsvBox').find('select').prop('disabled',true);
		<% if dftMethod <> 4 then %>
			//$('#clARSAnswTime').prop('disabled',true);
		<% end if %>
		fnRsvYN(0);
		$('input[name=rsvYN]').bind('click',function(){
			fnRsvYN($(this).val());
		});
		
		fnSelClMethod(<%=dftMethod%>);
		$('input[name=clMethod]').bind('click',function(){
			if($(this).val() == 4 || $(this).val() == 3){
				$('#clARSAnswTime').prop('disabled',false);
			}else{
				$('#clARSAnswTime').prop('disabled',true);
			}
			fnSelClMethod($(this).val());
		});
		
		$('input[name=addVMSMsg]').prop('checked',true);
		fnVMSMsgAdd($('input[name=addVMSMsg]'));
		
		fnTargetMsg();	// 최초 전송대상 메시지 출력
		
		fnSelTab();			// 최초 선택텝
		
		fnChkByte('VMSMsg');
		fnChkByte('SMSMsg');
		
		fnVMSLoadFile();
		fnSMSLoadFile();
		
		$('.imgBtn').bind('click',function(e){
			var nId = $(this).prop('id');
			posX = e.pageX+200;
			posY = e.pageY-100;
			if(nId == 'btnEmt'){
				fnOpenLayerContBox('layerEmt');
			}
		});
		
		$('#clAnswDTMF').change(function(){
			fnVMSMsgAdd('');
		});
		
		
		//	스케줄
		$('select[name=scdlType]').change(function(){
			var scdlType = $(this).val();
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
			for(var i = strSValu; i < strEValu; i++){
				if(scdlType == 'W'){
					var strRow = '<option value="'+i+'">'+arrWeek[i]+strValu+'</option>';
				}else{
					var strRow = '<option value="'+i+'">'+i+strValu+'</option>';
				}
				$('select[name=scdlValu]').append(strRow);
			}
		});
		
	});
	
	function fnSelClMethod(m){
		if(m == 4 || m == 3){
			$('#clARSAnswTime').prop('disabled',false);
		}else{
			$('#clARSAnswTime').prop('disabled',true);
		}
		if(m == 0){					// 음성만
		}else if(m == 1){		// 문자만
		}else if(m == 2){		// 음성+문자
		}else if(m == 3){		// 음성후문자
		}else if(m == 4){		// 문자후음성
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
	
	function fnChkByte(trg){
		var h = 250;
		if(trg == 'SMSMsg'){
			$('#smsByte').html(fnByte($('#SMSMsg').val()));
			var splitNo = fnSplit($('#SMSMsg').val());
			if(fnByte($('#SMSMsg').val()) > 2000){
				alert('문자는 최대 2000bytes까지 가능합니다.');
			}
			if(fnByte($('#SMSMsg').val()) > 90 || smsFileCnt > 0 || splitNo > 2){
				$('input[name=splitYN]').prop('checked',false);
				$('input[name=splitYN]').prop('disabled',true);
				if(smsFileCnt > 0){
					$('#SMSMsgTypeIcon').prop('src','<%=pth_pubImg%>/phn_btn_mms_on.png');
				}else{
					$('#SMSMsgTypeIcon').prop('src','<%=pth_pubImg%>/phn_btn_lms_on.png');
				}
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
	
	function fnRsvYN(n){		// 전송옵션 : 예약여부
		if(n == 'N'){
			$('#rsvBox').find('input').prop('disabled',true);
			$('#rsvBox').find('select').prop('disabled',true);
		}else if(n == 'Y'){
			$('#rsvBox').find('input').prop('disabled',false);
			$('#rsvBox').find('select').prop('disabled',false);
		}
	}
	
	function fnTargetMsg(){	// 전송대상 메시지 출력
		var msg = '<span class="colRed">전송 대상을 선택해 주세요.</span>';
		if(trgCnt > 0){
			msg = '<span class="colBlue fnt14">'+trgCnt+'</span> 명의 전송대상이 선택 되었습니다.';
		}
		$('#targetMsg').html(msg);
	}
	
	function fnTargetSet(){	// 전송대상설정 Popup Open
		layerW = 1300;
		layerH = 680;
		var url = '/pages/setTrg/pop_trgDetail.asp?clGB=<%=clGB%>';
		fnOpenLayer('전송대상설정',url);
	}
	
	function fnTargetChk(){	// 전송대상확인 Popup Open 
		layerW = 1000;
		layerH = 680;
		var url = '/pages/setTrg/pop_trgList.asp?clGB=<%=clGB%>';
		fnOpenLayer('전송대상확인',url);
	}
	
	function fnTabMenu(no){
		nTab = no;
		fnSelTab();
	}
	
	function fnSelTab(){
		$('.tabs .tabsMenu li').removeClass('on');
		$('.tabs .tabsContBox .tabsCont').css('display','none');
		$('.tabs .tabsMenu #tabsMenu_'+nTab).addClass('on');
		$('.tabs .tabsContBox #tabs-'+nTab).css('display','block');
		$('.tabs .tabsMenu li input[name=snd'+nTab+']').prop('checked',true);
	}
	
	//	문자전송	================================================================
	function fnSMSAddEmt(val){		// 이모티콘 입력
		var nSMSMsg = $('#SMSMsg').val();
		$('#SMSMsg').val(nSMSMsg+val);
		fnChkByte('SMSMsg');
	}
	function fnSMSAddFileOpen(){		// 첨부파일 업로드 레이어 오픈
		layerW = 600;
		layerH = 300;
		var url = 'pop_fileUpForm.asp?proc=sms';
		fnOpenLayer('파일업로드',url);
	}
	function fnSMSLoadFile(){				// 첨부파일 로드
		var param = 'proc=TmpFile&param=0]|[<%=ss_userIdx%>]|[<%=svr_remoteAddr%>]|[S&page=1&pageSize=999';
		param = encodeURI(param);
		var list = fnGetHttp('/pages/public/ajxList.asp?'+param);
		var arrList = list.split('}|{');
		smsFileCnt = arrList[0];
		$('#smsFileView').html('');
		$('#smsFileList tr').remove();
		if(smsFileCnt > 0 ){
			var arrVal, strRowView, strRowList;
			for(i = 2; i < arrList.length; i++){
				arrVal = arrList[i].split(']|[');
				// TMP_NO(1), TMP_DPNM(2), TMP_PATH(3), TMP_FILE(4), TMP_PAGE(5)
				strRowView = '<div id="smsImg_'+arrVal[1]+'"><img src="/data/'+arrVal[3]+'/'+arrVal[4]+'" /><div class="aR"><img class="imgBtn" src="<%=pth_pubImg%>/icons/smsImgDel.png" onclick="fnSMSDelFile('+arrVal[1]+')" /></div></div>';
				$('#smsFileView').append(strRowView);
			}
		}
		fnChkByte('SMSMsg');
	}
	function fnSMSDelFile(no){			// 첨부파일 삭제
		procFrame.location.href = 'tmpFileDel.asp?proc=sms&no='+no;
	}
	function fnSetSMSMsg(str){
		document.frm.SMSMsg.value = str;
		fnChkByte('SMSMsg');
	}
	//	문자전송	================================================================
	
	//	음성전송	================================================================
	function fnVMSAddFileOpen(){		// 첨부파일 업로드 레이어 오픈
		layerW = 600;
		layerH = 300;
		var url = 'pop_fileUpForm.asp?proc=vms';
		fnOpenLayer('파일업로드',url);
	}
	function fnVMSLoadFile(){				// 첨부파일 로드
		var param = 'proc=TmpFile&param=0]|[<%=ss_userIdx%>]|[<%=svr_remoteAddr%>]|[V&page=1&pageSize=999';
		param = encodeURI(param);
		var list = fnGetHttp('/pages/public/ajxList.asp?'+param);
		var arrList = list.split('}|{');
		vmsFileCnt = arrList[0];
		$('#vmsFileList tr').remove();
		if(vmsFileCnt > 0){
			var arrVal, strRowList;
			for(i = 2; i < arrList.length; i++){
				arrVal = arrList[i].split(']|[');
				// TMP_NO(1), TMP_DPNM(2), TMP_PATH(3), TMP_FILE(4), TMP_PAGE(5)
				strRowList = '<tr>'
				+'<td style="background:#ffffff;padding:3px 5px;"><img src="<%=pth_pubImg%>/icons/speaker-volume.png" /> '+arrVal[2]+' <img class="imgBtn" src="<%=pth_pubImg%>/icons/cross.png" onclick="fnVMSDelFile('+arrVal[1]+')" /></td>'
				+'</tr>';
				$('#vmsFileList').append(strRowList);
			}
			$('#VMSMsg').val('');
		}
	}
	function fnVMSDelFile(no){			// 첨부파일 삭제
		procFrame.location.href = 'tmpFileDel.asp?proc=vms&no='+no;
	}
	function fnVMSPreLit(){		// TTS미리듣기
		if(document.frm.VMSMsg.value == ''){
			alert('내용을 입력해 주세요.');document.frm.VMSMsg.focus();return;
		}
		document.frm.target = 'procFrame';
		document.frm.action = '/pages/public/ttsCreate.asp?proc=prev';
		document.frm.submit();
	}
	function fnSetVMSMsg(str){
		document.frm.VMSMsg.value = str;
		fnChkByte('VMSMsg');
	}
	//	음성전송	================================================================
	
	function fnCallMsg(){
		fnPop('/pages/public/pop_getMesg.asp', 'mesgList', 0, 0, 800, 600, 'N');
		/*
		layerW = 800;
		layerH = 520;
		var url = 'pop_callMsgList.asp';
		fnOpenLayer('메시지불러오기',url);
		document.frm.target = 'layerFrame';
		document.frm.action = 'pop_callMsgList.asp';
		document.frm.submit();
		*/
	}
	
	function fnGetMesg(tit, sms, vms){
		document.frm.clTit.value = tit;
		document.frm.SMSMsg.value = sms;
		fnChkByte('SMSMsg');
		document.frm.VMSMsg.value = vms;
		fnChkByte('VMSMsg');
	}
	
	function fnSend(){
		var rsvYN = $('input[name=rsvYN]:checked').val();
		var rsvDate = $('input[name=rsvDate]').val();
		var rsvHH = $('select[name=rsvHH]').val();
		var rsvNN = $('select[name=rsvNN]').val();
		if(rsvYN == 'Y'){
			if(rsvDate > '<%=fnDateToStr(dateadd("d",-1,dateadd("m",3,now)),"yyyy-mm-dd")%>'){
				alert('예약은 3개월 이전까지만 가능합니다.');return false;
			}
		}
		var url = 'ajxChkNowCall.asp?rsvYN='+rsvYN+'&rsvDate='+rsvDate+'&rsvHH='+rsvHH+'&rsvNN='+rsvNN;
		var msg = fnGetHttp(url);
		if(msg.length > 1){
			if(confirm(msg + '\n계속 진행하시겠습니까?')){
				fnRSend();
			}
		}else{
			fnRSend();
		}
	}
	
	function fnRSend(){
		var clMethod = '';
		$('input[name=clMethod]').each(function(){
			if($(this).prop('checked') == true){
				clMethod = $(this).val();
			}
		});
		if(clMethod == ''){
			alert('전송방법을 선택하세요.');return false;
		}else{
			if(clMethod != '1'){
				if($('#VMSMsg').val() == '' && vmsFileCnt == 0){
					alert('음성전송 내용을 입력하세요.');return false;
				}
				if($('input[name=clSndNum1]').value == ''){
					alert('음성발신번호를 입력해 주세요.');$('input[name=clSndNum1]').focus();return false;
				}
				if($('input[name=clSndNum1]').val().length > 12){
					alert('발신번호는 12자리까지 입력가능합니다.');$('input[name=clSndNum1]').focus();return false;
				}
			}
			if(clMethod != '0'){
				if($('#SMSMsg').val() == ''){
					alert('문자전송 내용을 입력하세요.');return false;
				}
				if(fnByte($('#SMSMsg').val()) > 2000){
					alert('문자는 최대 2000bytes까지 가능합니다.');return false;
				}
				if($('input[name=clSndNum2]').value == ''){
					alert('문자발신번호를 입력해 주세요.');$('input[name=clSndNum2]').focus();return false;
				}
				if($('input[name=clSndNum2]').val().length > 12){
					alert('발신번호는 12자리까지 입력가능합니다.');$('input[name=clSndNum2]').focus();return false;
				}
			}
		}
		if(fnNumberCheck($('input[name=clARSAnswTime]').val()) == true){
			if(parseInt($('input[name=clARSAnswTime]').val()) < 0 || parseInt($('input[name=clARSAnswTime]').val()) > 600){
				alert('응답대기시간은 1분에서 600분까지만 설정 가능합니다.');$('input[name=clARSAnswTime]').focus();return false;
			}
		}else{
			alert('응답대기시간은 숫자만 입력해 주세요.');$('input[name=clARSAnswTime]').focus();return false;
		}
		if(trgCnt == 0){
			alert('전송 대상을 선택하세요.');return false;
		}
		layerW = 900;
		layerH = 700;
		var url = 'pop_callConfirm.asp';
		fnOpenLayer('전송전확인',url);
		document.frm.target = 'layerFrame';
		document.frm.action = 'pop_callConfirm.asp';
		document.frm.submit();
	}
	
	function fnLoadTrg(){
	}
	
	function fnScdlReg(){
		if($('input[name=scdlReg]').prop('checked') == false){
			$('input[name=scdlReg]').prop('checked', true);
			$('.scdlBox').css('display','block');
		}else{
			$('input[name=scdlReg]').prop('checked', false);
			$('.scdlBox').css('display','none');
		}
	}
	
	function fnSaveMsg(){
		document.frm.target = 'procFrame';
		document.frm.action = 'pop_saveMsg.asp?msgGB=E';
		document.frm.submit();
	}
	
	function fnDelMsg(){
		if(confirm('메시지를 삭제하시겠습니까?')){
			procFrame.location.href = 'pop_delMsg.asp?msgIdx=<%=msgIdx%>';
		}
	}
	
</script>