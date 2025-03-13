<!--#include virtual="/common/common.asp"-->

<%
dim proc	: proc	= fnIsNull(nFnReq("proc", 4), "S")

dim addrIndx	: addrIndx	= fnIsNull(nFnReq("addrIndx", 0), 0)
dim addrGubn	: addrGubn	= fnIsNull(nFnReq("addrGubn", 1), "N")
dim addrSync	: addrSync	= fnIsNull(nFnReq("addrSync", 50), "")
dim addrName	: addrName	= fnIsNull(nFnReq("addrName", 50), "")
dim addrNum1	: addrNum1	= fnIsNull(nFnReq("addrNum1", 20), "")
dim addrNum2	: addrNum2	= fnIsNull(nFnReq("addrNum2", 20), "")
dim addrNum3	: addrNum3	= fnIsNull(nFnReq("addrNum3", 20), "")
dim addrMemo	: addrMemo	= fnIsNull(nFnReq("addrMemo", 1000), "")

dim grupIndx	: grupIndx	= fnIsNull(nFnReq("grupIndx", 4000), "")
dim addrCode	: addrCode	= fnIsNull(nFnReq("addrCode", 4000), "")


'set cmd = server.createobject("adodb.command")
'with cmd
'
'	.activeconnection = strDBConn
'	.commandtext = "nusp_procAddr"
'	.commandtype = adCmdStoredProc
'	
'	.parameters.append .createParameter("@proc",			adChar,			adParamInput,		1)
'	.parameters.append .createParameter("@addrIndx",	adInteger,	adParamInput,		0)
'	.parameters.append .createParameter("@addrGubn",	adchar,			adParamInput,		1)
'	.parameters.append .createParameter("@addrSync",	adVarchar,	adParamInput,		50)
'	.parameters.append .createParameter("@addrSort",	adInteger,	adParamInput,		0)
'	.parameters.append .createParameter("@addrName",	adVarchar,	adParamInput,		50)
'	.parameters.append .createParameter("@addrNum1",	adVarchar,	adParamInput,		255)
'	.parameters.append .createParameter("@addrNum2",	adVarchar,	adParamInput,		255)
'	.parameters.append .createParameter("@addrNum3",	adVarchar,	adParamInput,		255)
'	.parameters.append .createParameter("@addrMemo",	adVarchar,	adParamInput,		1000)
'	.parameters.append .createParameter("@grupIndx",	adVarchar,	adParamInput,		4000)
'	.parameters.append .createParameter("@addrCode",	adVarchar,	adParamInput,		4000)
'	.parameters.append .createParameter("@userIndx",	adInteger,	adParamInput,		0)
'	.parameters.append .createParameter("@userIP",		adVarchar,	adParamInput,		20)
'	.parameters.append .createParameter("@retn",			adInteger,	adParamOutput,	0)
'	
'	.parameters("@proc")			= proc
'	.parameters("@addrIndx")	= addrIndx
'	.parameters("@addrGubn")	= addrGubn
'	.parameters("@addrSync")	= addrSync
'	.parameters("@addrSort")	= 1
'	.parameters("@addrName")	= addrName
'	.parameters("@addrNum1")	= addrNum1
'	.parameters("@addrNum2")	= addrNum2
'	.parameters("@addrNum3")	= addrNum3
'	.parameters("@addrMemo")	= addrMemo
'	.parameters("@grupIndx")	= replace(grupIndx, " ", "")
'	.parameters("@addrCode")	= replace(addrCode, " ", "")
'	.parameters("@userIndx")	= ss_userIndx
'	.parameters("@userIP")		= svr_remoteAddr
'	.parameters("@retn")			= 0
'	
'	.execute
'	
'	dim retn	: retn	= .parameters("@retn")
'	
'end with
'set cmd = nothing

call subProcExec("nusp_procAddr", array(proc, addrIndx, addrGubn, addrSync, 1, addrName, addrNum1, addrNum2, addrNum3, addrMemo, replace(grupIndx, " ", ""), replace(addrCode, " ", ""), ss_userIndx, svr_remoteAddr))

call subSetLog(ss_userIdx, 8004, "연락처관리", "proc : " & proc & ", addrIndx : " & addrIndx, "")
%>

<script type="text/javascript">
	
	<% if proc = "S" then %>
		alert('저장되었습니다.');
		parent.location.href = 'pop_addrForm.asp?addrIndx=<%=retn%>';
		top.fnLoadPage(top.page);
	<% elseif proc = "D" then %>
		alert('삭제되었습니다.');
		top.location.reload();
	<% end if %>
	
</script>