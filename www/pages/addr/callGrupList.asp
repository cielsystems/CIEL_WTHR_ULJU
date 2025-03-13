<!--#include virtual="/common/common.asp"-->

<%
mnCD = "0303"

'#	선택된 그룹 정보
dim nSelGrupIndx	: nSelGrupIndx	= fnIsNull(nFnReq("nSelGrupIndx", 0), 0)
dim nSelGrupDpth	: nSelGrupDpth	= fnIsNull(nFnReq("nSelGrupDpth", 0), 0)
dim selGrup(5)
for i = 1 to 5
	selGrup(i) = 0
next

if nSelGrupIndx > 0 then
	
	set rs = server.createobject("adodb.recordset")
	set cmd = server.createobject("adodb.command")
	with cmd

		.activeconnection = strDBConn
		.commandtext = "nusp_getGrupUpers"
		.commandtype = adCmdStoredProc
		
		.parameters.append .createParameter("@grupIndx",	adInteger,	adParamInput,		0)
		
		.parameters("@grupIndx")	= nSelGrupIndx
		
		set rs = .execute
		
	end with
	set cmd = nothing

	if not rs.eof then
		selGrup(1) = rs(1)
		selGrup(2) = rs(2)
		selGrup(3) = rs(3)
		selGrup(4) = rs(4)
		selGrup(5) = rs(5)
	end if
	set rs = nothing
	
end if
%>

<!--#include virtual="/common/header_htm.asp"-->

<div id="subPageBox">
	
	<div class="flexBox">
		
		<div class="tree_box" style="width:35%;height:500px;">
			
			<%
			dim arrGrupGubn	: arrGrupGubn	= array("C")
			
			dim grupRs, grupRc, grupLoop
			
			for i = 0 to ubound(arrGrupGubn)
			
				set rs = server.createobject("adodb.recordset")
				set cmd = server.createobject("adodb.command")
				with cmd

					.activeconnection = strDBConn
					.commandtext = "nusp_listGrupTree"
					.commandtype = adCmdStoredProc
					
					.parameters.append .createParameter("@grupGubn",	adChar,			adParamInput,		1)
					.parameters.append .createParameter("@userIndx",	adInteger,	adParamInput,		0)
					
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
					response.write	"				<input type=""hidden"" name=""grupIndx"" value=""" & grupRs(0, grupLoop) & """ />"
					response.write	"				<input type=""hidden"" name=""grupDpth"" value=""" & grupRs(1, grupLoop) & """ />"
					'response.write	"				<input type=""checkbox"" name=""grupIndx"" value=""" & grupRs(0, grupLoop) & """ />"
					response.write	"				" & grupRs(3, grupLoop)
					if grupRs(12, grupLoop) > 0 then
						response.write	" <span class=""btn_radius bg_teal pdT01 pdR03 pdB01 pdL03 fnt11"">" & grupRs(12, grupLoop) & "</span>"
					end if
					response.write	"			</span>"
					response.write	"			<span class=""grup_butn"">"
					if grupRs(11, grupLoop) = "Y" then
						if grupRs(1, grupLoop) > 0 then
							response.write	"				<a href=""javascript:fnGrup('E'," & grupRs(0, grupLoop) & ")""><i class=""fa fa-edit""></i></a>"
							response.write	"				<a href=""javascript:fnGrup('D'," & grupRs(0, grupLoop) & ")""><i class=""fa fa-close""></i></a>"
						end if
						if grupRs(1, grupLoop) < 1 then
							response.write	"				<a href=""javascript:fnGrup('A'," & grupRs(0, grupLoop) & ")""><i class=""fa fa-plus""></i></a>"
						end if
					end if
					response.write	"			</span>"
					response.write	"		</li>"
					
				next
				
				response.write	"	</ul>"
				response.write	"</div>"
				
			next
			%>
			
		</div>
		
		<div style="width:65%;padding-left:10px;">
			
			<div class="listSchBox">
			
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							
							<table align="left">
								<tr>
									<td><label>검색</label></td>
									<td>
										<select id="schKey" name="schKey">
											<option value="NAME">이름</option>
											<% for i = 1 to ubound(arrCallMedia) %>
												<option value="NUM<%=i%>"><%=arrCallMedia(i)%></option>
											<% next %>
										</select>
										<input type="text" id="schVal" name="schVal" onkeypress="if(event.keyCode==13){fnLoadPage(1)}" size="16" />
										<select id="pageSize" name="pageSize">
											<option value="10">10개</option>
											<option value="20">20개</option>
											<option value="50">50개</option>
										</select>
									</td>
									<td>
										<img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" title="검색" onclick="fnLoadPage(1)" />
									</td>
								</tr>
							</table>
								
						</td>
						<td class="aR">
							총 <b><span id="cntAll">0</span></b>건
						</td>
					</tr>
				</table>
				
			</div>
			
			<%
			arrListHeader = array("","소속","분류","이름",arrCallMedia(1),"관리")
			arrListWidth = array("30px","*","160px","80px","100px","60px")
			
			call subListTable("listTbl")
			%>
			
		</div>
		
	</div>
	
	<div class="flexBox mgT10">
		
		<div style="width:35%">
		</div>
		<div style="width:65%">
			
			<div class="flexBox">
				<div style="width:50%">
				</div>
				<div style="width:50%" class="aR">
					<button class="btn btn_sm bg_purple" onclick="fnAddrDown()">다운로드</button>
				</div>
			</div>
		</div>
		
	</div>
	
</div>

<!--#include virtual="/common/footer_htm.asp"-->

<script type="text/javascript">
	
	var page	= 1;
	var rowCnt	= 0;
	
	var nGrupIndx	= 0;
	
	$(function(){
		
		<%
		if len(selGrup(1)) > 0 then
			'response.write	"fnSelGrup('grup_" & selGrup(1) & "');"
			if len(selGrup(2)) > 0 then
				response.write	"fnSelGrup('grup_" & selGrup(1) & "_" & selGrup(2) & "');"
				if len(selGrup(3)) > 0 then
					response.write	"fnSelGrup('grup_" & selGrup(1) & "_" & selGrup(2) & "_" & selGrup(3) & "');"
					if len(selGrup(4)) > 0 then
						response.write	"fnSelGrup('grup_" & selGrup(1) & "_" & selGrup(2) & "_" & selGrup(3) & "_" & selGrup(4) & "');"
						if len(selGrup(5)) > 0 then
							response.write	"fnSelGrup('grup_" & selGrup(1) & "_" & selGrup(2) & "_" & selGrup(3) & "_" & selGrup(4) & "_" & selGrup(5) & "');"
						end if
					end if
				end if
			end if
		end if
		%>
		
		fnLoadPage(page);
		
		$('body').on('mouseover', '.codesList', function(e){
			var posX = e.pageX;
			var posY = e.pageY;
			$(this).find('.codesListBox').css({'top':posY+'px','left':posX+'px','display':'block'});
		});
		$('body').on('mouseout', '.codesList', function(e){
			$(this).find('.codesListBox').css({'display':'none'});
		});
		
		$('.tree_list li .toggle_icon').click(function(){
			fnSelGrup($(this).parent().prop('id'));
		});
		
		$('.tree_list li .grup_name').click(function(){
			$('input[name=grupIndx]:not(:checked)').parent().parent().removeClass('on');
			$(this).parent().addClass('on');
			nGrupIndx	= $(this).find('input[name=grupIndx]').val();
			fnLoadPage(1);
		});
		
		$('input[name=grupIndx]').click(function(e){
			e.stopPropagation();
			fnLoadPage(1);
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
	
	function fnGrup(proc, indx){
		var url = 'pop_grupForm.asp';
		var tit	= '';
		if(proc == 'A'){		// 추가
			url	= url + '?proc='+proc+'&grupUper='+indx;
			tit	= '그룹추가';
		}else if(proc == 'E'){		// 수정
			url	= url + '?proc='+proc+'&grupIndx='+indx;
			tit	= '그룹추가';
		}else if(proc == 'D'){		// 삭제
			url	= url + '?grupIndx='+indx;
			if(confirm('삭제하시겠습니까?')){
				$.ajax({
					url	: 'pop_grupProc.asp',
					type	: 'POST',
					async:  false,
					data	: 'proc=D&grupIndx='+indx,
					success	: function(rslt){
						var arrRslt	= rslt.split('|');
						alert(arrRslt[1]);
						if(arrRslt[0] == 0){
							fnReloadGrup(arrRslt[2], arrRslt[3]);
							//location.href = '?nSelGrupIndx='+arrRslt[2]+'&nSelGrupDpth='+arrRslt[3];
						}
					},
					fail	: function(rslt){
						alert('오류가 발생했습니다.');
					}
				});
			}
			return false;
		}
		layerW = 600;
		layerH = 580;
		fnOpenLayer(tit, url);
	}
	
	function fnReloadGrup(indx, dpth){
		location.href = 'callGrupList.asp?nSelGrupIndx='+indx+'&nSelGrupDpth='+dpth;
	}
	
	/*	Addr	*/
	function fnAddrForm(indx){
		layerW = 800;
		layerH = 600;
		fnOpenLayer('연락처관리', 'pop_addrForm.asp?addrIndx='+indx);
	}
	
	function fnAddrDown(){
		var uperCode	= '';
		var addrCode	= '';
		$('.tree_list li.dpth2 .grup_name input[name=addrCode]:checked').each(function(index){
			if(index == 0){
				uperCode	= $(this).attr('data-uper');
			}else{
				if(uperCode != $(this).attr('data-uper')){
					addrCode	= addrCode + '|';
				}else if(addrCode.length > 0){
					addrCode	= addrCode + ',';
				}
			}
			addrCode	= addrCode + $(this).val();
			uperCode	= $(this).attr('data-uper');
		});
		
		$('#listTbl tbody tr').remove();
		
		var grupIndx	= nGrupIndx;
		var schKey		= $('select[name=schKey]').val();
		var schVal		= $('input[name=schVal]').val();
		var pageSize	= $('select[name=pageSize]').val();
		
		var params	= 'listGubn=C&grupIndx='+grupIndx+'&schKey='+schKey+'&schVal='+schVal;
		
		procFrame.location.href = 'addrDown.asp?'+params;
	}
	
	function fnLoadPage(p){
		page = p;
		var uperCode	= '';
		var addrCode	= '';
		$('.tree_list li.dpth2 .grup_name input[name=addrCode]:checked').each(function(index){
			if(index == 0){
				uperCode	= $(this).attr('data-uper');
			}else{
				if(uperCode != $(this).attr('data-uper')){
					addrCode	= addrCode + '|';
				}else if(addrCode.length > 0){
					addrCode	= addrCode + ',';
				}
			}
			addrCode	= addrCode + $(this).val();
			uperCode	= $(this).attr('data-uper');
		});
		
		$('#listTbl tbody tr').remove();
		
		var grupIndx	= nGrupIndx;
		var schKey		= $('select[name=schKey]').val();
		var schVal		= $('input[name=schVal]').val();
		var pageSize	= $('select[name=pageSize]').val();
		
		var params	= 'listGubn=C&grupIndx='+grupIndx+'&schKey='+schKey+'&schVal='+schVal+'&page='+page+'&pageSize='+pageSize;
		
		$.ajax({
			url	: 'ajxAddrList.asp',
			type	: 'POST',
			data	: params,
			success	: function(rslt){
				//console.log(rslt);
				var arrRslt	= rslt.split('}|{');
				rowCnt	= arrRslt[0];
				if(rowCnt > 0){
					var arrVal, strRow, arrGrup, strGrup, arrCodes, arrCodes2, strCodes;
					for(var i = 2; i < arrRslt.length; i++){
						arrVal	= arrRslt[i].split(']|[');strGrup = '';
						
						if(arrVal[9].length > 0){
							arrGrup = arrVal[9].split('^');
							for(ii = 0; ii < arrGrup.length - 1; ii++){
								var arrSubGrup	= arrGrup[ii].split('|');
								var subGrupClass = '';
								if(arrSubGrup[0] == '직원'){
									subGrupClass = 'A';
								}else if(arrSubGrup[0] == '개인'){
									subGrupClass = 'B';
								}
								strGrup = strGrup + '<span class="type'+subGrupClass+' addrGrupItem">';
								for(iii = 1; iii < arrSubGrup.length - 1; iii++){
									strGrup = strGrup + arrSubGrup[iii] + ' > ';
								}
								strGrup = strGrup + '<strong>' + arrSubGrup[iii] + '</strong></span>';
							}
						}
						
						if(arrVal[10].length > 0){
							arrCodes = arrVal[10].split('^');
							strCodes = arrCodes[0];
							if(arrCodes.length > 1){
								strCodes = strCodes + ' <span class="fnt11 color_blue">+' + (arrCodes.length - 1) + '</span>';
							}
							if(arrCodes.length > 1){
								strCodes = strCodes + '<div class="codesListBox"><ul>';
								for(var ii = 0; ii < arrCodes.length; ii++){
									strCodes = strCodes + '<li>'+arrCodes[ii].replace(']',']<strong>')+'</strong></li>';
								}
								strCodes = strCodes + '</ul></div>';
							}
						}else{
							strCodes = '';
						}
						
						strRow = '<tr>'
						+'	<td class="aC"><input type="checkbox" name="addrIndx" value="'+arrVal[2]+'" /></td>'
						+'	<td class="aL fnt11 color_gray">'+strGrup+'</td>'
						+'	<td class="aC codesList imgBtn">'+strCodes+'</td>'
						+'	<td class="aC">'+arrVal[5]+'</td>'
						+'	<td class="aC fnt11">'+fnPrntNumb(arrVal[6])+'</td>'
						+'	<td class="aC">'
						+'		<button class="btn btn_sm bg_olive" onclick="fnAddrForm('+arrVal[2]+')">관리</button>'
						+'	</td>'
						+'</tr>';
						$('#listTbl tbody').append(strRow);
					}
				}
				$('#listPaging').html(arrRslt[1]);
				$('#cntAll').html(rowCnt);
			}
		});
	}
	
</script>