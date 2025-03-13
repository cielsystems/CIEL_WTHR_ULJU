<!--#include virtual="/common/common.asp"-->

<%
mnCD = "1003"

sql = " select SET_NO, SET_VAL "
sql = sql & " from TBL_SET with(nolock) "
sql = sql & " where SET_NO < 9990 "
sql = sql & " order by SET_NO asc "
arrRs = execSqlRs(sql)
%>

<!--#include virtual="/common/header_adm.asp"-->

<style>
	h3 {margin-top:10px;}
</style>

<div id="subPageBox">
	
	<form name="frm" method="post" action="settingProc.asp" target="procFrame">
		
		<h3>서버</h3>
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="18%" />
				<col width="*" />
				<col width="18%" />
				<col width="32%" />
			</colgroup>
			<tr>
				<th>Web ServerIP</th>
				<td><input type="text" name="no1" value="<%=arrRs(1,0)%>" readonly class="read" /></td>
				<th>Web Server Port</th>
				<td><input type="text" name="no2" value="<%=arrRs(1,1)%>" readonly class="read" /></td>
			</tr>
			<tr>
				<th>DB ServerIP</th>
				<td><input type="text" name="no3" value="<%=arrRs(1,2)%>" readonly class="read" /></td>
				<th>DB Server Port</th>
				<td><input type="text" name="no4" value="<%=arrRs(1,3)%>" readonly class="read" /></td>
			</tr>
			<!--<tr>
				<th>문자 ServerIP</th>
				<td><input type="text" name="no5" value="<%=arrRs(1,4)%>" readonly class="read" /></td>
				<th>문자 Server Port</th>
				<td><input type="text" name="no6" value="<%=arrRs(1,5)%>" readonly class="read" /></td>
			</tr>
			<tr>
				<th>음성 ServerIP</th>
				<td><input type="text" name="no7" value="<%=arrRs(1,6)%>" readonly class="read" /></td>
				<th>음성 Server Port</th>
				<td><input type="text" name="no8" value="<%=arrRs(1,7)%>" readonly class="read" /></td>
			</tr>
			<tr>
				<th>팩스 ServerIP</th>
				<td><input type="text" name="no9" value="<%=arrRs(1,8)%>" readonly class="read" /></td>
				<th>팩스 Server Port</th>
				<td><input type="text" name="no10" value="<%=arrRs(1,9)%>" readonly class="read" /></td>
			</tr>
			<tr>
				<th>TTS ServerIP</th>
				<td><input type="text" name="no11" value="<%=arrRs(1,10)%>" readonly class="read" /></td>
				<th>TTS Server Port</th>
				<td><input type="text" name="no12" value="<%=arrRs(1,11)%>" readonly class="read" /></td>
			</tr>
			-->
			<% for i = 4 to 11 %>
				<input type="hidden" name="no<%=i+1%>" value="<%=arrRs(1,i)%>" />
			<% next %>
		</table>
		
		<h3>동보</h3>
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="18%" />
				<col width="*" />
				<col width="18%" />
				<col width="32%" />
			</colgroup>
			<tr>
				<th>기본전송방법</th>
				<td>
					<select name="no13"><!--	2001 -->
						<% for i = 0 to ubound(arrCallMethod) %>
							<option value="<%=i%>" <% if cInt(arrRs(1,12)) = i then %>selected<% end if %>><%=arrCallMethod(i)%></option>
						<% next %>
					</select>
				</td>
				<th>응답대기시간</th>
				<td>
					<select name="no14"><!--	2002 -->
						<option value="1">1분</option>
						<%
						for i = 0 to 60 step 5
							if i > 0 then
								response.write	"<option value=""" & i & """"
								if cint(i) = cint(arrRs(1,13)) then
									response.write	" selected "
								end if
								response.write	">" & i & "분</option>"
							end if
						next
						%>
					</select>
				</td>
			</tr>
			<tr>
				<th>전송매체</th>
				<td colspan="3">
					<% for i = 1 to 3 %>
						<%=i%>차 : 
						<select name="no<%=14+i%>">
							<option value="0">없음</option>
							<% for ii = 1 to ubound(arrCallMedia) %>
								<option value="<%=ii%>" <% if cInt(arrRs(1,13+i)) = ii then %>selected<% end if %>><%=arrCallMedia(ii)%></option>
							<% next %>
						</select>
						<select name="no<%=17+i%>">
							<% for ii = 1 to 5 %>
								<option value="<%=ii%>" <% if cInt(arrRs(1,16+i)) = ii then %>selected<% end if %>><%=ii%>회</option>
							<% next %>
						</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<% next %>
				</td>
			</tr>
			<tr>
				<!--<th>기본발신번호</th>
				<td><input type="text" name="no21" value="<%=arrRs(1,20)%>" /></td>-->
				<input type="hidden" name="no21" value="<%=arrRs(1,20)%>" />
				<th>문자발신번호</th>
				<td><input type="text" name="no22" value="<%=arrRs(1,21)%>" /></td>
			<!--</tr>
			<tr>-->
				<th>음성발신번호</th>
				<td><input type="text" name="no23" value="<%=arrRs(1,22)%>" /></td>
				<!--<th>팩스발신번호</th>
				<td><input type="text" name="no24" value="<%=arrRs(1,23)%>" /></td>-->
				<input type="hidden" name="no24" value="<%=arrRs(1,23)%>" />
			</tr>
		</table>
		
		<h3>문자</h3>
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="18%" />
				<col width="*" />
				<col width="22%" />
				<col width="22%" />
				<col width="22%" />
			</colgroup>
			<tr>
				<th colspan="2">구분</th>
				<th>SMS</th>
				<th>LMS</th>
				<th>MMS</th>
			</tr>
			<%
			dim arrUserGB : arrUserGB = array("","전체관리자","부서관리자","일반사용자")
			dim arrLimitGB : arrLimitGB = array("S","L","M")
			dim no
			for i = 1 to ubound(arrUserGB)
				if i = 1 then
					response.write	"<tr>" & vbcrlf
					response.write	"	<th rowspan=""3"">사용자별 문자전송제한</th>" & vbcrlf
				else
					response.write	"<tr>" & vbcrlf
				end if
				'if i = 2 then
				'	response.write	""
				'else
					response.write	"	<th>" & arrUserGB(i) & "</th>" & vbcrlf
				'end if
				for ii = 0 to ubound(arrLimitGB)
					no = 23 + (ii+(2*(i-1))) + i
					'if i = 2 or ii = 2 then
					'	response.write	"<input type=""hidden"" class=""aR"" name=""no" & no+1 & """ value=""" & arrRs(1,no) & """ size=""10"" />"
					'else
						response.write	"<td class=""aC""><input type=""text"" class=""aR"" name=""no" & no+1 & """ value=""" & arrRs(1,no) & """ size=""10"" /></td>" & vbcrlf
					'end if
				next
				response.write	"</tr>" & vbcrlf
			next
			%>
		</table>
		
		<h3>음성</h3>
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="18%" />
				<col width="*" />
				<col width="18%" />
				<col width="32%" />
			</colgroup>
			<!--
			<tr>
				<th>기본 Format</th>
				<td>
					<select name="no34">
						<% for j = 0 to ubound(arrTTSFormat) %>
							<option value="<%=arrTTSFormat(j)%>" <% if cStr(arrTTSFormat(j)) = cStr(arrRs(1,33)) then %>selected<% end if %>><%=arrTTSFormatNm(j)%></option>
						<% next %>
					</select>
				</td>
				<th>기본 Pitch</th>
				<td>
					<select name="no35">
						<% for j = 0 to ubound(arrTTSPitch) %>
							<option value="<%=arrTTSPitch(j)%>" <% if cStr(arrTTSPitch(j)) = cStr(arrRs(1,34)) then %>selected<% end if %>><%=arrTTSPitch(j)%></option>
						<% next %>
					</select>
				</td>
			</tr>
			<tr>
				<th>기본 Speed</th>
				<td>
					<select name="no36">
						<% for j = 0 to ubound(arrTTSSpeed) %>
							<option value="<%=arrTTSSpeed(j)%>" <% if cStr(arrTTSSpeed(j)) = cStr(arrRs(1,35)) then %>selected<% end if %>><%=arrTTSSpeed(j)%></option>
						<% next %>
					</select>
				</td>
				<th>기본 Volume</th>
				<td>
					<select name="no37">
						<% for j = 0 to ubound(arrTTSVolume) %>
							<option value="<%=arrTTSVolume(j)%>" <% if cStr(arrTTSVolume(j)) = cStr(arrRs(1,36)) then %>selected<% end if %>><%=arrTTSVolume(j)%></option>
						<% next %>
					</select>
				</td>
			</tr>
			-->
			<% for i = 33 to 36 %>
				<input type="hidden" name="no<%=i+1%>" value="<%=arrRs(1,i)%>" />
			<% next %>
			<tr>
				<th>멘트재생횟수</th>
				<td colspan="3">
					<select name="no38">
						<option value="1" <% if arrRs(1,37) = "1" then %>selected<% end if %>>1회</option>
						<option value="2" <% if arrRs(1,37) = "2" then %>selected<% end if %>>2회</option>
						<option value="3" <% if arrRs(1,37) = "3" then %>selected<% end if %>>3회</option>
						<option value="4" <% if arrRs(1,37) = "4" then %>selected<% end if %>>4회</option>
						<option value="5" <% if arrRs(1,37) = "5" then %>selected<% end if %>>5회</option>
					</select>
				</td>
			</tr>
		</table>
		
		<h3>파일경로</h3>
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="18%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>기본시스템경로</th>
				<td><input type="text" name="no39" value="<%=arrRs(1,38)%>" size="80"  readonly class="read" /></td>
			</tr>
			<tr>
				<th>문자첨부파일</th>
				<td><input type="text" name="no40" value="<%=arrRs(1,39)%>" size="80"  readonly class="read" /></td>
			</tr>
			<tr>
				<th>음성첨부파일</th>
				<td><input type="text" name="no41" value="<%=arrRs(1,40)%>" size="80"  readonly class="read" /></td>
			</tr>
			<!--<tr>
				<th>팩스첨부파일</th>
				<td><input type="text" name="no42" value="<%=arrRs(1,41)%>" size="80" /></td>
			</tr>-->
			<input type="hidden" name="no42" value="<%=arrRs(1,41)%>" size="80" />
			<tr>
				<th>메시지첨부파일</th>
				<td><input type="text" name="no43" value="<%=arrRs(1,42)%>" size="80"  readonly class="read" /></td>
			</tr>
		</table>
		
		<% if ARSAnswTimeUseYN = "Y" then %>
			<h3>기타설정</h3>
			<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
				<colgroup>
					<col width="18%" />
					<col width="*" />
				</colgroup>
				<tr>
					<th>음성종료후<br/>응답대기시간</th>
					<td>
						<input type="text" class="aR" name="no44" value="<%=arrRs(1,43)%>" size="6" />
						<select name="no44">
							<%
							for i = 0 to 120 step 10
								response.write	"<option value=""" & i & """ "
								if cint(i) = cint(arrRs(1,43)) then
									response.write	"selected"
								end if
								response.write	">" & i & "분</option>"
							next
							%>
						</select>
					</td>
				</tr>
			</table>
		<% end if %>
		
		<h3>장애알림문자 수신번호</h3>
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="20%" />
				<col width="20%" />
				<col width="20%" />
				<col width="20%" />
				<col width="20%" />
			</colgroup>
			<tr>
			<%
			for i = 0 to 9
				if i mod 5 = 0 then
					response.write	"</tr><tr>"
				end if
				response.write	"<td class=""aR"">" & i+1 & ". <input type=""text"" name=""no" & 43 + i + 1 & """ value=""" & arrRs(1,42 + i + 1) & """ size=""18"" /></td>"
			next
			%>
			</tr>
		</table>
		
	</form>
	
	<div class="aC" style="margin:10px;">
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_green_mod.png" onclick="fnSetMod()" />
	</div>
	
</div>

<!--#include virtual="/common/footer_adm.asp"-->

<script>
	
	function fnSetMod(){
		if(confirm('설정값이 잘못되면 시스템에 오류가 발생하거나 정상적인 작동을 하지 않을수 있습니다.\n\n그래도 설정을 수정하시겠습니까?')){
			document.frm.submit();
		}
	}
	
</script>