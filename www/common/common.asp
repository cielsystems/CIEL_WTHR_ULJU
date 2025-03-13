<% @language="vbscript" codepage="65001" %>

<%
option explicit
%>

<%
session.codePage = 65001
response.chaRset = "utf-8"
response.expires = 0
response.expiresabsolute = now() - 1
response.addHeader "Pragma","no-cache"
response.addHeader "Expires","0"
response.cacheControl = "no-cache"
%>

<!--#include file="config.asp"-->
<!--#include file="function.asp"-->
<!--#include file="setProc.asp"-->

<%
'#	이모티콘
dim arrEmt : arrEmt = array("※","☆","★","○","●","◎","◇","◆","□","■","△","▲","▽","▼","◁","◀","▷","▶"_
,"♤","♠","♡","♥","♧","♣","⊙","◈","▣","◐","◑","▒","▤","▥","▨","▧","▦","▩","♨","☏","☎","☜","☞"_
,"¶","†","‡","↕","↗","↙","↖","↘","♭","♩","♪","♬","㉿","㈜","№","㏇","™","㏂","㏘","℡","€","®")
						
'#	================================================================================================
'#	Get Setting Values : Start
dim dftMethod : dftMethod = 4
dim dftARSAnswTime : dftARSAnswTime = 10
dim dftMedia : dftMedia = array(1,0,0)
dim dftTry : dftTry = array(1,0,0)
dim dftSMSSplit : dftSMSSplit = "Y"
dim dftVMSPlay : dftVMSPlay = 2
dim dftSndNum

dftMethod				= fnDBVal("TBL_SET","SET_VAL","SET_NO=2001")
dftARSAnswTime	= fnDBVal("TBL_SET","SET_VAL","SET_NO=2002")
dftMedia(0)			= fnDBVal("TBL_SET","SET_VAL","SET_NO=2003")
dftMedia(1)			= fnDBVal("TBL_SET","SET_VAL","SET_NO=2004")
dftMedia(2)			= fnDBVal("TBL_SET","SET_VAL","SET_NO=2005")
dftTry(0)				= fnDBVal("TBL_SET","SET_VAL","SET_NO=2006")
dftTry(1)				= fnDBVal("TBL_SET","SET_VAL","SET_NO=2007")
dftTry(2)				= fnDBVal("TBL_SET","SET_VAL","SET_NO=2008")
dftSMSSplit			= 0
dftVMSPlay			= fnDBVal("TBL_SET","SET_VAL","SET_NO=4005")

dftSndNum				= fnIsNull(fnDBVal("NTBL_USER","USER_DFLT_NUM","USER_INDX = " & ss_userIndx & ""),fnDBVal("TBL_SET","SET_VAL","SET_NO=2010"))
dim dftSndNumAll : dftSndNumAll				= fnDBVal("TBL_SET","SET_VAL","SET_NO=2010")

dftTTSFormat  = fnDBVal("TBL_SET","SET_VAL","SET_NO=4001")
dftTTSPitch  	= fnDBVal("TBL_SET","SET_VAL","SET_NO=4002")
dftTTSSpeed  	= fnDBVal("TBL_SET","SET_VAL","SET_NO=4003")
dftTTSVolume  = fnDBVal("TBL_SET","SET_VAL","SET_NO=4004")

sql = " select distinct(SYS_GB) from TBL_SYSTEM with(nolock) where SYS_DT > dateAdd(second, -100, getdate()) "
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
if not rs.eof then
	arrRs = rs.getRows
	arrRc2 = ubound(arrRs,2)
else
	arrRc2 = -1
end if
rsClose()

dim arrDftSvr	: arrDftSvr	= array(1,2)
dim arrSvr : redim arrSvr(arrRc2)

if arrRc2 > -1 then
	for i = 0 to arrRc2
		'response.write	"<div>arrSvr(" & i & ") = " & arrRs(0,i) & "</div>"
		arrSvr(i)	= arrRs(0,i)
	next
else
	redim arrSvr(0)
	arrSvr(0)	= 1
end if


'#	Get Setting Values : End
'#	================================================================================================

sub subMsgForm(intMsgGB)

	if intMsgGB = 0 then
		%>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="250px" />
				<col width="20px" />
				<col width="*" />
			</colgroup>
			<tr>
				<td valign="top">
					<div style="margin:0 0 5px;"><img id="SMSMsgTypeIcon" src="<%=pth_pubImg%>/phn_btn_sms_on.png" /></div>
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
					<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
						<tr>
							<td>
								
								<% if mnCD <> "0106" then %>
									<img class="imgBtn" src="<%=pth_pubImg%>/btn/olive_call2.png" onclick="fnCallMsg()" />
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
				<td></td>
				<td valign="top">
					<h3>이모티콘</h3>
					<div style="margin-bottom:20px;">
						<table border="0" cellpadding="0" cellspacing="1" style="background:#cccccc;">
							<tr>
								<%
								for j = 0 to ubound(arrEmt)
									response.write	"<td style=""background:#ffffff;width:25px;height:25px;text-align:center;cursor:pointer;"" onclick=""fnSMSAddEmt('" & arrEmt(j) & "')"">" & arrEmt(j) & "</td>" & vbCrLf
									if j < ubound(arrEmt) then
										if j mod 21 = 20 then
											response.write	"</tr><tr>" & vbCrLf
										end if
									end if
								next
								%>
							</tr>
						</table>
					</div>
					<% if smsFileUP = "Y" then %>
						<h3>파일첨부</h3>
						<% call infoBox("sms") %>
						<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:10px 0 0;">
							<colgroup>
								<col width="*" />
								<col width="100px" />
							</colgroup>
							<tr>
								<td>
									<table width="100%" border="0" cellpadding="0" cellspacing="1" id="smsFileList" style="background:#cccccc;">
									</table>
								</td>
								<td class="aR">
									<img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_upload.png" onclick="fnSMSAddFileOpen()" />
								</td>
							</tr>
						</table>
					<% end if %>
				</td>
			</tr>
		</table>
		<%
	elseif intMsgGB = 1 then
		%>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="500px" />
				<col width="20px" />
				<col width="*" />
			</colgroup>
			<tr>
				<td valign="top">
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
					<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:5px 0 10px;">
						<tr>
							<td>
								
								<% if mnCD <> "0106" then %>
									<img class="imgBtn" src="<%=pth_pubImg%>/btn/olive_call2.png" onclick="fnCallMsg()" />
								<% end if %>
								
							</td>
							<td class="aR"><span id="vmsByte" class="bld">0</span> Byte</td>
						</tr>
					</table>
				</td>
				<td></td>
				<td valign="top">
					<!--
					<h3>TTS설정</h3>
					<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
						<colgroup>
							<col width="30%" />
							<col width="*" />
						</colgroup>
						<tr>
							<th>Pitch</th>
							<td><select name="TTS_pitch">
								<% for j = 0 to ubound(arrTTSPitch) %>
									<option value="<%=arrTTSPitch(j)%>" <% if cstr(arrTTSPitch(j)) = cstr(dftTTSPitch) then %>selected<% end if %>><%=arrTTSPitch(j)%></option>
								<% next %>
							</select></td>
						</tr>
						<tr>
							<th>Speed</th>
							<td><select name="TTS_speed">
								<% for j = 0 to ubound(arrTTSSpeed) %>
									<option value="<%=arrTTSSpeed(j)%>" <% if cstr(arrTTSSpeed(j)) = cstr(dftTTSSpeed) then %>selected<% end if %>><%=arrTTSSpeed(j)%></option>
								<% next %>
							</select></td>
						</tr>
						<tr>
							<th>Volume</th>
							<td><select name="TTS_volume">
								<% for j = 0 to ubound(arrTTSVolume) %>
									<option value="<%=arrTTSVolume(j)%>" <% if cstr(arrTTSVolume(j)) = cstr(dftTTSVolume) then %>selected<% end if %>><%=arrTTSVolume(j)%></option>
								<% next %>
							</select></td>
						</tr>
						<tr>
							<th>Format</th>
							<td><select name="TTS_sformat">
								<% for j = 0 to ubound(arrTTSFormat) %>
									<option value="<%=arrTTSFormat(j)%>" <% if cstr(arrTTSFormat(j)) = cstr(dftTTSFormat) then %>selected<% end if %>><%=arrTTSFormatNm(j)%></option>
								<% next %>
							</select></td>
						</tr>
						<tr>
							<th>Play</th>
							<td><select name="TTS_play">
								<% for j = 1 to 5 %>
									<option value="<%=j%>" <% if cstr(j) = cstr(dftVMSPlay) then %>selected<% end if %>><%=j%>회</option>
								<% next %>
							</select></td>
						</tr>
					</table>
					<div class="aR" style="margin:5px 0;">
						<img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_reset.png" onclick="fnVMSReset()" />
						<img class="imgBtn" src="<%=pth_pubImg%>/btn/green_prevLit.png" onclick="fnVMSPreLit()" />
						<script>
							function fnVMSReset(){		// TTS설정 리셋
								document.frm.TTS_pitch.value = '<%=dftTTSPitch%>';
								document.frm.TTS_speed.value = '<%=dftTTSSpeed%>';
								document.frm.TTS_volume.value = '<%=dftTTSVolume%>';
								document.frm.TTS_sformat.value = '<%=dftTTSFormat%>';
							}
						</script>
					</div>
					-->
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<% if vmsFileUP = "Y" then %>
						<div style="border-top:1px solid #999999;margin:5px 0 10px 0;"></div>
						<h3>음성파일 업로드</h3>
						<% call infoBox("vms") %>
						<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:10px 0 20px;">
							<colgroup>
								<col width="*" />
								<col width="100px" />
							</colgroup>
							<tr>
								<td>
									<table width="100%" border="0" cellpadding="0" cellspacing="1" id="vmsFileList" style="background:#cccccc;">
									</table>
								</td>
								<td class="aR">
									<img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_upload.png" onclick="fnVMSAddFileOpen()" />
								</td>
							</tr>
						</table>
					<% end if %>
				</td>
			</tr>
		</table>
		<%
	elseif intMsgGB = 2 then
		%>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<div class="formBox">
						<table border="0" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="115px" />
								<col width="*" />
								<col width="115px" />
							</colgroup>
							<tr>
								<th rowspan="2">첨부파일<div id="addFileCnt">(0건)</div></th>
								<td rowspan="2" class="midNode">
									<div id="addFileList">
									</div>
								</td>
								<td class="midNodeL" valign="top">
									<img class="imgBtn" src="<%=pth_pubImg%>/btn/blue_fileup2.png" alt="파일업로드" onclick="fnFMSAddFileOpen()" />
								</td>
							</tr>
							<tr>
								<td valign="bottom">
									<img class="imgBtn" src="<%=pth_pubImg%>/icons/navigation-button-up.png" onclick="fnFileMove('up')" title="위로" />
									<img class="imgBtn" src="<%=pth_pubImg%>/icons/navigation-button-dn.png" onclick="fnFileMove('dn')" title="아래로" />
								</td>
							</tr>
						</table>
					</div>
					
				</td>
			</tr>
		</table>
		<%
	end if
	
end sub

sub infoBox(strGB)
	select case strGB
		case "sms", "SMSMsg"
			%>
			<div style="background:#eeeeee;border:1px solid #cccccc;padding:10px;margin:10px 0;">
				<dl class="noticeMsgList">
					<dt>MMS 첨부파일 안내</dt>
					<dd>MMS 첨부파일은 <span>JPG이미지</span>만 가능합니다.</dd>
					<dd>JPG이미지의 규격은 해상도 : <span>220x184</span>, 파일크기 : <span>20kByte</span>이하로 총 <span>3장까지</span> 가능합니다.</dd>
					<dd>이미지의 해상도는 변경이 가능하나 특정폰에서 표시하지 못하는 경우가 있습니다.('콘텐츠에 오류가 있음'으로 표기)</dd>
					<dd>각 통신사별, 수신폰의 지원여부에 따라 3장의 이미지가 모두 전송되지 않을 수도 있습니다.</dd>
				</dl>
			</div>
			<%
		case "vms", "VMSMsg"
			%>
			<div style="background:#eeeeee;border:1px solid #cccccc;padding:10px;margin:10px 0;">
				<dl class="noticeMsgList">
					<dt>음성파일 업로드 파일 규격</dt>
					<dd>웨이브 파일 (*.<span>wav</span>) : <b>PCM, CCITT A-Law & Mu-Law, GSM 6.10, MS ADPCM, IMA ADPCM</b></dd>
					<dd>크로샷 음성파일 (*.<span>pcm</span>, *.<span>vox</span>) : <b>64kbps, 8KHz, mono CCITT A-Law</b></dd>
					<dd><span>지정된 파일규격이 아닐경우 정상적으로 재생이 되지 않습니다.</span></dd>
					<dd>업로드한 음성 파일은 <span>웹상에서 재생이 불가능</span> 하므로 미리들을수 없습니다.</dd>
					<dd>음성파일을 업로드 하시면 <span>TTS에 내용이 있어도 무시되고 음성파일만 재생</span>됩니다.</dd>
				</dl>
			</div>
			<%
		case "fms", "FMSMsg"
			%>
			<div style="background:#eeeeee;border:1px solid #cccccc;padding:10px;margin:10px 0;">
				<dl class="noticeMsgList">
					<dt>팩스전송 첨부파일 안내</dt>
					<dd>사용자PC에 저장된 문서 또는 이미지 파일만 전송 가능합니다.</dd>
					<dd>지원 파일 형식 : 아래한글, 워드, 엑셀, 파워포인트, PDF, TXT, BMP, JPG, GIF</dd>
					<dd>문서에 <span></span>암호가 설정된 경우, 압축파일</span>등은 전송이 불가능 합니다.</dd>
					<dd>엑셀 문서는 포함된 모든 시트가 전송 됩니다.</dd>
				</dl>
				<dl class="noticeMsgList" style="margin-top:10px;padding-top:10px;border-top:1px solid #999999;;">
					<dt>페이지지정 안내</dt>
					<dd>여러 페이지의 문서 중 페이지를 지정해서 전송할 수 있습니다.</dd>
					<dd><span>2,3</span> 또는 <span>1~3,5,9</span> 와 같은 방식으로 페이지를 지정합니다.</dd>
					<dd>입력하지않으면 문서 전체를 전송합니다</dd>
				</dl>
			</div>
			<%
		case "trgXls"
			%>			
			<div style="background:#eeeeee;border:1px solid #cccccc;padding:10px;margin:10px 0;">
				<dl class="noticeMsgList">
					<dt>주의사항</dt>
					<dd>예시와 같이 파일 양식에 따라 목록을 작성하신 후 <span>다른이름으로 저장</span>을 선택하여 엑셀파일 형식<span>(.xls, .xlsx)</span>으로 저장하여 업로드 해주세요.</dd>
					<dd>양식파일의 모든 필드는 <span>텍스트</span> 형식으로 변경해야 합니다.(셀서식 -> 표시형식 텝 "텍스트")</dd>
					<dd>각 번호는 <span>숫자와 하이픈(-)</span>만 사용할 수 있습니다.(이외의 문자가 들어간 경우 오류가 발생할 수 있습니다.)</dd>
					<dd>전송할 목록은 Sheet1에만 작성해 주세요.</dd>
					<dd>대상자는 <span>한번에 1,000건</span> 까지만 업로드할 수 있습니다. 1,000건 이상의 데이터는 <span>분할</span>해서 업로드 해주세요.</dd>
				</dl>
			</div>
			<%
		case "trgInpAdd"
			%>			
			<div style="background:#eeeeee;border:1px solid #cccccc;padding:10px;margin:10px 0;">
				<dl class="noticeMsgList">
					<dt>주의사항</dt>
					<dd>전송할 번호는 필수사항 입니다.</dd>
					<dd>번호는 숫자와 하이픈, 공백만 입력해 주시기 바랍니다.</dd>
				</dl>
			</div>
			<%
	end select
end sub
%>