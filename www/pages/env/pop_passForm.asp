<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<script src="<%=pth_pubJs%>/sha256.js"></script>

<div id="popBox">
	
	<form name="frm" method="post" action="pop_passProc.asp" target="popProcFrame">
		
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<tr>
				<th>기존비밀번호</th>
				<td><input type="password" name="_oldPass" maxlength="20" /><input type="hidden" name="oldPass" /></td>
			</tr>
			<tr>
				<th>새비밀번호</th>
				<td><input type="password" name="_newPass" maxlength="20" /><input type="hidden" name="newPass" /></td>
			</tr>
			<tr>
				<th>새비밀번호확인</th>
				<td><input type="password" name="_newPassChk" maxlength="20" /><input type="hidden" name="newPassChk" /></td>
			</tr>
		</table>
		
		<div class="btnBox">
			<input type="button" class="btn big blue" value="비밀번호변경" onclick="fnPassSave()" />
		</div>
		
	</form>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script type="text/javascript">
	
	function fnPassSave(){
		if(document.frm._oldPass.value == ''){
			alert('기존비밀번호를 입력해 주세요.');document.frm._oldPass.focus();return;
		}
		if(document.frm._newPass.value == ''){
			alert('새비밀번호를 입력해 주세요.');document.frm._newPass.focus();return;
		}
		if(document.frm._newPass.value.length < 4){
			alert('비밀번호는 4자리 이상 입력해 주세요.');document.frm._newPass.focus();return;
		}
		if(document.frm._newPassChk.value == ''){
			alert('새비밀번호를 한번더 입력해 주세요.');document.frm._newPassChk.focus();return;
		}
		if(document.frm._newPass.value != document.frm._newPassChk.value){
			alert('새비밀번호가 일치하지 않습니다.');document.frm._newPassChk.value = '';document.frm._newPassChk.focus();return;
		}
		document.frm.oldPass.value = sha256_digest(document.frm._oldPass.value);
		document.frm.newPass.value = sha256_digest(document.frm._newPass.value);
		document.frm.newPassChk.value = sha256_digest(document.frm._newPassChk.value);
		//document.frm.oldPass.value = document.frm._oldPass.value;
		//document.frm.newPass.value = document.frm._newPass.value;
		//document.frm.newPassChk.value = document.frm._newPassChk.value;
		document.frm.submit();
	}
	
</script>