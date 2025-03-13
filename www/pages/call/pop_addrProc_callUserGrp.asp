<!--#include virtual="/common/common.asp"-->

<%
dim proc : proc = fnReq("proc")
dim gb : gb = fnReq("gb")

dim grpCode1	: grpCode1	= fnReq("grpCode1")
dim grpCode2	: grpCode2	= fnReq("grpCode2")
dim grpCode3	: grpCode3	= fnReq("grpCode3")
dim grpCode4	: grpCode4	= fnReq("grpCode4")
dim grpCode5	: grpCode5	= fnReq("grpCode5")
dim grpCode
if len(grpCode1) > 0 then
	grpCode = grpCode1
end if
if len(grpCode2) > 0 then
	if len(grpCode) > 0 then
		grpCode = grpCode & ","
	end if
	grpCode = grpCode & grpCode2
end if
if len(grpCode3) > 0 then
	if len(grpCode) > 0 then
		grpCode = grpCode & ","
	end if
	grpCode = grpCode & grpCode3
end if
if len(grpCode4) > 0 then
	if len(grpCode) > 0 then
		grpCode = grpCode & ","
	end if
	grpCode = grpCode & grpCode4
end if
if len(grpCode5) > 0 then
	if len(grpCode) > 0 then
		grpCode = grpCode & ","
	end if
	grpCode = grpCode & grpCode5
end if

dim adGrp01	: adGrp01	= fnReq("adGrp01")
dim adGrp02	: adGrp02	= fnReq("adGrp02")
dim adGrp03	: adGrp03	= fnReq("adGrp03")

sqlW = " USEYN = 'Y' and AD_GB <> 'U' "

if len(grpCode) > 0 then
	sqlW = sqlW & " 	and (GRP_CODE in (" & grpCode & ") or AD_IDX in (select AD_IDX from TBL_GRPREL with(nolock) where GRP_CODE in (" & grpCode & "))) "
else
	
	'#	타부서 사용권한 처리
	dim cdUsGB : cdUsGB = cint(fnDBVal("TBL_ADDR", "CD_USERGB", "AD_IDX = " & ss_userIdx & ""))
	dim adPerAddr : adPerAddr = fnDBVal("TBL_ADDR", "AD_PERADDR", "AD_IDX = " & ss_userIdx & "")
	
	if cdUsGB < 1002 or adPerAddr = "A" then
		if gb = "D" then
			sqlW = sqlW & " 	and GRP_CODE in (select GRP_CODE from TBL_GRP where GRP_GB = '" & gb & "') "
		elseif gb = "P" then
			sqlW = sqlW & " 	and GRP_CODE in (select GRP_CODE from TBL_GRP where GRP_GB = '" & gb & "' and AD_IDX = " & ss_userIdx & ") "
		end if
	elseif gb = "E" then
		sqlW = sqlW & " 	 "
	else
		dim adGrpCode
		if gb = "D" then
			adGrpCode = fnDBVal("TBL_ADDR", "GRP_CODE", "AD_IDX = " & ss_userIdx & "")
		
			adGrpCode = fnDBVal("dbo.ufn_tblGetUpGrpCodes(" & adGrpCode & ")", "GRP2", "1=1")
			sqlW = sqlW & " 	and GRP_CODE in (select GRP_CODE from dbo.ufn_tblGetSubGrpCodes(" & adGrpCode & ") where GRP_GB = '" & gb & "') "
			
		else
			
			sqlW = sqlW & " 	and (GRP_CODE in (select GRP_CODE from TBL_GRP where GRP_GB = '" & gb & "' and AD_IDX = " & ss_userIdx & ") "
			sqlW = sqlW & " 	or AD_IDX in (select AD_IDX from TBL_GRPREL with(nolock) where GRP_CODE in (select GRP_CODE from TBL_GRP where GRP_GB = '" & gb & "' and AD_IDX = " & ss_userIdx & ")))"
			
		end if
		
	end if
	
end if
	
if gb = "D" then
	if len(adGrp01) > 0 then
		sqlW = sqlW & " 	and AD_GRP01 in (" & adGrp01 & ")"
	end if
	if len(adGrp02) > 0 then
		sqlW = sqlW & " 	and AD_GRP02 in (" & adGrp02 & ")"
	end if
	if len(adGrp03) > 0 then
		sqlW = sqlW & " 	and AD_GRP03 in (" & adGrp03 & ")"
	end if
	sqlW = sqlW & " and AD_GRP03 <> '500309' "
else
	if len(adGrp01) > 0 then
		sqlW = sqlW & " 	and AD_ETC3 in ('" & replace(adGrp01,", ","','") & "')"
	end if
	if len(adGrp02) > 0 then
		sqlW = sqlW & " 	and AD_ETC4 in ('" & replace(adGrp02,", ","','") & "')"
	end if
	if len(adGrp03) > 0 then
		sqlW = sqlW & " 	and AD_ETC5 in ('" & replace(adGrp03,", ","','") & "')"
	end if
end if
			
response.write	sqlW
	
if proc = "sch" then
	
	sql = " select "
	sql = sql & " 	AD_IDX, AD_NM "
	'sql = sql & " 	, dbo.ecl_DECRPART(AD_NUM1,4) "
	sql = sql & " 	, AD_NUM1 "
	sql = sql & " 	, dbo.ufn_getGrpFullName(GRP_CODE) as GRPFULLNM "
	if gb = "D" then
		sql = sql & " 	, dbo.ufn_getCodeName(AD_GRP01) as ADGRP01 "
		sql = sql & " 	, dbo.ufn_getCodeName(AD_GRP02) as ADGRP02 "
		sql = sql & " 	, dbo.ufn_getCodeName(AD_GRP03) as ADGRP03 "
	else
		sql = sql & " 	, AD_ETC3, AD_ETC4, AD_ETC5 "
	end if
	sql = sql & " from TBL_ADDR with(nolock) "
	sql = sql & " where " & sqlW
	sql = sql & " order by dbo.ufn_getGrpSort(GRP_CODE, 1) asc "
	sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE, 2) asc "
	sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE, 3) asc "
	sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE, 4) asc "
	sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE, 5) asc "
	sql = sql & " 	, AD_GRP03 asc "
	sql = sql & " 	, AD_SORT asc "
	response.write	sql
	arrRs = execSqlRs(sql)
	if isarray(arrRs) then
		arrRc2 = ubound(arrRs,2)
	else
		arrRc2 = -1
	end if
	
	dim maxCnt : maxCnt = 4
	if arrRc2 < maxCnt then
		maxCnt = arrRc2
	end if
	
	response.write	"<script>"
	response.write	"parent.$('#callUserGrpList tbody tr').remove();"
	for i = 0 to maxCnt
		
		response.write	"parent.fnSch_callUserGrp('" & arrRs(3,i) & "', '" & arrRs(4,i) & "', '" & arrRs(5,i) & "', '" & arrRs(6,i) & "', '" & arrRs(1,i) & "', '" & arrRs(2,i) & "');"
			
	next
	response.write	"parent.$('#selTrgCount_callUserGrp').html('" & arrRc2+1 & "');"
	response.write	"</script>"
	
elseif proc = "add" then
	
	dim tmpNo, trgCnt
	
	tmpNo = fnDBMax("TMP_CALLTRG","TMP_NO","CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
	tmpNo = clng(tmpNo)
	
	trgCnt = fnDBVal("TBL_ADDR", "count(*)", sqlW)
	
	sql = " insert into TMP_CALLTRG (CL_IDX, AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_NUM2, TMP_NUM3) "
	sql = sql & " select 0, " & ss_userIdx & ", '" & svr_remoteAddr & "', ROW_NUMBER() over(order by AD_IDX) + " & tmpNo & " "
	sql = sql & " 	, (case when left(AD_GRP03,4) = '5003' then convert(int, AD_GRP03) - 500300 else AD_GRP03 end), AD_IDX, AD_NM, AD_NUM1, AD_NUM2, AD_NUM3 "
	sql = sql & " from TBL_ADDR with(nolock) "
	sql = sql & " where " & sqlW
	sql = sql & " order by dbo.ufn_getGrpSort(GRP_CODE, 1) asc "
	sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE, 2) asc "
	sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE, 3) asc "
	sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE, 4) asc "
	sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE, 5) asc "
	sql = sql & " 	, AD_GRP03 asc "
	sql = sql & " 	, AD_SORT asc "
	
	response.write	sql
	call execSql(sql)

	dim tmpCnt : tmpCnt = fnDBVal("TMP_CALLTRG","count(*)","CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
	
	response.write	"<script>"
	response.write	"	top.trgCnt = " & tmpCnt & ";"
	response.write	"	top.fnTargetMsg();"
	response.write	"	if(confirm('" & trgCnt & "건의 전송대상이 추가되었습니다.\n전송대상을 더 추가하시겠습니까?')){"
	response.write	"		parent.fnLoadingE();"
	response.write	"	}else{"
	response.write	"		top.fnCloseLayer();"
	response.write	"	}"
	response.write	"</script>"
	
end if
%>