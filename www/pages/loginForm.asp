<!--#include virtual="/common/common.asp"-->

<%
dim reqLoginID : reqLoginID = request.cookies("loginID")
%>

<!doctype html>
<html lang="utf-8">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />

<title><%=siteTitle%></title>

<script src="<%=pth_pubJs%>/jquery-1.10.2.min.js"></script>

<link rel="stylesheet" type="text/css" href="<%=pth_pubCss%>/default.css" />

<script src="<%=pth_pubJs%>/default.js"></script>
<script src="<%=pth_sitJs%>/site.js"></script>

<script src="<%=pth_pubJs%>/sha256.js"></script>

<style type="text/css">
	* {font-family:맑은 고딕;}
	#loginBox {background:url(/images/loginBox.png) no-repeat 50% 80px;width:100%;height:686px;}
	label {font-size:14px;font-weight:bold;color:#555555;}
	input[type=text], input[type=password] {height:30px;line-height:28px;font-size:16px;font-weight:bold;border:1px solid #848484;vertical-align:top;}
</style>

<script type="text/javascript">
	
	$(document).ready(function(){
		
		$('#svrTime').html(fnSvrTime());
		setInterval("$('#svrTime').html(fnSvrTime())",1000);
		
		$('#loginID').bind('focus',function(){
			if($(this).val().length == 0){
				$(this).removeClass('loginID');
			}
		});
		$('#loginID').bind('blur',function(){
			if($(this).val().length == 0){
				$(this).addClass('loginID');
			}
		});
		
		$('#loginPW').bind('focus',function(){
			if($(this).val().length == 0){
				$(this).removeClass('loginPW');
			}
		});
		$('#loginPW').bind('blur',function(){
			if($(this).val().length == 0){
				$(this).addClass('loginPW');
			}
		});
		
	});
	
	function fnLogin(){
		var frm = document.frm;
		if(frm.loginID.value == ''){
			alert('아이디를 입력하세요.');frm.loginID.focus();return;
		}
		if(frm._loginPW.value == ''){
			alert('비밀번호를 입력하세요.');frm._loginPW.focus();return;
		}
		frm.loginPW.value = sha256_digest(frm._loginPW.value);
		//frm.loginPW.value = frm._loginPW.value;
		frm.submit();
	}
	
	function fnSvrTime(){
		var dt = new Date();
		var s = fnLeadingZero(dt.getFullYear(),4) + '-';
		s = s + fnLeadingZero(dt.getMonth() + 1, 2) + '-';
		s = s + fnLeadingZero(dt.getDate(), 2) + ' ';
		s = s + fnLeadingZero(dt.getHours(), 2) + ':';
		s = s + fnLeadingZero(dt.getMinutes(), 2) + ':';
		s = s + fnLeadingZero(dt.getSeconds(), 2);
		return s;
	}
	
	function fnLeadingZero(n, digits){
		var zero = '';
		n = n.toString();
		if(n.length < digits){
			for(i=0; i<digits-n.length; i++){
				zero += '0';
			}
		}
		return zero + n;
	}
	
</script>

</head>
<body>

<div id="loginBox">

	<table width="100%" border="0" cellpadding="0" cellspacing="0" style="text-align:center;">
		<colgroup>
			<col width="*" />
			<col width="820px" />
			<col width="*" />
		</colgroup>
		<tr>
			<td>&nbsp;</td>
			<td>
	
				<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:180px 0 20px 0;">
					<colgroup>
						<col width="210px" />
						<col width="*" />
					</colgroup>
					<tr>
						<td colspan="2"><img src="/images/login.jpg" style="width:760px;height:400px;border:1px solid #666666;" /></td>
					</tr>
					<tr>
						<td></td>
						<td style="text-align:right;padding:15px 20px;">
							
							<form name="frm" method="post" action="loginProc.asp" target="">
								<label for="loginID"><img src="/images/loginLbl01.png" /></label>
								<input type="text"id="loginID" class="loginID" name="loginID" value="<%=reqLoginID%>" onkeypress="if (event.keyCode==13) {fnLogin()}" tabindex="1" size="14" />&nbsp;
								<label for="loginPW"><img src="/images/loginLbl02.png" /></label>
								<input type="password" id="_loginPW" class="loginPW" name="_loginPW" onkeypress="if (event.keyCode==13) {fnLogin()}" tabindex="2" size="14" />
								<input type="hidden" id="loginPW" name="loginPW" />
								&nbsp;<img class="imgBtn" src="<%=pth_pubImg%>/btn/login.png" alt="로그인" onclick="fnLogin()" />
							</form>
							
						</td>
					</tr>
				</table>
			</td>
			<td>&nbsp;</td>
		</tr>
	</table>
	
	<div style="line-height:45px;text-align:center;color:#888888;"><%=siteTitle%>
		<div style="font-size:13px;"></div>
	</div>
			
</div>

</body>
</html>