<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/public/sha/sha256.asp"-->

<%
dim oldPass			: oldPass			= fnReq("oldPass")
dim newPass			: newPass			= fnReq("newPass")	
dim newPassChk	: newPassChk	= fnReq("newPassChk")	

dim nPass : nPass = fnDBVal("NTBL_USER", "USER_PW", "USER_INDX = " & ss_userIndx & "")

dim passYN	: passYN	= "N"

sql = " select (case when USER_PW = '" & oldPass & "' then 'Y' else 'N' end) from NTBL_USER with(nolock) where USER_INDX =  " & ss_userIndx & " "
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
if not rs.eof then
	passYN = rs(0)
end if
rsClose()

if passYN = "Y" then
	
	sql = " update NTBL_USER set USER_PW = '" & newPass & "', UPTDT = now() where USER_INDX = " & ss_userIndx & " "
	call execSql(sql)
		
	response.write	"<script type=""text/javascript"">alert('비밀번호가 변경되었습니다.');top.fnCloseLayer();</script>"
	
else
		
	response.write	"<script type=""text/javascript"">alert('비밀번호가 일치하지 않습니다.');parent.document.frm.reset();</script>"
	response.end
	
end if
%>