<!--#include virtual="/common/common.asp"-->

<%
dim proc : proc = fnReq("proc")

dim grpCD : grpCD = fnReq("grpCD") : if grpCD = "" or isnumeric(grpCD) = false then grpCD = 0 end if

'response.write	proc

if proc = "up" then
	
	if dbType = "mssql" then
		
		sql = " select "
		sql = sql & " 	(case "
		sql = sql & " 		when GRP_DEPTH = 2 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE) "
		sql = sql & " 		when GRP_DEPTH = 3 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE)) "
		sql = sql & " 		when GRP_DEPTH = 4 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE))) "
		sql = sql & " 		when GRP_DEPTH = 5 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE)))) "
		sql = sql & " 		else '' "
		sql = sql & " 	end) "
		sql = sql & " 	+ isnull(('](2)[' + case "
		sql = sql & " 		when GRP_DEPTH = 3 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE) "
		sql = sql & " 		when GRP_DEPTH = 4 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE)) "
		sql = sql & " 		when GRP_DEPTH = 5 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE))) "
		sql = sql & " 	end),'') "
		sql = sql & " 	+ isnull(('](3)[' + case "
		sql = sql & " 		when GRP_DEPTH = 4 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE) "
		sql = sql & " 		when GRP_DEPTH = 5 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE)) "
		sql = sql & " 	end),'') "
		sql = sql & " 	+ isnull(('](4)[' + case "
		sql = sql & " 		when GRP_DEPTH = 5 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE) "
		sql = sql & " 	end),'') "
		sql = sql & " from dbo.ufn_tblGetSubGrpCodesAdm(" & grpCD & ") as grp "
		sql = sql & " where GRP_CODE = " & grpCD & " "
		
	elseif dbType = "mysql" then
		
		sql = " select concat( "
		sql = sql & " 	(case "
		sql = sql & " 		when GRP_DEPTH = 2 then (select GRP_NM from TBL_GRP where GRP_CODE = grp.GRP_UPCODE) "
		sql = sql & " 		when GRP_DEPTH = 3 then (select GRP_NM from TBL_GRP where GRP_CODE = (select GRP_UPCODE from TBL_GRP where GRP_CODE = grp.GRP_UPCODE)) "
		sql = sql & " 		when GRP_DEPTH = 4 then (select GRP_NM from TBL_GRP where GRP_CODE = (select GRP_UPCODE from TBL_GRP where GRP_CODE = (select GRP_UPCODE from TBL_GRP where GRP_CODE = grp.GRP_UPCODE))) "
		sql = sql & " 		when GRP_DEPTH = 5 then (select GRP_NM from TBL_GRP where GRP_CODE = (select GRP_UPCODE from TBL_GRP where GRP_CODE = (select GRP_UPCODE from TBL_GRP where GRP_CODE = (select GRP_UPCODE from TBL_GRP where GRP_CODE = grp.GRP_UPCODE)))) "
		sql = sql & " 		else '' "
		sql = sql & " 	end) "
		sql = sql & " 	, isnull((case "
		sql = sql & " 		when GRP_DEPTH = 3 then concat('](2)[', (select GRP_NM from TBL_GRP where GRP_CODE = grp.GRP_UPCODE)) "
		sql = sql & " 		when GRP_DEPTH = 4 then concat('](2)[', (select GRP_NM from TBL_GRP where GRP_CODE = (select GRP_UPCODE from TBL_GRP where GRP_CODE = grp.GRP_UPCODE))) "
		sql = sql & " 		when GRP_DEPTH = 5 then concat('](2)[', (select GRP_NM from TBL_GRP where GRP_CODE = (select GRP_UPCODE from TBL_GRP where GRP_CODE = (select GRP_UPCODE from TBL_GRP where GRP_CODE = grp.GRP_UPCODE)))) "
		sql = sql & " 	end),'') "
		sql = sql & " 	, isnull((case "
		sql = sql & " 		when GRP_DEPTH = 4 then concat('](3)[', (select GRP_NM from TBL_GRP where GRP_CODE = grp.GRP_UPCODE)) "
		sql = sql & " 		when GRP_DEPTH = 5 then concat('](3)[', (select GRP_NM from TBL_GRP where GRP_CODE = (select GRP_UPCODE from TBL_GRP where GRP_CODE = grp.GRP_UPCODE))) "
		sql = sql & " 	end),'') "
		sql = sql & " 	, isnull((case "
		sql = sql & " 		when GRP_DEPTH = 5 then concat('](4)[', (select GRP_NM from TBL_GRP where GRP_CODE = grp.GRP_UPCODE)) "
		sql = sql & " 	end),'') "
		sql = sql & " ) from TBL_GRP as grp "
		sql = sql & " where GRP_CODE = " & grpCD & " "
		
	end if
	
elseif proc = "full" then
	
	sql = " select "
	sql = sql & " 	(case "
	sql = sql & " 		when GRP_DEPTH = 1 then GRP_NM "
	sql = sql & " 		when GRP_DEPTH = 2 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE) "
	sql = sql & " 		when GRP_DEPTH = 3 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE)) "
	sql = sql & " 		when GRP_DEPTH = 4 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE))) "
	sql = sql & " 		when GRP_DEPTH = 5 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE)))) "
	sql = sql & " 		else '' "
	sql = sql & " 	end) "
	sql = sql & " 	+ isnull(('](2)[' + case "
	sql = sql & " 		when GRP_DEPTH = 2 then GRP_NM "
	sql = sql & " 		when GRP_DEPTH = 3 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE) "
	sql = sql & " 		when GRP_DEPTH = 4 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE)) "
	sql = sql & " 		when GRP_DEPTH = 5 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE))) "
	sql = sql & " 	end),'') "
	sql = sql & " 	+ isnull(('](3)[' + case "
	sql = sql & " 		when GRP_DEPTH = 3 then GRP_NM "
	sql = sql & " 		when GRP_DEPTH = 4 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE) "
	sql = sql & " 		when GRP_DEPTH = 5 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = (select GRP_UPCODE from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE)) "
	sql = sql & " 	end),'') "
	sql = sql & " 	+ isnull(('](4)[' + case "
	sql = sql & " 		when GRP_DEPTH = 4 then GRP_NM "
	sql = sql & " 		when GRP_DEPTH = 5 then (select GRP_NM from TBL_GRP with(nolock) where GRP_CODE = grp.GRP_UPCODE) "
	sql = sql & " 	end),'') "
	sql = sql & " 	+ isnull(('](5)[' + case "
	sql = sql & " 		when GRP_DEPTH = 5 then GRP_NM "
	sql = sql & " 	end),'') "
	sql = sql & " from TBL_GRP as grp "
	sql = sql & " where GRP_CODE = " & grpCD & " "
		
end if
'response.write	sql

if grpCD > 0 then
		
	dim rtn : rtn = execSqlArrVal(sql)
	dim strRtn : strRtn = rtn(0)
	dim strHref
	
	if len(strRtn) > 0 then
		strRtn = "<a href=""javascript:fnReSelGrp(1)""><span class=""colPurple"" style=""background:#eeeeee;border:1px solid #cccccc;padding:2px 5px 2px 5px;"">" & strRtn & "</span></a> > "
		for i = 1 to 5
			strHref = "</span></a> > <a href=""javascript:fnReSelGrp(" & i & ")""><span class=""colPurple"" style=""background:#eeeeee;border:1px solid #cccccc;padding:2px 5px 2px 5px;"">"
			strRtn = replace(strRtn,"](" & i & ")[",strHref)
		next
	end if
	
	response.write	strRtn
	
end if
%>