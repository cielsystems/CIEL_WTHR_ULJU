<!--#include virtual="/common/common.asp"-->

<%
dim gb : gb = fnReq("gb") : if gb = "" then gb = "0" end if
dim trg : trg = fnReq("trg")

dim today : today = date
dim yy, mm, dd, prevmm, nextmm, ww, endDay

yy = request("yy") : if yy = "" then yy = year(today) end if
mm = request("mm") : if mm = "" then mm = month(today) end if
mm = right("0" & mm,2)

dd = day(today)
dd = right("0" & dd,2)

prevmm = month(dateadd("m",-1,dateserial(yy,mm,1)))
nextmm = month(dateadd("m",1,dateserial(yy,mm,1)))

ww = weekday(dateserial(yy,mm,1)) - 1

endDay = day(dateadd("d",-1,(dateadd("m",1,dateserial(yy,mm,1)))))

dim prevLastDay : prevLastDay = dateadd("d",-1,dateserial(yy,mm,1))
prevLastDay = dateadd("d",-ww,prevLastDay)

dim prevDate	: prevDate	= dateadd("m",-1,dateserial(yy,mm,dd))
dim prevYear	: prevYear	= fnDateToStr(prevDate,"yyyy")
dim prevMonth	: prevMonth	= fnDateToStr(prevDate,"mm")

dim nextDate	: nextDate	= dateadd("m",1,dateserial(yy,mm,dd))
dim nextYear	: nextYear	= fnDateToStr(nextDate,"yyyy")
dim nextMonth	: nextMonth	= fnDateToStr(nextDate,"mm")
%>

<!doctype html>
<html>
<head>
<meta http-equiv="expires" content="0">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<title></title>
<style>
	* {font-size:13px;}
	body {margin:0;padding:0;background:#eeeeee;font-family:맑은 고딕,Verdana;}
	th {background:#dddddd;padding:2px;}
	td {text-align:center;padding:2px;}
	.colorRed {color:red;}
	.colorBlue {color:blue;}
	.on {font-weight:bold;color:orange;}
	.noneThisMonth {color:#999;}
	select {font-size:12px;}
	a {text-decoration:none;color:#333;}
</style>
</head>
<body>

<form name="frm_cal" method="post" action="" target="">
	<input type="hidden" name="trg" value="<%=trg%>" />
	
<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:5px 0;">
	<tr>
		<td align="left"><a href="javascript:fnMovePrev()"><img src="<%=pth_pubImg%>/icons/control-left.png" border="0" /></a></td>
		<td align="center">
			<select name="yy" onchange="fnMoveYear(this.value)">
				<%
				for i = -5 to 1
					response.write	"<option value=""" & year(dateadd("yyyy",i,date)) & """"
					if cStr(year(dateadd("yyyy",i,date))) = cStr(yy) then
						response.write	" selected "
					end if
					response.write	">" & year(dateadd("yyyy",i,date)) & "년</option>"
				next
				%>
			</select>
			<select name="mm" onchange="fnMoveMonth(this.value)">
				<%
				for i = 1 to 12
					response.write	"<option value=""" & right("0" & i, 2) & """"
					if cStr(right("0" & i, 2)) = cStr(mm) then
						response.write	" selected "
					end if
					response.write	">" & right("0" & i, 2) & "월</option>"
				next
				%>
			</select>
		</td>
		<td align="right"><a href="javascript:fnMoveNext()"><img src="<%=pth_pubImg%>/icons/control-right.png" border="0" /></a></td>
	</tr>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<colgroup>
		<col width="*" />
		<col width="14%" />
		<col width="14%" />
		<col width="14%" />
		<col width="14%" />
		<col width="14%" />
		<col width="14%" />
	</colgroup>
	<tr>
		<th class="colorRed">S</th>
		<th>M</th>
		<th>T</th>
		<th>W</th>
		<th>T</th>
		<th>F</th>
		<th class="colorBlue">S</th>
	</tr>
	<tr>
		<%
		for i = 1 to ww step 1
			response.write	"<td style=""cursor:pointer;"" class=""noneThisMonth"" onclick=""fnSelDate('" & dateadd("d",i,prevLastDay) & "')"">" & day(dateadd("d",i,prevLastDay)) & "</td>"
		next
		
		for i = 1 to endDay step 1
			response.write	"<td style=""cursor:pointer;"""
			if cStr(right("0" & i,2)) = cStr(dd) then
				response.write	" class=""on"""
			else
				response.write	""
			end if
			response.write	" onclick=""fnSelDate('" & yy & "-" & right("0" & mm,2) & "-" & right("0" & i,2) & "')"">" & i & "</td>"
			if (i+ww) mod 7 = 0 then
				response.write	"</tr><tr>"
			end if
		next
		
		do until ((i+ww) mod 7 = 1)
		response.write	"<td style=""cursor:pointer;"" class=""noneThisMonth"" onclick=""fnSelDate('" & dateadd("m",1,yy & "-" & right("0" & mm,2) & "-" & right("0" & i-endDay,2)) & "')"">" & i-endDay & "</td>"
			i = i+1
		loop
		%>
	</tr>
</table>

<% if gb = "0" then %>
	<div style="text-align:right;margin-top:5px;"><a href="javascript:fnClose()" style="font-size:12px;font-weight:bold;">[닫기]</a></div>
<% end if %>

</form>

</body>
</html>

<script>
	var frm_cal = document.frm_cal;
	function fnMoveMonth(mm) {
		location.href = '?gb=<%=gb%>&trg='+frm_cal.trg.value+'&yy='+frm_cal.yy.value+'&mm='+mm;
	}
	function fnMoveYear(yy) {
		location.href = '?gb=<%=gb%>&trg='+frm_cal.trg.value+'&yy='+yy+'&mm='+frm_cal.mm.value;
	}
	function fnMovePrev(){
		location.href = '?gb=<%=gb%>&trg='+frm_cal.trg.value+'&yy=<%=prevYear%>&mm=<%=prevMonth%>';
	}
	function fnMoveNext(){
		location.href = '?gb=<%=gb%>&trg='+frm_cal.trg.value+'&yy=<%=nextYear%>&mm=<%=nextMonth%>';
	}
	function fnSelDate(date) {
		<% if gb <> "1" then %>
			parent.document.getElementById('<%=trg%>').value = date;
			fnClose();
		<% end if %>
	}
	function fnClose() {
		parent.fnClosePosLayer();
	}
</script>