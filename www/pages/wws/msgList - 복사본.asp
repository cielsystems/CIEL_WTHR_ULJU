<!--#include virtual="/common/common.asp"-->

<%
mnCD = "0501"
%>

<!--#include virtual="/common/header_htm.asp"-->

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
					response.write	"<button class=""btn_sm bg_red"">발령</button> "
				else
					response.write	"<button class=""btn_sm bg_lgray"">없음</button> "
				end if
				
				clrIdx	= fnIsNull(fnDBVal("TBL_WORK", "WRK_IDX", "CD_WORK = " & wrkRs(0, wrkLoop) & " and CD_RANK = " & rnkRs(0, rnkLoop) & " and WRK_TYP = 'C'"), 0)
				if clrIdx > 0 then
					response.write	" <button class=""btn_sm bg_blue"">해제</button>"
				else
					response.write	" <button class=""btn_sm bg_lgray"">없음</button> "
				end if
				
				response.write	"</td>"
				
			next
			
			response.write	"</tr>"
			
		next
		%>
	</table>
	
</div>

<!--#include virtual="/common/footer_htm.asp"-->