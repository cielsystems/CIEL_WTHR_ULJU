<!--#include virtual="/common/common.asp"-->

<%
dim proc : proc = fnReq("proc")

if proc = "sys" then
	
	dim sysACS : sysACS = right(fnDBVal("TBL_SYSERROR", "SE_GB", "left(SE_GB,1) = 'A' order by REGDT desc limit 0, 1"),1)
	dim sysSMS : sysSMS = right(fnDBVal("TBL_SYSERROR", "SE_GB", "left(SE_GB,1) = 'S' order by REGDT desc limit 0, 1"),1)
	dim sysDB : sysDB = "0"
	
	if len(sysACS) = 0 then
		sysACS = "0"
	end if
	
	if len(sysSMS) = 0 then
		sysSMS = "0"
	end if
	
	response.write	sysACS & "]|[" & sysSMS & "]|[" & sysDB
	
elseif proc = "list" then
	
	dim page : page = fnIsNull(fnReq("page"),1)
	dim pageSize : pageSize = fnIsNull(fnReq("pageSize"),g_pageSize)
	
	dim sPage : sPage = (pageSize * (page - 1))
	
	rowCnt = fnDBVal("TBL_SYSERROR", "count(*)", "1=1")
	
	sql = " select left(SE_GB,1), right(SE_GB,1), SE_MSG, REGDT from TBL_SYSERROR order by REGDT desc limit " & sPage & ", " & pageSize & " "
	arrRs = execSqlRs(sql)
	if isarray(arrRs) then
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
	
end if
%>