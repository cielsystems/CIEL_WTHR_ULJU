<!--#include virtual="/common/common.asp"-->

<%
dim clIdx : clIdx = fnReq("clIdx")

sql = " update TBL_CALL set USEYN = 'N' where CL_IDX = " & clIdx & " "
call execSql(sql)
%>

<script>
	alert('삭제되었습니다.');
	parent.location.reload();
</script>