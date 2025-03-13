<!--#include virtual="/common/common.asp"-->

<%
dim clGB	: clGB	= fnReq("clGB")

dim proc	: proc	= fnIsNull(fnReq("proc"), "")

dim grupIndx	: grupIndx	= fnIsNull(fnReq("grupIndx"), "")
dim addrCode	: addrCode	= fnIsNull(fnReq("addrCode"), "")
dim addrIndx	: addrIndx	= fnIsNull(fnReq("addrIndx"), "")
dim tmpNo	: tmpNo	= fnIsNull(fnReq("tmpNo"), 0)

sqlO	= " CALLSORT, ADDR_SORT "

dim sqlDft	: sqlDft	= " and len(ADDR_NUM1) between 10 and 11 and ADDR_NUM1 like '01%' "

dim sqlNot	: sqlNot	= " and ADDR_INDX not in (select TMP_IDX from TMP_CALLTRG with(nolock) where AD_IDX = " & ss_userIndx & " and AD_IP = '" & svr_remoteAddr & "') "

dim maxNo	: maxno	= fnIsNull(fnDBVal("TMP_CALLTRG", "max(TMP_NO)", "AD_IDX = " & ss_userIndx & " and AD_IP = '" & svr_remoteAddr & "'"), 0)

if proc = "addAllStaf" then
	
	sqlW	= " ADDR_INDX in (select ADDR_INDX from NTBL_GRUP_ADDR_REL with(nolock) where GRUP_INDX in (select GRUP_INDX from NTBL_GRUP where USEYN = 'Y' and GRUP_GUBN = 'D')) "
	
	sql = " insert into TMP_CALLTRG (CL_IDX, AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_NUM2, TMP_NUM3) "
	sql = sql & " select "
	sql = sql & " 	0, " & ss_userIndx & ", '" & svr_remoteAddr & "', ROW_NUMBER() over(order by " & sqlO & ") + " & maxNo & ", CALLSORT "
	sql = sql & " 	, ADDR_INDX, ADDR_NAME, ADDR_NUM1, ADDR_NUM2, ADDR_NUM3 "
	sql = sql & " from nviw_addrList as addr with(nolock) "
	sql = sql & " where " & sqlW & sqlDft & sqlNot
	sql = sql & " order by " & sqlO

elseif proc	= "addSelGrup" then

	sqlW = " (ADDR_INDX in (select ADDR_INDX from NTBL_GRUP_ADDR_REL with(nolock) where GRUP_INDX in (" & grupIndx & ")) and "
	sqlW = sqlW & " ADDR_INDX not in (select TMP_IDX from TMP_CALLTRG with(nolock) where AD_IDX = " & ss_userIndx & " and AD_IP = '" & svr_remoteAddr & "')) "
	
	sql = " insert into TMP_CALLTRG (CL_IDX, AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_NUM2, TMP_NUM3) "
	sql = sql & " select "
	sql = sql & " 	0, " & ss_userIndx & ", '" & svr_remoteAddr & "', ROW_NUMBER() over(order by " & sqlO & ") + " & maxNo & ", CALLSORT "
	sql = sql & " 	, ADDR_INDX, ADDR_NAME, ADDR_NUM1, ADDR_NUM2, ADDR_NUM3 "
	sql = sql & " from nviw_addrList as addr with(nolock) "
	sql = sql & " where " & sqlW & sqlDft & sqlNot
	sql = sql & " order by " & sqlO

elseif proc	= "addSelCode" then
	
	sqlW = " ADDR_INDX in (select ADDR_INDX from NTBL_ADDR_CODE_REL with(nolock) where ADDR_CODE in (" & addrCode & ")) "

	sql = " insert into TMP_CALLTRG (CL_IDX, AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_NUM2, TMP_NUM3) "
	sql = sql & " select "
	sql = sql & " 	0, " & ss_userIndx & ", '" & svr_remoteAddr & "', ROW_NUMBER() over(order by " & sqlO & ") + " & maxNo & ", CALLSORT "
	sql = sql & " 	, ADDR_INDX, ADDR_NAME, ADDR_NUM1, ADDR_NUM2, ADDR_NUM3 "
	sql = sql & " from nviw_addrList as addr with(nolock) "
	sql = sql & " where " & sqlW & sqlDft & sqlNot
	sql = sql & " order by " & sqlO

elseif proc	= "addSelCallGrup" then
	
	sqlW = " ADDR_INDX in ( "
	sqlW = sqlW & " 	select ADDR_INDX from NTBL_ADDR_CODE_REL with(nolock) where ADDR_CODE in ( "
	sqlW = sqlW & " 		select ADDR_CODE from NTBL_GRUP_ADDR_CODE_REL with(nolock) where GRUP_INDX in (" & grupIndx & ") "
	sqlW = sqlW & " 	) "
	sqlW = sqlW & " ) "
	
	if fnDBVal("NTBL_GRUP_GRUP_REL", "count(*)", "GRUP_INDX = " & grupIndx & "") > 0 then
		sqlW = sqlW & " and ADDR_INDX in ( "
		sqlW = sqlW & " 	select ADDR_INDX from NTBL_GRUP_ADDR_REL where GRUP_INDX in (select GRUP_INDX_REL from NTBL_GRUP_GRUP_REL where GRUP_INDX = " & grupIndx & ") "
		sqlW = sqlW & " ) "
	end if
	
	sql = " insert into TMP_CALLTRG (CL_IDX, AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_NUM2, TMP_NUM3) "
	sql = sql & " select "
	sql = sql & " 	0, " & ss_userIndx & ", '" & svr_remoteAddr & "', ROW_NUMBER() over(order by " & sqlO & ") + " & maxNo & ", CALLSORT "
	sql = sql & " 	, ADDR_INDX, ADDR_NAME, ADDR_NUM1, ADDR_NUM2, ADDR_NUM3 "
	sql = sql & " from nviw_addrList as addr with(nolock) "
	sql = sql & " where " & sqlW & sqlDft & sqlNot
	sql = sql & " order by " & sqlO
	
elseif proc = "addSelAddr" then
	
	sqlW = " ADDR_INDX in (" & addrIndx & ") "
	
	sql = " insert into TMP_CALLTRG (CL_IDX, AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_NUM2, TMP_NUM3) "
	sql = sql & " select "
	sql = sql & " 	0, " & ss_userIndx & ", '" & svr_remoteAddr & "', ROW_NUMBER() over(order by " & sqlO & ") + " & maxNo & ", CALLSORT "
	sql = sql & " 	, ADDR_INDX, ADDR_NAME, ADDR_NUM1, ADDR_NUM2, ADDR_NUM3 "
	sql = sql & " from nviw_addrList as addr with(nolock) "
	sql = sql & " where " & sqlW & sqlDft & sqlNot
	sql = sql & " order by " & sqlO
	
elseif proc = "addAddr" then
	
	sqlW = " ADDR_INDX = " & addrIndx & " "
	
	sql = " insert into TMP_CALLTRG (CL_IDX, AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_NUM2, TMP_NUM3) "
	sql = sql & " select "
	sql = sql & " 	0, " & ss_userIndx & ", '" & svr_remoteAddr & "', ROW_NUMBER() over(order by " & sqlO & ") + " & maxNo & ", CALLSORT "
	sql = sql & " 	, ADDR_INDX, ADDR_NAME, ADDR_NUM1, ADDR_NUM2, ADDR_NUM3 "
	sql = sql & " from nviw_addrList as addr with(nolock) "
	sql = sql & " where " & sqlW & sqlDft & sqlNot
	sql = sql & " order by " & sqlO
	
elseif proc = "delAddr" then
	
	sql = " delete TMP_CALLTRG where AD_IDX = " & ss_userIndx & " and AD_IP = '" & svr_remoteAddr & "' and TMP_IDX = " & addrIndx & " "
	
elseif proc = "delAll" then
	
	sql = " delete TMP_CALLTRG where AD_IDX = " & ss_userIndx & " and AD_IP = '" & svr_remoteAddr & "' "
	
elseif proc = "trgDel" then
	
	sql = " delete TMP_CALLTRG where AD_IDX = " & ss_userIndx & " and AD_IP = '" & svr_remoteAddr & "' and TMP_NO = " & tmpNo & " "
	
elseif proc = "trgAllDel" then
	
	sql = " delete TMP_CALLTRG where AD_IDX = " & ss_userIndx & " and AD_IP = '" & svr_remoteAddr & "' "
	
end if

dim reqCnt, addCnt

if left(proc, 3) = "add" then
	
	reqCnt	= fnDBVal("nViw_addrList", "count(*)", sqlW)
	
	addCnt	= fnDBVal("nViw_addrList", "count(*)", sqlW & sqlDft & sqlNot)
	
end if

if len(sql) > 0 then
	'sql = " exec symtKeyCielOpen " & sql
	'response.write	"<div>" & sql & "</div>"
	call execSql(sql)
end if

dim tmpCnt : tmpCnt = fnDBVal("TMP_CALLTRG", "count(*)", "CL_IDX = 0 and AD_IDX = " & ss_userIndx & " and AD_IP = '" & svr_remoteAddr & "'")

response.write	"0|" & reqCnt & "|" & addCnt & "|" & tmpCnt & "|"

if left(proc, 3) = "trg" then
	response.write	"<script type=""text/javascript"">"
	if clGB = "E" or clGB = "W" then
		response.write	"top.trgCnt = " & tmpCnt & ";"
		response.write	"top.fnTargetMsg();"
	end if
	response.write	"top.fnLoadingE();"
	response.write	"top.fnLoadTrg();"
	response.write	"	parent.fnLoadPage(parent.page);"
	response.write	"</script>"
end if
%>