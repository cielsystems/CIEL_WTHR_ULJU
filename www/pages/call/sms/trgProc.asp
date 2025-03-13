<!--#include virtual="/common/common.asp"-->

<%
dim tp : tp = fnReq("tp") : tp = tp - 1

dim trg(4)
trg(1) = fnReq("trg2")
trg(2) = fnReq("trg3")
trg(3) = fnReq("trg4")
trg(4) = fnReq("trg5")

dim strTrg : strTrg = trg(tp)

dim arrTrg : arrTrg = split(strTrg,",")

dim arrVal

dim maxNo : maxNo = fnDBMax("TMP_CALLTRG", "TMP_NO", "CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
maxNo = clng(maxNo) + 1
dim maxSort : maxSort = fnDBMax("TMP_CALLTRG", "TMP_SORT", "CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
maxSort = clng(maxSort) + 1

sql = " insert into TMP_CALLTRG (AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1) values "

dim cntOK : cntOK = 0
dim cntErr : cntErr = 0

dim uuid

dim strErr : strErr = ""

dim tmpChar
for i = 0 to ubound(arrTrg)
	
	arrVal = split(trim(arrTrg(i)),"||")
		
	if fnChkMobileNum(trim(arrVal(2))) = true then
		
		sql = sql & " (" & ss_userIdx & ", '" & svr_remoteAddr & "', " & clng(maxNo) + i & ", " & clng(maxSort) + i & ", " & trim(arrVal(0)) & ", '" & trim(arrVal(1)) & "'"
		'sql = sql & " , dbo.ecl_ENCRPART('" &  trim(arrVal(2)) & "',4)) "
		sql = sql & " , '" &  trim(arrVal(2)) & "') "
		if i < ubound(arrTrg) then
			sql = sql & ","
		end if
		
		cntOK = cntOK + 1
		
	else
		
		'strErr = strErr & "\n" & fnDBVal("TBL_ADDR", "'[' + AD_NM + '] ' + AD_NUM1", "AD_IDX = " & trim(arrVal(0)) & "")
		strErr = strErr & "\n" & fnDBVal("nviw_addrList", "'[' + ADDR_NAME + '] ' + ADDR_NUM1", "ADDR_INDX = " & trim(arrVal(0)) & "")
		
		cntErr = cntErr + 1
		
	end if
	
next

if cntOK > 0 then
	
	do while right(sql,1) = ","
		sql = left(sql,len(sql)-1)
	loop
	
	'response.write	sql
	call execSql(sql)
	
	response.write	"<script>"
	if cntErr > 0 then
		response.write	"alert('휴대폰번호가 잘못된 " & cntErr & "명을 제외한 " & cntOK & "명의 대상자가 추가되었습니다.\n\n------------------------------" & strErr & "');"
	else
		response.write	"alert('" & cntOK & "명의 대상자가 추가되었습니다.');"
	end if
	response.write	"top.fnLoadAddr(top.nTab);"
	response.write	"top.fnLoadTrg();"
	response.write	"</script>"
	
else
	
	response.write	"<script>"
	response.write	"alert('휴대폰번호가 잘못된 " & cntErr & "명을 제외한 " & cntOK & "명의 대상자가 추가되었습니다.');"
	response.write	"</script>"
	
end if
%>