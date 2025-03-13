<!--#include virtual="/common/common.asp"-->

<%
dim schKey		: schKey		= fnIsNull(fnReq("schKey"), "")
dim schVal		: schVal		= fnIsNull(fnReq("schVal"), "")
dim page			: page			= fnIsNull(fnReq("page"), 1)
dim pageSize	: pageSize	= fnIsNull(fnReq("pageSize"), g_pageSize)

sqlC	= " trg.TMP_NO, trg.TMP_SORT, trg.TMP_NM, trg.TMP_NUM1, trg.TMP_NUM2, trg.TMP_NUM3 "
sqlC	= sqlC & " 	, dbo.nufn_getAddrGrupData(addr.ADDR_INDX, " & ss_userIndx & ") as GRUPDATA "
sqlC	= sqlC & "		, dbo.nufn_getAddrCodeData(addr.ADDR_INDX, " & ss_userIndx & ") as CODEDATA "

sqlF	= " TMP_CALLTRG as trg with(nolock) "
sqlF	= sqlF & " 	left join NTBL_ADDR as addr with(nolock) on (trg.TMP_IDX = addr.ADDR_INDX) "

sqlW	= " trg.AD_IDX = " & ss_userIndx & " and trg.AD_IP = '" & svr_remoteAddr & "' "
if len(schVal) > 0 then
	if schKey = "NUM" then
		sqlW	= sqlW & " 	and (trg.TMP_NUM1 like '%" & schVal & "%' or trg.TMP_NUM2 like '%" & schVal & "%' or trg.TMP_NUM3 like '%" & schVal & "%') "
	else
		sqlW	= sqlW & " 	and trg.TMP_" & schKey & " like '%" & schVal & "%' "
	end if
end if

sqlO	= "TMP_NO, TMP_SORT "

rowCnt	= fnDBVal(sqlF, "count(*)", sqlW)

sql = " select " & rowCnt &", * from ( "
sql = sql & " 	select row_number() over(order by " & sqlO & ") as ROWNUM, " & sqlC
sql = sql & " 	from " & sqlF
sql = sql & " 	where " & sqlW
sql = sql & " ) as tbl "
sql = sql & " where ROWNUM between " & (pageSize * (page - 1)) & " and " & (pageSize * page) & " "
'response.write	sql
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
if not rs.eof then
	arrRs		= rs.getRows
	arrRc1	= ubound(arrRs, 1)
	arrRc2	= ubound(arrRs, 2)
	rowCnt	= arrRs(0,0)
else
	arrRc2	= -1
	rowCnt	= 0
end if
set rs = nothing

response.write	rowCnt & "}|{"

call subPaging()

response.write	"}|{"

for i = 0 to arrRc2
	for ii = 0 to arrRc1
		response.write	arrRs(ii, i)
		if ii < arrRc1 then
			response.write	"]|["
		end if
	next
	if i < arrRc2 then
		response.write	"}|{"
	end if
next
%>