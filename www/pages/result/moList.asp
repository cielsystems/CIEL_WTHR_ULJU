<!--#include virtual="/common/common.asp"-->

<% mnCD = "0205" %>

<!--#include virtual="/common/header_htm.asp"-->

<%
dim schSDate : schSDate = dateserial(year(date),month(date),1)
dim schEDate : schEDate = dateadd("d",7,date)
%>

<div id="subPageBox">
	
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<table align="left">
						<tr>
							<td><label>기간</label></td>
							<td colspan="7">
								<input type="text" id="schSDate" name="schSDate" value="<%=schSDate%>" size="10" readonly />
								<img class="calBtn" src="<%=pth_pubImg%>/icons/calendar-select.png" title="달력" /> ~
								<input type="text" id="schEDate" name="schEDate" value="<%=schEDate%>" size="10" readonly />
								<img class="calBtn" src="<%=pth_pubImg%>/icons/calendar-select.png" title="달력" />
							</td>
							<td><label>검색</label></td>
							<td>
								<select id="schKey" name="schKey">
									<option value="SendMember">발신번호</option>
									<option value="Massage">내용</option>
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
	arrListHeader = array("발신번호","수신일시","내용")
	arrListWidth = array("160px","300px","*")
	
	call subListTable("listTbl")
	%>
	
</div>

<!--#include virtual="/common/footer_htm.asp"-->

<script>
	
	var page = 1;
	var pageSize = 10;
	var rowCnt = 0;
	
	$(function(){
		
		fnLoadPage(1);
		
	});
	
	function fnLoadPage(p){
		page = p;
		var param = 'proc=MoList&param='+$('#schSDate').val()+']|['+$('#schEDate').val()+']|['+$('#schKey').val()+']|['+$('#schVal').val()+'&page='+page+'&pageSize='+pageSize;
		param = encodeURI(param);
		var list = fnGetHttp('/pages/public/ajxList.asp?'+param);
		var arrList = list.split('}|{');
		rowCnt = arrList[0];
		$('#cntAll').html(rowCnt);
		$('#listTbl tbody tr').remove();
		if(rowCnt > 0){
			var strRow, arrVal, clStep;
			for(i = 2; i < arrList.length; i++){
				arrVal = arrList[i].split(']|[');
				//	Msg_idx(2), SendMember(3), CreateDT(4), RecvNumber(5), Massage(6), RecvDate(7)
				strRow = '<tr>'
				+'	<td class="aC">'+arrVal[3]+'</td>'
				+'	<td class="aC">'+arrVal[4]+' <span class="fnt11 colGray">('+arrVal[7]+')</span></td>'
				+'	<td class="aC fnt11 colGray">'+arrVal[6]+'</td>'
				+'</tr>';
				$('#listTbl tbody').append(strRow);
			}
		}
		$('#listPaging').html(arrList[1]);
	}
	
</script>