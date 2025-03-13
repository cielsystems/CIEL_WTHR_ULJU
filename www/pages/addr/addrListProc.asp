<!--#include virtual="/common/common.asp"-->

<%
dim proc	: proc	= fnIsNull(nFnReq("proc",	4), "")

dim addrIndx	: addrIndx	= fnIsNull(nFnReq("addrIndx",	4000), "")

dim arrIndx		: arrIndx		= split(addrIndx, ",")

if proc = "D" and len(addrIndx) > 0 then
	
	for i = 0 to ubound(arrIndx)
		call subProcExec("nusp_procAddr", array("D", arrIndx(i), "", "", 0, "", "", "", "", "", "", "", ss_userIndx, svr_remoteAddr))
	next
	
	call subSetLog(ss_userIdx, 8004, "선택연락처삭제", "addrIndx : " & addrIndx, "")
	
	response.write	"0|" & ubound(arrIndx) + 1 & "건의 연락처가 삭제되었습니다."
	
else
	
	response.write	"Error"
	
end if
%>