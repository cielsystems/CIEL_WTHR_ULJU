<!--#include virtual="/common/common.asp"-->

<% mnCD = "3005" %>

<!--#include virtual="/common/header_adm.asp"-->

<%
dim schSDate : schSDate = fnIsNull(fnReq("schSDate"),left(date,4) + "-01")
dim schEDate : schEDate = fnIsNull(fnReq("schEDate"),left(date,7))

%>

<div id="subPageBox">
	
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<form name="schFrm" method="post">
						
						<table align="left">
							<tr>
								<td><label>기간(년월)</label></td>
								<td>
									<input type="text" id="schSDate" name="schSDate" value="<%=schSDate%>" size="7" readonly />
									~
									<input type="text" id="schEDate" name="schEDate" value="<%=schEDate%>" size="7" readonly />
									
									<img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" title="검색" onclick="fnSch()" />
								</td>
							</tr>
						</table>
						
					</form>
						
				</td>
				<!-- <td class="aR" width="100px">
					<<img class="imgBtn" src="<%=pth_pubImg%>/btn/xlsDown2.png" onclick="fnXls()" />
				</td> -->
			</tr>
		</table>
	</div>
	
	<%
	sql = " exec nuri.dbo.usp_statusSyncID '" & replace(schSDate,"-","") & "', '" & replace(schEDate,"-","") & "' "
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
			<col width="120px" />
			<col width="120px" />
			<col width="80px" />
			<col width="80px" />
			<col width="80px" />
			<col width="80px" />
			<col width="80px" />
			<col width="80px" />
		</colgroup>
		<tr>
			<th rowspan="2">연동계정</th>
			<th rowspan="2">년월</th>
			<th colspan="3">단문</th>
			<th colspan="3">장문</th>
			<th rowspan="2">총계</th> 
		</tr>
		<tr>
			<th>성공</th>
			<th>실패</th>
			<th>계</th>
			<th>성공</th>
			<th>실패</th>
			<th>계</th>
		</tr>
		<%
		dim oldGrp
		dim arrSum(13)
		for ii = 2 to 8
			
			arrSum(ii) = 0
		next		
		
		for i = 0 to arrRc2

				response.write	"<tr>"
				response.write	"	<th colspan=""1"">"&arrRs(1,i)&"</th>"
				response.write	"	<th colspan=""1"">"&arrRs(0,i)&"</th>"
				for ii = 2 to 8
					response.write	"	<th class=""aR"">" & formatNumber(arrRs(ii,i),0) & "</th>"
					arrSum(ii) = arrSum(ii) + clng(arrRs(ii,i))
				next
				'response.write	"	<th class=""aR"">" & formatNumber(arrSum(ii),0) & "</th>"
				response.write	"</tr>"

		next
				response.write	"<tr>"
				response.write	"	<th colspan=""2"">계</th>"
				for ii = 2 to 8
					response.write	"	<th class=""aR"">" & formatNumber( arrSum(ii),0) & "</th>"
					'arrSum(ii) = arrSum(ii) + arrRs(ii,i)
				next
				'response.write	"	<th class=""aR"">" & formatNumber(arrSum(ii),0) & "</th>"
				response.write	"</tr>"				

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