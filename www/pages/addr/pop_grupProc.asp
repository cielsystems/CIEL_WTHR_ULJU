<!--#include virtual="/common/common.asp"-->

<%
dim proc	: proc	= fnIsNull(nFnReq("proc", 4), "S")

dim grupGubn		: grupGubn		= fnIsNull(nFnReq("grupGubn", 1), "")
dim grupUper		: grupUper		= fnIsNull(nFnReq("grupUper", 0), 0)
dim grupIndx		: grupIndx		= fnIsNull(nFnReq("grupIndx", 0), 0)
dim grupName		: grupName		= fnIsNull(nFnReq("grupName", 50), "")
dim grupSort		: grupSort		= fnIsNull(nFnReq("grupSort", 0), 1)

dim grupIndxRel	: grupIndxRel	= fnIsNull(nFnReq("grupIndxRel", 4000), "")
dim arrCodes		: arrCodes		= fnIsNull(nFnReq("addrCode", 4000), "")

if proc <> "D" and len(grupGubn) <> 1 then
	response.write	"1|Request Value Error!"
	response.end
end if

if fnIsNull(fnDBVal("NTBL_GRUP", "GRUP_DPTH", "GRUP_INDX = " & grupIndx & ""), 1) = 0 then
	response.write	"2|최상위 그룹은 편집할수 없습니다."
	response.end
end if

call subProcExec("nusp_procGrup", array(proc, grupGubn, grupUper, grupIndx, grupSort, grupName, replace(grupIndxRel, " ", ""), replace(arrCodes, " ", ""), ss_userIndx, svr_remoteAddr))

'set cmd = server.createobject("adodb.command")
'with cmd
'
'	.activeconnection = strDBConn
'	.commandtext = "nusp_procGrup"
'	.commandtype = adCmdStoredProc
'	
'	.parameters.append .createParameter("@proc",				adChar,			adParamInput,		1)
'	.parameters.append .createParameter("@grupGubn",		adChar,			adParamInput,		1)
'	.parameters.append .createParameter("@grupUper",		adInteger,	adParamInput,		0)
'	.parameters.append .createParameter("@grupIndx",		adInteger,	adParamInput,		0)
'	.parameters.append .createParameter("@grupSort",		adInteger,	adParamInput,		0)
'	.parameters.append .createParameter("@grupName",		adVarchar,	adParamInput,		50)
'	.parameters.append .createParameter("@grupIndxRel",	adVarchar,	adParamInput,		4000)
'	.parameters.append .createParameter("@arrCodes",		adVarchar,	adParamInput,		4000)
'	.parameters.append .createParameter("@userIndx",		adInteger,	adParamInput,		0)
'	.parameters.append .createParameter("@userIP",			adVarchar,	adParamInput,		20)
'	.parameters.append .createParameter("@retn",				adInteger,	adParamOutput,	0)
'	
'	.parameters("@proc")				= proc
'	.parameters("@grupGubn")		= grupGubn
'	.parameters("@grupUper")		= grupUper
'	.parameters("@grupIndx")		= grupIndx
'	.parameters("@grupSort")		= grupSort
'	.parameters("@grupName")		= grupName
'	.parameters("@grupIndxRel")	= replace(grupIndxRel, " ", "")
'	.parameters("@arrCodes")		= replace(arrCodes, " ", "")
'	.parameters("@userIndx")		= ss_userIndx
'	.parameters("@userIP")			= svr_remoteAddr
'	.parameters("@retn")				= 0
'	
'	.execute
'	
'	retn	= .parameters("@retn")
'	
'end with
'set cmd = nothing

dim grupDpth	: grupDpth	= fnDBVal("NTBL_GRUP", "GRUP_DPTH", "GRUP_INDX = " & retn & "")

if proc = "A" then
	response.write	"0|추가되었습니다.|" & retn & "|" & grupDpth
elseif proc = "S" or proc = "E" then
	response.write	"0|저장되었습니다.|" & retn & "|" & grupDpth
elseif proc = "D" then
	response.write	"0|삭제되었습니다.|" & retn & "|" & grupDpth
end if
%>