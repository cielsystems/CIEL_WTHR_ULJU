<!--#include virtual="/common/common.asp"-->

<%
dim clIdx : clIdx = fnReq("clIdx")

dim smsCntAll, smsCntCmp, smsCntAnsw
sql = " select "
sql = sql & " 	count(*) as CNTALL "
sql = sql & " 	, count(case when CD_RESULT > 9002 then 1 else null end) as CNTCMP "
sql = sql & " 	, count(case when CLTS_ANSWYN ='Y' then 1 else null end) as CNTANSW "
sql = sql & " from TBL_CALLTRG_SMS with(nolock) where CL_IDX = " & clIdx & " and (CLTS_SPLITNO < 2 or CLTS_SPLITNO is null) "
arrRs = execSqlArrVal(sql)
smsCntAll = clng(arrRs(0))
smsCntCmp = clng(arrRs(1))
smsCntAnsw = clng(arrRs(2))

dim vmsCntAll, vmsCntCmp, ingCnt
sql = " select "
'sql = sql & " 	count(*) as CNTALL "
sql = sql & " (select count(*) from TBL_CALLTRG_VMS with(nolock) where CL_IDX = " & clIdx & ") as CNTALL "
sql = sql & " ,(select count(*) from TBL_CALLTRG_VMS with(nolock) where CL_IDX = " & clIdx & " and CD_STATUS > 3032) as CNTCMP "
'sql = sql & " 	, count(case when CD_VMSSTATUS > 3032 then 1 else null end) as CNTCMP "
sql = sql & " from TBL_CALLTRG with(nolock) where CL_IDX = " & clIdx & " "
arrRs = execSqlArrVal(sql)
vmsCntAll = clng(arrRs(0))
vmsCntCmp = clng(arrRs(1))

dim clStep : clStep = fnDBVal("TBL_CALL","CL_STEP","CL_IDX = " & clIdx & "")

dim arrResult : arrResult = array(fnPer(smsCntAll, smsCntCmp), smsCntAll, fnPer(smsCntAll, smsCntAnsw), smsCntAll, fnPer(vmsCntAll, vmsCntCmp), vmsCntAll, "check", "check", "check", clStep)

for i = 0 to ubound(arrResult)
	response.write	arrResult(i)
	if i < ubound(arrResult) then
		response.write	"]|["
	end if
next
%>