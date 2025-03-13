<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<!--#include virtual="/common/config_noti.asp"-->

<%
dim scdlIndx	: scdlIndx	= fnIsNull(fnReq("scdlIndx"), 0)
%>

<div id="popBody">
	
	<div id="popupBox">
		
		<h3>대상그룹설정</h3>
		
		<div id="popupCont">
			
			<div class="tree_box" style="height:400px;">
				
				<%
				dim arrGrupGubn	: arrGrupGubn	= array("D", "P", "C")
				
				dim grupRs, grupRc, grupLoop
				
				for i = 0 to ubound(arrGrupGubn)
				
					set rs = server.createobject("adodb.recordset")
					set cmd = server.createobject("adodb.command")
					with cmd

						.activeconnection = strDBConn
						.commandtext = "nusp_listGrupTreeScdl"
						.commandtype = adCmdStoredProc
						
						.parameters.append .createParameter("@grupGubn",	adChar,			adParamInput,		1)
						.parameters.append .createParameter("@userIndx",	adInteger,	adParamInput,		0)
						.parameters.append .createParameter("@scdlIndx",	adInteger,	adParamInput,		0)
						
						.parameters("@grupGubn")	= arrGrupGubn(i)
						.parameters("@userIndx")	= ss_userIndx
						.parameters("@scdlIndx")	= scdlIndx
						
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
						response.write	"				<input type=""hidden"" name=""grupDpth"" value=""" & grupRs(1, grupLoop) & """ />"
						response.write	"				<input type=""hidden"" name=""grupName"" value=""" & grupRs(3, grupLoop) & """ />"
						response.write	"				<input type=""hidden"" name=""grupAddr"" value=""" & grupRs(13, grupLoop) & """ />"
						if grupRs(1, grupLoop) = 0 then
							response.write	"				<input type=""hidden"" name=""grupIndx"" value=""" & grupRs(0, grupLoop) & """ />"
						else
							response.write	"				<input type=""checkbox"" name=""grupIndx"" value=""" & grupRs(0, grupLoop) & """"
							if grupRs(12, grupLoop) > 0 then
								response.write	" checked"
							end if
							if grupRs(11, grupLoop) = "N" then
								response.write	" readonly disabled"
							end if
							response.write	" />"
						end if
						response.write	"				" & grupRs(3, grupLoop) & ""
						if grupRs(13, grupLoop) > 0 then
							response.write	" <span class=""btn_radius bg_teal pdT01 pdR03 pdB01 pdL03 fnt11"">" & grupRs(13, grupLoop) & "</span>"
						end if
						response.write	"				</label>"
						response.write	"			</span>"
						response.write	"			<span class=""grup_butn"">"
						'if grupRs(11, grupLoop) = "Y" then
						'	if grupRs(1, grupLoop) > 0 then
						'		response.write	"				<a href=""javascript:fnGrup('E'," & grupRs(0, grupLoop) & ")""><i class=""fa fa-edit""></i></a>"
						'		response.write	"				<a href=""javascript:fnGrup('D'," & grupRs(0, grupLoop) & ")""><i class=""fa fa-close""></i></a>"
						'	end if
						'	if grupRs(1, grupLoop) < 5 then
						'		response.write	"				<a href=""javascript:fnGrup('A'," & grupRs(0, grupLoop) & ")""><i class=""fa fa-plus""></i></a>"
						'	end if
						'end if
						'response.write	"				<label><input type=""radio"" name=""applyWorkingHour_" & grupRs(0, grupLoop) & """ value=""Y"""
						'if grupRs(13, grupLoop) = "Y" then
						'	response.write	" checked "
						'end if
						'response.write	" />적용</label>"
						'response.write	"				<label><input type=""radio"" name=""applyWorkingHour_" & grupRs(0, grupLoop) & """ value=""N"""
						'if grupRs(13, grupLoop) = "N" then
						'	response.write	" checked "
						'end if
						'response.write	" />무시</label>"
						response.write	"			</span>"
						response.write	"		</li>"
						
					next
					
					response.write	"	</ul>"
					response.write	"</div>"
				
				next
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
			$('input[name=grupIndx]:not(:checked)').parent().parent().removeClass('on');
			if($(this).find('input[name=grupIndx]').prop('checked') == true){
				$(this).parent().addClass('on');
				strProc = 'A';
			}else{
				$(this).parent().removeClass('on');
				strProc = 'D';
			}
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
		}else{
			$('.tree_list li[id^='+nGrupID+'][class^=dpth'+nGrupDpth+']').removeClass('close');
			$('.tree_list li[id^='+nGrupID+'][class^=dpth'+nGrupDpth+']').addClass('open');
			$('#'+grupid+' .toggle_icon i').removeClass('fa-plus-square-o');
			$('#'+grupid+' .toggle_icon i').addClass('fa-minus-square-o');
		}
	}
	
	function fnRelOK(){
		opener.fnTrgtGrupReset();
		$('input[name=grupIndx]:checked').each(function(){
			var prnt = $(this).parent().parent();
			var args	= $(this).val()
			+']|['+prnt.find('input[name=grupName]').val()
			+']|['+prnt.find('input[name=grupAddr]').val()
			+']|['+$('input[name=applyWorkingHour_'+$(this).val()+']:checked').val();
			opener.fnTrgtGrupProc('add', args);
		});
		self.close();
	}
	
</script>