<!--#include virtual="/common/common.asp"-->

<%
dim proc : proc = fnReq("proc")

if proc = "del" then
	
	dim no : no = fnReq("no")
	
	sql = " delete from TMP_CALLFILE where TMP_GB = 'S' and TMP_NO = " & no & " and CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
	response.write	sql
	call execSql(sql)
	
	response.write	"<script>"
	response.write	"top.fnFileLoad();top.fnDelMMSFile(" & no & ")"
	response.write	"</script>"

elseif proc = "delAll" then
	
	sql = " delete from TMP_CALLFILE where TMP_GB = 'S' and CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
	response.write	sql
	call execSql(sql)
	
	response.write	"<script>"
	response.write	"top.fnFileLoad();top.fnDelMMSFile(" & no & ")"
	response.write	"</script>"
	
elseif proc = "sel" then
	
	sql = " select TMP_GB, TMP_NO, TMP_DPNM, TMP_PATH, TMP_FILE from TMP_CALLFILE with(nolock) "
	sql = sql & " where TMP_GB = 'S' and CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' order by TMP_SORT "
	arrRs = execSqlRs(sql)
	if isarray(arrRs) then
		arrRc1 = ubound(arrRs,1)
		arrRc2 = ubound(arrRs,2)
		response.write	arrRc2+1 & "}|{"
		for i = 0 to arrRc2
			for ii = 0 to arrRc1
				response.write	arrRs(ii,i)
				if ii < arrRc1 then
					response.write	"]|["
				end if
			next
			if i < arrRc2 then
				response.write	"}|{"
			end if
		next
	else
		response.write	0
	end if
	
end if
%>