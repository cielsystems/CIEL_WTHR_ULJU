<!--#include virtual="/common/common.asp"-->

<%
dim grpCD	: grpCD	= fnIsNull(fnReq("grpCD"),0)

response.write	fnDBVal("TBL_GRP", "USEYN", "GRP_CODE = " & grpCD & "")
%>