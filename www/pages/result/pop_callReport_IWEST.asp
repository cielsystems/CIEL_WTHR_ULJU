<!--#include virtual="/common/common.asp"-->

<%
dim clIdx : clIdx = fnReq("clIdx")

dim adID, adNM, clCode, clRsvDT, clStep, clMethod, clSMSMsg, clVMSMsg, clSMSSDT, clSMSEDT, clVMSSDT, clVMSEDT, clSndNum1, clSndNum2
dim callInfo

sql = " select ad.AD_ID, ad.AD_NM, cl.CL_CODE, cl.CL_RSVDT, cl.CL_STEP, cl.CL_METHOD, cl.CL_SMSMSG, cl.CL_VMSMSG "
if dbType = "mssql" then
	sql = sql & " 	, (select top 1 CLTS_SDT from TBL_CALLTRG_SMS with(nolock) where CL_IDX = cl.CL_IDX and CLTS_SDT is not null order by CLTS_SDT asc) as SMSSDT "
	sql = sql & " 	, (select top 1 CLTS_EDT from TBL_CALLTRG_SMS with(nolock) where CL_IDX = cl.CL_IDX and CLTS_EDT is not null order by CLTS_EDT desc) as SMSEDT "
	sql = sql & " 	, (select top 1 CLTV_SDT from TBL_CALLTRG_VMS with(nolock) where CL_IDX = cl.CL_IDX and CLTV_SDT is not null order by CLTV_SDT asc) as VMSSDT "
	sql = sql & " 	, (select top 1 CLTV_EDT from TBL_CALLTRG_VMS with(nolock) where CL_IDX = cl.CL_IDX and CLTV_EDT is not null order by CLTV_EDT desc) as VMSEDT "
elseif dbType = "mysql" then
	sql = sql & " 	, (select CLTS_SDT from TBL_CALLTRG_SMS with(nolock) where CL_IDX = cl.CL_IDX and CLTS_SDT is not null order by CLTS_SDT asc limit 0, 1) as SMSSDT "
	sql = sql & " 	, (select CLTS_EDT from TBL_CALLTRG_SMS with(nolock) where CL_IDX = cl.CL_IDX and CLTS_EDT is not null order by CLTS_EDT desc limit 0, 1) as SMSEDT "
	sql = sql & " 	, (select CLTV_SDT from TBL_CALLTRG_VMS with(nolock) where CL_IDX = cl.CL_IDX and CLTV_SDT is not null order by CLTV_SDT asc limit 0, 1) as VMSSDT "
	sql = sql & " 	, (select CLTV_EDT from TBL_CALLTRG_VMS with(nolock) where CL_IDX = cl.CL_IDX and CLTV_EDT is not null order by CLTV_EDT desc limit 0, 1) as VMSEDT "
end if
sql = sql & " 	, cl.CL_SNDNUM1, cl.CL_SNDNUM2 "
sql = sql & " from TBL_CALL as cl with(nolock) "
sql = sql & " 	left join TBL_ADDR as ad with(nolock) on (cl.AD_IDX = ad.AD_IDX) "
sql = sql & " where cl.CL_IDX = " & clIdx & " "
'response.write	sql
callInfo = execSqlArrVal(sql)
adID			= callInfo(0)
adNM			= callInfo(1)
clCode		= callInfo(2)
clRsvDT		= fnDateToStr(callInfo(3), "yyyy-mm-dd hh:nn:ss")
clStep		= callInfo(4)
clMethod	= callInfo(5)
clSMSMsg	= callInfo(6)
clVMSMsg	= callInfo(7)
clSMSSDT	= fnDateToStr(callInfo(8) , "yyyy-mm-dd hh:nn:ss")
clSMSEDT	= fnDateToStr(callInfo(9) , "yyyy-mm-dd hh:nn:ss")
clVMSSDT	= fnDateToStr(callInfo(10), "yyyy-mm-dd hh:nn:ss")
clVMSEDT	= fnDateToStr(callInfo(11), "yyyy-mm-dd hh:nn:ss")
clSndNum1	= callInfo(12)
clSndNum2	= callInfo(13)

dim arrGrpHeader : arrGrpHeader = array("음성발령+문자발령","음성발령","문자발령")
%>

<!--#include virtual="/common/header_pop.asp"-->

<style>
	h2 {margin-bottom:10px;}
	h2 td {border-bottom:2px solid #000000;padding:0 10px 5px 10px;font-size:22px;}
	.tblPrint {width:100%;margin:2px 0;}
	.tblPrint th {padding:3px;font-weight:normal;color:#000000;background:#eeeeee;}
	.tblPrint td {padding:3px;text-align:center;}
	.tdBG {background:#eeeeee;color:#333333;}
	.grpBox {padding:0;}
	.grpBox .tit {background:#eeeeee;color:#333333;line-height:28px;}
	.grpBox .grp {}
	.barBlue {background:#0060fe;}
	.barRed {background:#ff1e1e;}
	.barGreen {background:#68ac00;}
	.barGray {background:#7c7c7c;}
	.grpBox .grpBar {width:60px;}
	.grpBox .grpBar .non {background:#ffffff;font-size:0px;padding:1px 0 0 0;}
	.grpBox .grpBar .bar {font-size:0px;padding:1px 0 0 0;}
	.grpBox .grpBar .txt {background:#ffffff;font-size:11px;}
</style>

<div id="popBody">

	<div class="aR"><img class="imgBtn" src="<%=pth_pubImg%>/btn/blue_print.png" onclick="fnPrint()" /></div>

	<div id="printBox">

		<h2 class="aC">
			<table><tr><td>비상 발령 결과 보고서 </td></tr></table>
		</h2>

		<table width="100%" border="1" cellpadding="0" cellspacing="0">
			<tr>
				<td style="padding:0 2px;">

					<table border="1" cellpadding="0" cellspacing="0" class="tblPrint">
						<colgroup>
							<col width="120px" />
							<col width="220px" />
							<col width="90px" />
							<col width="220px" />
							<col width="90px" />
							<col width="*" />
						</colgroup>
						<tr>
							<th>발령코드</th>
							<td class="tdBG"><%=clCode%></td>
							<th>발령자계정</th>
							<td><%=adNM%>(<%=adID%>)</td>
							<th>발령결과</th>
							<td><span class="<%=arrCallStepCls(clStep)%>"><%=arrCallStep(clStep)%></span></td>
						</tr>
						<tr>
							<th>(음성)시작시간</th>
							<td><%=clVMSSDT%></td>
							<th>완료시간</th>
							<td><%=clVMSEDT%></td>
							<th>소요시간</th>
							<td><%=fnPeriodToStr(clVMSSDT, clVMSEDT)%></td>
						</tr>
						<tr>
							<th>(문자)시작시간</th>
							<td><%=clSMSSDT%></td>
							<th>완료시간</th>
							<td><%=clSMSEDT%></td>
							<th>소요시간</th>
							<td><%=fnPeriodToStr(clSMSSDT, clSMSEDT)%></td>
						</tr>
					</table>

					<table border="1" cellpadding="0" cellspacing="0" class="tblPrint">
						<colgroup>
							<col width="120px" />
							<col width="*" />
						</colgroup>
						<tr>
							<th>음성내용</th>
							<td style="text-align:left;"><%=clVMSMsg%></td>
						</tr>
						<tr>
							<th>문자내용</th>
							<td style="text-align:left;"><%=clSMSMsg%></td>
						</tr>
					</table>
					
<%
sql = " exec usp_callReport " & clIdx & " "
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

for i = 0 to arrRc2
	if arrRs(1,i) > 0 then
		%>
			<h3 style="margin-top:30px;<% if i mod 2 = 1 then %>page-break-before: always;<% end if %>"><%=mid(arrRs(0,i),3,len(arrRs(0,i)))%></h3>
					<table border="1" cellpadding="0" cellspacing="0" class="tblPrint">
						<colgroup>
							<col width="*" />
							<col width="20%" />
							<col width="20%" />
							<col width="2px" />
							<col width="20%" />
							<col width="20%" />
						</colgroup>
						<tr>
							<th>전체</th>
							<th>응답</th>
							<th>미응답</th>
							<th></th>
							<th>음성응답</th>
							<th>문자응답</th>
						</tr>
						<tr>
							<td><%=formatNumber(arrRs(1,i),0)%></td>
							<td><%=formatNumber(arrRs(2,i),0)%></td>
							<td><%=formatNumber(arrRs(3,i),0)%></td>
							<td></td>
							<td><%=formatNumber(arrRs(4,i),0)%></td>
							<td><%=formatNumber(arrRs(5,i),0)%></td>
						</tr>
					</table>

					<table border="1" cellpadding="0" cellspacing="0" class="tblPrint">
						<colgroup>
							<col width="50%" />
							<col width="50%" />
						</colgroup>
						<tr>
								<td class="grpBox" style="padding:0;" valign="top">
									<div class="tit">응답여부</div>
									<div class="grp">
										<table border="0" cellpadding="0" cellspacing="0" style="margin-top:30px;margin-bottom:30px;">
											<tr>
												<td valign="bottom">
													<table border="0" cellpadding="01" cellspacing="0" class="grpBar barBlue">
														<tr><td class="non" style="height:<%=(100-fnPer(arrRs(1,i),arrRs(2,i)))*2%>px;">&nbsp;</td></tr>
														<tr><td class="bar" style="height:<%=fnPer(arrRs(1,i),arrRs(2,i))*2%>px;">&nbsp;</td></tr>
														<tr><td class="txt">응답<br>(<%=fnPer(arrRs(1,i),arrRs(2,i))%>%)</td></tr>
													</table>
												</td>
												<td valign="bottom">
													<table border="0" cellpadding="01" cellspacing="0" class="grpBar barRed">
														<tr><td class="non" style="height:<%=(100-fnPer(arrRs(1,i),arrRs(3,i)))*2%>px;">&nbsp;</td></tr>
														<tr><td class="bar" style="height:<%=fnPer(arrRs(1,i),arrRs(3,i))*2%>px;">&nbsp;</td></tr>
														<tr><td class="txt">미응답<br>(<%=fnPer(arrRs(1,i),arrRs(3,i))%>%)</td></tr>
													</table>
												</td>
											</tr>
										</table>
									</div>
								</td>
								<td class="grpBox" style="padding:0;" valign="top">
									<div class="tit">응답구분</div>
									<div class="grp">
										<table border="0" cellpadding="0" cellspacing="0" style="margin-top:30px;margin-bottom:30px;">
											<tr>
												<td valign="bottom">
													<table border="0" cellpadding="01" cellspacing="0" class="grpBar barBlue">
														<tr><td class="non" style="height:<%=(100-fnPer(arrRs(2,i),arrRs(4,i)))*2%>px;">&nbsp;</td></tr>
														<tr><td class="bar" style="height:<%=fnPer(arrRs(2,i),arrRs(4,i))*2%>px;">&nbsp;</td></tr>
														<tr><td class="txt">음성응답<br>(<%=fnPer(arrRs(2,i),arrRs(4,i))%>%)</td></tr>
													</table>
												</td>
												<td valign="bottom">
													<table border="0" cellpadding="01" cellspacing="0" class="grpBar barRed">
														<tr><td class="non" style="height:<%=(100-fnPer(arrRs(2,i),arrRs(5,i)))*2%>px;">&nbsp;</td></tr>
														<tr><td class="bar" style="height:<%=fnPer(arrRs(2,i),arrRs(5,i))*2%>px;">&nbsp;</td></tr>
														<tr><td class="txt">문자응답<br>(<%=fnPer(arrRs(2,i),arrRs(5,i))%>%)</td></tr>
													</table>
												</td>
											</tr>
										</table>
									</div>
								</td>
						</tr>
					</table>
					
		<%
	end if
next
%>

				</td>
			</tr>
		</table>

	</div>

</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>

	function fnPrint(){
		window.print();
	}

</script>