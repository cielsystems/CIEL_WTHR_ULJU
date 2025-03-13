<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<!--#include virtual="/common/config_noti.asp"-->

<%
dim ruleID	: ruleID	= fnIsNull(nFnReq("ruleID", 0), 0)
%>

<div id="popBody">
	
	<div id="popupBox">
		
		<h3>대상목록</h3>
		
		<div id="popupCont">
		
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
			arrListHeader = array("소속","분류","이름","휴대폰")
			arrListWidth = array("*","200px","100px","120px")
			
			call subListTable("listTbl")
			%>
		
		</div>
		
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script type="text/javascript">
	
	var page = 1;
	var rowCnt	= 0;
	
	$(function(){
		
		fnLoadPage(page);
		
		$('body').on('mouseover', '.codesList', function(e){
			var posX = e.pageX;
			var posY = e.pageY;
			$(this).find('.codesListBox').css({'top':posY+'px','left':posX+'px','display':'block'});
		});
		$('body').on('mouseout', '.codesList', function(e){
			$(this).find('.codesListBox').css({'display':'none'});
		});
		
	});
	
	function fnLoadPage(p){
		page = p;
		
		var schKey					= $('select[name=schKey]').val();
		var schVal					= $('input[name=schVal]').val();
		var pageSize	= $('select[name=pageSize]').val();
		
		var params	= 'ruleID=<%=ruleID%>&schKey='+schKey+'&schVal='+schVal+'&page='+page+'&pageSize='+pageSize
		
		$('#listTbl tbody tr').remove();
		
		$.ajax({
			url	: 'ajxNotiTrgtList.asp',
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
						+'	<td class="aL fnt11">'+strGrup+'</td>'
						+'	<td class="aC codesList imgBtn">'+strCodes+'</td>'
						+'	<td class="aC">'+arrVal[5]+'</td>'
						+'	<td class="aC fnt11">'+fnPrntNumb(arrVal[6])+'</td>'
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