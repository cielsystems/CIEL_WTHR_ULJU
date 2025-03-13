<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/public/sha/sha256.asp"-->

<%
dim proc	: proc	= nFnReq("proc", 5)

dim userIndx	: userIndx	= fnIsNull(nFnReq("userIndx", 0), 0)

dim userPW	: userPW	= sha256(dftPass)

sql = " update NTBL_USER set USER_PW = '" & userPW & "', UPTDT = getdate() where USER_INDX = " & userIndx & " "
call execSql(sql)

call subSetLog(ss_userIdx, 8006, "사용자 비밀번호변경", "userIndx : " & userIndx & "", "")
%>

<script type="text/javascript">
	alert('비밀번호가 변경되었습니다.');
	parent.location.reload();
</script>