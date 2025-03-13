<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<%
dim relGubn	: relGubn	= fnIsNull(nFnReq("relGubn", 1), "")

dim addrIndx	: addrIndx	= fnIsNull(nFnReq("addrIndx", 0), 0)
dim grupIndx	: grupIndx	= fnIsNull(nFnReq("grupIndx", 0), 0)

dim strTitl
if relGubn = "G" then
	strTitl	= "그룹설정"
elseif relGubn = "C" then
	strTitl	= "분류코드설정"
end if
%>

<div id="popBody">
	
	<div id="popupBox">
		
		<h3><%=strTitl%></h3>
		
		<div id="popupCont">
			
			<div class="tree_box" style="height:400px;">
				
				<%
				if relGubn = "G" then
					
					dim arrGrupGubn	: arrGrupGubn	= array("D", "P")
					
					dim grupRs, grupRc, grupLoop
					
					for i = 0 to ubound(arrGrupGubn)
						
						set rs = server.createobject("adodb.recordset")
						set cmd = server.createobject("adodb.command")
						with cmd

							.activeconnection = strDBConn
							.commandtext = "nusp_listGrupTreeAddr"
							.commandtype = adCmdStoredProc
							
							.parameters.append .createParameter("@addrIndx",	adInteger,	adParamInput,		0)
							.parameters.append .createParameter("@grupGubn",	adChar,			adParamInput,		1)
							.parameters.append .createParameter("@userIndx",	adInteger,	adParamInput,		0)
							
							.parameters("@addrIndx")	= addrIndx
							.parameters("@grupGubn")	= arrGrupGubn(i)
							.parameters("@userIndx")	= ss_userIndx
							
							set rs = .execute
							
						end with
						set cmd = nothing

						if not rs.eof then
							grupRs = rs.getRows
							grupRc = ubound(grupRs,2)
						else
							grupRc = -1
						end if
						set rs = nothing
						
						response.write	"<div class=""tree_block"">"
						response.write	"	<ul class=""tree_list"">"
						
						dim nDpthToggle	: nDpthToggle	= "close"
						
						for grupLoop = 0 to grupRc
							
							if grupRs(1, grupLoop) > 1 then
								nDpthToggle	= "close"
							else
								nDpthToggle	= "open"
							end if
							
							response.write	"		<li class=""dpth" & grupRs(1, grupLoop) & " " & nDpthToggle
							if grupRs(12, grupLoop) > 0 then
								response.write	" on"
							end if
							if grupRs(4, grupLoop) = 0 then
								response.write	" lastGrup"
							end if
							response.write	""" id=""grup_" & grupRs(5, grupLoop) & ""
							if grupRs(1, grupLoop) > 0 then
								response.write	"_" & grupRs(6, grupLoop) & ""
								if grupRs(1, grupLoop) > 1 then
									response.write	"_" & grupRs(7, grupLoop) & ""
									if grupRs(1, grupLoop) > 2 then
										response.write	"_" & grupRs(8, grupLoop) & ""
										if grupRs(1, grupLoop) > 3 then
											response.write	"_" & grupRs(9, grupLoop) & ""
											if grupRs(1, grupLoop) > 4 then
												response.write	"_" & grupRs(10, grupLoop) & ""
											end if
										end if
									end if
								end if
							end if
							
							response.write	""">"
							if grupRs(4, grupLoop) > 0 then
								if grupRs(1, grupLoop) > 0 then
									response.write	"				<a class=""toggle_icon""><i class=""fa fa-plus-square-o""></i></a>"
								else
									response.write	"				<a class=""toggle_icon""><i class=""fa fa-minus-square-o""></i></a>"
								end if
							else
								response.write	"				<a class=""toggle_icon"">&nbsp;&nbsp;</a>"
							end if
							response.write	"			<span class=""grup_name"">"
							response.write	"				<label>"
							'response.write	"				<input type=""hidden"" name=""grupIndx"" value=""" & grupRs(0, grupLoop) & """ />"
							response.write	"				<input type=""hidden"" name=""grupDpth"" value=""" & grupRs(1, grupLoop) & """ />"
							response.write	"				<input type=""checkbox"" name=""grupIndx"" value=""" & grupRs(0, grupLoop) & """"
							if grupRs(12, grupLoop) > 0 then
								response.write	" checked"
							end if
							if grupRs(11, grupLoop) = "N" then
								response.write	" readonly disabled"
							end if
							response.write	" />"
							response.write	"				" & grupRs(3, grupLoop) & ""
							if grupRs(13, grupLoop) > 0 then
								response.write	" <span class=""btn_radius bg_teal pdT01 pdR03 pdB01 pdL03 fnt11"">" & grupRs(13, grupLoop) & "</span>"
							end if
							response.write	"				</label>"
							response.write	"			</span>"
							'response.write	"			<span class=""grup_butn"">"
							'if grupRs(11, grupLoop) = "Y" then
							'	if grupRs(1, grupLoop) > 0 then
							'		response.write	"				<a href=""javascript:fnGrup('E'," & grupRs(0, grupLoop) & ")""><i class=""fa fa-edit""></i></a>"
							'		response.write	"				<a href=""javascript:fnGrup('D'," & grupRs(0, grupLoop) & ")""><i class=""fa fa-close""></i></a>"
							'	end if
							'	if grupRs(1, grupLoop) < 5 then
							'		response.write	"				<a href=""javascript:fnGrup('A'," & grupRs(0, grupLoop) & ")""><i class=""fa fa-plus""></i></a>"
							'	end if
							'end if
							'response.write	"			</span>"
							response.write	"		</li>"
							
						next
						
						response.write	"	</ul>"
						response.write	"</div>"
					
					next
					
				elseif relGubn = "C" then
					
					dim uperRs, uperRc, uperLoop
					
					set rs = server.createobject("adodb.recordset")
					set cmd = server.createobject("adodb.command")
					with cmd

						.activeconnection = strDBConn
						.commandtext = "nusp_listAddrCode"
						.commandtype = adCmdStoredProc
						
						.parameters.append .createParameter("@userIndx",			adInteger,	adParamInput,		0)
						.parameters.append .createParameter("@addrCodeUper",	adInteger,	adParamInput,		0)
						
						.parameters("@userIndx")			= ss_userIndx
						.parameters("@addrCodeUper")	= 0
						
						set rs = .execute
						
					end with
					set cmd = nothing

					if not rs.eof then
						uperRs = rs.getRows
						uperRc = ubound(uperRs,2)
					else
						uperRc = -1
					end if
					set rs = nothing
					
					for uperLoop = 0 to uperRc
						
						response.write	"<div class=""tree_block"">"
						response.write	"	<ul class=""tree_list"">"
						
						response.write	"		<li class=""dpth0 open"" id=""grup_" & uperRs(0, uperLoop) & """>"
						response.write	"			<a class=""toggle_icon""><i class=""fa fa-plus-square-o""></i></a>"
						response.write	"			<span class=""grup_name"">"
						response.write	"				<label>"
						response.write	"					<input type=""hidden"" name=""grupDpth"" value=""0"" />"
						'response.write	"					<input type=""checkbox"" name=""addrCode"" value=""" & uperRs(0, uperLoop) & """ />"
						response.write	"					<input type=""hidden"" name=""addrCode"" value=""" & uperRs(0, uperLoop) & """ />"
						response.write	"					" & uperRs(1, uperLoop) & "</label>"
						response.write	"			</span>"
						response.write	"		</li>"
						
						dim codeRs, codeRc, codeLoop
						
						'response.write	"exec nusp_listAddrCodeTreeAddr " & addrIndx & ", " & grupIndx & ", " & uperRs(0, uperLoop) & ""
						
						set rs = server.createobject("adodb.recordset")
						set cmd = server.createobject("adodb.command")
						with cmd

							.activeconnection = strDBConn
							.commandtext = "nusp_listAddrCodeTreeAddr"
							.commandtype = adCmdStoredProc
							
							.parameters.append .createParameter("@addrIndx",			adInteger,	adParamInput,		0)
							.parameters.append .createParameter("@grupIndx",			adInteger,	adParamInput,		0)
							.parameters.append .createParameter("@addrCodeUper",	adInteger,	adParamInput,		0)
							
							.parameters("@addrIndx")			= addrIndx
							.parameters("@grupIndx")			= grupIndx
							.parameters("@addrCodeUper")	= uperRs(0, uperLoop)
							
							set rs = .execute
							
						end with
						set cmd = nothing
						if not rs.eof then
							codeRs = rs.getRows
							codeRc = ubound(codeRs,2)
						else
							codeRc = -1
						end if
						set rs = nothing
						
						for codeLoop = 0 to codeRc
							response.write	"		<li class=""dpth1 close "
							if codeRs(2, codeLoop) > 0 then
								response.write	" on"
							end if
							response.write	" lastGrup"" id=""grup_" & uperRs(0, uperLoop) & "_" & codeRs(0, codeLoop) & """>"
							response.write	"			<span class=""grup_name"">"
							response.write	"				<label>"
							response.write	"					<input type=""hidden"" name=""grupDpth"" value=""1"" />"
							response.write	"					<input type=""checkbox"" name=""addrCode"" value=""" & codeRs(0, codeLoop) & """"
							if codeRs(2, codeLoop) > 0 then
								response.write	" checked"
							end if
							response.write	" />"
							response.write	"					" & codeRs(1, codeLoop)
							if codeRs(3, codeLoop) > 0 then
								response.write	" <span class=""btn_radius bg_teal pdT01 pdR03 pdB01 pdL03 fnt11"">" & codeRs(3, codeLoop) & "</span>"
							end if
							response.write	"				</label>"
							response.write	"			</span>"
							response.write	"		</li>"
						next
						
						response.write	"	</ul>"
						response.write	"</div>"
						
					next
					
				end if
				%>
				
			</div>
		
		</div>
		
		<div class="aR mgT05">
			<button class="btn btn_md bg_blue" onclick="fnRelOK()">확인</button>
		</div>
		
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script type="text/javascript">
	
	$(function(){
		
		$('.tree_list li .toggle_icon').click(function(){
			fnSelGrup($(this).parent().prop('id'));
		});
		
		$('.tree_list li .grup_name').click(function(){
			var strProc;
			<% if relGubn = "G" then %>
				$('input[name=grupIndx]:not(:checked)').parent().parent().removeClass('on');
				if($(this).find('input[name=grupIndx]').prop('checked') == true){
					$(this).parent().addClass('on');
					strProc = 'A';
				}else{
					$(this).parent().removeClass('on');
					strProc = 'D';
				}
				var grupIndx	= $(this).find('input[name=grupIndx]').val();
				$.ajax({
					url	: 'ajxAddrRelProc.asp',
					type	: 'POST',
					data	: 'relGubn=<%=relGubn%>&proc=data&grupIndx='+grupIndx,
					success	: function(rslt){
						opener.fnProcRel(strProc, 'G', rslt);
					},
					fail	: function(rslt){
						alert('오류가 발생했습니다.');
					}
				});
			<% elseif relGubn = "C" then %>
				$('input[name=addrCode]:not(:checked)').parent().parent().removeClass('on');
				if($(this).find('input[name=addrCode]').prop('checked') == true){
					$(this).parent().addClass('on');
					strProc = 'A';
				}else{
					$(this).parent().removeClass('on');
					strProc = 'D';
				}
				var addrCode	= $(this).find('input[name=addrCode]').val();
				$.ajax({
					url	: 'ajxAddrRelProc.asp',
					type	: 'POST',
					data	: 'relGubn=<%=relGubn%>&proc=data&addrCode='+addrCode,
					success	: function(rslt){
						opener.fnProcRel(strProc, 'C', rslt);
					},
					fail	: function(rslt){
						alert('오류가 발생했습니다.');
					}
				});
			<% end if %>
		});
		
	});
	
	/*	Grup	*/
	function fnSelGrup(grupid){
		var nGrupID		= grupid + '_';
		var nGrupDpth	= parseInt($('#'+grupid+' input[name=grupDpth]').val()) + 1;
		var subClass	= '';
		if(!$('.tree_list li[id^='+nGrupID+'][class^=dpth'+nGrupDpth+']').eq(0).prop('class')){
			subClass	= '';
		}else{
			subClass	= $('.tree_list li[id^='+nGrupID+'][class^=dpth'+nGrupDpth+']').eq(0).prop('class');
		}
		if(subClass.indexOf('open') > 0){
			$('.tree_list li[id^='+nGrupID+']').removeClass('open');
			$('.tree_list li[id^='+nGrupID+']').addClass('close');
			$('.tree_list li[id^='+nGrupID+'] .toggle_icon i').removeClass('fa-minus-square-o');
			$('.tree_list li[id^='+nGrupID+'] .toggle_icon i').addClass('fa-plus-square-o');
			$('#'+grupid+' .toggle_icon i').removeClass('fa-minus-square-o');
			$('#'+grupid+' .toggle_icon i').addClass('fa-plus-square-o');
		}else{
			$('.tree_list li[id^='+nGrupID+'][class^=dpth'+nGrupDpth+']').removeClass('close');
			$('.tree_list li[id^='+nGrupID+'][class^=dpth'+nGrupDpth+']').addClass('open');
			$('.tree_list li[id^='+nGrupID+'] .toggle_icon i').removeClass('fa-plus-square-o');
			$('.tree_list li[id^='+nGrupID+'] .toggle_icon i').addClass('fa-minus-square-o');
			$('#'+grupid+' .toggle_icon i').removeClass('fa-plus-square-o');
			$('#'+grupid+' .toggle_icon i').addClass('fa-minus-square-o');
		}
	}
	
	function fnRelOK(){
		self.close();
	}
	
</script>