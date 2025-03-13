<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<%
dim userGubn, userID, userName, userNum1, userNum2, userNum3, userStep, userDfltNum

set rs = server.createobject("adodb.recordset")
set cmd = server.createobject("adodb.command")
with cmd

	.activeconnection = strDBConn
	.commandtext = "nusp_infoUser"
	.commandtype = adCmdStoredProc
	
	.parameters.append .createParameter("@userIndx",	adInteger,	adParamInput,		0)
	
	.parameters("@userIndx")			= ss_userIndx
	
	set rs = .execute
	
end with
set cmd = nothing
if not rs.eof then
	userGubn	= rs("USER_GUBN")
	userID		= rs("USER_ID")
	userName	= rs("USER_NAME")
	userNum1	= rs("USER_NUM1")
	userNum2	= rs("USER_NUM2")
	userNum3	= rs("USER_NUM3")
	userStep	= rs("USER_STEP")
	userDfltNum	= rs("USER_DFLT_NUM")
end if
set rs = nothing
%>

<div id="subPageBox">
	
	<form name="frm" method="post" action="myinfoProc.asp" target="popProcFrame">
		
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="15%" />
				<col width="*" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr>
				<th>구분</th>
				<td><%=fnPrintUserGubn(userGubn)%></td>
				<th>이름</th>
				<td><%=userName%></td>
			</tr>
			<tr>
				<th>아이디</th>
				<td><%=userID%></td>
				<th>비밀번호</th>
				<td><img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_pass2.png" alt="비밀번호변경" onclick="fnModPass()" /></td>
			</tr>
			<tr>
				<th><%=arrCallMedia(1)%>번호</th>
				<td><input type="text" name="userNum1" value="<%=userNum1%>" maxlength="20" /></td>
				<th><%=arrCallMedia(2)%>번호</th>
				<td><input type="text" name="userNum2" value="<%=userNum2%>" maxlength="20" /></td>
			</tr>
			<tr>
				<th><%=arrCallMedia(3)%>번호</th>
				<td><input type="text" name="userNum3" value="<%=userNum3%>" maxlength="20" /></td>
				<th>기본발신번호</th>
				<td><input type="text" name="userDfltNum" value="<%=userDfltNum%>" maxlength="20" /></td>
			</tr>
		</table>
			
		<div class="aC" style="margin-top:10px;">
			<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_blue_save.png" title="저장" onclick="fnSave()" />
		</div>
		
	</form>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	function fnModPass(){
		layerW = 400;
		layerH = 260;
		var url = 'pop_passForm.asp';
		fnOpenLayer('비밀번호변경',url);
	}
	
	function fnSave(){
	/*
		if(document.frm.myAdNum1.value.length > 0){
			if(fnChkMobile(document.frm.myAdNum1.value) == false && fnChkPhone(document.frm.myAdNum1.value) == false){
				alert('휴대폰번호를 정확히 입력해 주세요.');  document.frm.myAdNum1.focus(); return;
			}
		}
		if(document.frm.myAdNum2.value.length > 0){
			if(fnChkMobile(document.frm.myAdNum2.value) == false && fnChkPhone(document.frm.myAdNum2.value) == false){
				alert('집전화번호를 정확히 입력해 주세요.');  document.frm.myAdNum2.focus(); return;
			}
		}
		if(document.frm.myAdNum3.value.length > 0){
			if(fnChkMobile(document.frm.myAdNum3.value) == false && fnChkPhone(document.frm.myAdNum3.value) == false){
				alert('기타전화번호를 정확히 입력해 주세요.');  document.frm.myAdNum3.focus(); return;
			}
		}
		*/
		document.frm.submit();
	}
	
</script>