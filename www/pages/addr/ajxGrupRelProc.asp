<!--#include virtual="/common/common.asp"-->

<%
dim proc	: proc	= fnIsNull(nFnReq("proc", 4), "")

dim relGubn	: relGubn	= fnIsNull(nFnReq("relGubn", 1), "")

dim grupIndx	: grupIndx	= fnIsNull(nFnReq("grupIndx", 0), 0)
dim addrCode	: addrCode	= fnIsNull(nFnReq("addrCode", 0), 0)

dim relValu
if relGubn = "G" then
	relValu	= grupIndx
elseif relGubn = "C" then
	relValu	= addrCode
end if

if proc = "data" then
	
	set rs = server.createobject("adodb.recordset")
	set cmd = server.createobject("adodb.command")
	with cmd

		.activeconnection = strDBConn
		.commandtext = "nusp_infoAddrRelData"
		.commandtype = adCmdStoredProc
		
		.parameters.append .createParameter("@relGubn",		adChar,			adParamInput,		1)
		.parameters.append .createParameter("@relValu",		adInteger,	adParamInput,		0)
		.parameters.append .createParameter("@userIndx",	adInteger,	adParamInput,		0)
		
		.parameters("@relGubn")		= relGubn
		.parameters("@relValu")		= relValu
		.parameters("@userIndx")	= ss_userIndx
		
		set rs = .execute
		
	end with
	set cmd = nothing

	if not rs.eof then
		response.write	rs(0) & "]|[" & rs(1) & "]|[" & rs(2) & "]|[" & rs(3) & "]|[" & rs(4) & "]|[" & rs(5)
	end if
	set rs = nothing
	
elseif proc = "list" then
	
	'response.write	"exec nusp_listAddrRel '" & relGubn & "', " & addrIndx & ", " & grupIndx & ", " & ss_userIndx & ""
	
	set rs = server.createobject("adodb.recordset")
	set cmd = server.createobject("adodb.command")
	with cmd

		.activeconnection = strDBConn
		.commandtext = "nusp_listGrupRel"
		.commandtype = adCmdStoredProc
		
		.parameters.append .createParameter("@relGubn",		adChar,			adParamInput,		1)
		.parameters.append .createParameter("@grupIndx",	adInteger,	adParamInput,		0)
		.parameters.append .createParameter("@userIndx",	adInteger,	adParamInput,		0)
		
		.parameters("@relGubn")			= relGubn
		.parameters("@grupIndx")		= grupIndx
		.parameters("@userIndx")		= ss_userIndx
		
		set rs = .execute
		
	end with
	set cmd = nothing

	if not rs.eof then
		arrRs = rs.getRows
		arrRc2 = ubound(arrRs,2)
		arrRc1 = ubound(arrRs,1)
	else
		arrRc2 = -1
	end if
	set rs = nothing
	
	response.write	arrRc2 & "}|{"
	
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
%>