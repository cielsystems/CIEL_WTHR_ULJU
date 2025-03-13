<!--#include virtual="/common/common.asp"-->

<%
dim msgIdx	: msgIdx	= fnIsNull(fnReq("msgIdx"), 0)

sql = " update TBL_MSG set USEYN = 'N', UPTDT = getdate() where MSG_IDX = " & msgIdx & " "
call execSql(sql)
%>

<script type="text/javascript">
	alert('삭제되었습니다.');
	top.location.href = 'msgList.asp?gb=1';
</script>