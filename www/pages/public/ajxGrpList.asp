<!--#include virtual="/common/common.asp"-->

<%
dim proc	: proc	= fnReq("proc")
dim grpGB : grpGB = fnIsNull(fnReq("grpGB"),"D")
dim grpUpCD : grpUpCD = fnReq("grpUpCD")

'//	GRP_CD(0), GRP_UPCD(1), GRP_NM(2)
dim sqlProc : sqlProc = "usp_listGrp_IWEST"

'#	타부서 사용권한 처리
dim cdUsGB : cdUsGB = clng(fnDBVal("TBL_ADDR", "CD_USERGB", "AD_IDX = " & ss_userIdx & ""))
dim adPerAddr : adPerAddr = fnDBVal("TBL_ADDR", "AD_PERADDR", "AD_IDX = " & ss_userIdx & "")

dim listPer	: listPer	= adPerAddr

if grpGB = "P" then
	listPer	= "A"
end if

'response.write	sqlProc & " " & grpGB & "," & grpUpCD & "," & ss_userIdx & ", '" & listPer & "', 'N'"

arrRs = execProcRs(sqlProc, array(grpGB, grpUpCD, ss_userIdx, listPer, "N"))
if isarray(arrRs) then
	arrRc2 = ubound(arrRs,2)
	arrRc1 = ubound(arrRs,1)
else
	arrRc2 = -1
end if

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
%>