<!--#include virtual="/common/common.asp"-->

<%
dim clIdx : clIdx = fnReq("clIdx")

dim clCode : clCode = fnDBVal("TBL_CALL", "CL_CODE", "CL_IDX = " & clIdx & "")

dim fileName : fileName = clCode & ".xls"
'dim fileName : fileName = clCode & ".hwp"

response.cacheControl = "public"
response.charSet = "utf-8"
response.contentType = "application/vnd.ms-excel"
'response.contentType = "application/hwp"
response.addHeader "Content-disposition","attachment;filename=" & server.URLPathEncode(fileName)

response.write	"<html>"
response.write	"<head>"
response.write	"<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"">"
response.write	"<style type=""text/css"">"
response.write	"	.txt {mso-number-format:'\@'}"
response.write	"</style>"
response.write	"</head>"
response.write	"<body>"

'#	상단 보고서 : 시작	========================================================
dim adID, adNM, clRsvDT, clStep, clMethod, clSMSMsg, clVMSMsg, clSMSSDT, clSMSEDT, clVMSSDT, clVMSEDT, clSndNum1, clSndNum2
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
	sql = sql & " 	, COUNT(case when CD_VMSSTATUS = 3033 then 1 else null end) as CNTVMSCMP "
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
<table border="0"><tr><td colspan="6"><h1>음성전송 결과 보고서</h1></td></tr></table>
<br />
<table border="1">
	<tr>
		<th>발령코드</th>
		<td><%=clCode%></td>
		<th>발령자계정</th>
		<td><%=adNM%>(<%=adID%>)</td>
		<th>발령결과</th>
		<td><%=arrCallStep(clStep)%></td>
	</tr>
	<tr>
		<th>시작시간</th>
		<td><%=clVMSSDT%></td>
		<th>완료시간</th>
		<td><%=clVMSEDT%></td>
		<th>소요시간</th>
		<td><%=fnPeriodToStr(clVMSSDT, clVMSEDT)%></td>
	</tr>
</table>
<br />
<table border="1">
	<tr>
		<th>문자내용</th>
		<td colspan="5"><%=clSMSMsg%></td>
	</tr>
</table>
<br />
<table border="1">
	<tr>
		<th rowspan="2" colspan="2">전체</th>
		<th colspan="4">문자전송결과(회신번호:<%=clSndNum2%>)</th>
	</tr>
	<tr>
		<th>대기</th>
		<th>진행중</th>
		<th>취소/실패</th>
		<th>완료</th>
	</tr>
		<td colspan="2"><%=formatNumber(cntVMSAll,0)%></td>
		<td><%=formatNumber(cntVMSStay,0)%></td>
		<td><%=formatNumber(cntVMSIng,0)%></td>
		<td><%=formatNumber(cntVMSCnl + cntVMSErr,0)%></td>
		<td><%=formatNumber(cntVMSCmp,0)%></td>
	</tr>
</table>
<br />
<table border="0"><tr><td colspan="6"><h2>대상자 목록</h2></td></tr></table>
<br />
<%
'#	상단 보고서 : 끝	========================================================

'#	하단 대상자목록 : 시작	========================================================
arrRs = execProcRs("usp_listCallResultTargets", array(clIdx, "0", "0", "", "", 1, 999999))
if isarray(arrRs) then
	arrRc2 = ubound(arrRs,2)
else
	arrRc2 = -1
end if

response.write	"<table border=""1"">"
response.write	"	<tr>"
response.write	"		<th>번호</th>"
response.write	"		<th>소속</th>"
response.write	"		<th>직위</th>"
response.write	"		<th>이름</th>"
response.write	"		<th>" & arrCallMedia(1) & "번호</th>"
response.write	"		<th>시작일시</th>"
response.write	"		<th>종료일시</th>"
response.write	"		<th>상태</th>"
response.write	"	</tr>"
'//	CLT_NO(2), CLT_NM(3), CLT_SDR(4), CLT_EDT(5), CD_STATUS(6), CDSTATUSNM(7), CD_RESULT(8), CD_RESULTNM(9), CD_ERROR(10)
'//	, CDERRORNM(11), CLT_ANSWYN(12), CLT_ANSWMEDIA(13), CLT_ANSWDT(14), CD_SMSSTATUS(15), CD_VMSSTATUS(16), CLTSTATUS(17), CLT_NUM1(18), CLT_NUM2(19)
'//, CLT_NUM3(20), AD_NO(21)
for i = 0 to arrRc2
	response.write	"<tr>"
	response.write	"	<td class=""txt"">" & arrRs(0,i)-i & "</td>"
	response.write	"	<td class=""txt"">" & arrRs(21,i) & "</td>"
	response.write	"	<td class=""txt"">" & arrRs(22,i) & "</td>"
	response.write	"	<td class=""txt"">" & arrRs(3,i) & "</td>"
	response.write	"	<td class=""txt"">" & arrRs(18,i) & "</td>"
	response.write	"	<td class=""txt"">" & arrRs(28,i) & "</td>"
	response.write	"	<td class=""txt"">" & arrRs(29,i) & "</td>"
	
	response.write	"<td class=""txt"">"
	if arrRs(16,i) = "3031" then
		response.write	"대기"
	elseif arrRs(16,i) = "3032" then
		response.write	"진행중"
	elseif arrRs(16,i) = "3033" then
		response.write	"완료"
	elseif arrRs(16,i) = "3034" then
		response.write	"취소"
	elseif arrRs(16,i) = "3035" then
		response.write	"실패"
	end if
	response.write	"</td>"
	
	response.write	"</tr>"
next
response.write	"</table>"
'#	하단 대상자목록 : 끝	========================================================

response.write	"</body>"
response.write	"</html>"
%>