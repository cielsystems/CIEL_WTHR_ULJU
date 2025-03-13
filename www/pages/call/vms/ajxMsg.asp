<!--#include virtual="/common/common.asp"-->

<%
dim msgIdx : msgIdx = fnReq("idx")

sql = " select MSG_TIT, MSG_VMS from TBL_MSG with(nolock) where MSG_IDX = " & msgIdx & " "
dim msgInfo : msgInfo = execSqlArrVal(sql)

response.write	msgInfo(0) & "]|[" & msgInfo(1)
%>