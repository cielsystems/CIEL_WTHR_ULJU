<!--#include virtual="/common/common.asp"-->

<%
dim userNum1	: userNum1	= fnIsNull(nFnReq("userNum1", 20), "")
dim userNum2	: userNum2	= fnIsNull(nFnReq("userNum2", 20), "")
dim userNum3	: userNum3	= fnIsNull(nFnReq("userNum3", 20), "")
dim userDfltNum	: userDfltNum	= fnIsNull(nFnReq("userDfltNum", 20), "")

sql = " update NTBL_USER "
sql = sql & " set USER_NUM1 = '" & userNum1 & "', USER_NUM2 = '" & userNum2 & "', USER_NUM3 = '" & userNum3 & "' "
sql = sql & " 	, USER_DFLT_NUM = '" & userDfltNum & "', UPTDT = getdate() "
sql = sql & " where USER_INDX = " & ss_userIndx & " "
call execSql(sql)

call subSetLog(ss_userIdx, 8009, "개인정보수정", "", "")
%>

<script>
	alert('저장되었습니다.');parent.location.reload();
</script>