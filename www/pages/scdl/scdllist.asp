<!--#include virtual="/common/common.asp"-->

<% mnCD = "0501" %>

<!--#include virtual="/common/header_htm.asp"-->

<div id="subPageBox">
	
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<table align="left">
						<tr>
							<td><label>검색</label></td>
							<td>
								<select name="schKey">
									<option value="TIT">제목</option>
								</select>
								<input type="text" id="schVal" name="schVal" onkeypress="if(event.keyCode==13){fnLoadPage(1)}" />
							</td>
							<td><img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" title="검색" onclick="fnLoadPage(1)" /></td>
						</tr>
					</table>
						
				</td>
				<td class="aR">
					총 <b><span id="cntAll">0</span></b>건
					<img class="imgBtn" src="<%=pth_pubImg%>/btn/blue_add2.png" onclick="fnScdlForm(0)" />
				</td>
			</tr>
		</table>
	</div>
	
	<%
	arrListHeader = array("제목","설정","기간","전송방법","대상","상태","관리")
	arrListWidth = array("*","160px","220px","140px","120px","70px","70px")
	
	call subListTable("listTbl")
	%>
	
</div>

<!--#include virtual="/common/footer_htm.asp"-->

<script>
	
	var arrWeek	= ['일','월','화','수','목','금','토'];
	
	var page = 1;
	var pageSize = 10;
	var rowCnt = 0;
	
	$(function(){
		
		fnLoadPage(1);
		
	});
	
	function fnLoadPage(p){
		page = p;
		var param = 'schKey='+$('select[name=schKey]').val()+'&schVal='+$('input[name=schVal]').val()+'&page='+page+'&pageSize='+pageSize;
		param = encodeURI(param);
		var list = fnGetHttp('ajxScdlList.asp?'+param);
		var arrList = list.split('}|{');
		rowCnt = arrList[0];
		$('#cntAll').html(rowCnt);
		$('#listTbl tbody tr').remove();
		if(rowCnt > 0){
			var strRow, arrVal, scdlGubn, strScdl, scdlStat, strTrgt;
			for(i = 2; i < arrList.length; i++){
				arrVal = arrList[i].split(']|[');
				
				if(arrVal[3] == 'E'){
					scdlGubn = '<span class="color_red">비상발령</span>';
				}else{
					scdlGubn = '<span class="color_green">일반문자</span>';
				}
				
				strScdl = '';
				if(arrVal[4] == 'H'){
					strScdl	= strScdl	+ '<b>' +arrVal[5] + '시간</b> 마다';
				}else if(arrVal[4] == 'D'){
					strScdl	= strScdl	+ '<b>' +arrVal[5] + '일</b> 마다';
				}else if(arrVal[4] == 'W'){
					strScdl	= strScdl	+ '<b>매주 ' +arrWeek[arrVal[5]] + '요일</b> 마다';
				}else if(arrVal[4] == 'M'){
					strScdl	= strScdl	+ '<b>매월 ' +arrVal[5] + '일</b> 마다';
				}
				
				if(arrVal[8] == '0'){
					scdlStat = '<span class="color_blue">사용중</span>';
				}else{
					scdlStat = '<span class="color_gray">중지</span>';
				}
				
				if(arrVal[11].length > 1){
					var arrTrgt	= arrVal[11].split('|');
					strTrgt = arrTrgt[0] + '그룹 (' + arrTrgt[1] + '명)';
				}else{
					strTrgt	= '-';
				}
				
				strRow = '<tr>'
				+'	<td class="aL">'+arrVal[9]+'</td>'
				+'	<td class="aC">'+strScdl+' 반복</td>'
				+'	<td class="aC fnt11">'+arrVal[6] + ' ~ ' + arrVal[7]+'</td>'
				+'	<td class="aC">'+arrVal[10]+'</td>'
				+'	<td class="aC">'+strTrgt+'</td>'
				+'	<td class="aC">'+scdlStat+'</td>'
				+'	<td class="aC"><button class="btn btn_sm bg_olive" onclick="fnScdlForm('+arrVal[2]+')">관리</button></td>'
				+'</tr>';
				$('#listTbl tbody').append(strRow);
			}
		}
		$('#listPaging').html(arrList[1]);
	}
	
	function fnScdlForm(indx){
		layerW = 1200;
		layerH = 640;
		fnOpenLayer('스케줄관리', 'pop_scdlForm.asp?scdlIndx='+indx);
	}
	
</script>