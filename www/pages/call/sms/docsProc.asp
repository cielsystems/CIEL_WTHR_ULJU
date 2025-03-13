<!--#include virtual="/common/common.asp"-->

<%
dim proc : proc = fnReq("proc")
dim idx : idx = fnReq("idx")

if proc = "add" then
	
	dim tit : tit = fnReq("tit")
	dim msg : msg = fnReq("msg")
	'msg = replace(msg,Chr(13),"")
	'msg = replace(msg,Chr(10),"<br>")
	
	call execProc("usp_setMsg", array("I", 0, "N", 200301, "N", 0, "", tit, msg, "", "", ss_userIdx, svr_remoteAddr))
	
	call subSetLog(ss_userIdx, 8003, "메시지추가 <" & tit & ">", idx, "")
	
	response.write	"<script>"
	response.write	"	alert('저장되었습니다.');"
	response.write	"	top.location.reload();"
	response.write	"</script>"

elseif proc = "del" then
	
	call execProc("usp_setMsg", array("D", idx, "N", 200301, "N", 0, "", tit, msg, "", "", ss_userIdx, svr_remoteAddr))
	
	call subSetLog(ss_userIdx, 8003, "메시지삭제 <" & tit & ">", idx, "")
	
	response.write	"<script>"
	response.write	"	top.fnCloseLayerContBox();"
	response.write	"	top.fnOpenLayerContBox('layerDocs');"
	response.write	"</script>"

elseif proc = "delN" then
	
	call execProc("usp_setMsg", array("D", idx, "N", 200301, "N", 0, "", tit, msg, "", "", ss_userIdx, svr_remoteAddr))
	
	call subSetLog(ss_userIdx, 8003, "메시지삭제 <" & tit & ">", idx, "")
	
	response.write	"<script>"
	response.write	"	alert('삭제되었습니다.');"
	response.write	"	top.location.reload();"
	response.write	"</script>"
	
end if
%>