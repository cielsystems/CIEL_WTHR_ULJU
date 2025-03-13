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

sql = " select ADDR_INDX, ADDR_NAME, ADDR_NUM1 "
sql = sql & " from nviw_addrList with(nolock) "
sql = sql & " where ADDR_INDX in (select ADDR_INDX from NTBL_GRUP_ADDR_REL with(nolock) where GRUP_INDX in (" & arrGrp & ")) "
'sql = sql & " 	and len(replace(ADDR_NUM1, '-', '')) between 10 and 11 and ADDR_NUM1 like '01%' "
sql = sql & " 	and ADDR_INDX not in (select TMP_IDX from TMP_CALLTRG where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "') "
sql = sql & " order by CALLSORT, ADDR_SORT "
'response.write	sql
arrRs = execSqlRs(sql)
if isarray(arrRs) then
	arrRc2 = ubound(arrRs,2)
else
	arrRc2 = -1
end if

sql = ""

dim strErr : strErr = ""

for i = 0 to arrRc2
	
	if fnChkMobileNum(fnIsNull(arrRs(2,i), "")) = true then
		
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