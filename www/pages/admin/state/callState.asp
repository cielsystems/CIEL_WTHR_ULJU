<!--#include virtual="/common/common.asp"-->

<% mnCD = "3001" %>

<!--#include virtual="/common/header_adm.asp"-->

<%
dim viewType : viewType = fnIsNull(fnReq("viewType"),"T")

dim schSDate : schSDate = fnIsNull(fnReq("schSDate"),dateserial(year(date),month(date),1))
dim schEDate : schEDate = fnIsNull(fnReq("schEDate"),date)

if datediff("d",schSDate,schEDate) > 31 then
	response.write	"<script type=""text/javascript"">"
	response.write	"alert('검색기간은 31일을 초과할 수 없습니다.');"
	response.write	"history.back();"
	response.write	"</script>"
	schSDate = dateserial(year(date),month(date),1)
	schEDate = date
end if

dim cntA(5), cntB(5), cntC(18)

sql = " select "
sql = sql & " 	COUNT(*) as CNTALL "
sql = sql & " 	, COUNT(case when CD_RESULT = 9001 OR CD_RESULT = 0 then 1 else null end) as CNTSTY "
sql = sql & " 	, COUNT(case when CD_RESULT = 9002 then 1 else null end) as CNTING "
sql = sql & " 	, COUNT(case when CD_RESULT = 9003 then 1 else null end) as CNTCMP "
sql = sql & " 	, COUNT(case when CD_RESULT = 9004 then 1 else null end) as CNTCNL "
sql = sql & " 	, COUNT(case when CD_RESULT = 9005 then 1 else null end) as CNTERR "
sql = sql & " from TBL_CALLTRG as clt with(nolock) "
sql = sql & " where USEYN = 'Y' "
sql = sql & " 	and CL_IDX in ( "
sql = sql & " 		select CL_IDX from TBL_CALL with(nolock)  "
sql = sql & " 		where USEYN = 'Y' and CL_RSVDT between '" & schSDate & " 00:00:00' and '" & schEDate & " 23:59:59' "
sql = sql & " 	) "
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
if not rs.eof then
	for i = 0 to ubound(cntA)
		cntA(i) = clng(rs(i))
	next
end if
rsClose()

sql = " select "
sql = sql & " 	COUNT(*) as CNTALL "
sql = sql & "		, COUNT(case when CLT_ANSWMEDIA = '0' or (CLT_ANSWMEDIA = 'V' and dbo.ufn_getCallAnswMedia(CL_IDX, CLT_NO) = 0)then 1 else null end) as CNT0 "
sql = sql & "		, COUNT(case when CLT_ANSWMEDIA = 'S' then 1 else null end) as CNT1 "
sql = sql & "		, COUNT(case when CLT_ANSWMEDIA = 'V' and dbo.ufn_getCallAnswMedia(CL_IDX, CLT_NO) = 1 then 1 else null end) as CNT2 "
sql = sql & "		, COUNT(case when CLT_ANSWMEDIA = 'V' and dbo.ufn_getCallAnswMedia(CL_IDX, CLT_NO) = 2 then 1 else null end) as CNT3 "
sql = sql & "		, COUNT(case when CLT_ANSWMEDIA = 'V' and dbo.ufn_getCallAnswMedia(CL_IDX, CLT_NO) = 3 then 1 else null end) as CNT4 "
sql = sql & " from TBL_CALLTRG as clt with(nolock) "
sql = sql & " where USEYN = 'Y' "
sql = sql & " 	and CL_IDX in ( "
sql = sql & " 		select CL_IDX from TBL_CALL with(nolock)  "
sql = sql & " 		where USEYN = 'Y' and CL_RSVDT between '" & schSDate & " 00:00:00' and '" & schEDate & " 23:59:59' and (CL_GB = 'E' or CL_GB = 'W') "
sql = sql & " 	) "
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
if not rs.eof then
	for i = 0 to ubound(cntB)
		cntB(i) = clng(rs(i))
	next
end if
rsClose()

sql = " select "
sql = sql & " 	COUNT(*) "
sql = sql & " 	, COUNT(case when cl.CL_GB = 'E' then 1 else null end) as CNT10 "
sql = sql & " 	, COUNT(case when cl.CL_GB = 'E' and clt.CD_RESULT in (0,9001,9002) then 1 else null end) as CNT11 "
sql = sql & " 	, COUNT(case when cl.CL_GB = 'E' and clt.CD_RESULT in (9003) and clt.CLT_ANSWYN = 'Y' then 1 else null end) as CNT12 "
sql = sql & " 	, COUNT(case when cl.CL_GB = 'E' and clt.CD_RESULT in (9003) and clt.CLT_ANSWYN = 'N' then 1 else null end) as CNT13 "
sql = sql & " 	, COUNT(case when cl.CL_GB = 'E' and clt.CD_RESULT in (9004,9005) then 1 else null end) as CNT14 "

sql = sql & " 	, COUNT(case when cl.CL_GB = 'S' then 1 else null end) as CNT20 "
sql = sql & " 	, COUNT(case when cl.CL_GB = 'S' and clt.CD_RESULT in (0,9001,9002) then 1 else null end) as CNT21 "
sql = sql & " 	, COUNT(case when cl.CL_GB = 'S' and clt.CD_RESULT in (9003) then 1 else null end) as CNT22 "
sql = sql & " 	, COUNT(case when cl.CL_GB = 'S' and clt.CD_RESULT in (9004,9005) then 1 else null end) as CNT23 "

sql = sql & " 	, COUNT(case when cl.CL_GB = 'V' then 1 else null end) as CNT30 "
sql = sql & " 	, COUNT(case when cl.CL_GB = 'V' and clt.CD_RESULT in (0,9001,9002) then 1 else null end) as CNT31 "
sql = sql & " 	, COUNT(case when cl.CL_GB = 'V' and clt.CD_RESULT in (9003) then 1 else null end) as CNT32 "
sql = sql & " 	, COUNT(case when cl.CL_GB = 'V' and clt.CD_RESULT in (9004,9005) then 1 else null end) as CNT33 "

sql = sql & " 	, COUNT(case when cl.CL_GB = 'W' then 1 else null end) as CNT34 "
sql = sql & " 	, COUNT(case when cl.CL_GB = 'W' and clt.CD_RESULT in (0,9001,9002) then 1 else null end) as CNT35 "
sql = sql & " 	, COUNT(case when cl.CL_GB = 'W' and clt.CD_RESULT in (9003) and clt.CLT_ANSWYN = 'Y' then 1 else null end) as CNT36 "
sql = sql & " 	, COUNT(case when cl.CL_GB = 'W' and clt.CD_RESULT in (9003) and clt.CLT_ANSWYN = 'N' then 1 else null end) as CNT37 "
sql = sql & " 	, COUNT(case when cl.CL_GB = 'W' and clt.CD_RESULT in (9004,9005) then 1 else null end) as CNT38 "

sql = sql & " from TBL_CALL as cl with(nolock) "
sql = sql & " 	left join TBL_CALLTRG as clt with(nolock) on (cl.CL_IDX = clt.CL_IDX) "
sql = sql & " where cl.USEYN = 'Y' and clt.USEYN = 'Y' "
sql = sql & " 	and cl.CL_RSVDT between '" & schSDate & " 00:00:00' and '" & schEDate & " 23:59:59' "
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
if not rs.eof then
	for i = 0 to ubound(cntC)
		cntC(i) = clng(rs(i))
	next
end if
rsClose()
%>

<script src="/public/Highcharts/js/highcharts.js"></script>
<script src="/public/Highcharts/js/highcharts-3d.js"></script>
<script src="/public/Highcharts/js/modules/exporting.js"></script>

<div id="subPageBox">
	
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<form name="schFrm" method="post" action="" target="">
						
						<table align="left">
							<tr>
								<td><label>기간</label></td>
								<td>
									<input type="text" id="schSDate" name="schSDate" value="<%=schSDate%>" size="10" readonly />
									<img class="calBtn" src="<%=pth_pubImg%>/icons/calendar-select.png" title="달력" /> ~
									<input type="text" id="schEDate" name="schEDate" value="<%=schEDate%>" size="10" readonly />
									<img class="calBtn" src="<%=pth_pubImg%>/icons/calendar-select.png" title="달력" />
									<img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" title="검색" onclick="fnSch()" />
								</td>
							</tr>
						</table>
						
					</form>
						
				</td>
				<td class="aR" width="100px">
					<% if viewType = "G" then %>
						<img class="imgBtn" src="<%=pth_pubImg%>/btn/purple_viewTable.png" onclick="fnHref('callState.asp?viewType=T');" />
					<% elseif viewType = "T" then %>
						<img class="imgBtn" src="<%=pth_pubImg%>/btn/olive_viewGraph.png" onclick="fnHref('callState.asp?viewType=G');" />
					<% end if %>
				</td>
			</tr>
		</table>
	</div>
	<br />
	
	<% if viewType = "G" then %>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="49%" />
				<col width="*" />
				<col width="49%" />
			</colgroup>
			<tr>
				<td><div id="graph01" style="height:300px"></div></td>
				<td></td>
				<td><div id="graph02" style="height:300px"></div></td>
			</tr>
			<tr><td colspan="3" style="height:10px;"></td></tr>
			<tr>
				<td colspan="3"><div id="graph03" style="height:460px"></div></td>
			</tr>
		</table>
	<% elseif viewType = "T" then %>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="49%" />
				<col width="*" />
				<col width="49%" />
			</colgroup>
			<tr>
				<td>
					<h3>전송결과</h3>
					<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
						<colgroup>
							<col width="40%" />
							<col width="*" />
						</colgroup>
						<tr><th>전체</th>		<td class="aR bld"><%=formatNumber(cntA(0),0)%> (<%=fnPer(cntA(0),cntA(0))%>%)</td></tr>
						<tr><th>대기</th>		<td class="aR bld"><%=formatNumber(cntA(1),0)%> (<%=fnPer(cntA(0),cntA(1))%>%)</td></tr>
						<tr><th>진행중</th>	<td class="aR bld"><%=formatNumber(cntA(2),0)%> (<%=fnPer(cntA(0),cntA(2))%>%)</td></tr>
						<tr><th>성공</th>		<td class="aR bld"><%=formatNumber(cntA(3),0)%> (<%=fnPer(cntA(0),cntA(3))%>%)</td></tr>
						<tr><th>실패</th>		<td class="aR bld"><%=formatNumber(cntA(4),0)%> (<%=fnPer(cntA(0),cntA(4))%>%)</td></tr>
						<tr><th>오류</th>		<td class="aR bld"><%=formatNumber(cntA(5),0)%> (<%=fnPer(cntA(0),cntA(5))%>%)</td></tr>
					</table>
				</td>
				<td></td>
				<td>
					<h3>응답여부<span class="fnt11 colRed">(비상발령)</span></h3>
					<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
						<colgroup>
							<col width="40%" />
							<col width="30%" />
							<col width="*" />
						</colgroup>
						<tr><th>전체</th>			<td colspan="2" class="aR bld"><%=formatNumber(cntB(0),0)%> (<%=fnPer(cntB(0),cntB(0))%>%)</td></tr>
						<tr><th>미응답</th>		<td colspan="2" class="aR bld"><%=formatNumber(cntB(1),0)%> (<%=fnPer(cntB(0),cntB(1))%>%)</td></tr>
						<tr><th>문자응답</th>	
							<td class="aR bld"><%=formatNumber(cntB(2),0)%> (<%=fnPer(cntB(0),cntB(2))%>%)</td>
							<td rowspan="4" class="aR bld"><%=formatNumber(cntB(2)+cntB(3)+cntB(4)+cntB(5),0)%> (<%=fnPer(cntB(0),cntB(2)+cntB(3)+cntB(4)+cntB(5))%>%)</td>
						</tr>
						<tr><th>1차응답</th>	<td class="aR bld"><%=formatNumber(cntB(3),0)%> (<%=fnPer(cntB(0),cntB(3))%>%)</td></tr>
						<tr><th>2차응답</th>	<td class="aR bld"><%=formatNumber(cntB(4),0)%> (<%=fnPer(cntB(0),cntB(4))%>%)</td></tr>
						<tr><th>3차이상</th>	<td class="aR bld"><%=formatNumber(cntB(5),0)%> (<%=fnPer(cntB(0),cntB(5))%>%)</td></tr>
					</table>
				</td>
			</tr>
			<tr><td colspan="3" style="height:10px;"></td></tr>
			<tr>
				<td colspan="3">
					<h3>전송구분별통계</h3>
					<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
						<tr><th colspan="2">전체</th>												<td class="aR bld"><%=formatNumber(cntC(0),0)%> (<%=fnPer(cntC(0),cntC(0))%>%)</td></tr>
						<tr><th rowspan="5">비상발령</th>	<th>전체</th>			<td class="aR bld"><%=formatNumber(cntC(1),0)%> (<%=fnPer(cntC(0),cntC(1))%>%)</td></tr>
						<tr>															<th>진행중</th>		<td class="aR bld"><%=formatNumber(cntC(2),0)%> (<%=fnPer(cntC(0),cntC(2))%>%)</td></tr>
						<tr>															<th>응답</th>			<td class="aR bld"><%=formatNumber(cntC(3),0)%> (<%=fnPer(cntC(0),cntC(3))%>%)</td></tr>
						<tr>															<th>미응답</th>		<td class="aR bld"><%=formatNumber(cntC(4),0)%> (<%=fnPer(cntC(0),cntC(4))%>%)</td></tr>
						<tr>															<th>취소/오류</th><td class="aR bld"><%=formatNumber(cntC(5),0)%> (<%=fnPer(cntC(0),cntC(5))%>%)</td></tr>
						<tr><th rowspan="4">문자메시지</th>	<th>전체</th>			<td class="aR bld"><%=formatNumber(cntC(6),0)%> (<%=fnPer(cntC(0),cntC(6))%>%)</td></tr>
						<tr>															<th>진행중</th>		<td class="aR bld"><%=formatNumber(cntC(7),0)%> (<%=fnPer(cntC(0),cntC(7))%>%)</td></tr>
						<tr>															<th>성공</th>			<td class="aR bld"><%=formatNumber(cntC(8),0)%> (<%=fnPer(cntC(0),cntC(8))%>%)</td></tr>
						<tr>															<th>취소/오류</th><td class="aR bld"><%=formatNumber(cntC(9),0)%> (<%=fnPer(cntC(0),cntC(9))%>%)</td></tr>
						<!--
						<tr><th rowspan="4">음성메시지</th>	<th>전체</th>			<td class="aR bld"><%=formatNumber(cntC(10),0)%> (<%=fnPer(cntC(0),cntC(10))%>%)</td></tr>
						<tr>															<th>진행중</th>		<td class="aR bld"><%=formatNumber(cntC(11),0)%> (<%=fnPer(cntC(0),cntC(11))%>%)</td></tr>
						<tr>															<th>성공</th>			<td class="aR bld"><%=formatNumber(cntC(12),0)%> (<%=fnPer(cntC(0),cntC(12))%>%)</td></tr>
						<tr>															<th>취소/오류</th><td class="aR bld"><%=formatNumber(cntC(13),0)%> (<%=fnPer(cntC(0),cntC(13))%>%)</td></tr>
						-->
						<tr><th rowspan="5">기상특보</th>	<th>전체</th>			<td class="aR bld"><%=formatNumber(cntC(14),0)%> (<%=fnPer(cntC(0),cntC(14))%>%)</td></tr>
						<tr>															<th>진행중</th>		<td class="aR bld"><%=formatNumber(cntC(15),0)%> (<%=fnPer(cntC(0),cntC(15))%>%)</td></tr>
						<tr>															<th>응답</th>			<td class="aR bld"><%=formatNumber(cntC(16),0)%> (<%=fnPer(cntC(0),cntC(16))%>%)</td></tr>
						<tr>															<th>미응답</th>		<td class="aR bld"><%=formatNumber(cntC(17),0)%> (<%=fnPer(cntC(0),cntC(17))%>%)</td></tr>
						<tr>															<th>취소/오류</th><td class="aR bld"><%=formatNumber(cntC(18),0)%> (<%=fnPer(cntC(0),cntC(18))%>%)</td></tr>
					</table>
				</td>
			</tr>
		</table>
	<% end if %>
	
</div>

<!--#include virtual="/common/footer_adm.asp"-->

<script>
	
	$(function(){
		
		<% if viewType = "G" then %>
		
			//	전송결과
			$('#graph01').highcharts({
				chart:{
					plotBackgroundColor:null,
					plotBorderWidth:null,
					plotShadow:false
				},
				credits:false,
				exporting:false,
				title:{
					text:'<span style="font-family:맑은 고딕;font-size:13px;font-weight:bold;">전송결과</span>'
				},
				tooltip:{
					pointFormat:'<b>{point.percentage:.1f}%</b>'
				},
				plotOptions:{
					pie:{
						allowPointSelect:true,
						cursor:'pointer',
						colors:['#FFCC00','#FF9900','#FF6600','#FF3300','#FF1100'],
						dataLabels:{
							enabled:true,
							format:'<b>{point.name}</b>:{point.percentage:.1f}%',
							style:{
								color:(Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
							}
						}
					}
				},
				series:[{
					type:'pie',
					name:'Browsershare',
					data:[
						['대기',		<%=fnPer(cntA(0),cntA(1))%>],
						['진행중',	<%=fnPer(cntA(0),cntA(2))%>],
						['성공',		<%=fnPer(cntA(0),cntA(3))%>],
						['실패',		<%=fnPer(cntA(0),cntA(4))%>],
						['취소',		<%=fnPer(cntA(0),cntA(5))%>],
					]
				}]
			});
			
			//	응답여부
			$('#graph02').highcharts({
				chart:{
					plotBackgroundColor:null,
					plotBorderWidth:null,
					plotShadow:false,
				},
				credits:false,
				exporting:false,
				title:{
					text:'<span style="font-family:맑은 고딕;font-size:13px;font-weight:bold;">응답여부</span><span style="font-size:11px;color:red;">(비상발령)</span>'
				},
				tooltip:{
					pointFormat:'<b>{point.percentage:.1f}%</b>'
				},
				plotOptions:{
					pie:{
						allowPointSelect:true,
						cursor:'pointer',
						colors:['#174866','#2677A8','#419CD3','#85BFE2'],
						dataLabels:{
							enabled:true,
							format:'<b>{point.name}</b>:{point.percentage:.1f}%',
							style:{
								color:(Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
							}
						}
					}
				},
				series:[{
					type:'pie',
					name:'Browsershare',
					data:[
						['미응답',	<%=fnPer(cntB(0),cntB(1))%>],
						['문자응답',	<%=fnPer(cntB(0),cntB(2))%>],
						['1차응답',	<%=fnPer(cntB(0),cntB(3))%>],
						['2차응답',	<%=fnPer(cntB(0),cntB(4))%>],
						['3차이상',	<%=fnPer(cntB(0),cntB(5))%>],
					]
				}]
			});
			
			//	전송구분별통계
			var colors = ['#3E5A21','#215A38','#205A5B'],
			categories=['비상발령','문자메시지','기상특보'],
			data=[{
				y:<%=fnPer(cntC(0),cntC(2)+cntC(3)+cntC(4)+cntC(5))%>,
				color:colors[0],
				drilldown:{
					name:'emr',
					categories:['진행중','응답','미응답','취소/오류'],
					data:[<%=fnPer(cntC(0),cntC(2))%>,<%=fnPer(cntC(0),cntC(3))%>,<%=fnPer(cntC(0),cntC(4))%>,<%=fnPer(cntC(0),cntC(5))%>],
					color:colors[0]
				}
			},{
				y:<%=fnPer(cntC(0),cntC(7)+cntC(8)+cntC(9))%>,
				color:colors[1],
				drilldown:{
					name:'sms',
					categories:['진행중','성공','취소/오류'],
					data:[<%=fnPer(cntC(0),cntC(7))%>,<%=fnPer(cntC(0),cntC(8))%>,<%=fnPer(cntC(0),cntC(9))%>],
					color:colors[1]
				}
			},{
				y:<%=fnPer(cntC(0),cntC(15)+cntC(16)+cntC(17)+cntC(18))%>,
				color:colors[2],
				drilldown:{
					name:'wth',
					categories:['진행중','응답','미응답','취소/오류'],
					data:[<%=fnPer(cntC(0),cntC(15))%>,<%=fnPer(cntC(0),cntC(16))%>,<%=fnPer(cntC(0),cntC(17))%>,<%=fnPer(cntC(0),cntC(18))%>],
					color:colors[2]
				}
			}],
			browserData=[],
			versionsData=[],
			i,
			j,
			dataLen=data.length,
			drillDataLen,
			brightness;
			
			for(i=0;i<dataLen;i+=1){
				browserData.push({
					name:categories[i],
					y:data[i].y,
					color:data[i].color
				});
				
				drillDataLen=data[i].drilldown.data.length;
				for(j=0;j<drillDataLen;j+=1){
					brightness=0.4-(j/drillDataLen)/3;
					versionsData.push({
						name:data[i].drilldown.categories[j],
						y:data[i].drilldown.data[j],
						color:Highcharts.Color(data[i].color).brighten(brightness).get()
					});
				}
			}
	
	    // Create the chart
			$('#graph03').highcharts({
				chart:{
					type:'pie'
				},
				credits:false,
				exporting:false,
				title:{
					text:'<span style="font-family:맑은고딕;font-size:13px;font-weight:bold;">전송구분별통계</span>'
				},
				yAxis:{
					title:{
						text:''
					}
				},
				plotOptions:{
					pie:{
						shadow:false,
						center:['50%','50%']
					}
				},
				tooltip:{
					enabled:false,
				},
				series:[{
					name:'Browsers',
					data:browserData,
					size:'60%',
					dataLabels:{
						formatter:function(){
							return this.y>5?'<b>'+this.point.name+':'+this.y+'%</b>':null;
						},
						color:'white',
						distance:-30
					}
				},{
					name:'Versions',
					data:versionsData,
					size:'80%',
					innerSize:'60%',
					dataLabels:{
						formatter:function(){
							return this.y>1?'<b>'+this.point.name+':'+this.y+'%</b>':null;
						}
					}
				}]
			});
			
		<% elseif viewType = "T" then %>
			
			
			
		<% end if %>
		
	});
	
	function fnSch(){
		document.schFrm.submit();
	}
	
</script>