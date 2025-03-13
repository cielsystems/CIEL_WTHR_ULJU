<!--#include virtual="/common/common.asp"-->

<%
dim grpCD	: grpCD	= fnReq("grpCD")
dim schKey	: schKey	= fnReq("schKey")
dim schVal	: schVal	= fnReq("schVal")
dim exceptGB	: exceptGB	= fnIsNull(fnReq("exceptGB"),"N")

sqlC = " AD_IDX, AD_NM, AD_NUM1, AD_NUM2, AD_NUM3, AD_EMAIL, AD_MEMO, GRP_CODE "
sqlC = sqlC & " , GRPSORT1, GRPSORT2, GRPSORT3, GRPSORT4, GRPSORT5, AD_SORT, AD_GRP01, AD_GRP02, AD_GRP03, AD_GRP04, AD_GRP05 "

sqlW = " USEYN = 'Y' and AD_GB <> 'U' "
if grpCD = "1" and len(schVal) > 0 then
	sqlW = sqlW & ""
else
	sqlW = sqlW & " and ( "
	'sqlW = sqlW & " 	GRP_CODE in (select GRP_CODE from dbo.ufn_tblGetSubGrpCodes(" & grpCD & ")) "
	'sqlW = sqlW & " 	or AD_IDX in (select AD_IDX from TBL_GRPREL with(nolock) where GRP_CODE in (select GRP_CODE from dbo.ufn_tblGetSubGrpCodes(" & grpCD & "))) "
	sqlW = sqlW & " 	GRP_CODE = " & grpCD & " or AD_IDX in (select AD_IDX from TBL_GRPREL with(nolock) where GRP_CODE = " & grpCD & ") "
	sqlW = sqlW & " ) "
end if

if len(schVal) > 0 then
	if schKey = "NUM" then
		sqlW = sqlW & " and ( "
		sqlW = sqlW & " 	AD_NUM1 like '%" & schVal & "' "
		sqlW = sqlW & " 	or AD_NUM2 like '%" & schVal & "' "
		sqlW = sqlW & " 	or AD_NUM3 like '%" & schVal & "' "
		sqlW = sqlW & " ) "
	else
		sqlW = sqlW & " and AD_" & schKey & " like '%" & schVal & "%' "
	end if
end if

'rowCnt = fnDBVal("TBL_ADDR", "count(*)", sqlW)
rowCnt = fnDBVal("viw_addrList", "count(*)", sqlW)

sql = " select " & sqlC & " "
'sql = sql & " 	from TBL_ADDR with(nolock) "
sql = sql & " 	from viw_addrList with(nolock) "
sql = sql & " 	where " & sqlW & " "

dim sql2
sql2 = " select a.AD_IDX, a.AD_NM "	'1
'sql2 = sql2 & " , dbo.ecl_DECRPART(a.AD_NUM1,4), dbo.ecl_DECRPART(a.AD_NUM2,4), dbo.ecl_DECRPART(a.AD_NUM3,4) "
sql2 = sql2 & " , a.AD_NUM1, a.AD_NUM2, a.AD_NUM3 "	'4
sql2 = sql2 & " , a.AD_EMAIL, a.AD_MEMO, (case when b.TMP_NO is null then 'N' else 'Y' end) as TRGYN "	'7
sql2 = sql2 & " , dbo.ufn_getGrpFullName(GRP_CODE) as GRPFULLNM "	'8
sql2 = sql2 & " , dbo.ufn_getCodeName(AD_GRP02) as DUTYNAME "	'9
sql2 = sql2 & " , a.AD_GRP01, a.AD_GRP02, a.AD_GRP03, a.AD_GRP04, a.AD_GRP05 "	'14
sql2 = sql2 & " , dbo.ufn_getCodeName(AD_GRP04) as WORKSTATENAME "	'15
sql2 = sql2 & " from (" & sql & ") as a "
sql2 = sql2 & " 	left join (select TMP_IDX, TMP_NO from TMP_CALLTRG where AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "') as b on (a.AD_IDX = b.TMP_IDX) "
sql2 = sql2 & " order by GRPSORT1, GRPSORT2, GRPSORT3, GRPSORT4, GRPSORT5, AD_SORT, AD_GRP02, AD_GRP01 "

arrRs = execSqlRs(sql2)
if isarray(arrRs) then
	arrRc2 = ubound(arrRs,2)
	arrRc1 = ubound(arrRs,1)
else
	arrRc2 = -1
end if

response.write	rowCnt & "}|{"

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