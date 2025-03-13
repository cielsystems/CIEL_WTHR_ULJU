<!--#include virtual="/common/common.asp"-->

<%
dim grupDpth	: grupDpth	= fnIsNull(nFnReq("grupDpth"), 0)
dim grupUper	: grupUper	= fnIsNull(nFnReq("grupUper"), 0)

sql = " select "
sql = sql & " 	grup.GRUP_INDX, grup.GRUP_UPER, grup.GRUP_DPTH, grup.GRUP_NAME "
sql = sql & " 	, (case when grupsub.GRUP_INDX is null then 'N' else 'Y' end) as SUBYN "
sql = sql & " 	, (case when prmt.USER_INDX is null then 'N' else 'Y' end) as RPTMYN "
sql = sql & " from nViw_grupList as grup "
sql = sql & " 	left join nViw_grupList as grupsub on (grup.GRUP_INDX = grupsub.GRUP_UPER) "
sql = sql & " 	left join (select * from NTBL_USER_GRUP_PRMT where USER_INDX = " & ss_userIndx & ") as prmt on (grup.GRUP_INDX = prmt.GRUP_INDX) "
sql = sql & " where grup.GRUP_DPTH = " & grupDpth & " and grup.GRUP_UPER = " & grupUper & " "
sql = sql & " order by grup.GRUPSORT0, grup.GRUPSORT1, grup.GRUPSORT2, grup.GRUPSORT3, grup.GRUPSORT4, grup.GRUPSORT5, grup.GRUP_NAME "
response.write	sql
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
if not rs.eof then
	arrRs = rs.getRows
	arrRc2 = ubound(arrRs,2)
	arrRc1 = ubound(arrRs,1)
else
	arrRc2 = -1
end if
rsClose()

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