<!--#include virtual="/common/common.asp"-->

<%
mnCD = "5002"
%>

<!--#include virtual="/common/header_adm.asp"-->

<!--#include virtual="/common/config_noti.asp"-->

<%
dim schSDate : schSDate = dateserial(year(date),month(date),1)
dim schEDate : schEDate = dateadd("d",0,date)
%>

<div id="subPageBox">
	
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<table align="left">
						<tr>
							<td><label>기간</label></td>
							<td>
								<input type="text" id="schSDate" name="schSDate" value="<%=schSDate%>" size="10" readonly />
								<img class="calBtn" src="<%=pth_pubImg%>/icons/calendar-select.png" title="달력" /> ~
								<input type="text" id="schEDate" name="schEDate" value="<%=schEDate%>" size="10" readonly />
								<img class="calBtn" src="<%=pth_pubImg%>/icons/calendar-select.png" title="달력" />
							</td>
							<td width="20px"></td>
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
							<td><label>검색</label></td>
							<td>
								<select name="schKey">
									<option value="areaName">지역</option>
								</select>
								<input type="text" id="schVal" name="schVal" onkeypress="if(event.keyCode==13){fnLoadPage(1)}" />
							</td>
							<td><img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" title="검색" onclick="fnLoadPage(1)" /></td>
						</tr>
					</table>
					
				</td>
				<td class="aR" width="180px">
					총 <b><span id="cntAll">0</span></b>건
				</td>
			</tr>
		</table>
	</div>
	
	<%
	arrListHeader = array("발표일시","발효일시","종류","단계","코드","지역")
	arrListWidth = array("140px","140px","100px","100px","100px","160px","*")
	
	call subListTable("listTbl")
	%>
	
</div>

<!--#include virtual="/common/footer_adm.asp"-->

<script type="text/javascript">
	
	var page	= 1;
	var pageSize	= <%=g_pageSize%>;
	var rowCnt	= 0;
	
	$(function(){
		
		fnLoadPage(page);
		
	});
	
	function fnLoadPage(p){
		page = p;
		
		var schSDate				= $('input[name=schSDate]').val();
		var schEDate				= $('input[name=schEDate]').val();
		var warnVarCode			= $('select[name=warnVarCode]').val();
		var warnStressCode	= $('select[name=warnStressCode]').val();
		var schKey					= $('select[name=schKey]').val();
		var schVal					= $('input[name=schVal]').val();
		
		var params	= 'schSDate='+schSDate+'&schEDate='+schEDate+'&warnVarCode='+warnVarCode+'&warnStressCode='+warnStressCode+'&schKey='+schKey+'&schVal='+schVal+'&page='+page+'&pageSize='+pageSize
		
		$('#listTbl tbody tr').remove();
		
		$.ajax({
			url	: 'ajxNotiRecvList.asp',
			type	: 'POST',
			data	: params,
			success	: function(rslt){
				//console.log(rslt);
				var arrRslt	= rslt.split('}|{');
				rowCnt	= arrRslt[0];
				if(rowCnt > 0){
					var arrVal, strRow;
					for(var i = 2; i < arrRslt.length; i++){
						arrVal	= arrRslt[i].split(']|[');strGrup = '';
						
						strRow = '<tr>'
						+'	<td class="aC">'+arrVal[3]+'</td>'
						+'	<td class="aC">'+arrVal[4]+'</td>'
						+'	<td class="aC">'+arrVal[5]+'</td>'
						+'	<td class="aC">'+arrVal[8]+'</td>'
						+'	<td class="aC">'+arrVal[9]+'</td>'
						+'	<td class="aC">'+arrVal[7]+'</td>'
						/*+'	<td class="aC">'
						+'		<button class="btn btn_sm bg_olive" onclick="fnNotiForm('+arrVal[2]+')">관리</button>'
						+'	</td>'*/
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