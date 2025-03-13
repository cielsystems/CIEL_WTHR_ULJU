<!--#include virtual="/common/common.asp"-->

<%
dim proc	: proc	= fnReq("proc")

dim warnVarCode		: warnVarCode		= fnIsNull(fnReq("warnVarCode"), 0)
dim warnStressCode	: warnStressCode	= fnIsNull(fnReq("warnStressCode"), 0)
dim commandCode		: commandCode		= fnIsNull(fnReq("v"), 0)
dim schKey			: schKey			= fnIsNull(fnReq("schKey"), "")
dim schVal			: schVal			= fnIsNull(fnReq("schVal"), "")

dim ruleID			: ruleID			= fnIsNull(fnReq("ruleID"), "")

if right(proc, 1) = "D" then
	sql = " update TBL_NotiRuleSet set USEYN = 'N' where USEYN = 'Y' "
else
	sql = " update TBL_NotiRuleSet set autoUseYN = '" & right(proc, 1) & "' where USEYN = 'Y' "
end if

if left(proc, 3) = "all" then
	
	if warnVarCode > 0 then
		sql = sql & " and warnVarCode = " & warnVarCode & " "
	end if
	if warnStressCode > 0 then
		sql = sql & " and warnStressCode = " & warnStressCode & " "
	end if
	if commandCode > 0 then
		sql = sql & " and commandCode = " & commandCode & " "
	end if
	if len(schVal) > 0 then
		sql = sql & " and (areaName like '%" & schVal & "%' or areaCode in (select AREACODE from NTBL_NOTI_AREA where AREANAME like '%" & schVal & "%')) "
	end if

elseif left(proc, 3) = "sel" then
	
	if len(ruleID) > 0 then
		sql = sql & " and ruleID in (" & ruleID & ") "
	end if
	
end if

response.write	sql
call execSql(sql)
%>

<script type="text/javascript">
	top.fnLoadPage(top.page);
</script>