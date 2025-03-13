<!--#include virtual="/common/common.asp"-->

<%
dim proc : proc = fnReq("proc")

if proc = "input" then
	
	dim addNm : addNm = fnReq("addNm")
	dim addNum : addNum = fnReq("addNum")
	
	addNum = replace(addNum,"-","")
	
	dim maxNo : maxNo = fnDBMax("TMP_CALLTRG", "TMP_NO", "AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
	maxNo = clng(maxNo) + 1
	dim maxSort : maxSort = fnDBMax("TMP_CALLTRG", "TMP_SORT", "AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
	maxSort = clng(maxSort) + 1
	
	sql = " insert into TMP_CALLTRG (AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1) "
	'sql = sql & " values (" & ss_userIdx & ", '" & svr_remoteAddr & "', " & maxNo & ", " & maxSort & ", 0, '" & addNm & "', dbo.ecl_ENCRPART('" & addNum & "',4)) "
	sql = sql & " values (" & ss_userIdx & ", '" & svr_remoteAddr & "', " & maxNo & ", " & maxSort & ", 0, '" & addNm & "', '" & addNum & "') "
	response.write	sql
	execSql(sql)
	
	response.write	"<script>"
	response.write	"top.frm.add_num.value = '';top.fnLoadTrg();top.fnLoadingE();"
	response.write	"</script>"
	
elseif proc = "delNum" then
	
	dim no : no = fnReq("no")
	dim num : num = fnReq("num")
	
	sql = " delete from TMP_CALLTRG "
	sql = sql & " where TMP_NO = '" & no & "' and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
	'sql = sql & " 	and TMP_NUM1 = dbo.ecl_ENCRPART('" & num & "',4) "
	sql = sql & " 	and TMP_NUM1 = '" & num & "' "
	call execSql(sql)
	
	response.write	"<script>"
	response.write	"top.fnLoadTrg();top.fnLoadingE();"
	response.write	"</script>"
	
elseif proc = "delAll" then
	
	sql = " delete from TMP_CALLTRG where AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
	call execSql(sql)
	
	response.write	"<script>"
	response.write	"top.fnLoadTrg();top.fnLoadingE();"
	response.write	"</script>"

elseif proc = "sel" then
	
	sql = " select '', TMP_NO, TMP_IDX, TMP_NM "
	'sql = sql & " 	, dbo.ecl_DECRPART(TMP_NUM1,4), dbo.ecl_DECRPART(TMP_NUM2,4), dbo.ecl_DECRPART(TMP_NUM3,4) "
	sql = sql & " 	, TMP_NUM1, TMP_NUM2, TMP_NUM3 "
	sql = sql & " from TMP_CALLTRG with(nolock) "
	sql = sql & " where AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
	arrRs = execSqlRs(sql)
	if isarray(arrRs) then
		arrRc1 = ubound(arrRs,1)
		arrRc2 = ubound(arrRs,2)
		response.write	arrRc2+1 & "}|{"
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
	else
		response.write	0
	end if

end if
%>