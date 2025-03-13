<!--#include virtual="/common/common.asp"-->

<% mnCD = "00" %>

<!--#include virtual="/common/header_htm.asp"-->

<div id="subPageBox">
	
	<div style="background:#eeeeee;border:1px solid #cccccc;padding:10px;margin:10px 0;">
		<dl class="noticeMsgList">
			<dt style="font-size:13px;">모든 사용자의 비상발령 내역이 보여집니다. 로그인한 계정의 내역만 확인하시려면 <a href="/pages/result/emrList.asp">전송결과</a> 로 이동하시기 바립니다.</dt>
		</dl>
	</div>
	
	<h3>▶ 비상발령현황</h3>
	
	<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
		<colgroup>
			<col width="100px" />
			<col width="160px" />
			<col width="140px" />
			<col width="80px" />
			<col width="*" />
			<col width="100px" />
			<col width="80px" />
		</colgroup>
		<tr>
			<th>발령자</th>
			<th>시작시간</th>
			<th>경과시간</th>
			<th>실행구분</th>
			<th>구분</th>
			<th>대상자</th>
			<th>결과</th>
		</tr>
		<%
		'//	CL_IDX(2), CL_RSVDT(3), CL_RSVYN(4), CL_METHOD(5), TRGCNT(6), CL_STEP(7), CL_EDT(8)
		arrRs = execProcRs("usp_listHome",array(1, 1, 5))
		if isarray(arrRs) then
			arrRc2 = ubound(arrRs,2)
		else
			arrRc2 = -1
		end if
		for i = 0 to arrRc2
			response.write	"<tr>"
			response.write	"	<td class=""aC"">" & arrRs(9,i) & "</td>"
			response.write	"	<td class=""aC"">" & arrRs(3,i) & "</td>"
			response.write	"	<td class=""aC"">" & fnPeriodToStr(arrRs(3,i), now()) & "</td>"
			response.write	"	<td class=""aC"">"
			if arrRs(4,i) = "Y" then
				response.write	"<span class=""colRed"">예약</span>"
			else
				response.write	"<span class=""colBlue"">즉시</span>"
			end if
			response.write	"</td>"
			response.write	"	<td class=""aC"">" & arrCallMethod(arrRs(5,i)) & "</td>"
			response.write	"	<td class=""aC"">" & formatNumber(arrRs(6,i),0) & "명</td>"
			response.write	"	<td class=""aC""><span class=""" & arrCallStepCls(arrRs(7,i)) & """>" & arrCallStep(arrRs(7,i)) & "</span></td>"
			response.write	"</tr>"
		next
		%>
	</table>
	<br />
	
	<h3>▶ 비상발령결과</h3>
	
	<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
		<colgroup>
			<col width="100px" />
			<col width="160px" />
			<col width="140px" />
			<col width="80px" />
			<col width="*" />
			<col width="100px" />
			<col width="80px" />
		</colgroup>
		<tr>
			<th>발령자</th>
			<th>시작시간</th>
			<th>완료시간</th>
			<th>실행구분</th>
			<th>구분</th>
			<th>대상자</th>
			<th>결과</th>
		</tr>
		<%
		'//	CL_IDX(2), CL_RSVDT(3), CL_RSVYN(4), CL_METHOD(5), TRGCNT(6), CL_STEP(7), CL_EDT(8)
		arrRs = execProcRs("usp_listHome",array(2, 1, 5))
		if isarray(arrRs) then
			arrRc2 = ubound(arrRs,2)
		else
			arrRc2 = -1
		end if
		for i = 0 to arrRc2
			response.write	"<tr>"
			response.write	"	<td class=""aC"">" & arrRs(9,i) & "</td>"
			response.write	"	<td class=""aC"">" & arrRs(3,i) & "</td>"
			response.write	"	<td class=""aC"">" & fnPeriodToStr(arrRs(3,i), arrRs(8,i)) & "</td>"
			response.write	"	<td class=""aC"">"
			if arrRs(4,i) = "Y" then
				response.write	"<span class=""colRed"">예약</span>"
			else
				response.write	"<span class=""colBlue"">즉시</span>"
			end if
			response.write	"</td>"
			response.write	"	<td class=""aC"">" & arrCallMethod(arrRs(5,i)) & "</td>"
			response.write	"	<td class=""aC"">" & formatNumber(arrRs(6,i),0) & "명</td>"
			response.write	"	<td class=""aC""><span class=""" & arrCallStepCls(arrRs(7,i)) & """>" & arrCallStep(arrRs(7,i)) & "</span></td>"
			response.write	"</tr>"
		next
		%>
	</table>
	
</div>

<!--#include virtual="/common/footer_htm.asp"-->