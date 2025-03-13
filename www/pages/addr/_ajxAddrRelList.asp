<!--#include virtual="/common/common.asp"-->

<%
dim proc	: proc	= fnIsNull(fnReq("proc"), "")

dim relGubn	: relGubn	= fnIsNull(fnReq("relGubn"), "")

dim addrIndx	: addrIndx	= fnIsNull(fnReq("addrIndx"), 0)

if proc = "data" then
	
	if relGubn = "G" then
		
		sql = " select "
		sql = sql & " 	GRUP_INDX, dbo.nufn_getGrupLeftName(GRUP_INDX) as LEFTNAME, GRUP_NAME "
		sql = sql & " 	, (case GRUP_GUBN when 'D' then 'A' when 'P' then 'B' when 'C' then 'C' end) as GUBN "
		sql = sql & " from nViw_grupList with(nolock) "
		sql = sql & " where GRUP_INDX = " & grupIndx & " "
		
	elseif relGubn = "C" then
		
		sql = " select "
		sql = sql & " 	code.ADDR_CODE, uper.ADDR_CODE_NAME, code.ADDR_CODE_NAME, '' as GUBN "
		sql = sql & " from NTBL_ADDR_CODE as code with(nolock) "
		sql = sql & " 	left join NTBL_ADDR_CODE as uper with(nolock) on (uper.ADDR_CODE = code.ADDR_CODE_UPER) "
		sql = sql & " where code.ADDR_CODE = " & addrCode & " "
		
	end if

	if len(sql) > 0 then
		
		cmdOpen(sql)
		set rs = cmd.execute
		cmdClose()
		if not rs.eof then
			response.write	rs(0) & "]|[" & rs(1) & "]|[" & rs(2) & "]|[" & rs(3)
		end if
		rsClose()
		
	end if

elseif proc = "list" then

	if relGubn = "G" then
		
		sql = " select "
		sql = sql & " 	grup.GRUP_INDX, dbo.nufn_getGrupLeftName(grup.GRUP_INDX) as LEFTNAME, grup.GRUP_NAME "
		sql = sql & " 	, (case grup.GRUP_GUBN when 'D' then 'A' when 'P' then 'B' when 'C' then 'C' end) as GUBN "
		sql = sql & " from NTBL_GRUP_ADDR_REL as rel with(nolock) "
		sql = sql & " 	left join nViw_grupList as grup with(nolock) on (rel.GRUP_INDX = grup.GRUP_INDX) "
		sql = sql & " where rel.ADDR_INDX = " & addrIndx & " "
		sql = sql & " order by grup.GRUP_GUBN, grup.GRUPSORT0, grup.GRUPSORT1, grup.GRUPSORT2, grup.GRUPSORT3, grup.GRUPSORT4, grup.GRUPSORT5 "
		
	elseif relGubn = "C" then
		
		sql = " select "
		sql = sql & " 	code.ADDR_CODE, uper.ADDR_CODE_NAME, code.ADDR_CODE_NAME, '' as GUBN "
		sql = sql & " from NTBL_ADDR_CODE_REL as rel with(nolock) "
		sql = sql & " 	left join NTBL_ADDR_CODE as code with(nolock) on (rel.ADDR_CODE = code.ADDR_CODE) "
		sql = sql & " 	left join NTBL_ADDR_CODE as uper with(nolock) on (uper.ADDR_CODE = code.ADDR_CODE_UPER) "
		sql = sql & " where rel.ADDR_INDX = " & addrIndx & " "
		sql = sql & " order by uper.ADDR_CODE_SORT, uper.ADDR_CODE_NAME, code.ADDR_CODE_SORT, code.ADDR_CODE_NAME "
		
	end if

	if len(sql) > 0 then
		
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
		
		response.write	arrRc2 + 1 & "}|{"
		
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
		
	end if
	
end if
%>