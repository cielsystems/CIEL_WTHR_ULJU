<!--#include virtual="/common/common.asp"-->

<%
dim proc : proc = fnIsNull(fnReq("proc"),"all")
dim clIdx : clIdx = fnReq("clIdx")
dim cltNo : cltNo = fnReq("cltNo")

dim strProc

if proc = "all" then
	
	call execProc("usp_callStop", array(clIdx, 0))
	
	strProc = "parent.location.reload();parent.window.close();"
	
elseif proc = "one" then
	
	call execProc("usp_callStop", array(clIdx, cltNo))
	
	strProc = "parent.location.reload();"
	
end if

call subSetLog(ss_userIdx, 8002, "전송중지", "Proc : " & proc & ", clIdx : " & clIdx & ", cltNo : " & cltNo & "", "")
%>

<script>
	alert('중지되었습니다.');
	<%=strProc%>
</script>