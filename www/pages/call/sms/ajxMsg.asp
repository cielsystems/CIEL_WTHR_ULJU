<!--#include virtual="/common/common.asp"-->

<%
dim msgIdx : msgIdx = fnReq("idx")

'#	기존파일 삭제
sql = " delete from TMP_CALLFILE where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
call execSql(sql)

'#	메시지파일을 임시파일로 복사
sql = " insert into TMP_CALLFILE (CL_IDX, AD_IDX, AD_IP, TMP_GB, TMP_NO, TMP_SORT, TMP_DPNM, TMP_PATH, TMP_FILE, TMP_PAGE) "
sql = sql & " select 0, " & ss_userIdx & ", '" & svr_remoteAddr & "', MSGF_GB, MSGF_NO, MSGF_SORT, MSGF_DPNM, MSGF_PATH, MSGF_FILE, MSGF_PAGE "
sql = sql & " from TBL_MSGFILE with(nolock) "
sql = sql & " where MSG_IDX = " & msgIdx & " "
call execSql(sql)

sql = " select MSG_TIT, MSG_SMS from TBL_MSG with(nolock) where MSG_IDX = " & msgIdx & " "
dim msgInfo : msgInfo = execSqlArrVal(sql)

response.write	msgInfo(0) & "]|[" & msgInfo(1)
%>