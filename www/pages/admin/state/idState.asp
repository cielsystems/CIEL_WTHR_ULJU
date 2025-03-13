<!--#include virtual="/common/common.asp"-->

<% mnCD = "3004" %>

<!--#include virtual="/common/header_adm.asp"-->

<%
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
%>

<div id="subPageBox">
	
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<form name="schFrm" method="post">
						
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
					<img class="imgBtn" src="<%=pth_pubImg%>/btn/xlsDown2.png" onclick="fnXls()" />
				</td>
			</tr>
		</table>
	</div>
	
	<%
	sql = " exec usp_statusNuriID '" & schSDate & "', '" & schEDate & "' "
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
	%>
	
	<table border="0" cellpadding="0" cellspacing="1" class="tblList">
		<colgroup>
			<col width="*" />
			<col width="120px" />
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
			<th colspan="2">구분</th>
			<th colspan="4">비상전파</th>
			<th colspan="3">문자메시지</th>
			<th rowspan="2">음성메시지</th>
		</tr>
		<tr>
			<th>과금아이디</th>
			<th>사용계정</th>
			<th>음성</th>
			<th>단문</th>
			<th>장문</th>
			<th>멀티</th>
			<th>단문</th>
			<th>장문</th>
			<th>멀티</th>
		</tr>
		<%
		dim oldGrp
		dim arrSum(13)
		for i = 0 to arrRc2
			if i > 0 then
				if oldGrp <> arrRs(0,i) then
					response.write	"<tr>"
					response.write	"	<th colspan=""2"">소계</th>"
					for ii = 6 to 13
						response.write	"	<th class=""aR"">" & formatNumber(arrSum(ii),0) & "</th>"
						arrSum(ii) = 0
					next
					response.write	"</tr>"
				end if
			end if
			response.write	"<tr>"
			if oldGrp <> arrRs(0,i) then
				response.write	"	<th rowspan=""" & arrRs(3,i) & """>" & arrRs(1,i) & "<div>[" & arrRs(2,i) & "]</div></th>"
			end if
			response.write	"	<td>" & arrRs(5,i) & "</td>"
			for ii = 6 to 13
				arrSum(ii) = arrSum(ii) + arrRs(ii,i)
				response.write	"	<td class=""aR"">" & formatNumber(arrRs(ii,i),0) & "</td>"
			next
			response.write	"</tr>"
			oldGrp = arrRs(0,i)
			if i = arrRc2 then
				response.write	"<tr>"
				response.write	"	<th colspan=""2"">소계</th>"
				for ii = 6 to 13
					response.write	"	<th class=""aR"">" & formatNumber(arrSum(ii),0) & "</th>"
					arrSum(ii) = 0
				next
				response.write	"</tr>"
			end if
		next
		%>
	</table>
	
</div>

<!--#include virtual="/common/footer_adm.asp"-->

<script>
	
	function fnSch(){
		document.schFrm.submit();
	}
	
	function fnXls(){
		procFrame.location.href = 'idStateXls.asp?schSDate=<%=schSDate%>&schEDate=<%=schEDate%>';
	}
	
</script>