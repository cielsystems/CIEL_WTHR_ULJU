<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<%
dim gb	: gb	= fnReq("gb")

sql = " select TMP_NO, TMP_NM "
'sql = sql & " 	, dbo.ecl_DECRPART(TMP_NUM,4) "
sql = sql & " 	, TMP_NUM "
sql = sql & " 	, TMP_TIT, TMP_MSG, TMP_MCRVAL1, TMP_MCRVAL2, TMP_MCRVAL3 "
sql = sql & " from TMP_MCRTRG with(nolock) where AD_IDX = " & ss_userIdx & " and AD_IP = '" &svr_remoteAddr & "' order by TMP_NO "
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

'#	발신번호
'dim clSndNum : clSndNum = fnDBVal("TBL_ADDR", "dbo.ecl_DECRPART(dbo.ufn_getSndNum('S', AD_IDX),4)", "AD_IDX = '" & ss_userIdx & "'")
dim clSndNum : clSndNum = fnDBVal("TBL_ADDR", "dbo.ufn_getSndNum('S', AD_IDX)", "AD_IDX = '" & ss_userIdx & "'")
if clSndNum = "" then
	clSndNum = dftSndNum
end if
'clSndNum = dftSndNum
%>

<div id="popBody">
	
	<form name="frm" method="post" action="popMcrProc.asp" target="popProcFrame">
		<input type="hidden" name="gb" value="<%=gb%>" />
		
		<% if gb = "1" then %>
		
			<div style="padding:5px;background:#eefcff;border:1px solid #cccccc;border-radius:5px;margin-bottom:2px;">
				발신번호 : <input type="test" name="sndNum" value="<%=clSndNum%>" />
			</div>
			
			<div style="height:560px;overflow-x:hidden;overflow-y:scroll;">
				<table border="0" cellpadding="0" cellspacing="1" class="tblList">
					<colgroup>
						<col width="60px" />
						<col width="80px" />
						<col width="100px" />
						<col width="120px" />
						<col width="*" />
					</colgroup>
					<tr>
						<th>번호</th>
						<th>이름</th>
						<th>휴대폰번호</th>
						<th>제목</th>
						<th>내용</th>
					</tr>
					<%
					for i = 0 to arrRc2
						response.write	"<tr>"
						response.write	"	<td class=""aC"">" & i+1 & "</td>"
						response.write	"	<td class=""aC"">" & arrRs(1,i) & "</td>"
						response.write	"	<td class=""aC"">" & arrRs(2,i) & "</td>"
						response.write	"	<td>" & arrRs(3,i) & "</td>"
						response.write	"	<td>" & arrRs(4,i) & "</td>"
						response.write	"</tr>"
					next
					%>
				</table>
			</div>
			
		<% elseif gb = "2" then %>
		
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-top:10px;">
				<colgroup>
					<col width="250px" />
					<col width="10px" />
					<col width="*" />
				</colgroup>
				<tr>
					<td valign="top">
						
						<div style="padding:5px;background:#eefcff;border:1px solid #cccccc;border-radius:5px;margin-bottom:2px;">
							발신번호 : <input type="test" name="sndNum" value="<%=clSndNum%>" />
						</div>
						<div style="padding:5px;background:#eefcff;border:1px solid #cccccc;border-radius:5px;margin-bottom:2px;">제목 : <input type="text" name="clTit" size="30" value="" /></div>
						<div style="background:url(/images/phone_bg_light.png);width:250px;height:300px;">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td>
										<div style="width:238px;height:265px;border:1px solid #cccccc;overflow-x:hidden;overflow-y:scroll;margin:25px 5px 10px 5px;">
											<div id="smsFileView"></div>
											<textarea id="SMSMsg" name="SMSMsg" style="width:218px;height:250px;margin:5px;background:none;overflow:hidden;border:0;"
												onkeypress="fnChkByte('SMSMsg');" onkeydown="fnChkByte('SMSMsg');" onkeyup="fnChkByte('SMSMsg');"
											></textarea>
										</div>
									</td>
								</tr>
							</table>
						</div>
						
						<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
							<tr>
								<th>$Name</th><td>이름</td>
							</tr>
							<tr>
								<th>$Number</th><td>휴대폰번호</td>
							</tr>
							<tr>
								<th>$1</th><td>변수1</td>
							</tr>
							<tr>
								<th>$2</th><td>변수2</td>
							</tr>
							<tr>
								<th>$3</th><td>변수3</td>
							</tr>
						</table>
						
					</td>
					<td></td>
					<td valign="top">
						
						<div style="height:560px;overflow-x:hidden;overflow-y:scroll;">
							<table border="0" cellpadding="0" cellspacing="1" class="tblList">
								<tr>
									<th>번호</th>
									<th>이름($Name)</th>
									<th>휴대폰번호($Number)</th>
									<th>변수1($1)</th>
									<th>변수2($2)</th>
									<th>변수3($3)</th>
								</tr>
								<%
								for i = 0 to arrRc2
									response.write	"<tr>"
									response.write	"	<td class=""aC"">" & i+1 & "</td>"
									response.write	"	<td>" & arrRs(1,i) & "</td>"
									response.write	"	<td>" & arrRs(2,i) & "</td>"
									response.write	"	<td>" & arrRs(5,i) & "</td>"
									response.write	"	<td>" & arrRs(6,i) & "</td>"
									response.write	"	<td>" & arrRs(7,i) & "</td>"
									response.write	"</tr>"
								next
								%>
							</table>
						</div>
						
					</td>
				</tr>
			</table>
		
		<% end if  %>
		
	</form>
	
	<div class="aR" style="margin-top:10px;">
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_green_send.png" onclick="fnSend()" />
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	function fnSend(){
		if(document.frm.sndNum.value.length < 1){
			alert('발신번호를 입력해 주세요.');document.frm.sndNum.focus();return false;
		}
		<% if gb = "1" then %>
			if(confirm('업로드한 내용으로 전송을 요청하시겠습니까?')){
				document.frm.submit();
			}
		<% elseif gb = "2" then %>
			if($('#SMSMsg').val().length < 1){
				alert('내용을 입력하세요.');$('#SMSMsg').focus();return false;
			}
			if(confirm('입력한 내용을 업로드한 내용으로 치환해서 전송을 요청하시겠습니까?')){
				document.frm.submit();
			}
		<% end if %>
	}
	
</script>