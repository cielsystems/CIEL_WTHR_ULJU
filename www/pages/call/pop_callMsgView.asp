<!--#include virtual="/common/common.asp"-->

<%
dim clGB : clGB = fnReq("clGB")
dim msgIdx : msgIdx = fnReq("msgIdx")

sql = " select MSG_TIT, MSG_SMS, MSG_VMS from TBL_MSG with(nolock) where MSG_IDX = " & msgIdx & " "
dim msgInfo : msgInfo = execSqlArrVal(sql)
dim msgTit : msgTit = msgInfo(0)
dim SMSMsg : SMSMsg = msgInfo(1)
dim VMSMsg : VMSMsg = msgInfo(2)

sql = " select MSGF_PATH, MSGF_FILE "
sql = sql & " from TBL_MSGFILE with(nolock) "
sql = sql & " where MSG_IDX = " & msgIdx & " and MSGF_GB = 'S' order by MSGF_SORT "
arrRs = execSqlRs(sql)
if isarray(arrRs) then
	arrRc2 = ubound(arrRs,2)
else
	arrRc2 = -1
end if

'#	================================================================================================
'#	음성전송 Print
sub emrConfirmVMS()

	if len(VMSMsg) > 0 then
		
		response.write	"<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0"">"
		response.write	"	<tr>"
		response.write	"		<td width=""500px"">"
		
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
		
		response.write	"	</tr>"
		response.write	"</table>"
		
	end if
	
end sub
'#	================================================================================================

'#	================================================================================================
'#	문자전송 Print
sub emrConfirmSMS()

	if len(SMSMsg) > 0 or arrRc2 > -1 then
		
		response.write	"<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0"">"
		response.write	"<colgroup>"
		response.write	"	<col width=""33%"" />"
		response.write	"	<col width=""33%"" />"
		response.write	"	<col width=""*"" />"
		response.write	"</colgroup>"
		response.write	"	<tr>"
		
		response.write	"		<td style=""padding:0 20px 0 0"">"
		response.write	"			<div style=""background:url(/images/phone_bg_light.png);width:250px;height:300px;"">"
		response.write	"				<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0"">"
		response.write	"					<tr>"
		response.write	"						<td>"
		response.write	"							<div style=""width:238px;height:265px;border:1px solid #cccccc;overflow-x:hidden;overflow-y:scroll;margin:25px 5px 10px 5px;"">"
		response.write	"								<div id=""smsFileList"">"
		for i = 0 to arrRc2
			response.write	"									<div><img src=""/data/" & arrRs(0,i) & "/" & arrRs(1,i) & """ /></div>"
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
		response.write	"</table>"
		
		response.write	"<textarea name=""SMSMsg"" style=""display:none;"">" & SMSMsg & "</textarea>"
		
	end if
	
end sub
'#	================================================================================================

dim arrClMethod : arrClMethod = array("문자","음성")
%>

<!--#include virtual="/common/header_pop.asp"-->

<div id="popBody">
	
	<div class="tabs">
		<ul class="tabsMenu">
			<% for i = 0 to ubound(arrClMethod) %>
				<li id="tabsMenu_<%=i+1%>" onclick="fnTabMenu(<%=i+1%>)"><%=arrClMethod(i)%>내용</li>
			<% next %>
			<div class="clr"></div>
		</ul>
		<div class="tabsContBox">
			<div id="tabs-1" class="tabsCont">
				<div style="height:340px;overflow-x:hidden;overflow-y:scroll;">
					
					<%
					call emrConfirmSMS()
					%>
					
				</div>
			</div>
			<div id="tabs-2" class="tabsCont">
				<div style="height:340px;overflow-x:hidden;overflow-y:scroll;">
					
					<%
					call emrConfirmVMS()
					%>
					
				</div>
			</div>
		</div>
	</div>
	
	<div class="aR" style="margin-top:10px;">
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/purple_appl.png" onclick="fnSelMsg()" />
	</div>
		
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	var nTab = 1;			// 최초 선택된 Tab 번호
	
	var page = 1;
	var pageSize = 10;
	
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
	
	function fnSelMsg(){
		var strSMS = $('#SMSMsg').html();
		var strVMS = $('#VMSMsg').html();
		if(strSMS.length == 0 && strVMS.length == 0){
			alert('내용이 없습니다.');return;
		}else{
			popProcFrame.location.href = 'pop_callMsgViewProc.asp?clGB=<%=clGB%>&msgIdx=<%=msgIdx%>';
		}
	}
	
</script>