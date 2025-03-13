<!--#include virtual="/common/common.asp"-->

<%
mnCD = "5001"
%>

<!--#include virtual="/common/header_adm.asp"-->

<div id="subPageBox">
	
	<table border="0" cellpadding="0" cellspacing="1" class="tblList">
		<colgroup>
			<col width="*" />
			<col width="25%" />
			<col width="25%" />
			<col width="25%" />
		</colgroup>
		<%
		dim rnkRs, rnkRc, rnkLoop
		sql = " select CD_CODE, CD_NM from TBL_CODE with(nolock) where USEYN = 'Y' and CD_UPCODE = 71 order by CD_SORT "
		cmdOpen(sql)
		set rs = cmd.execute
		cmdClose()
		if not rs.eof then
			rnkRs = rs.getRows
			rnkRc = ubound(rnkRs, 2)
		else
			rnkRc = -1
		end if
		rsClose()
		
		dim wrkRs, wrkRc, wrkLoop
		
		sql = " select CD_CODE, CD_NM from TBL_CODE with(nolock) where USEYN = 'Y' and CD_UPCODE = 70 order by CD_SORT "
		cmdOpen(sql)
		set rs = cmd.execute
		cmdClose()
		if not rs.eof then
			wrkRs = rs.getRows
			wrkRc = ubound(wrkRs, 2)
		else
			wrkRc = -1
		end if
		rsClose()
		
		dim isuIdx, clrIdx
		
		for wrkLoop = 0 to wrkRc
		
			response.write	"<tr>"
			response.write	"	<th rowspan=""2"">" & wrkRs(1, wrkLoop) & "</th>"
			
			for rnkLoop = 0 to rnkRc
				
				response.write	"	<th>" & rnkRs(1, rnkLoop) & "</th>"
				
			next
			
			response.write	"</tr>"
			response.write	"<tr>"
			
			for rnkLoop = 0 to rnkRc
			
				response.write	"	<td class=""aC"">"
				
				isuIdx	= fnIsNull(fnDBVal("TBL_WORK", "WRK_IDX", "CD_WORK = " & wrkRs(0, wrkLoop) & " and CD_RANK = " & rnkRs(0, rnkLoop) & " and WRK_TYP = 'I'"), 0)
				if isuIdx > 0 then
					response.write	"<button class=""btn_sm bg_red"" onclick=""fnForm('I', " & wrkRs(0, wrkLoop) & ", " & rnkRs(0, rnkLoop) & ", " & isuIdx & ")"">발령관리</button> "
				else
					response.write	"<button class=""btn_sm bg_lgray"" onclick=""fnForm('C', " & wrkRs(0, wrkLoop) & ", " & rnkRs(0, rnkLoop) & ", 0)"">발령생성</button> "
				end if
				
				clrIdx	= fnIsNull(fnDBVal("TBL_WORK", "WRK_IDX", "CD_WORK = " & wrkRs(0, wrkLoop) & " and CD_RANK = " & rnkRs(0, rnkLoop) & " and WRK_TYP = 'C'"), 0)
				if clrIdx > 0 then
					response.write	" <button class=""btn_sm bg_blue"" onclick=""fnForm('I', " & wrkRs(0, wrkLoop) & ", " & rnkRs(0, rnkLoop) & ", " & clrIdx & ")"">해제관리</button>"
				else
					response.write	" <button class=""btn_sm bg_lgray"" onclick=""fnForm('C', " & wrkRs(0, wrkLoop) & ", " & rnkRs(0, rnkLoop) & ", 0)"">해제생성</button> "
				end if
				
				response.write	"</td>"
				
			next
			
			response.write	"</tr>"
			
		next
		%>
	</table>
	
</div>

<!--#include virtual="/common/footer_adm.asp"-->

<script type="text/javascript">
	
	function fnForm(typ, wrk, rnk, idx){
		layerW = 1200;
		layerH = 800;
		var url = 'pop_wwsForm.asp?wrkTyp='+typ+'&cdWork='+wrk+'&cdRank='+rnk+'&wrkIdx='+idx;
		var strType	= '발령';
		if(typ == 'C')	strType = '해제';
		var strProc = '관리';
		if(idx == 0)	strProc = '생성';
		fnOpenLayer(strType+strProc, url);
	}
	
</script>