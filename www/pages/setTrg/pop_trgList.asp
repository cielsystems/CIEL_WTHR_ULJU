<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<%
dim clGB : clGB = fnReq("clGB")
%>

<div id="popBody">
	
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<table align="left">
						<tr>
							<td><label>검색</label></td>
							<td>
								<select id="schKey" name="schKey">
									<option value="NM">이름</option>
									<option value="NUM">번호</option>
								</select>
								<input type="text" id="schVal" name="schVal" onkeypress="if(event.keyCode==13){fnLoadPage(1)}" />
							</td>
							<td><img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch.png" title="검색" onclick="fnLoadPage(1)" /></td>
						</tr>
					</table>
						
				</td>
				<td class="aR">
					총 <b><span id="cntAll">0</span></b>명
					<img class="imgBtn" src="<%=pth_pubImg%>/btn/red_allDel.png" onclick="fntmpTrgAllDel()" />
				</td>
			</tr>
		</table>
	</div>
	
	<%
	arrListHeader = array("<input type=""checkbox"" name=""allChek"" value=""addrIndx"" />","소속","분류","이름",arrCallMedia(1),"관리")
	arrListWidth = array("30px","*","160px","80px","100px","60px")
	
	call subListTable("listTbl")
	%>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	var page = 1;
	var pageSize = 10;
	var rowCnt = 0;
	
	$(function(){
		
		fnLoadPage(1);
		
	});
	
	function fnLoadPage(p){
		page = p;
		
		$('#listTbl tbody tr').remove();
		
		var schKey		= $('select[name=schKey]').val();
		var schVal		= $('input[name=schVal]').val();
		
		var params	= 'schKey='+schKey+'&schVal='+schVal+'&page='+page+'&pageSize='+pageSize
		
		$.ajax({
			url	: 'ajxTrgtList.asp',
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
						
						if(arrVal[8].length > 0){
							arrGrup = arrVal[8].split('^');
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
						
						if(arrVal[9].length > 0){
							arrCodes = arrVal[9].split('^');
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
						+'	<td class="aC"><input type="checkbox" name="tmpNo" value="'+arrVal[2]+'" /></td>'
						+'	<td class="aL fnt11">'+strGrup+'</td>'
						+'	<td class="aC codesList imgBtn">'+strCodes+'</td>'
						+'	<td class="aC">'+arrVal[4]+'</td>'
						+'	<td class="aC fnt11">'+fnPrntNumb(arrVal[5])+'</td>'
						+'	<td class="aC">'
						+'		<button class="btn btn_sm bg_red" onclick="fnTmpTrgDel('+arrVal[2]+')">제외</button>'
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
	
	function fnTmpTrgDel(no){
		popProcFrame.location.href = 'pop_trgDetail_proc.asp?clGB=<%=clGB%>&proc=trgDel&tmpNo='+no;
	}
	
	function fntmpTrgAllDel(){
		popProcFrame.location.href = 'pop_trgDetail_proc.asp?clGB=<%=clGB%>&proc=trgAllDel';
	}
	
</script>