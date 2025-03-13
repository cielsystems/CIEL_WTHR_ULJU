<!--#include virtual="/common/common.asp"-->

<%
server.scriptTimeOut = 999999999

dim arrGrp : arrGrp = fnReq("arrGrp")

dim maxNo : maxNo = fnDBMax("TMP_CALLTRG", "TMP_NO", "CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
maxNo = clng(maxNo) + 1
dim maxSort : maxSort = fnDBMax("TMP_CALLTRG", "TMP_SORT", "CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
maxSort = clng(maxSort) + 1

dim cntOK : cntOK = 0
dim cntErr : cntErr = 0

sql = " select AD_IDX, AD_NM, AD_NUM1 "
sql = sql & " from viw_addrList with(nolock) "
sql = sql & " where USEYN = 'Y' and AD_GB = 'A' and GRP_CODE in (" & arrGrp & ") and AD_GRP03 <> '500309' "
sql = sql & " 	and AD_IDX not in (select TMP_IDX from TMP_CALLTRG where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "') "
sql = sql & " order by GRPSORT1, GRPSORT2, GRPSORT3, GRPSORT4, GRPSORT5, AD_SORT, AD_GRP02, AD_GRP01 "
'sql = "select AD_IDX, AD_NM, AD_NUM1 "
''sql = sql & " 	, dbo.ecl_DECRPART(AD_NUM1,4) "
'sql = sql & " 	, AD_NUM1 "
'sql = sql & " from TBL_ADDR "
'sql = sql & " where USEYN = 'Y' "
'sql = sql & " 	AND ( "
'sql = sql & " 				GRP_CODE IN ( "
'sql = sql & " 					SELECT GRP_CODE FROM ( "
'sql = sql & " 						( "
'sql = sql & " 							SELECT GRP_CODE FROM TBL_GRP WHERE GRP_CODE in (" & arrGrp & ") "
'sql = sql & " 						) UNION ( "
'sql = sql & " 							SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE in (" & arrGrp & ") "
'sql = sql & " 						) UNION ( "
'sql = sql & " 							SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE in (" & arrGrp & ")) "
'sql = sql & " 						) UNION ( "
'sql = sql & " 							SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE in (" & arrGrp & "))) "
'sql = sql & " 						) UNION ( "
'sql = sql & " 							SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE in (" & arrGrp & ")))) "
'sql = sql & " 						) "
'sql = sql & " 					) AS grp "
'sql = sql & " 				) "
'sql = sql & " 				OR AD_IDX IN (SELECT AD_IDX FROM TBL_GRPREL WHERE GRP_CODE IN ( "
'sql = sql & " 					SELECT GRP_CODE FROM ( "
'sql = sql & " 						( "
'sql = sql & " 							SELECT GRP_CODE FROM TBL_GRP WHERE GRP_CODE in (" & arrGrp & ") "
'sql = sql & " 						) UNION ( "
'sql = sql & " 							SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE in (" & arrGrp & ") "
'sql = sql & " 						) UNION ( "
'sql = sql & " 							SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE in (" & arrGrp & ")) "
'sql = sql & " 						) UNION ( "
'sql = sql & " 							SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE in (" & arrGrp & "))) "
'sql = sql & " 						) UNION ( "
'sql = sql & " 							SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE IN (SELECT GRP_CODE FROM TBL_GRP WHERE GRP_UPCODE in (" & arrGrp & ")))) "
'sql = sql & " 						) "
'sql = sql & " 					) AS grp "
'sql = sql & " 				)) "
'sql = sql & " 			) "
'sql = sql & " order by "
'sql = sql & " 	dbo.ufn_getGrpSort(GRP_CODE,1) asc "
'sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE,2) asc "
'sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE,3) asc "
'sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE,4) asc "
'sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE,5) asc "
'sql = sql & " 	, AD_SORT asc, AD_GRP03 asc, AD_NO asc, AD_NM asc "
arrRs = execSqlRs(sql)
if isarray(arrRs) then
	arrRc2 = ubound(arrRs,2)
else
	arrRc2 = -1
end if

'sql = " insert into TMP_CALLTRG (AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1) values "
sql = ""

dim strErr : strErr = ""

for i = 0 to arrRc2
	
	if fnChkMobileNum(arrRs(2,i)) = true then
		
		'sql = sql & " (" & ss_userIdx & ", '" & svr_remoteAddr & "', " & clng(maxNo) + i & ", " & clng(maxSort) + i & ", " & arrRs(0,i) & ", '" & arrRs(1,i) & "', '" &  arrRs(2,i) & "') "
		'if i < arrRc2 then
		'	sql = sql & ","
		'end if
		
		if len(sql) > 0 then
			sql = sql & " union all "
		end if
		sql = sql & " select " & ss_userIdx & ", '" & svr_remoteAddr & "', " & clng(maxNo) + i & ", " & clng(maxSort) + i & ", " & arrRs(0,i) & ", '" & arrRs(1,i) & "', '" &  arrRs(2,i) & "' "
		
		cntOK = cntOK + 1
		
	else
		
		strErr = strErr & "\n[" & arrRs(1,i) & "] " & arrRs(2,i)
		
		cntErr = cntErr + 1
		
	end if
	
next
sql = " insert into TMP_CALLTRG (AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1) " & sql
response.write	sql

if cntOK > 0 then
	
	do while right(sql,1) = ","
		sql = left(sql,len(sql)-1)
	loop
	
	response.write	sql
	call execSql(sql)
	
	response.write	"<script>"
	if cntErr > 0 then
		response.write	"alert('휴대폰번호가 잘못된 " & cntErr & "명을 제외한 " & cntOK & "명의 대상자가 추가되었습니다.\n\n------------------------------" & strErr & "');"
	else
		response.write	"alert('" & cntOK & "명의 대상자가 추가되었습니다.');"
	end if
	response.write	"top.fnLoadAddr(top.nTab);top.fnLoadTrg();"
	response.write	"</script>"
	
else
	
	response.write	"<script>"
	response.write	"alert('휴대폰번호가 잘못된 " & cntErr & "명을 제외한 " & cntOK & "명의 대상자가 추가되었습니다.');"
	response.write	"</script>"
	
end if
%>