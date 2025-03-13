<!--#include virtual="/common/common.asp"-->

<%
dim userIndx	: userIndx	= fnIsNull(nFnReq("userIndx", 0), 0)

dim userGubn, userID, userName, userNum1, userNum2, userNum3, userStep

if userIndx > 0 then
	
	set rs = server.createobject("adodb.recordset")
	set cmd = server.createobject("adodb.command")
	with cmd

		.activeconnection = strDBConn
		.commandtext = "nusp_infoUser"
		.commandtype = adCmdStoredProc
		
		.parameters.append .createParameter("@userIndx",	adInteger,	adParamInput,		0)
		
		.parameters("@userIndx")			= userIndx
		
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
	end if
	set rs = nothing
	
end if
%>

<!--#include virtual="/common/header_pop.asp"-->

<div id="popBody">
	
	<form name="frm" method="post" action="pop_userProc.asp" target="popProcFrame" onsubmit="return false;">
		
		<input type="hidden" name="proc" value="" />
		<input type="hidden" name="userIndx" value="<%=userIndx%>" />
		
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="15%" />
				<col width="*" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr>
				<th>구분</th>
				<td>
					<select name="userGubn">
						<option value="0">::: 선택 :::</option>
						<%
						for i = 1 to ubound(arrUserGubn)
							response.write	"<option value=""" & arrUserGubn(i)(0) & """"
							if userGubn = arrUserGubn(i)(0) then
								response.write	" selected "
							end if
							response.write	">" & arrUserGubn(i)(1) & "</option>"
						next
						%>
					</select>
				</td>
				<th>상태</th>
				<td>
					<select name="userStep">
						<option value="0">::: 선택 :::</option>
						<%
						for i = 0 to ubound(arrUserStep)
							response.write	"<option value=""" & arrUserStep(i)(0) & """"
							if cInt(userStep) = arrUserStep(i)(0) then
								response.write	" selected "
							end if
							response.write	">" & arrUserStep(i)(1) & "</option>"
						next
						%>
					</select>
				</td>
			</tr>
			<tr>
				<th>이름</th>
				<td><input type="text" name="userName" value="<%=userName%>" /></td>
				<th><%=arrCallMedia(1)%> 번호</th>
				<td><input type="text" name="userNum1" value="<%=userNum1%>" maxlength="25" /></td>
			</tr>
			<tr>
				<th>아이디</th>
				<td><% if userIndx > 0 then %><%=userID%><% else %><input type="text" name="userID" value="<%=userID%>" /><% end if %></td>
				<th><%=arrCallMedia(2)%> 번호</th>
				<td><input type="text" name="userNum2" value="<%=userNum2%>" maxlength="25" /></td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td>
					<% if userIndx > 0 then %>
						<img class="imgBtn" src="<%=pth_pubImg%>/btn/red_passReset2.png" onclick="fnPassReset()" />
					<% else %>
					<% end if %>
					초기비밀번호 : <b><%=dftPass%></b>
				</td>
				<th><%=arrCallMedia(3)%>번호</th>
				<td><input type="text" name="userNum3" value="<%=userNum3%>" maxlength="25" /></td>
			</tr>
		</table>
		
		<style>
			.adGrpItemBox {height:260px;overflow-x:hidden;overflow-y:scroll;}
			.adGrpItemBox .grupItem {line-height:20px;border-bottom:1px solid #cccccc;padding-left:5px;font-size:11px;}
			.adGrpItemBox .grupUperItem	{line-height:20px;border-bottom:1px solid #cccccc;padding-left:5px;font-size:11px;background-color:#eee;font-weight:bold;}
			.adGrpItemBox .on {background:#ff9900;}
			.upCode {background:#dddddd;font-weight:bold;}
		</style>

		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="20%" />
				<col width="20%" />
				<col width="20%" />
				<col width="20%" />
				<col width="20%" />
			</colgroup>
			<tr>
				<th colspan="5">부서(그룹) 전체선택 <input type="checkbox" name="allGrupChek" /></th>
			</tr>
			<%
			dim grupRs, grupRc, grupLoop, grupID, prevGrupUper
			
			for i = 1 to 5
			
				response.write	"<td style=""padding:0px;"">"
				response.write	"	<div class=""adGrpItemBox"">"
				
				sql = " select GRUP_INDX, GRUP_DPTH, GRUP_NAME, GRUPINDX0, GRUPINDX1, GRUPINDX2, GRUPINDX3, GRUPINDX4, GRUPINDX5 "
				sql = sql & " 	, dbo.nufn_getUserGrupPrmt(" & userIndx & ", GRUP_INDX) as YN "
				sql = sql & " 	, GRUP_UPER, dbo.nufn_getGrupName(GRUP_UPER) as GRUPUPERNAME "
				sql = sql & " from nViw_grupList with(nolock) where GRUP_GUBN = 'D' and GRUP_DPTH = " & i & " "
				sql = sql & " order by GRUPSORT1, GRUPSORT2, GRUPSORT3, GRUPSORT4, GRUPSORT5 "
				cmdOpen(sql)
				set rs = cmd.execute
				cmdClose()
				if not rs.eof then
					grupRs = rs.getRows
					grupRc = ubound(grupRs,2)
				else
					grupRc = -1
				end if
				rsClose()
				
				for grupLoop = 0 to grupRc
					grupID	= "grup_" & grupRs(3, grupLoop) & ""
					if grupRs(1, grupLoop) > 0 then
						grupID	= grupID & "_" & grupRs(4, grupLoop) & ""
						if grupRs(1, grupLoop) > 1 then
							grupID	= grupID & "_" & grupRs(5, grupLoop) & ""
							if grupRs(1, grupLoop) > 2 then
								grupID	= grupID & "_" & grupRs(6, grupLoop) & ""
								if grupRs(1, grupLoop) > 3 then
									grupID	= grupID & "_" & grupRs(7, grupLoop) & ""
									if grupRs(1, grupLoop) > 4 then
										grupID	= grupID & "_" & grupRs(8, grupLoop) & ""
									end if
								end if
							end if
						end if
					end if
					
					if prevGrupUper <> grupRs(10, grupLoop) then
						response.write	"<div class=""grupUperItem"">" & grupRs(11, grupLoop) & "</div>"
					end if
					prevGrupUper	= grupRs(10, grupLoop)
					
					response.write	"<div class=""grupItem"
					if grupRs(9, grupLoop) = "Y" then
						response.write	" on"
					end if
					response.write	""" id=""" & grupID & """>"
					response.write	"<label onclick=""fnSelGrup('" & grupID & "')"">"
					response.write	"<input type=""checkbox"" name=""grupIndx"" value=""" & grupRs(0, grupLoop) & """"
					if grupRs(9, grupLoop) = "Y" then
						response.write	" checked"
					end if
					response.write	" />"
					response.write	"" & grupRs(2, grupLoop) & "</label></div>"
				next
				
				response.write	"	</div>"
				response.write	"</td>"
				
			next
			%>
		</table>
		
	</form>
	
	<div class="aC" style="margin-top:10px;">
		<% if userIndx > 0 then %>
			<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_red_del.png" onclick="fnUserDel()" />
		<% end if %>
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_blue_save.png" onclick="fnUserSave()" />
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	$(function(){
		
		$('input[name=allGrupChek]').click(function(){
			if($(this).prop('checked') == true){
				$('input[name=grupIndx]').prop('checked', true);
				$('input[name=grupIndx]').parent().parent().addClass('on');
			}else{
				$('input[name=grupIndx]').prop('checked', false);
				$('input[name=grupIndx]').parent().parent().removeClass('on');
			}
		});
		
	});
	
	function fnSelGrup(nID){
		if($('#'+nID).find('input[name=grupIndx]').prop('checked') == true){
			$('#'+nID).addClass('on');
			$('.grupItem[id^='+nID+'_]').addClass('on');
			$('.grupItem[id^='+nID+'_]').find('input[name=grupIndx]').prop('checked', true);
		}else{
			$('#'+nID).removeClass('on');
			$('.grupItem[id^='+nID+'_]').removeClass('on');
			$('.grupItem[id^='+nID+'_]').find('input[name=grupIndx]').prop('checked', false);
		}
	}
	
	function fnUserDel(){
		if(confirm('삭제하시겠습니까?')){
			document.frm.proc.value = 'D';
			//document.frm.submit();
			$.ajax({
				url	: 'pop_userProc.asp',
				type	: 'POST',
				data	: $('form[name=frm]').serialize(),
				success	: function(rslt){
					console.log(rslt);
					var arrRslt	= rslt.split('|');
					alert(arrRslt[1]);
					if(arrRslt[0] == 0){
						parent.location.reload();
					}
				},
				fail	: function(rslt){
					alert('오류가 발생했습니다.');
				}
			});
		}
	}
	
	function fnUserSave(){
		if(document.frm.userGubn.value == 0){
			alert('구분을 선택하세요.');document.frm.userGubn.focus();return;
		}
		if(document.frm.userName.value == ''){
			alert('이름을 입력하세요.');document.frm.userName.focus();return;
		}
		<% if userIndx = 0 then %>
		if(document.frm.userID.value == ''){
			alert('아이디를 입력하세요.');document.frm.userID.focus();return;
		}
		<% end if %>
		document.frm.proc.value = 'S';
		//document.frm.submit();
		$.ajax({
			url	: 'pop_userProc.asp',
			type	: 'POST',
			data	: $('form[name=frm]').serialize(),
			success	: function(rslt){
				console.log(rslt);
				var arrRslt	= rslt.split('|');
				alert(arrRslt[1]);
				if(arrRslt[0] == 0){
					parent.fnLoadPage(parent.page);
					location.href = 'pop_userForm.asp?userIndx='+arrRslt[2];
				}
			},
			fail	: function(rslt){
				alert('오류가 발생했습니다.');
			}
		});
	}
	
	function fnPassReset(){
		popProcFrame.location.href = 'pop_userPassProc.asp?proc=reset&userIndx=<%=userIndx%>';
	}
	
</script>