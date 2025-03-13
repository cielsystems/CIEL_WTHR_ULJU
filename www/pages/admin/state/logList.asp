<!--#include virtual="/common/common.asp"-->

<% mnCD = "3003" %>

<!--#include virtual="/common/header_adm.asp"-->

<div id="subPageBox">
	
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<table align="left">
						<tr>
							<td><label>구분</label></td>
							<td>
								<% call subCodeSelet(80, "cdLogGB", "") %>
							</td>
							<td></td>
							<td><label>검색</label></td>
							<td>
								<select id="schKey" name="schKey">
									<option value="id">ID</option>
									<option value="nm">이름</option>
									<option value="tit">로그</option>
								</select>
								<input type="text" id="schVal" name="schVal" onkeypress="if(event.keyCode==13){fnLoadPage(1)}" />
							</td>
							<td><img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" title="검색" onclick="fnLoadPage(1)" /></td>
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
	arrListHeader = array("구분","로그","사용자","IP","일시")
	arrListWidth = array("100px","*","180px","100px","160px")
	
	call subListTable("listTbl")
	%>
	
</div>

<!--#include virtual="/common/footer_adm.asp"-->

<script>
	
	var page = 1;
	var pageSize = 10;
	var rowCnt = 0;
	
	$(function(){
		
		fnLoadPage(1);
		
	});
	
	function fnLoadPage(p){
		page = p;
		var cdLogGB = $('#cdLogGB').val();
		if(cdLogGB == ''){cdLogGB = 0;}
		var param = 'proc=logList&param='+cdLogGB+']|['+$('#schKey').val()+']|['+$('#schVal').val()+'&page='+page+'&pageSize='+pageSize;
		param = encodeURI(param);
		var list = fnGetHttp('/pages/public/ajxList.asp?'+param);
		var arrList = list.split('}|{');
		rowCnt = arrList[0];
		$('#cntAll').html(rowCnt);
		$('#listTbl tbody tr').remove();
		if(rowCnt > 0){
			var strRow, arrVal;
			for(i = 2; i < arrList.length; i++){
				arrVal = arrList[i].split(']|[');
				//	LOG_IDX(2), CDLOGGBNM(3), LOG_TIT(4), AD_IDX(5), AD_ID(6), AD_NM(7), LOG_IP(8), LOG_DT(9)
				strRow = '<tr>'
				+'	<td class="aC">'+arrVal[3]+'</td>'
				+'	<td class="aL">'+arrVal[4]+'</td>'
				+'	<td class="aC">'+arrVal[6]+'<span class="fnt11 colBlue">('+arrVal[7]+')</span></td>'
				+'	<td class="aC">'+arrVal[8]+'</td>'
				+'	<td class="aC fnt11">'+arrVal[9]+'</td>'
				+'</tr>';
				$('#listTbl tbody').append(strRow);
			}
		}
		$('#listPaging').html(arrList[1]);
	}

</script>