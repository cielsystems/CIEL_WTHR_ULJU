<!--#include virtual="/common/common.asp"-->

<%
dim schYear	: schYear	= fnIsNull(fnReq("schYear"), year(now))

dim fileName	: fileName	= schYear & "년 월별통계.xls"

response.cacheControl = "public"
response.charSet = "utf-8"
response.contentType = "application/vnd.ms-excel"
response.addHeader "Content-disposition","attachment;filename=" & server.URLPathEncode(fileName)

response.write	"<html>"
response.write	"<head>"
response.write	"<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"">"
response.write	"<style type=""text/css"">"
response.write	"	.txt {mso-number-format:'\@'}"
response.write	"</style>"
response.write	"</head>"
response.write	"<body>"
%>
	
	<table border="1">
		<colgroup>
		</colgroup>
		<tr>
			<th colspan="7"><%=schYear%>년 월별통계</th>
		</tr>
		<tr>
			<th rowspan="2">구분</th>
			<th colspan="2">비상발령</th>
			<th colspan="2">문자</th>
			<th colspan="2">합계</th>
		</tr>
		<tr>
			<th>전송</th>
			<th>대상</th>
			<th>전송</th>
			<th>대상</th>
			<th>전송</th>
			<th>대상</th>
		</tr>
		<%
		dim emrCnt, emrTrgCnt, smsCnt, smsTrgCnt
		dim sumCnt(5)
		for i = 1 to 12
		
			sql = " select "
			sql = sql & " 	count(*) "
			sql = sql & " 	, count(case CL_GB when 'E' then 1 else null end) "
			sql = sql & " 	, isnull(sum(case CL_GB when 'E' then cnt else null end), 0) "
			sql = sql & " 	, count(case CL_GB when 'S' then 1 else null end) "
			sql = sql & " 	, isnull(sum(case CL_GB when 'S' then cnt else null end), 0) "
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
			else
				emrCnt		= 0
				emrTrgCnt	= 0
				smsCnt		= 0
				smsTrgCnt	= 0
			end if
			rsClose()
			
			response.write	"<tr>"
			response.write	"	<th>" & schYear & "년 " & right("0" & i, 2) & "월</th>"
			response.write	"	<td class=""aR bld"">" & formatNumber(emrCnt, 0) & "</td>"
			response.write	"	<td class=""aR bld"">" & formatNumber(emrTrgCnt, 0) & "</td>"
			response.write	"	<td class=""aR bld"">" & formatNumber(smsCnt, 0) & "</td>"
			response.write	"	<td class=""aR bld"">" & formatNumber(smsTrgCnt, 0) & "</td>"
			response.write	"	<th class=""aR bld"">" & formatNumber(emrCnt + smsCnt, 0) & "</th>"
			response.write	"	<th class=""aR bld"">" & formatNumber(emrTrgCnt + smsTrgCnt, 0) & "</th>"
			response.write	"</tr>"
			
			sumCnt(0) = cInt(sumCnt(0)) + cInt(emrCnt)
			sumCnt(1) = cInt(sumCnt(1)) + cInt(emrTrgCnt)
			sumCnt(2) = cInt(sumCnt(2)) + cInt(smsCnt)
			sumCnt(3) = cInt(sumCnt(3)) + cInt(smsTrgCnt)
			sumCnt(4) = cInt(sumCnt(4)) + cInt(emrCnt + smsCnt)
			sumCnt(5) = cInt(sumCnt(5)) + cInt(emrTrgCnt + smsTrgCnt)
			
		next
		%>
		<tr>
			<th>합계</th>
			<% for i = 0 to 5 %>
				<th class="aR"><%=formatNumber(sumCnt(i), 0)%></th>
			<% next %>
		</tr>
	</table>
	
	<%
response.write	"</body>"
response.write	"</html>"
%>