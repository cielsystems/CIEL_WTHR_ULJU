<!--#include virtual="/common/common.asp"-->

<%
dim proc : proc = fnReq("proc")

dim adIdx : adIdx = fnReq("adIdx")

dim tmpNo, tmpSort, trgCnt

if proc = "selAdd" then
	
	trgCnt = fnDBVal("TBL_ADDR", "count(*)", "USEYN = 'Y' and AD_IDX in (" & adIdx & ")")
	
	if dbType = "mssql" then
			
		tmpNo = fnDBMax("TMP_CALLTRG","TMP_NO","CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
		tmpNo = clng(tmpNo)
		
		sql = " insert into TMP_CALLTRG (CL_IDX, AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_NUM2, TMP_NUM3) "
		sql = sql & " select 0, " & ss_userIdx & ", '" & svr_remoteAddr & "', ROW_NUMBER() over(order by AD_IDX) + " & tmpNo & " "
		sql = sql & " 	, (case when left(AD_GRP03,4) = '5003' then convert(int, AD_GRP03) - 500300 else AD_GRP03 end), AD_IDX, AD_NM, AD_NUM1, AD_NUM2, AD_NUM3 "
		sql = sql & " from TBL_ADDR with(nolock) "
		sql = sql & " where USEYN = 'Y' and AD_IDX in (" & adIdx & ") and AD_GRP03 <> '500309' "
		'#	중복대상제외
		sql = sql & " 	and AD_IDX not in (select TMP_IDX from TMP_CALLTRG where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "') "
		sql = sql & " order by dbo.ufn_getGrpSort(GRP_CODE, 1) asc "
		sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE, 2) asc "
		sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE, 3) asc "
		sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE, 4) asc "
		sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE, 5) asc "
		sql = sql & " 	, AD_GRP03 asc "
		sql = sql & " 	, AD_SORT asc "
		
	elseif dbType = "mysql" then
		
		sql = " select AD_IDX, AD_NM, AD_NUM1, AD_NUM2, AD_NUM3, isnull(AD_GRP03,0) "
		sql = sql & " from TBL_ADDR "
		sql = sql & " where USEYN = 'Y' and AD_IDX in (" & adIdx & ") and AD_GRP03 <> '500309' "
		'#	중복대상제외
		sql = sql & " 	and AD_IDX not in (select TMP_IDX from TMP_CALLTRG where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "') "
		sql = sql & " order by ufn_getGrpSort(GRP_CODE, 1) asc "
		sql = sql & " 	, ufn_getGrpSort(GRP_CODE, 2) asc "
		sql = sql & " 	, ufn_getGrpSort(GRP_CODE, 3) asc "
		sql = sql & " 	, ufn_getGrpSort(GRP_CODE, 4) asc "
		sql = sql & " 	, ufn_getGrpSort(GRP_CODE, 5) asc "
		sql = sql & " 	, AD_GRP03 asc "
		sql = sql & " 	, AD_SORT asc "
		cmdOpen(sql)
		set rs = cmd.execute
		cmdClose()
		if not rs.eof then
			arrRs = rs.getRows
			arrRc1 = ubound(arrRs,1)
			arrRc2 = ubound(arrRs,2)
		else
			arrRc2 = -1
		end if
		rsClose()
		
		tmpNo = fnDBMax("TMP_CALLTRG","TMP_NO","CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
		tmpNo = clng(tmpNo) + 1
		
		sql = " insert into TMP_CALLTRG (CL_IDX, AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_NUM2, TMP_NUM3) values "
		
		for i = 0 to arrRc2
			
			sql = sql & " (0, " & ss_userIdx & ", '" & svr_remoteAddr & "', " & tmpNo + i & " "
			if left(arrRs(5,i),4) = "5003" then
				sql = sql & " , '" & clng(arrRs(5,i)) - 500300 & "' "
			elseif len(arrRs(5,i)) =  0 then
				sql = sql & " , '0' "
			else
				sql = sql & " , '" & arrRs(5,i) & "' "
			end if
			for ii = 0 to arrRc1 - 1
				sql = sql & " , '" & arrRs(ii,i) & "' "
			next
			sql = sql & " ) "
			
			if i < arrRc2 then
				sql = sql & ","
			end if
			
		next
		
	end if
	
elseif proc = "inpAdd" then
	
	tmpNo = fnDBMax("TMP_CALLTRG","TMP_NO","CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
	tmpNo = clng(tmpNo) + 1
	tmpSort = fnDBMax("TMP_CALLTRG","TMP_SORT","CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
	tmpSort = clng(tmpNo) + 1
	
	dim inpNM		: inpNM		= fnReq("inpNM")
	'dim inpMob	: inpMob	= fnReq("inpMob")
	'dim inpPhn	: inpPhn	= fnReq("inpPhn")
	'dim inpFax	: inpFax	= fnReq("inpFax")
	dim inpNum1	: inpNum1	= fnReq("inpNum1")
	
	sql = " insert into TMP_CALLTRG (CL_IDX, AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_NUM2, TMP_NUM3) "
	sql = sql & " values (0, " & ss_userIdx & ", '" & svr_remoteAddr & "', " & tmpNo & ", " & tmpSort & ", 0, '" & inpNM & "', '" & inpNum1 & "', '', '') "
	
elseif proc = "trgDel" then
	
	tmpNo = fnReq("no")
	
	sql = " delete from TMP_CALLTRG where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' and TMP_NO = " & tmpNo & " "
	
elseif proc = "trgAllDel" then
	
	sql = " delete from TMP_CALLTRG where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
	
elseif proc = "allStf" then	'# 전직원 추가
	
	trgCnt = fnDBVal("TBL_ADDR", "count(*)", "USEYN = 'Y' and AD_IDX > 1 and AD_GRP03 <> '500309' and GRP_CODE in (select GRP_CODE from TBL_GRP where USEYN = 'Y' and GRP_GB = 'D')")
	
	if dbType = "mssql" then
		
		tmpNo = fnDBMax("TMP_CALLTRG","TMP_NO","CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
		tmpNo = clng(tmpNo)
		
		sql = " insert into TMP_CALLTRG (CL_IDX, AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_NUM2, TMP_NUM3) "
		sql = sql & " select 0, " & ss_userIdx & ", '" & svr_remoteAddr & "', ROW_NUMBER() over(order by AD_IDX) + " & tmpNo & " "
		sql = sql & " 	, (case when left(AD_GRP03,4) = '5003' then convert(int, AD_GRP03) - 500300 else AD_GRP03 end), AD_IDX, AD_NM, AD_NUM1, AD_NUM2, AD_NUM3 "
		sql = sql & " from TBL_ADDR with(nolock) "
		sql = sql & " where USEYN = 'Y' and AD_IDX > 1 and AD_GRP03 <> '500309' and GRP_CODE in (select GRP_CODE from TBL_GRP where USEYN = 'Y' and GRP_GB = 'D') "
		sql = sql & " 	and AD_GB = 'A' "
		'#	중복대상제외
		sql = sql & " 	and AD_IDX not in (select TMP_IDX from TMP_CALLTRG where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "') "
		sql = sql & " order by dbo.ufn_getGrpSort(GRP_CODE, 1) asc "
		sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE, 2) asc "
		sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE, 3) asc "
		sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE, 4) asc "
		sql = sql & " 	, dbo.ufn_getGrpSort(GRP_CODE, 5) asc "
		sql = sql & " 	, AD_GRP03 asc "
		sql = sql & " 	, AD_SORT asc "
		
	elseif dbType = "mysql" then
		
		sql = " select AD_IDX, AD_NM, AD_NUM1, AD_NUM2, AD_NUM3, isnull(AD_GRP03,0) "
		sql = sql & " from TBL_ADDR "
		sql = sql & " where USEYN = 'Y' and AD_IDX > 1 and AD_GRP03 <> '500309' and GRP_CODE in (select GRP_CODE from TBL_GRP where USEYN = 'Y' and GRP_GB = 'D') "
		'#	중복대상제외
		sql = sql & " 	and AD_IDX not in (select TMP_IDX from TMP_CALLTRG where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "') "
		sql = sql & " 	and AD_GB = 'A' "
		sql = sql & " order by ufn_getGrpSort(GRP_CODE, 1) asc "
		sql = sql & " 	, ufn_getGrpSort(GRP_CODE, 2) asc "
		sql = sql & " 	, ufn_getGrpSort(GRP_CODE, 3) asc "
		sql = sql & " 	, ufn_getGrpSort(GRP_CODE, 4) asc "
		sql = sql & " 	, ufn_getGrpSort(GRP_CODE, 5) asc "
		sql = sql & " 	, AD_GRP03 asc "
		sql = sql & " 	, AD_SORT asc "
		cmdOpen(sql)
		set rs = cmd.execute
		cmdClose()
		if not rs.eof then
			arrRs = rs.getRows
			arrRc1 = ubound(arrRs,1)
			arrRc2 = ubound(arrRs,2)
		else
			arrRc2 = -1
		end if
		rsClose()
		
		tmpNo = fnDBMax("TMP_CALLTRG","TMP_NO","CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
		tmpNo = clng(tmpNo) + 1
		
		sql = " insert into TMP_CALLTRG (CL_IDX, AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_NUM2, TMP_NUM3) values "
		
		for i = 0 to arrRc2
			
			sql = sql & " (0, " & ss_userIdx & ", '" & svr_remoteAddr & "', " & tmpNo + i & " "
			if left(arrRs(5,i),4) = "5003" then
				sql = sql & " , '" & clng(arrRs(5,i)) - 500300 & "' "
			elseif len(arrRs(5,i)) =  0 then
				sql = sql & " , '0' "
			else
				sql = sql & " , '" & arrRs(5,i) & "' "
			end if
			for ii = 0 to arrRc1 - 1
				sql = sql & " , '" & arrRs(ii,i) & "' "
			next
			sql = sql & " ) "
			
			if i < arrRc2 then
				sql = sql & ","
			end if
			
		next
		
	end if
	
elseif proc = "addTrg" then
	
	tmpNo = fnDBMax("TMP_CALLTRG","TMP_NO","CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
	tmpNo = clng(tmpNo) + 1
	tmpSort = fnDBMax("TMP_CALLTRG","TMP_SORT","CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
	tmpSort = clng(tmpNo) + 1
	
	sql = " insert into TMP_CALLTRG (CL_IDX, AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_NUM2, TMP_NUM3) "
	sql = sql & " select 0, " & ss_userIdx & ", '" & svr_remoteAddr & "', " & tmpNo & ", " & tmpSort & ", AD_IDX, AD_NM, AD_NUM1, AD_NUM2, AD_NUM3 from TBL_ADDR where AD_IDX = " & adIdx & " "
	
elseif proc = "delTrg" then
	
	sql = " delete from TMP_CALLTRG where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' and TMP_IDX = " & adIdx & " "
	
end if

if len(sql) > 0 then
	response.write	sql
	call execSql(sql)
end if

dim tmpCnt : tmpCnt = fnDBVal("TMP_CALLTRG","count(*)","CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")

dim strScript

select case proc
	case "selAdd"		: strScript = "if(confirm('" & trgCnt & "건의 전송대상이 추가되었습니다.\n전송대상을 더 추가하시겠습니까?')){parent.fnLoadAddr(parent.nGrpCD);parent.fnLoadingE();}else{top.fnCloseLayer();}"
	case "inpAdd"			: strScript = "if(confirm('전송대상이 추가되었습니다.\n전송대상을 더 추가하시겠습니까?')){parent.fnLoadAddr(parent.nGrpCD);parent.fnLoadingE();}else{top.fnCloseLayer();}"
	case "trgDel"			: strScript = "alert('전송대상이 삭제되었습니다.');parent.fnLoadPage(parent.page);"
	case "trgAllDel"	: strScript = "alert('전송대상이 모두 삭제되었습니다.');parent.fnLoadPage(parent.page);op.fnCloseLayer();"
	case "allStf"			: strScript = "alert('" & trgCnt & "건의 전송대상이 추가되었습니다.');top.fnCloseLayer();"
	case "addTrg"			: strScript = "parent.fnLoadAddr(parent.nGrpCD);"
	case "delTrg"			: strScript = "parent.fnLoadAddr(parent.nGrpCD);"
end select
%>

<script>
	top.trgCnt = <%=tmpCnt%>;
	top.fnTargetMsg();
	<%=strScript%>
</script>