<!--#include virtual="/common/common.asp"-->

<% mnCD = "3002" %>

<!--#include virtual="/common/header_adm.asp"-->

<%
dim viewType : viewType = fnIsNull(fnReq("viewType"),"T")

dim schSDate : schSDate = fnIsNull(fnReq("schSDate"),dateserial(year(date),month(date),1))
dim schEDate : schEDate = fnIsNull(fnReq("schEDate"),date)

'if datediff("d",schSDate,schEDate) > 31 then
'	response.write	"<script type=""text/javascript"">"
'	response.write	"alert('검색기간은 31일을 초과할 수 없습니다.');"
'	response.write	"history.back();"
'	response.write	"</script>"
'	schSDate = dateserial(year(date),month(date),1)
'	schEDate = date
'end if

sql = " select "
sql = sql & " 	USER_ID, USER_NAME, CNTALL, EMRALL, EMRCMP, EMRCNL, EMRING, SMRALL, SMRCMP, SMRCNL, SMRING, WTHALL, WTHCMP, WTHCNL, WTHING "
sql = sql & " from ( "
sql = sql & " 	select "
sql = sql & " 		AD_IDX, sum(CNT) as CNTALL "
sql = sql & " 		, sum((case when CL_GB = 'E' then CNT else 0 end)) as EMRALL "
sql = sql & " 		, sum((case when CL_GB = 'E' and CL_STEP = 5 then CNT else 0 end)) as EMRCMP "
sql = sql & " 		, sum((case when CL_GB = 'E' and CL_STEP = 4 then CNT else 0 end)) as EMRCNL "
sql = sql & " 		, sum((case when CL_GB = 'E' and CL_STEP < 4 then CNT else 0 end)) as EMRING "
sql = sql & " 		, sum((case when CL_GB = 'S' then CNT else 0 end)) as SMRALL "
sql = sql & " 		, sum((case when CL_GB = 'S' and CL_STEP = 5 then CNT else 0 end)) as SMRCMP "
sql = sql & " 		, sum((case when CL_GB = 'S' and CL_STEP = 4 then CNT else 0 end)) as SMRCNL "
sql = sql & " 		, sum((case when CL_GB = 'S' and CL_STEP < 4 then CNT else 0 end)) as SMRING "
sql = sql & " 		, sum((case when CL_GB = 'W' then CNT else 0 end)) as WTHALL "
sql = sql & " 		, sum((case when CL_GB = 'W' and CL_STEP = 5 then CNT else 0 end)) as WTHCMP "
sql = sql & " 		, sum((case when CL_GB = 'W' and CL_STEP = 4 then CNT else 0 end)) as WTHCNL "
sql = sql & " 		, sum((case when CL_GB = 'W' and CL_STEP < 4 then CNT else 0 end)) as WTHING "
sql = sql & " 	from ( "
sql = sql & " 		select "
sql = sql & " 			AD_IDX, CL_GB, CL_STEP, count(*) as CNT "
sql = sql & " 		from TBL_CALL with(nolock) "
sql = sql & " 		where USEYN = 'Y' "
sql = sql & " 			and CL_RSVDT between '" & schSDate & " 00:00:00' and '" & schEDate & " 23:59:59' "
sql = sql & " 		group by AD_IDX, CL_GB, CL_STEP "
sql = sql & " 	) as A "
sql = sql & " 	group by AD_IDX "
sql = sql & " ) as B "
sql = sql & " left join NTBL_USER as us with(nolock) on (B.AD_IDX = us.USER_INDX) "
'response.write	sql
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
if not rs.eof then
	arrRs = rs.getRows
	arrRc2 = ubound(arrRs,2)
	arrRc1	= ubound(arrRs,1)
else
	arrRc2 = -1
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
						<input type="hidden" name="viewType" value="<%=viewType%>" />
						
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
					
				</td>
			</tr>
		</table>
	</div>
	
	<br />
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
			<col width="70px" />
			<col width="70px" />
			<col width="70px" />
		</colgroup>
		<tr>
			<th rowspan="2">사용자</th>
			<th rowspan="2">전체</th>
			<th colspan="4">비상발령</th>
			<th colspan="4">일반메시지</th>
			<th colspan="4">기상특보</th>
		</tr>
		<tr>
			<th>전체</th>
			<th>성공</th>
			<th>취소</th>
			<th>진행중</th>
			<th>전체</th>
			<th>성공</th>
			<th>취소</th>
			<th>진행중</th>
			<th>전체</th>
			<th>성공</th>
			<th>취소</th>
			<th>진행중</th>
		</tr>
		<%
		dim sumCnt	: redim sumCnt(arrRc1)
		for i = 0 to arrRc2
			for ii = 2 to arrRc1
				sumCnt(ii) = sumCnt(ii) + clng(arrRs(ii,i))
			next
			response.write	"<tr>"
			response.write	"	<td class=""aC fnt11"">" & arrRs(0,i) & "(" & arrRs(1,i) & ")</td>"
			response.write	"	<td class=""aR fnt11"">" & formatNumber(arrRs(2,i) ,0)& "</td>"
			response.write	"	<td class=""aR fnt11"">" & formatNumber(arrRs(3,i) ,0)& "</td>"
			response.write	"	<td class=""aR fnt11"">" & formatNumber(arrRs(4,i) ,0)& "</td>"
			response.write	"	<td class=""aR fnt11"">" & formatNumber(arrRs(5,i) ,0)& "</td>"
			response.write	"	<td class=""aR fnt11"">" & formatNumber(arrRs(6,i) ,0)& "</td>"
			response.write	"	<td class=""aR fnt11"">" & formatNumber(arrRs(7,i) ,0)& "</td>"
			response.write	"	<td class=""aR fnt11"">" & formatNumber(arrRs(8,i),0) & "</td>"
			response.write	"	<td class=""aR fnt11"">" & formatNumber(arrRs(9,i),0) & "</td>"
			response.write	"	<td class=""aR fnt11"">" & formatNumber(arrRs(10,i),0) & "</td>"
			response.write	"	<td class=""aR fnt11"">" & formatNumber(arrRs(11,i) ,0)& "</td>"
			response.write	"	<td class=""aR fnt11"">" & formatNumber(arrRs(12,i),0) & "</td>"
			response.write	"	<td class=""aR fnt11"">" & formatNumber(arrRs(13,i),0) & "</td>"
			response.write	"	<td class=""aR fnt11"">" & formatNumber(arrRs(14,i),0) & "</td>"
			response.write	"</tr>"
		next
		%>
		<tr>
			<th>합계</th>
			<%
			for i = 2 to ubound(sumCnt)
				%><th class="aR"><%=formatNumber(sumCnt(i),0)%></th><%
			next
			%>
		</tr>
	</table>
	
</div>

<!--#include virtual="/common/footer_adm.asp"-->

<script>
	
	function fnSch(){
		document.schFrm.submit();
	}
	
</script>