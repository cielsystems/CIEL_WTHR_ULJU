<!--#include virtual="/common/common.asp"-->

<%
dim admYN			: admYN	= fnIsNull(fnReq("admYN"), "N")
dim adGB			: adGB	= fnIsNull(fnReq("adGB"),"A")
dim grpCD			: grpCD	= fnIsNull(fnReq("grpCD"),0)
dim cdUserGB	: cdUserGB	= fnIsNull(fnReq("cdUserGB"),0)
dim adGrp01		: adGrp01	= fnIsNull(fnReq("adGrp01"),0)
dim adGrp02		: adGrp02	= fnIsNull(fnReq("adGrp02"),0)
dim adGrp03		: adGrp03	= fnIsNull(fnReq("adGrp03"),0)
dim adGrp04		: adGrp04	= fnIsNull(fnReq("adGrp04"),0)
dim adGrp05		: adGrp05	= fnIsNull(fnReq("adGrp05"),0)
dim schKey		: schKey		= fnIsNull(fnReq("schKey"),"")
dim schVal		: schVal		= fnIsNull(fnReq("schVal"),"")
dim page 			: page = fnIsNull(fnReq("page"),1)
dim pageSize	: pageSize = fnIsNull(fnReq("pageSize"),g_pageSize)
dim listPer		: listPer	= fnIsNull(fnReq("listPer"),"A")

dim adPerAddr : adPerAddr = fnDBVal("TBL_ADDR", "AD_PERADDR", "AD_IDX = " & ss_userIdx & "")
if adPerAddr = "M" then
	listPer = "M"
end if
if adGB = "U" then 
	listPer = "A"
end if

if grpCD = 5 then
	listPer = "A"
end if

if fnDBVal("TBL_GRP", "GRP_GB", "GRP_CODE = "& grpCD & "") = "P" then
	listPer = "A"
end if

dim arrVal : arrVal = array(adGB, grpCD, cdUserGB, adGrp01, adGrp02, adGrp03, adGrp04, adGrp05, schKey, schVal, page, pageSize, ss_userIdx, svr_remoteAddr, listPer)
'	ROWCNT(0), ROWNUM(1), AD_IDX(2), AD_NM(3), AD_NUM1(4), AD_NUM2(5), AD_NUM3(6), AD_EMAIL(7), AD_MEMO(8)
'	, AD_GRP01(9), dbo.ufn_getCodeName(AD_GRP01) as ADGRP01(10) '
'	, AD_GRP02(11), dbo.ufn_getCodeName(AD_GRP02) as ADGRP02(12) '
'	, AD_GRP03(13), dbo.ufn_getCodeName(AD_GRP03) as ADGRP03(14) '
'	, AD_GRP04(15), dbo.ufn_getCodeName(AD_GRP04) as ADGRP04(16) '
'	, AD_GRP05(17), dbo.ufn_getCodeName(AD_GRP05) as ADGRP05(18) '
'	, dbo.ufn_getGrpFullName(GRP_CODE) as GRPFULLNM(19) '
'	, (case when trg.TMP_IDX is null then ''N'' else ''Y'' end) as TRGYN(20) '

'response.write	"exec usp_addrListNew "
'for i = 0 to ubound(arrVal)
'	response.write	"'" & arrVal(i) & "'"
'	if i < ubound(arrVal) then
'		response.write	","
'	end if
'next

if admYN = "Y" then
	arrRs = execProcRs("usp_addrListAdm", arrVal)
else
	arrRs = execProcRs("usp_addrListNew", arrVal)
end if
if isarray(arrRs) then
	rowCnt = arrRs(0,0)
	arrRc2 = ubound(arrRs,2)
	arrRc1 = ubound(arrRs,1)
else
	arrRc2 = -1
end if

response.write	rowCnt & "}|{"

call subPaging()

response.write	"}|{"

for i = 0 to arrRc2
	for ii = 0 to arrRc1
		response.write	arrRs(ii,i)
		if ii < arrRc1 then
			response.write	"]|["
		end if
	next
	if i < arrRc2 then
		response.write	"}|{"
	end if
next
%>