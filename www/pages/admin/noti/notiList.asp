<!--#include virtual="/common/common.asp"-->

<%
mnCD = "5001"
%>

<!--#include virtual="/common/header_adm.asp"-->

<!--#include virtual="/common/config_noti.asp"-->

<div id="subPageBox">
	
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<table align="left">
						<tr>
							<td><label>종류</label></td>
							<td>
								<select name="warnVarCode">
									<option value="">::: 전체 :::</option>
									<%
									for ntCateLoop = 0 to ntCateRc
										response.write	"<option value=""" & ntCateRs(0, ntCateLoop) & """>" & ntCateRs(1, ntCateLoop) & "</option>"
									next
									%>
								</select>
							</td>
							<td width="20px"></td>
							<td><label>단계</label></td>
							<td>
								<select name="warnStressCode"">
									<option value="">::: 전체 :::</option>
									<%
									for ntRankLoop = 0 to ntRankRc
										response.write	"<option value=""" & ntRankRs(0, ntRankLoop) & """>" & ntRankRs(1, ntRankLoop) & "</option>"
									next
									%>
								</select>
							</td>
							<td width="20px"></td>
							<td><label>코드</label></td>
							<td>
								<select name="commandCode"">
									<option value="">::: 전체 :::</option>
									<%
									for ntTypeLoop = 0 to ntTypeRc
										response.write	"<option value=""" & ntTypeRs(0, ntTypeLoop) & """>" & ntTypeRs(1, ntTypeLoop) & "</option>"
									next
									%>
								</select>
							</td>
							<td width="20px"></td>
							<td><label>지역</label></td>
							<td>
								<input type="text" id="schVal" name="schVal" onkeypress="if(event.keyCode==13){fnLoadPage(1)}" />
							</td>
							<td><img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" title="검색" onclick="fnLoadPage(1)" /></td>
						</tr>
					</table>
					
				</td>
				<td class="aR" width="180px">
					총 <b><span id="cntAll">0</span></b>건
					<img class="imgBtn" src="<%=pth_pubImg%>/btn/blue_add2.png" onclick="fnNotiForm(0)" />
				</td>
			</tr>
		</table>
	</div>
	
	<%
	arrListHeader = array("<input type=""checkbox"" name=""allChek"" value=""ruleID"" />","종류","단계","코드","지역","통보시각","전송방법","대상","자동여부","관리")
	arrListWidth = array("30px","80px","100px","100px","120px","*","200px","160px","80px","70px")
	
	call subListTable("listTbl")
	%>
	
	<div class="flexBox">
		<div class="aL" style="width:50%">
			<button class="btn btn_sm bg_purple" onclick="fnAllAuto('N')">검색전체 미사용</button>
			<button class="btn btn_sm bg_blue" onclick="fnAllAuto('Y')">검색전체 사용</button>
		</div>
		<div class="aR" style="width:50%">
			<button class="btn btn_sm bg_purple" onclick="fnSelAuto('N')">선택 미사용</button>
			<button class="btn btn_sm bg_blue" onclick="fnSelAuto('Y')">선택 사용</button>
			<button class="btn btn_sm bg_red" onclick="fnSelDel()">선택 삭제</button>
		</div>
	</div>
	
</div>

<!--#include virtual="/common/footer_adm.asp"-->

<script type="text/javascript">
	
	var page	= 1;
	var pageSize	= <%=g_pageSize%>;
	var rowCnt	= 0;
	
	$(function(){
		
		fnLoadPage(page);
		
		$('input[type=checkbox][name=allChek]').click(function(){
			var trg = $(this).val();
			if($(this).prop('checked') == true){
				$('input[type=checkbox][name='+trg+']').prop('checked', true);
			}else{
				$('input[type=checkbox][name='+trg+']').prop('checked', false);
			}
		});
		
	});
	
	function fnLoadPage(p){
		page = p;
		
		var warnVarCode			= $('select[name=warnVarCode]').val();
		var warnStressCode	= $('select[name=warnStressCode]').val();
		var commandCode			= $('select[name=commandCode]').val();
		var schKey					= $('select[name=schKey]').val();
		var schVal					= $('input[name=schVal]').val();
		
		var params	= 'warnVarCode='+warnVarCode+'&warnStressCode='+warnStressCode+'&commandCode='+commandCode+'&schKey='+schKey+'&schVal='+schVal+'&page='+page+'&pageSize='+pageSize
		
		$('#listTbl tbody tr').remove();
		
		$.ajax({
			url	: 'ajxNotiList.asp',
			type	: 'POST',
			data	: params,
			success	: function(rslt){
				//console.log(rslt);
				var arrRslt	= rslt.split('}|{');
				rowCnt	= arrRslt[0];
				if(rowCnt > 0){
					var arrVal, strRow, strTime, strTrgt;
					for(var i = 2; i < arrRslt.length; i++){
						arrVal	= arrRslt[i].split(']|[');strGrup = '';
						
						if(arrVal[9] == 0){
							strTime = '<span class="color_blue">즉시</span>';
						}else{
							strTime = '<span class="color_red">예약 ' + arrVal[9] + '분 후</span>';
						}
						
						if(arrVal[11].length > 1){
							var arrTrgt	= arrVal[11].split('|');
							strTrgt = arrTrgt[0] + '그룹 (' + arrTrgt[1] + '명)';
						}else{
							strTrgt	= '-';
						}
						
						strRow = '<tr>'
						+'	<td class="aC"><input type="checkbox" name="ruleID" value="'+arrVal[2]+'" /></td>'
						+'	<td class="aC">'+arrVal[3]+'</td>'
						+'	<td class="aC">'+arrVal[6]+'</td>'
						+'	<td class="aC">'+arrVal[7]+'</td>'
						+'	<td class="aC">'+arrVal[4]+arrVal[5]+'</td>'
						+'	<td class="aC">'+arrVal[8]+' '+strTime+'</td>'
						+'	<td class="aC">'+arrVal[10]+'</td>'
						+'	<td class="aC">'+strTrgt+'</td>'
						+'	<td class="aC">'+arrVal[12]+'</td>'
						+'	<td class="aC">'
						+'		<button class="btn btn_sm bg_olive" onclick="fnNotiForm('+arrVal[2]+')">관리</button>'
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
	
	function fnNotiForm(indx){
		layerW = 1200;
		layerH = 640;
		fnOpenLayer('통보관리', 'pop_notiForm.asp?ruleID='+indx);
	}
	
	function fnAllAuto(yn){
		var strYN = '';
		if(yn == 'N'){
			strYN = '미사용';
		}else{
			strYN = '사용';
		}
		if(confirm(rowCnt+'건의 메시지를 자동 '+strYN+'으로 변경하시겠습니까?')){
		
			var warnVarCode			= $('select[name=warnVarCode]').val();
			var warnStressCode	= $('select[name=warnStressCode]').val();
			var commandCode			= $('select[name=commandCode]').val();
			var schKey					= $('select[name=schKey]').val();
			var schVal					= $('input[name=schVal]').val();
			
			var params	= 'proc=all_'+yn+'&warnVarCode='+warnVarCode+'&warnStressCode='+warnStressCode+'&commandCode='+commandCode+'&schKey='+schKey+'&schVal='+schVal;
			
			procFrame.location.href = 'notiListProc.asp?'+params;
		}
	}
	
	function fnSelAuto(yn){
		var selCnt = $('input[name=ruleID]:checked').length;
		if(selCnt == 0){
			alert('메시지를 선택하세요.');
		}else{
			var strYN = '';
			if(yn == 'N'){
				strYN = '미사용';
			}else{
				strYN = '사용';
			}
			if(confirm('선택한 '+selCnt+'건의 메시지를 자동 '+strYN+'으로 변경하시겠습니까?')){
				
				var ruleID = '';
				$('input[name=ruleID]:checked').each(function(){
					if(ruleID.length > 0){
						ruleID = ruleID + ',';
					}
					ruleID = ruleID + $(this).val();
				});
				var params	= 'proc=sel_'+yn+'&ruleID='+ruleID;
				
				procFrame.location.href = 'notiListProc.asp?'+params;
			}
		}
	}
	
	function fnSelDel(){
		var selCnt = $('input[name=ruleID]:checked').length;
		if(selCnt == 0){
			alert('메시지를 선택하세요.');
		}else{
			if(confirm('선택한 '+selCnt+'건의 메시지를 삭제 하시겠습니까?\n삭제된 메시지는 복구가 불가합니다.')){
				
				var ruleID = '';
				$('input[name=ruleID]:checked').each(function(){
					if(ruleID.length > 0){
						ruleID = ruleID + ',';
					}
					ruleID = ruleID + $(this).val();
				});
				var params	= 'proc=sel_D&ruleID='+ruleID;
				
				procFrame.location.href = 'notiListProc.asp?'+params;
			}
		}
	}
	
</script>