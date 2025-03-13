<!--#include virtual="/common/common.asp"-->

<%
dim clGB	: clGB	= fnReq("clGB")
dim tabNo	: tabNo	= fnReq("tabNo")
%>

<!--#include virtual="/common/header_pop.asp"-->

<div class="flexBox">
	
	<div class="tree_box" style="width:25%;height:500px;">
		
		<%
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
			response.write	"					<input type=""checkbox"" name=""addrCodeUper"" value=""" & uperRs(0, uperLoop) & """ />"
			if uperRs(2, uperLoop) = "A" then
				response.write	" <span class=""color_green"">[공용]</span>"
			elseif uperRs(2, uperLoop) = "P" then
				response.write	" <span class=""color_purple"">[개인]</span>"
			end if
			response.write	"					" & uperRs(1, uperLoop) & "</label>"
			response.write	"			</span>"
			'response.write	"			<span class=""grup_butn"">"
			'if uperRs(3, uperLoop) = "Y" then
			'	response.write	"				<a href=""javascript:fnGrup('E'," & uperRs(0, uperLoop) & ")""><i class=""fa fa-edit""></i></a>"
			'	response.write	"				<a href=""javascript:fnGrup('D'," & uperRs(0, uperLoop) & ")""><i class=""fa fa-close""></i></a>"
			'	response.write	"				<a href=""javascript:fnGrup('A'," & uperRs(0, uperLoop) & ")""><i class=""fa fa-plus""></i></a>"
			'end if
			'response.write	"			</span>"
			response.write	"		</li>"
			
			dim codeRs, codeRc, codeLoop
			
			set rs = server.createobject("adodb.recordset")
			set cmd = server.createobject("adodb.command")
			with cmd

				.activeconnection = strDBConn
				.commandtext = "nusp_listAddrCode"
				.commandtype = adCmdStoredProc
				
				.parameters.append .createParameter("@userIndx",			adInteger,	adParamInput,		0)
				.parameters.append .createParameter("@addrCodeUper",	adInteger,	adParamInput,		0)
				
				.parameters("@userIndx")			= ss_userIndx
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
				response.write	" lastGrup"" id=""grup_" & uperRs(0, uperLoop) & "_" & codeRs(0, codeLoop) & """>" & vbcrlf
				response.write	"			<a class=""toggle_icon"">&nbsp;&nbsp;</a>" & vbcrlf
				response.write	"			<span class=""grup_name"">" & vbcrlf
				response.write	"				<label>" & vbcrlf
				response.write	"					<input type=""hidden"" name=""grupDpth"" value=""1"" />" & vbcrlf
				response.write	"					<input type=""checkbox"" name=""addrCode"" value=""" & codeRs(0, codeLoop) & """ data-uper=""" & uperRs(0, uperLoop) & """ />" & vbcrlf
				response.write	"					" & codeRs(1, codeLoop) & "" & vbcrlf
				if codeRs(4, codeLoop) > 0 then
					response.write	" <span class=""btn_radius bg_teal pdT01 pdR03 pdB01 pdL03 fnt11"">" & codeRs(4, codeLoop) & "</span>" & vbcrlf
				end if
				response.write	"				</label>" & vbcrlf
				response.write	"			</span>" & vbcrlf
				'response.write	"			<span class=""grup_butn"">"
				'if codeRs(3, codeLoop) = "Y" then
				'	response.write	"				<a href=""javascript:fnGrup('E'," & codeRs(0, codeLoop) & ")""><i class=""fa fa-edit""></i></a>"
				'	response.write	"				<a href=""javascript:fnGrup('D'," & codeRs(0, codeLoop) & ")""><i class=""fa fa-close""></i></a>"
				'end if
				'response.write	"			</span>"
				response.write	"		</li>" & vbcrlf
			next
			
			response.write	"	</ul>"
			response.write	"</div>"
			
		next
		%>
		
		<!--
		<div class="tree_block">
			<ul class="tree_list">
				<li class="dpth0">
					<span class="grup_name">
						<label>
							<input type="checkbox" name="addrCodeUper" value="NC" />
							분류없음
						</label>
					</span>
				</li>
			</ul>
		</div>
		-->
		
	</div>
	
	<div style="width:75%;padding-left:10px;height:500px;overflow-x:hidden;overflow-y:scroll;">
		
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
		arrListHeader = array("<input type=""checkbox"" name=""allChek"" value=""addrIndx"" />","소속","분류","이름",arrCallMedia(1),arrCallMedia(2),arrCallMedia(3),"관리")
		arrListWidth = array("30px","*","160px","80px","100px","100px","100px","40px")
		
		call subListTable("listTbl")
		%>
		
	</div>
	
</div>

<div class="flexBox mgT10">
	
	<div style="width:25%">
		<button class="btn btn_sm bg_orange" onclick="fnCodeSelAddTrg()">선택분류추가</button>
	</div>
	<div style="width:75%" class="aR">
		<button class="btn btn_sm bg_purple" onclick="fnAddrSelAddTrg()">선택연락처추가</button>
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	var page	= 1;
	var rowCnt	= 0;
	
	var nGrupIndx	= 0;
	
	$(function(){
		
		parent.tabsFrame3.location.href = 'pop_trgDetail_callGrup.asp?clGB=<%=clGB%>&tabNo=3';
		
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
		
		$('.tree_list li.dpth0  input[name=addrCodeUper]').click(function(){
			if($(this).val() == 'NC'){
				nGrupIndx = 'NC';
				$('input[name=addrCodeUper]').parent().parent().parent().removeClass('on');
				$('input[name=addrCodeUper]').prop('checked', false);
				$('input[name=addrCode]').parent().parent().parent().removeClass('on');
				$('input[name=addrCode]').prop('checked', false);
				$(this).prop('checked', true);
				$(this).parent().parent().parent().addClass('on');
			}else{
				$('input[name=addrCodeUper][value=NC]').prop('checked', false);
				$('input[name=addrCodeUper][value=NC]').parent().parent().parent().removeClass('on');
				nGrupIndx = 0;
				var nCode	= $(this).val();
				if($(this).prop('checked') == true){
					$(this).parent().parent().parent().addClass('on');
					$('.tree_list li[id^=grup_'+nCode+'_]').addClass('on');
					$('.tree_list li[id^=grup_'+nCode+'_] input[name=addrCode]').prop('checked', true);
				}else{
					$(this).parent().parent().parent().removeClass('on');
					$('.tree_list li[id^=grup_'+nCode+'_]').removeClass('on');
					$('.tree_list li[id^=grup_'+nCode+'_] input[name=addrCode]').prop('checked', false);
				}
			}
			fnLoadPage(1);
		});
		
		$('.tree_list li.dpth1 input[name=addrCode]').click(function(e){
			$('input[name=addrCodeUper][value=NC]').prop('checked', false);
			$('input[name=addrCodeUper][value=NC]').parent().parent().parent().removeClass('on');
			nGrupIndx = 0;
			if($(this).prop('checked') == true){
				$(this).parent().parent().parent().addClass('on');
			}else{
				$(this).parent().parent().parent().removeClass('on');
			}
			fnLoadPage(1);
			e.stopPropagation();
		});
		
		$('input[type=checkbox][name=allChek]').click(function(){
			var trg = $(this).val();
			if($(this).prop('checked') == true){
				$('input[type=checkbox][name='+trg+']').prop('checked', true);
			}else{
				$('input[type=checkbox][name='+trg+']').prop('checked', false);
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
			$('#'+grupid+' .toggle_icon i').removeClass('fa-minus-square-o');
			$('#'+grupid+' .toggle_icon i').addClass('fa-plus-square-o');
		}else{
			$('.tree_list li[id^='+nGrupID+'][class^=dpth'+nGrupDpth+']').removeClass('close');
			$('.tree_list li[id^='+nGrupID+'][class^=dpth'+nGrupDpth+']').addClass('open');
			$('#'+grupid+' .toggle_icon i').removeClass('fa-plus-square-o');
			$('#'+grupid+' .toggle_icon i').addClass('fa-minus-square-o');
		}
	}
	
	function fnLoadPage(p){
		page = p;
		var uperCode	= '';
		var addrCode	= '';
		$('.tree_list li.dpth1 .grup_name input[name=addrCode]:checked').each(function(index){
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
		
		var listGubn = 'A';
		if(grupIndx == 'NC'){
			listGubn = 'NA';
			grupIndx = 0;
		}
		
		var params	= 'listGubn='+listGubn+'&addrCode='+addrCode+'&schKey='+schKey+'&schVal='+schVal+'&page='+page+'&pageSize='+pageSize;
		
		
		$.ajax({
			url	: '/pages/addr/ajxAddrList.asp',
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
						
						if(arrVal[12] == 'N'){
							strRow = '<tr>'
							+'	<td class="aC"><input type="checkbox" name="addrIndx" value="'+arrVal[2]+'" /></td>'
							+'	<td class="aL fnt11">'+strGrup+'</td>'
							+'	<td class="aC codesList imgBtn">'+strCodes+'</td>'
							+'	<td class="aC">'+arrVal[5]+'</td>'
							+'	<td class="aC fnt11">'+fnPrntNumb(arrVal[6])+'</td>'
							+'	<td class="aC fnt11">'+fnPrntNumb(arrVal[7])+'</td>'
							+'	<td class="aC fnt11">'+fnPrntNumb(arrVal[8])+'</td>'
							+'	<td class="aC">'
							+'		<a href="javascript:fnAddrToggleAdd('+arrVal[2]+')"><img class="imgBtn" src="<%=pth_pubImg%>/icons/plus.png" /></a>'
							+'	</td>'
							+'</tr>';
						}else if(arrVal[12] == 'Y'){
							strRow = '<tr style="background-color:#eee;">'
							+'	<td class="colGray aC"><input type="checkbox" name="addrIndx" value="'+arrVal[2]+'" /></td>'
							+'	<td class="colGray aL fnt11">'+strGrup+'</td>'
							+'	<td class="colGray aC codesList imgBtn">'+strCodes+'</td>'
							+'	<td class="colGray aC">'+arrVal[5]+'</td>'
							+'	<td class="colGray aC fnt11">'+fnPrntNumb(arrVal[6])+'</td>'
							+'	<td class="colGray aC fnt11">'+fnPrntNumb(arrVal[7])+'</td>'
							+'	<td class="colGray aC fnt11">'+fnPrntNumb(arrVal[8])+'</td>'
							+'	<td class="colGray aC">'
							+'		<a href="javascript:fnAddrToggleDel('+arrVal[2]+')"><img class="imgBtn" src="<%=pth_pubImg%>/icons/minus.png" /></a>'
							+'	</td>'
							+'</tr>';
						}
						$('#listTbl tbody').append(strRow);
					}
				}
				$('#listPaging').html(arrRslt[1]);
				$('#cntAll').html(rowCnt);
			}
		});
	}
	
	var trgAddrCode	= '';
	var trgAddrIndx	= '';
	
	function fnCodeSelAddTrg(){
		var proc = 'addSelCode';
		trgGrupIndx = '';
		$('input[name=addrCode]:checked').each(function(){
			if(trgAddrCode.length > 0){
				trgAddrCode = trgAddrCode + ',';
			}
			trgAddrCode = trgAddrCode + $(this).val();
		});
		if(trgAddrCode.length > 0){
			fnTrgProc(proc);
		}else{
			alert('그룹을 선택하세요.');return false;
		}
	}
	
	function fnAddrSelAddTrg(){
		var proc = 'addSelAddr';
		trgAddrIndx = '';
		$('input[name=addrIndx]:checked').each(function(){
			if(trgAddrIndx.length > 0){
				trgAddrIndx = trgAddrIndx + ',';
			}
			trgAddrIndx = trgAddrIndx + $(this).val();
		});
		if(trgAddrIndx.length > 0){
			fnTrgProc(proc);
		}else{
			alert('연락처를 선택하세요.');return false;
		}
	}
	
	function fnAddrToggleAdd(indx){
		var proc = 'addAddr';
		trgAddrIndx	= indx;
		fnTrgProc(proc);
	}
	
	function fnAddrToggleDel(indx){
		var proc = 'delAddr';
		trgAddrIndx	= indx;
		fnTrgProc(proc);
	}
	
	function fnTrgProc(proc){
		top.fnLoadingS();
		$.ajax({
			url	: 'pop_trgDetail_proc.asp',
			type	: 'POST',
			data	: 'clGB=<%=clGB%>&proc='+proc+'&addrCode='+trgAddrCode+'&addrIndx='+trgAddrIndx,
			success	: function(rslt){
				console.log(rslt);
				var arrRslt	= rslt.split('|');
				if(arrRslt[0] == 0){
					<% if clGB = "E" or clGB = "W" then %>
						top.trgCnt = arrRslt[3];
						top.fnTargetMsg();
					<% end if %>
					top.fnLoadingE();
					top.fnLoadTrg();
					if(proc == 'addSelGrup' || proc == 'addSelAddr' || proc == 'addAllStaf' || proc == 'addAddr' || proc == 'addSelCode' || proc == 'addSelCallGrup'){
						if(confirm('요청하신 ' + arrRslt[1]+'건중 ' + arrRslt[2] + '건의 전송대상이 추가되었습니다.\n전송대상을 더 추가하시겠습니까?\n(중복, 번호오류 등 제외)')){
							fnLoadPage(1);
						}else{
							top.fnCloseLayer();
						}
					}else if(proc == 'delAddr'){
						alert('전송대상이 삭제되었습니다.');
						fnLoadPage(1);
					}
				}else{
					alert('오류가 발생했습니다.('+arrRslt+')');
				}
			},
			fail	: function(rslt){
				alert('오류가 발생했습니다.');
			}
		});
	}
	
</script>