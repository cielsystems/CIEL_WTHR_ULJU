<!--#include virtual="/common/common.asp"-->

<%
dim proc : proc = fnReq("proc")

dim grpDepth : grpDepth = fnReq("grpDepth")
dim grpCD : grpCD = fnIsNull(fnReq("grpCD"),1)
dim grpNM : grpNM = fnReq("grpNM")
dim useYN	: useYN	= fnIsNull(fnReq("useYN"),"V")

response.write	useYN
'response.end

dim grpCode(5)
grpCode(1) = fnIsNull(fnReq("grpCode1"),0)
grpCode(2) = fnIsNull(fnReq("grpCode2"),0)
grpCode(3) = fnIsNull(fnReq("grpCode3"),0)
grpCode(4) = fnIsNull(fnReq("grpCode4"),0)
grpCode(5) = fnIsNull(fnReq("grpCode5"),0)

dim strProc

if proc = "I" then
	
	dim grpUpCD : grpUpCD = grpCD
	dim grpSort : grpSort = fnDBMax("TBL_GRP", "GRP_SORT", "GRP_GB = 'D' and GRP_UPCODE = '" & grpUpCD & "'")
	grpSort = clng(grpSort) + 1
	dim tmpCD : tmpCD = fnDBMax("TBL_GRP", "GRP_CODE", "1=1")
	grpCD = tmpCD + 1
	
	sql = " insert into TBL_GRP (GRP_CODE, GRP_UPCODE, GRP_GB, AD_IDX, GRP_SORT, GRP_NM, USEYN) "
	sql = sql & " values (" & grpCD & ", " & grpUpCD & ", 'D', " & ss_userIdx & ", " & grpSort & ", '" & grpNM & "', '" & useYN & "') "
	
	'grpCode(grpDepth) = 0
	
	strProc = "추가"
	
elseif proc = "U" then
	
	sql = " update TBL_GRP set GRP_NM = '" & grpNM & "', USEYN = '" & useYN & "', UPTDT = getdate() where GRP_CODE = " & grpCD & " "
	
	'if useYN = "V" then
		sql = sql & " update TBL_GRP set USEYN = '" & useYN & "', UPTDT = getdate() where GRP_UPCODE = " & grpCD & " "
		sql = sql & " update TBL_GRP set USEYN = '" & useYN & "', UPTDT = getdate() where GRP_UPCODE in (select GRP_CODE from TBL_GRP where GRP_UPCODE = " & grpCD & ") "
		sql = sql & " update TBL_GRP set USEYN = '" & useYN & "', UPTDT = getdate() where GRP_UPCODE in (select GRP_CODE from TBL_GRP where GRP_UPCODE in (select GRP_CODE from TBL_GRP where GRP_UPCODE = " & grpCD & ")) "
		sql = sql & " update TBL_GRP set USEYN = '" & useYN & "', UPTDT = getdate() where GRP_UPCODE in (select GRP_CODE from TBL_GRP where GRP_UPCODE in (select GRP_CODE from TBL_GRP where GRP_UPCODE in (select GRP_CODE from TBL_GRP where GRP_UPCODE = " & grpCD & "))) "
	'end if
	
	strProc = "수정"
	
elseif proc = "D" then
	
	sql = " update TBL_ADDR set USEYN = 'N' where USEYN = 'Y' and GRP_CODE = " & grpCD & "; "
	call execSql(sql)
	
	sql = " update TBL_ADDR set USEYN = 'N' where USEYN = 'Y' and AD_IDX in (select AD_IDX from TBL_GRPREL with(nolock) where GRP_CODE = " & grpCD & "); "
	call execSql(sql)
	
	sql = " update TBL_GRP set USEYN = 'N' where GRP_CODE = " & grpCD & "; "
	
	strProc = "삭제"
	
end if

response.write	sql
call execSql(sql)

if proc = "I" then
	
	sql = " update TBL_GRP set GRP_DEPTH = dbo.ufn_getGrpDepth(GRP_CODE) where GRP_CODE = " & grpCD & " "
	call execSql(sql)
	
end if

call subSetLog(ss_userIdx, 8007, "그룹(부서)" & strProc, "grpUpCD : " & grpUpCD & ", grpCD : " & grpCD & "", "")
%>

<script>
	alert('부서가 <%=strProc%>되었습니다.');
	parent.selGrp[1] = <%=grpCode(1)%>;
	parent.selGrp[2] = <%=grpCode(2)%>;
	parent.selGrp[3] = <%=grpCode(3)%>;
	parent.selGrp[4] = <%=grpCode(4)%>;
	parent.selGrp[5] = <%=grpCode(5)%>;
	parent.fnLoadGrp(1,1);
	parent.fnSelGrp(2);
	<%
	for i = 2 to 5
		if grpCode(i) > 0 then
			%>
			parent.fnLoadGrp(<%=i%>,<%=grpCode(i-1)%>);
			parent.fnSelGrp(<%=i+1%>);
			<%
		end if
	next
	%>
</script>