<!--#include virtual="/common/common.asp"-->

<% mnCD = "3002" %>

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

dim selGrp(5)
selGrp(1) = fnIsNull(fnReq("grpCode1"),0)
selGrp(2) = fnIsNull(fnReq("grpCode2"),0)
selGrp(3) = fnIsNull(fnReq("grpCode3"),0)
selGrp(4) = fnIsNull(fnReq("grpCode4"),0)
selGrp(5) = fnIsNull(fnReq("grpCode5"),0)

dim grpCode : grpCode = 0
if selGrp(1) > 0 then grpCode = selGrp(1) end if
if selGrp(2) > 0 then grpCode = selGrp(2) end if
if selGrp(3) > 0 then grpCode = selGrp(3) end if
if selGrp(4) > 0 then grpCode = selGrp(4) end if
if selGrp(5) > 0 then grpCode = selGrp(5) end if   

dim emrCnt, smsCnt, vmsCnt

if grpCode > 0 then
	
	'sql = " select "
	'sql = sql & " 	dbo.ufn_getAddrID(cl.AD_IDX) as ADID "
	'sql = sql & " 	, dbo.ufn_getAddrName(cl.AD_IDX) as ADNM "
	'sql = sql & " 	, COUNT(*) "
	'if viewType = "G" then
	'	sql = sql & " 	, COUNT(case when CL_GB = 'E' then 1 else null end) "
	'	sql = sql & " 	, COUNT(case when CL_GB = 'S' then 1 else null end) "
	'	sql = sql & " 	, COUNT(case when CL_GB = 'V' then 1 else null end) "
	'else
	'	sql = sql & " 	, COUNT(case when CL_GB = 'E' and CD_RESULT in (0,9001,9002) then 1 else null end) "
	'	sql = sql & " 	, COUNT(case when CL_GB = 'E' and CD_RESULT in (9003) then 1 else null end) "
	'	sql = sql & " 	, COUNT(case when CL_GB = 'E' and CD_RESULT in (9004,9005) then 1 else null end) "
	'	sql = sql & " 	, COUNT(case when CL_GB = 'S' and CD_RESULT in (0,9001,9002) then 1 else null end) "
	'	sql = sql & " 	, COUNT(case when CL_GB = 'S' and CD_RESULT in (9003) then 1 else null end) "
	'	sql = sql & " 	, COUNT(case when CL_GB = 'S' and CD_RESULT in (9004,9005) then 1 else null end) "
	'	sql = sql & " 	, COUNT(case when CL_GB = 'V' and CD_RESULT in (0,9001,9002) then 1 else null end) "
	'	sql = sql & " 	, COUNT(case when CL_GB = 'V' and CD_RESULT in (9003) then 1 else null end) "
	'	sql = sql & " 	, COUNT(case when CL_GB = 'V' and CD_RESULT in (9004,9005) then 1 else null end) "
	'end if
	'sql = sql & " from TBL_CALL as cl with(nolock) "
	'sql = sql & " 	left join TBL_CALLTRG as clt with(nolock) on (cl.CL_IDX = clt.CL_IDX) "
	'sql = sql & " where cl.USEYN = 'Y' "
	'sql = sql & " 	and cl.CL_RSVDT between '" & schSDate & " 00:00:00' and '" & schEDate & " 23:59:59' "
	'sql = sql & " 	and cl.AD_IDX in ( "
	'sql = sql & " 		select AD_IDX from TBL_ADDR as ad with(nolock) "
	'sql = sql & " 		where USEYN = 'Y' and CD_USERGB > 1000 and AD_GB = 'U' "
	'sql = sql & " 			and GRP_CODE in (select GRP_CODE from dbo.ufn_tblGetSubGrpCodes(" & grpCode & ")) "
	'sql = sql & " 	) "
	'sql = sql & " group by cl.AD_IDX "
	sql = " select dbo.ufn_getAddrID(AD_IDX) as ADID, dbo.ufn_getAddrName(AD_IDX) as ADNM "
	sql = sql & " 	, count(*) "                
	if viewType = "G" then
		sql = sql & " 	, count(case when CL_GB = 'E' then 1 else null end) "
		sql = sql & " 	, count(case when CL_GB = 'S' then 1 else null end) "
		sql = sql & " 	, count(case when CL_GB = 'V' then 1 else null end) "
	else
		sql = sql & " 	, count(case when CL_GB = 'E' and CL_STEP in (0,1,2,3) then 1 else null end) "
		sql = sql & " 	, count(case when CL_GB = 'E' and CL_STEP in (5) then 1 else null end) "
		sql = sql & " 	, count(case when CL_GB = 'E' and CL_STEP in (4) then 1 else null end) "
		
		sql = sql & " 	, count(case when CL_GB = 'S' and CL_STEP in (0,1,2,3) then 1 else null end) "
		sql = sql & " 	, count(case when CL_GB = 'S' and CL_STEP in (5) then 1 else null end) "
		sql = sql & " 	, count(case when CL_GB = 'S' and CL_STEP in (4) then 1 else null end) "
		
		sql = sql & " 	, count(case when CL_GB = 'V' and CL_STEP in (0,1,2,3) then 1 else null end) "
		sql = sql & " 	, count(case when CL_GB = 'V' and CL_STEP in (5) then 1 else null end) "
		sql = sql & " 	, count(case when CL_GB = 'V' and CL_STEP in (4) then 1 else null end) "
	end if
	sql = sql & " from TBL_CALL with(nolock) "
	sql = sql & " where USEYN = 'Y' "
	sql = sql & " 	and CL_RSVDT between '" & schSDate & " 00:00:00' and '" & schEDate & " 23:59:59' "
	sql = sql & " 	and AD_IDX in ( "
	sql = sql & " 		select AD_IDX from TBL_ADDR as ad with(nolock) "
	sql = sql & " 		where USEYN = 'Y' and CD_USERGB > 1000 and AD_GB = 'U' "
	if dbType = "mssql" then
		sql = sql & " 			and GRP_CODE in (select GRP_CODE from dbo.ufn_tblGetSubGrpCodes(" & grpCode & ")) "
	else
		sql = sql & " 			and GRP_CODE in ( "
		sql = sql & " select GRP_CODE from ( "
		sql = sql & " 	( "
		sql = sql & " 		SELECT GRP_CODE FROM TBL_GRP WHERE GRP_CODE = " & grpCode & " "
		sql = sql & " 	) UNION ( "
		sql = sql & " 		SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE = " & grpCode & " "
		sql = sql & " 	) UNION ( "
		sql = sql & " 		SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE = " & grpCode & ") "
		sql = sql & " 	) UNION ( "
		sql = sql & " 		SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE = " & grpCode & ")) "
		sql = sql & " 	) UNION ( "
		sql = sql & " 		SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE = " & grpCode & "))) "
		sql = sql & " 	) "
		sql = sql & " ) AS grp "
		sql = sql & " 		) "
	end if
	sql = sql & " ) "
	sql = sql & " group by AD_IDX "
	'response.write	sql
	cmdOpen(sql)
	set rs = cmd.execute
	cmdClose()
	if not rs.eof then
		arrRs = rs.getRows
		arrRc2 = ubound(arrRs,2)
	else
		arrRc2 = -1
	end if
	rsClose()
	
end if

dim sumCnt(9)
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
						<input type="hidden" name="viewType" value="<%=viewType%>" />
						
						<table align="left">
							<tr>
								<td><label>부서</label></td>
								<td>
									<select id="grpCode1" name="grpCode1" onchange="fnLoadGrp(2,this.value)"></select>
									<% for i = 2 to g_useGrpDepth %>
										<select id="grpCode<%=i%>" name="grpCode<%=i%>" onchange="fnLoadGrp(<%=i+1%>,this.value)">
											<option value="0">:::::::::: 선택 ::::::::::</option>
										</select>
									<% next %>
								</td>
							</tr>
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
						<img class="imgBtn" src="<%=pth_pubImg%>/btn/purple_viewTable.png" onclick="fnViewType('T');" />
					<% elseif viewType = "T" then %>
						<img class="imgBtn" src="<%=pth_pubImg%>/btn/olive_viewGraph.png" onclick="fnViewType('G');" />
					<% end if %>
				</td>
			</tr>
		</table>
	</div>
	
	<br />
	<% if grpCode > 0 then %>
		<% if viewType = "G" then %>
			<div id="graph01" style="height:<%=(((arrRc2 + 1) * 60) + 200)%>px"></div>
		<% else %>
			<table border="0" cellpadding="0" cellspacing="1" class="tblList">
				<colgroup>
					<col width="*" />
					<col width="70px" />
					<col width="70px" />
					<col width="70px" />
					<col width="70px" />
					<col width="70px" />
					<col width="70px" />
					<col width="70px" />
					<col width="70px" />
					<col width="70px" />
					<col width="70px" />
				</colgroup>
				<tr>
					<th rowspan="2">사용자</th>
					<th rowspan="2">전체</th>
					<th colspan="3">비상발령</th>
					<th colspan="3">문자메시지</th>
					<th colspan="3">음성메시지</th>
				</tr>
				<tr>
					<th>진행중</th>
					<th>성공</th>
					<th>실패</th>
					<th>진행중</th>
					<th>성공</th>
					<th>실패</th>
					<th>진행중</th>
					<th>성공</th>
					<th>실패</th>
				</tr>
				<%
				for i = 0 to arrRc2
					for ii = 0 to ubound(sumCnt)
						sumCnt(ii) = sumCnt(ii) + clng(arrRs(ii+2,i))
					next
					response.write	"<tr>"
					response.write	"	<td class=""aC"">" & arrRs(0,i) & "(" & arrRs(1,i) & ")</td>"
					response.write	"	<td class=""aR"">" & formatNumber(arrRs(2,i) ,0)& "</td>"
					response.write	"	<td class=""aR"">" & formatNumber(arrRs(3,i) ,0)& "</td>"
					response.write	"	<td class=""aR"">" & formatNumber(arrRs(4,i) ,0)& "</td>"
					response.write	"	<td class=""aR"">" & formatNumber(arrRs(5,i) ,0)& "</td>"
					response.write	"	<td class=""aR"">" & formatNumber(arrRs(6,i) ,0)& "</td>"
					response.write	"	<td class=""aR"">" & formatNumber(arrRs(7,i) ,0)& "</td>"
					response.write	"	<td class=""aR"">" & formatNumber(arrRs(8,i),0) & "</td>"
					response.write	"	<td class=""aR"">" & formatNumber(arrRs(9,i),0) & "</td>"
					response.write	"	<td class=""aR"">" & formatNumber(arrRs(10,i),0) & "</td>"
					response.write	"	<td class=""aR"">" & formatNumber(arrRs(11,i),0) & "</td>"
					response.write	"</tr>"
				next
				%>
				<tr>
					<th>합계</th>
					<%
					for i = 0 to ubound(sumCnt)
						%><th class="aR"><%=formatNumber(sumCnt(i),0)%></th><%
					next
					%>
				</tr>
			</table>
		<% end if %>
	<% else %>
		<div class="aC">부서를 선택해 주세요.</div>
	<% end if %>
	
</div>

<!--#include virtual="/common/footer_adm.asp"-->

<script>
	
	var selGrp = new Array;
	selGrp[1] = <%=selGrp(1)%>;
	selGrp[2] = <%=selGrp(2)%>;
	selGrp[3] = <%=selGrp(3)%>;
	selGrp[4] = <%=selGrp(4)%>;
	selGrp[5] = <%=selGrp(5)%>;
	
	$(function(){
		
		fnLoadGrp(1,1);
		fnSelGrp(2);
		<%
		for i = 2 to 5
			if selGrp(i) > 0 then
				%>
				fnLoadGrp(<%=i%>,<%=selGrp(i-1)%>);
				fnSelGrp(<%=i+1%>);
				<%
			end if
		next
		%>
	
		<% if grpCode > 0 then %>
			
			<% if viewType = "G" then %>
				<%
				for i = 0 to arrRc2
					sumCnt(1) = sumCnt(1) + clng(arrRs(3,i))
					sumCnt(2) = sumCnt(2) + clng(arrRs(4,i))
					sumCnt(3) = sumCnt(3) + clng(arrRs(5,i))
				next
				%>
				
				$('#graph01').highcharts({
					chart:{
						type:'bar'
					},
	        title: {
	            text: '<span style="font-family:맑은 고딕;font-size:12px;">전송건수가 없는 사용자는 표시되지 않습니다.</span>'
	        },
					xAxis:{
						categories:['전체'
						<%
						for i = 0 to arrRc2
							response.write	",'" & arrRs(1,i) & "'"
						next
						%>
						],
						title:{
							text:null
						}
					},
					yAxis:{
						min:0,
						title:{
							text:'건',
							align:'high'
						},
						labels:{
							overflow:'justify'
						}
					},
					tooltip:{
						valueSuffix:'건'
					},
					plotOptions:{
						bar:{
							dataLabels:{
								enabled:true
							}
						}
					},
					credits:{
						enabled:false
					},
					exporting:false,
					series:[{
						index:1,
						color:'#0060fe',
						name:'비상발령',
						data:[<%=sumCnt(1)%>
						<%
						for i = 0 to arrRc2
							response.write	"," & arrRs(3,i)
						next
						%>
						]
					},{
						index:2,
						color:'#68ac00',
						name:'문자메시지',
						data:[<%=sumCnt(2)%>
						<%
						for i = 0 to arrRc2
							response.write	"," & arrRs(4,i)
						next
						%>
						]
					},{
						index:3,
						color:'#ff6600',
						name:'음성메시지',
						data:[<%=sumCnt(3)%>
						<%
						for i = 0 to arrRc2
							response.write	"," & arrRs(5,i)
						next
						%>
						]
					}]
				});
				
			<% end if %>
			
		<% end if %>
			
	});
	
	function fnLoadGrp(depth,upcd){	// 그룹 가져오기
		var trg = $('#grpCode'+depth);
		$(trg).find('option').remove();
		$(trg).append('<option value="0">:::::::::: 선택 ::::::::::</option>');
		var result = fnGetHttp('/pages/public/ajxGrpList.asp?grpGB=D&grpUpCD='+upcd);
		var arrResult = result.split('}|{');
		var rowCnt = arrResult[0];
		if(rowCnt > 0){
			var arrVal, strRow;
			for(var i = 1; i < arrResult.length; i++){
				arrVal = arrResult[i].split(']|[');
				//	GRP_CD, GRP_UPCD, GRP_NM, GRP_NUM1, GRP_NUM2
				strRow = '<option value="'+arrVal[0]+'"';
				if(arrVal[0] == selGrp[depth]){
					strRow = strRow + ' selected ';
				}
				strRow = strRow + '>'+arrVal[2]+'</option>';
				$(trg).append(strRow);
			}
		}
	}
	
	function fnSelGrp(depth){
		grpDepth = depth-1;
		var nGrpCD = $('#grpCode'+(depth-1)+' option:selected').val();
		fnLoadGrp(depth,nGrpCD);
	}
	
	function fnSch(){
		if(document.schFrm.grpCode1.value == 0){
			alert('부서를 선택하세요.');document.schFrm.grpCode1.focus();return;
		}
		//if(document.schFrm.grpCode2.value == 0){
		//	alert('부서를 선택하세요.');document.schFrm.grpCode2.focus();return;
		//}
		document.schFrm.submit();
	}
	
	function fnViewType(tp){
		document.schFrm.viewType.value = tp;
		document.schFrm.submit();
	}
	
</script>