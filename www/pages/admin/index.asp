<!--#include virtual="/common/common.asp"-->

<%
response.redirect	"/pages/admin/env/userList.asp"
%>

<%
mnCD = "0000"

dim arrGubun1 : arrGubun1 = array("전체","비상동보","문자전송","음성전송")
dim arrGubun2 : arrGubun2 = array("금일","당월","전체")
dim arrGubun3 : arrGubun3 = array("전체","직원","동보","개인")
dim arrGubun4 : arrGubun4 = array("전체","시스템","주소록","게시판","메시지","문자","음성","기타")
%>

<!--#include virtual="/common/header_adm.asp"-->

<div id="subPageBox">
	
	<h3>▶ 전송통계</h3>
	
	<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
		<colgroup>
			<col width="*" />
			<col width="180px" />
			<col width="180px" />
			<col width="180px" />
			<col width="180px" />
		</colgroup>
		<tr>
			<th>구분</th>
			<% for i = 0 to ubound(arrGubun1) %>
				<th><%=arrGubun1(i)%></th>
			<% next %>
		</tr>
		<% for i = 0 to ubound(arrGubun2) %>
			<tr>
				<th><%=arrGubun2(i)%></th>
				<% for ii = 0 to ubound(arrGubun1) %>
					<td class="aR">1건</td>
				<% next %>
			</tr>
		<% next %>
	</table>
	
	<br /><br />
	
	<h3>▶ 주소록통계</h3>
	
	<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
		<colgroup>
			<col width="180px" />
			<col width="180px" />
			<col width="180px" />
			<col width="180px" />
		</colgroup>
		<tr>
			<% for i = 0 to ubound(arrGubun3) %>
				<th><%=arrGubun3(i)%></th>
			<% next %>
		</tr>
		<tr>
			<% for i = 0 to ubound(arrGubun3) %>
				<td class="aR">1건</td>
			<% next %>
		</tr>
	</table>
	
	<br /><br />
	
	<h3>▶ Disk사용량</h3>
	
	<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
		<colgroup>
			<col width="*" />
			<col width="100px" />
			<col width="100px" />
			<col width="100px" />
			<col width="100px" />
			<col width="100px" />
			<col width="100px" />
			<col width="100px" />
		</colgroup>
		<tr>
			<% for i = 0 to ubound(arrGubun4) %>
				<th><%=arrGubun4(i)%></th>
			<% next %>
		</tr>
		<tr>
			<% for i = 0 to ubound(arrGubun4) %>
				<td class="aR">100Gbyte</td>
			<% next %>
		</tr>
	</table>

</div>

<!--#include virtual="/common/footer_adm.asp"-->