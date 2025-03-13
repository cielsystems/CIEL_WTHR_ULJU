<!--#include virtual="/common/common.asp"-->

<% mnCD = "3006" %>

<!--#include virtual="/common/header_adm.asp"-->

<%
dim schYear	: schYear	= fnIsNull(fnReq("schYear"), year(now))
%>

<div id="subPageBox">
	
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<form name="schFrm" method="post" action="" target="">
						
						<select name="schYear">
							<%
							dim tmpYear
							for i = -5 to 0
								tmpYear	= year(dateAdd("yyyy", i, now))
								response.write	"<option value=""" & tmpYear & """"
								if cInt(tmpYear) = cInt(schYear) then
									response.write	" selected "
								end if
								response.write	">" & tmpYear & "년</option>"
							next
							%>
						</select>
						<img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" title="검색" onclick="fnSch()" />
						
					</form>
						
				</td>
				<td class="aR" width="100px">
					<!--<img class="imgBtn" src="<%=pth_pubImg%>/btn/xlsDown2.png" title="엑셀다운" onclick="fnXlsDown()" />-->
				</td>
			</tr>
		</table>
	</div>
	
	<br />
	
	<table border="0" cellpadding="0" cellspacing="1" class="tblList">
		<colgroup>
		</colgroup>
		<tr>
			<th rowspan="2">구분</th>
			<th colspan="2">비상발령</th>
			<th colspan="2">문자</th>
			<th colspan="2">기상특보</th>
			<th colspan="2">합계</th>
		</tr>
		<tr>
			<th>전송</th>
			<th>대상</th>
			<th>전송</th>
			<th>대상</th>
			<th>전송</th>
			<th>대상</th>
			<th>전송</th>
			<th>대상</th>
		</tr>
		<%
		dim emrCnt, emrTrgCnt, smsCnt, smsTrgCnt, wthCnt, wthTrgCnt
		dim sumCnt(7)
		for i = 1 to 12
		
			sql = " select "
			sql = sql & " 	count(*) "
			sql = sql & " 	, count(case CL_GB when 'E' then 1 else null end) "
			sql = sql & " 	, isnull(sum(case CL_GB when 'E' then cnt else null end), 0) "
			sql = sql & " 	, count(case CL_GB when 'S' then 1 else null end) "
			sql = sql & " 	, isnull(sum(case CL_GB when 'S' then cnt else null end), 0) "
			sql = sql & " 	, count(case CL_GB when 'W' then 1 else null end) "
			sql = sql & " 	, isnull(sum(case CL_GB when 'W' then cnt else null end), 0) "
			sql = sql & " from ( "
			sql = sql & " 	select  "
			sql = sql & " 		cl.CL_IDX, cl.CL_GB, count(*) as cnt "
			sql = sql & " 	from TBL_CALL as cl with(nolock) "
			sql = sql & " 		left join TBL_CALLTRG as clt with(nolock) on (cl.CL_IDX = clt.CL_IDX) "
			sql = sql & " 	where cl.USEYN = 'Y' and clt.USEYN = 'Y' and format(CL_RSVDT, 'yyyyMM') = '" & schYear & right("0" & i, 2) & "' "
			sql = sql & " 	group by cl.CL_IDX, cl.CL_GB "
			sql = sql & " ) as tbl "
			'response.write	sql
			cmdOpen(sql)
			set rs = cmd.execute
			cmdClose()
			if not rs.eof then
				emrCnt		= rs(1)
				emrTrgCnt	= rs(2)
				smsCnt		= rs(3)
				smsTrgCnt	= rs(4)
				wthCnt		= rs(5)
				wthTrgCnt	= rs(6)
			else
				emrCnt		= 0
				emrTrgCnt	= 0
				smsCnt		= 0
				smsTrgCnt	= 0
				wthCnt		= 0
				wthTrgCnt	= 0
			end if
			rsClose()
			
			response.write	"<tr>"
			response.write	"	<th>" & schYear & "년 " & right("0" & i, 2) & "월</th>"
			response.write	"	<td class=""aR bld"">" & formatNumber(emrCnt, 0) & "</td>"
			response.write	"	<td class=""aR bld"">" & formatNumber(emrTrgCnt, 0) & "</td>"
			response.write	"	<td class=""aR bld"">" & formatNumber(smsCnt, 0) & "</td>"
			response.write	"	<td class=""aR bld"">" & formatNumber(smsTrgCnt, 0) & "</td>"
			response.write	"	<td class=""aR bld"">" & formatNumber(wthCnt, 0) & "</td>"
			response.write	"	<td class=""aR bld"">" & formatNumber(wthTrgCnt, 0) & "</td>"
			response.write	"	<th class=""aR bld"">" & formatNumber(emrCnt + smsCnt + wthCnt, 0) & "</th>"
			response.write	"	<th class=""aR bld"">" & formatNumber(emrTrgCnt + smsTrgCnt + wthTrgCnt, 0) & "</th>"
			response.write	"</tr>"
			
			sumCnt(0) = cInt(sumCnt(0)) + cInt(emrCnt)
			sumCnt(1) = cInt(sumCnt(1)) + cInt(emrTrgCnt)
			sumCnt(2) = cInt(sumCnt(2)) + cInt(smsCnt)
			sumCnt(3) = cInt(sumCnt(3)) + cInt(smsTrgCnt)
			sumCnt(4) = cInt(sumCnt(4)) + cInt(wthCnt)
			sumCnt(5) = cInt(sumCnt(5)) + cInt(wthTrgCnt)
			sumCnt(6) = cInt(sumCnt(6)) + cInt(emrCnt + smsCnt + wthCnt)
			sumCnt(7) = cInt(sumCnt(7)) + cInt(emrTrgCnt + smsTrgCnt + wthTrgCnt)
			
		next
		%>
		<tr>
			<th>합계</th>
			<% for i = 0 to 7 %>
				<th class="aR"><%=formatNumber(sumCnt(i), 0)%></th>
			<% next %>
		</tr>
	</table>
	
</div>

<!--#include virtual="/common/footer_adm.asp"-->

<script>
	
	function fnSch(){
		location.href = '?schYear='+$('select[name=schYear]').val();
	}
	
	function fnXlsDown(){
		procFrame.location.href = 'monthStateXls.asp?schYear=<%=schYear%>';
	}
	
</script>