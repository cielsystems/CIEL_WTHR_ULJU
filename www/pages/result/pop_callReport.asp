<!--#include virtual="/common/common.asp"-->

<%
dim clIdx : clIdx = fnReq("clIdx")

dim adID, adNM, clCode, clRsvDT, clStep, clMethod, clSMSMsg, clVMSMsg, clSMSSDT, clSMSEDT, clVMSSDT, clVMSEDT, clSndNum1, clSndNum2
dim callInfo

sql = " select ad.USER_ID, ad.USER_NAME, cl.CL_CODE, cl.CL_RSVDT, cl.CL_STEP, cl.CL_METHOD, cl.CL_SMSMSG, cl.CL_VMSMSG "
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
sql = sql & " 	left join NTBL_USER as ad with(nolock) on (cl.AD_IDX = ad.USER_INDX) "
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
clSMSSDT	= fnDateToStr(callInfo(3) , "yyyy-mm-dd hh:nn:ss")
clSMSEDT	= fnDateToStr(callInfo(9) , "yyyy-mm-dd hh:nn:ss")
clVMSSDT	= fnDateToStr(callInfo(10), "yyyy-mm-dd hh:nn:ss")
clVMSEDT	= fnDateToStr(callInfo(11), "yyyy-mm-dd hh:nn:ss")
clSndNum1	= callInfo(12)
clSndNum2	= callInfo(13)

sql = " select "
sql = sql & " 	COUNT(*) as CNTALL "
sql = sql & " 	, COUNT(case when CLT_ANSWYN = 'Y' then 1 else null end) as CNTANSW "
sql = sql & " 	, COUNT(case when CLT_ANSWYN = 'N' /*and CD_RESULT = 9003*/ then 1 else null end) as CNTNOANSW "
sql = sql & " 	, COUNT(case when CLT_ANSWYN = 'Y' and CLT_ANSWMEDIA = 'S' then 1 else null end) as CNTSMSANSW "
sql = sql & " 	, COUNT(case when CLT_ANSWYN = 'Y' and CLT_ANSWMEDIA = 'V' then 1 else null end) as CNTVMSANSW "
sql = sql & " 	, COUNT(case when CD_RESULT = 0 then 1 else null end) as CNTSTAY "
sql = sql & " 	, COUNT(case when CD_RESULT between 9001 and 9002 then 1 else null end) as CNTING "
sql = sql & " 	, COUNT(case when CD_RESULT = 9003 then 1 else null end) as CNTCMP "
sql = sql & " 	, COUNT(case when CD_RESULT = 9004 then 1 else null end) as CNTCNL "
sql = sql & " 	, COUNT(case when CD_RESULT = 9005 then 1 else null end) as CNTERR "
if clMethod = "0" then
	sql = sql & " 	, 0 as CNTSMSALL "
	sql = sql & " 	, 0 as CNTSMSSTAY "
	sql = sql & " 	, 0 as CNTSMSING "
	sql = sql & " 	, 0 as CNTSMSCMP "
	sql = sql & " 	, 0 as CNTSMSCNL "
	sql = sql & " 	, 0 as CNTSMSERR "
else
	sql = sql & " 	, (select count(*) from TBL_CALLTRG_SMS with(nolock) where CL_IDX = " & clIdx & ") as CNTSMSALL "
	sql = sql & " 	, (select count(*) from TBL_CALLTRG_SMS with(nolock) where CL_IDX = " & clIdx & " and CD_STATUS < 3032) as CNTSMSSTAY "
	sql = sql & " 	, (select count(*) from TBL_CALLTRG_SMS with(nolock) where CL_IDX = " & clIdx & " and CD_STATUS = 3032) as CNTSMSING "
	sql = sql & " 	, (select count(*) from TBL_CALLTRG_SMS with(nolock) where CL_IDX = " & clIdx & " and CD_STATUS = 3033) as CNTSMSCMP "
	sql = sql & " 	, (select count(*) from TBL_CALLTRG_SMS with(nolock) where CL_IDX = " & clIdx & " and CD_STATUS = 3034) as CNTSMSCNL "
	sql = sql & " 	, (select count(*) from TBL_CALLTRG_SMS with(nolock) where CL_IDX = " & clIdx & " and CD_STATUS = 3035) as CNTSMSERR "
	'sql = sql & " 	, COUNT(case when CD_SMSSTATUS < 3032 then 1 else null end) as CNTSMSSTAY "
	'sql = sql & " 	, COUNT(case when CD_SMSSTATUS = 3032 then 1 else null end) as CNTSMSING "
	'sql = sql & " 	, COUNT(case when CD_SMSSTATUS = 3033 then 1 else null end) as CNTSMSCMP "
	'sql = sql & " 	, COUNT(case when CD_SMSSTATUS = 3034 then 1 else null end) as CNTSMSCNL "
	'sql = sql & " 	, COUNT(case when CD_SMSSTATUS = 3035 then 1 else null end) as CNTSMSERR "
end if
if clMethod = "1" then
	sql = sql & " 	, COUNT(*) as CNTVMSNONE "
	sql = sql & " 	, 0 as CNTVMSSTAY "
	sql = sql & " 	, 0 as CNTVMSING "
	sql = sql & " 	, 0 as CNTVMSCMP "
	sql = sql & " 	, 0 as CNTVMSCNL "
	sql = sql & " 	, 0 as CNTVMSERR "
else
	sql = sql & " 	, COUNT(case when CD_VMSSTATUS = 0 and CD_STATUS = 3033 and CLT_ANSWYN = 'Y' and CLT_ANSWMEDIA = 'S' then 1 else null end) as CNTVMSNONE "
	sql = sql & " 	, COUNT(case when CD_VMSSTATUS < 3032 then 1 else null end) as CNTVMSSTAY "
	sql = sql & " 	, COUNT(case when CD_VMSSTATUS = 3032 then 1 else null end) as CNTVMSING "
	sql = sql & " 	, COUNT(case when CD_VMSSTATUS = 3033 or CLT_ANSWYN = 'Y' then 1 else null end) as CNTVMSCMP "
	sql = sql & " 	, COUNT(case when CD_VMSSTATUS = 3034 and CLT_ANSWYN = 'N' then 1 else null end) as CNTVMSCNL "
	sql = sql & " 	, COUNT(case when CD_VMSSTATUS = 3035 and CLT_ANSWYN = 'N' then 1 else null end) as CNTVMSERR "
end if
sql = sql & " from TBL_CALLTRG with(nolock) "
sql = sql & " where CL_IDX = " & clIdx & " "
'response.write	sql
callInfo = execSqlArrVal(sql)
'for i = 0 to ubound(callInfo)
'	response.write	"<div>" & i & ":" & callInfo(i) & "</div>"
'next
dim cntAll			: cntAll			= clng(callInfo(0))
dim cntAnsw			: cntAnsw			= clng(callInfo(1))
dim cntNoAnsw		: cntNoAnsw		= clng(callInfo(2))
dim cntSMSAnsw	: cntSMSAnsw	= clng(callInfo(3))
dim cntVMSAnsw	: cntVMSAnsw	= clng(callInfo(4))
dim cntStay			: cntStay			= clng(callInfo(5))
dim cntIng			: cntIng			= clng(callInfo(6))
dim cntCmp			: cntCmp			= clng(callInfo(7))
dim cntCnl			: cntCnl			= clng(callInfo(8))
dim cntErr			: cntErr			= clng(callInfo(9))

dim cntSMSAll		: cntSMSAll		= clng(callInfo(10))
dim cntSMSStay	: cntSMSStay	= clng(callInfo(11))
dim cntSMSIng		: cntSMSIng		= clng(callInfo(12))
dim cntSMSCmp		: cntSMSCmp		= clng(callInfo(13))
dim cntSMSCnl		: cntSMSCnl		= clng(callInfo(14))
dim cntSMSErr		: cntSMSErr		= clng(callInfo(15))

dim cntVMSAll		: cntVMSAll		= cntAll - clng(callInfo(16))
dim cntVMSStay	: cntVMSStay	= clng(callInfo(17))
dim cntVMSIng		: cntVMSIng		= clng(callInfo(18))
dim cntVMSCmp		: cntVMSCmp		= clng(callInfo(19))
dim cntVMSCnl		: cntVMSCnl		= clng(callInfo(20))
dim cntVMSErr		: cntVMSErr		= clng(callInfo(21))

dim perAnsw(2), perNoAnsw(2), perNone(2), perErr(2)
perAnsw(0) = fnPer(cntAll,cntAnsw)
perAnsw(1) = fnPer(cntVMSAll,cntVMSAnsw)
perAnsw(2) = fnPer(cntSMSALL,cntSMSAnsw)
perNoAnsw(0) = fnPer(cntAll,cntNoAnsw)
perNoAnsw(1) = fnPer(cntVMSAll,cntVMSAll-cntVMSAnsw)
perNoAnsw(2) = fnPer(cntSMSALL,cntSMSALL-cntSMSAnsw)
perNone(0) = fnPer(cntAll,cntStay+cntIng)
perNone(1) = fnPer(cntVMSAll,cntVMSStay+cntVMSIng)
perNone(2) = fnPer(cntSMSALL,cntSMSStay+cntSMSIng)
perErr(0) = fnPer(cntAll,cntCnl+cntErr)
perErr(1) = fnPer(cntVMSAll,cntVMSCnl+cntVMSErr)
perErr(2) = fnPer(cntSMSALL,cntSMSCnl+cntSMSErr)


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
							<th>ARS응답</th>
						</tr>
						<tr>
							<td><%=formatNumber(cntAll,0)%></td>
							<td><%=formatNumber(cntAnsw,0)%></td>
							<td><%=formatNumber(cntNoAnsw,0)%></td>
							<td></td>
							<td><%=formatNumber(cntVMSAnsw,0)%></td>
							<td><%=formatNumber(cntSMSAnsw,0)%></td>
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
														<tr><td class="non" style="height:<%=(100-fnPer(cntAll,cntAnsw))*2%>px;">&nbsp;</td></tr>
														<tr><td class="bar" style="height:<%=fnPer(cntAll,cntAnsw)*2%>px;">&nbsp;</td></tr>
														<tr><td class="txt">응답<br>(<%=fnPer(cntAll,cntAnsw)%>%)</td></tr>
													</table>
												</td>
												<td valign="bottom">
													<table border="0" cellpadding="01" cellspacing="0" class="grpBar barRed">
														<tr><td class="non" style="height:<%=(100-fnPer(cntAll,cntNoAnsw))*2%>px;">&nbsp;</td></tr>
														<tr><td class="bar" style="height:<%=fnPer(cntAll,cntNoAnsw)*2%>px;">&nbsp;</td></tr>
														<tr><td class="txt">미응답<br>(<%=fnPer(cntAll,cntNoAnsw)%>%)</td></tr>
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
														<tr><td class="non" style="height:<%=(100-fnPer(cntAnsw,cntVMSAnsw))*2%>px;">&nbsp;</td></tr>
														<tr><td class="bar" style="height:<%=fnPer(cntAnsw,cntVMSAnsw)*2%>px;">&nbsp;</td></tr>
														<tr><td class="txt">음성응답<br>(<%=fnPer(cntAnsw,cntVMSAnsw)%>%)</td></tr>
													</table>
												</td>
												<td valign="bottom">
													<table border="0" cellpadding="01" cellspacing="0" class="grpBar barRed">
														<tr><td class="non" style="height:<%=(100-fnPer(cntAnsw,cntSMSAnsw))*2%>px;">&nbsp;</td></tr>
														<tr><td class="bar" style="height:<%=fnPer(cntAnsw,cntSMSAnsw)*2%>px;">&nbsp;</td></tr>
														<tr><td class="txt">ARS응답<br>(<%=fnPer(cntAnsw,cntSMSAnsw)%>%)</td></tr>
													</table>
												</td>
											</tr>
										</table>
									</div>
								</td>
						</tr>
					</table>

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