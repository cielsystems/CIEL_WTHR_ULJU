<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<%
dim proc	: proc	= fnIsNull(nFnReq("proc", 4), "S")

dim addrCode			: addrCode			=	fnIsNull(nFnReq("addrCode", 0), 0)
dim addrCodeUper	: addrCodeUper	= fnIsNull(nFnReq("addrCodeUper", 0), 0)
dim userIndx, addrCodeDpth, addrCodeSort, addrCodeGubn, addrCodeName
dim addrCodeUperName

'response.write	"exec nusp_infoAddrCode " & addrCode & ", " & addrCodeUper & ""

set rs = server.createobject("adodb.recordset")
set cmd = server.createobject("adodb.command")
with cmd

	.activeconnection = strDBConn
	.commandtext = "nusp_infoAddrCode"
	.commandtype = adCmdStoredProc
	
	.parameters.append .createParameter("@addrCode",			adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@addrCodeUper",	adInteger,	adParamInput,		0)
	
	.parameters("@addrCode")			= addrCode
	.parameters("@addrCodeUper")	= addrCodeUper
	
	set rs = .execute
	
end with
set cmd = nothing

if not rs.eof then
	
	if addrCode > 0 then
		
		userIndx	= rs("USER_INDX")
		addrCodeUper	= rs("ADDR_CODE_UPER")
		addrCodeDpth	= rs("ADDR_CODE_DPTH")
		addrCodeSort	= rs("ADDR_CODE_SORT")
		addrCodeGubn	= rs("ADDR_CODE_GUBN")
		addrCodeName	= rs("ADDR_CODE_NAME")
		
	else
		
		addrCodeGubn	= rs("ADDR_CODE_GUBN")
		addrCodeDpth	= rs("ADDR_CODE_DPTH")
		addrCodeSort	= rs("ADDR_CODE_SORT")
		
	end if
	
	addrCodeUperName = rs("ADDR_CODE_UPER_NAME")
		
end if
set rs = nothing
%>

<div id="popBody">
	
	<form name="frm" method="post" action="pop_addrCodeProc.asp" target="popProcFrame" onsubmit="return false;">
		
		<input type="hidden" name="proc" value="<%=proc%>" />
		<input type="hidden" name="addrCode" value="<%=addrCode%>" />
		<input type="hidden" name="addrCodeUper" value="<%=addrCodeUper%>" />
		<input type="hidden" name="addrCodeDpth" value="<%=addrCodeDpth%>" />
		
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="30%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>상위분류코드</th>
				<td><%=addrCodeUperName%></td>
			</tr>
			<tr>
				<th>사용구분</th>
				<td>
					<select name="addrCodeGubn">
						<option value="A" <% if addrCodeGubn = "A" then %>selected<% end if %> <% if ss_userGubn > 10 then %>disabled<% end if %>>공용</option>
						<option value="P" <% if addrCodeGubn = "P" then %>selected<% end if %>>개인용</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>분류코드명</th>
				<td><input type="text" name="addrCodeName" value="<%=addrCodeName%>" maxlength="30" /></td>
			</tr>
			<tr>
				<th>정렬순서</th>
				<td><input type="text" name="addrCodeSort" value="<%=addrCodeSort%>" class="onlyNumb" maxlength="10" /></td>
			</tr>
		</table>
		
	</form>
	
	<div class="aC mgT10">
		<% if addrCode > 0 then %>
			<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_red_del.png" onclick="fnAddrCodeProc('D')" />
		<% end if %>
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_blue_save.png" onclick="fnAddrCodeProc('S')" />
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script type="text/javascript">
	
	$(function(){
		
	});
	
	function fnAddrCodeProc(proc){
		if(proc == 'S'){
			if($('input[name=addrCodeName]').val().length == 0){
				alert('분류코드명을 입력해 주세요.');$('input[name=addrCodeName]').focus();return false;
			}
		}
		$('input[name=proc]').val(proc);
		$.ajax({
			url	: 'pop_addrCodeProc.asp',
			type	: 'POST',
			data	: $('form[name=frm]').serialize(),
			success	: function(rslt){
				var arrRslt	= rslt.split('|');
				alert(arrRslt[1]);
				if(arrRslt[0] == 0){
					top.location.reload();
				}
			},
			fail	: function(rslt){
				alert('오류가 발생했습니다.');
			}
		});
	}
	
</script>