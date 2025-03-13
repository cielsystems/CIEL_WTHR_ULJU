<!--#include virtual="/common/common.asp"-->

<%
dim gb : gb = fnReq("gb")
dim bdIdx : bdIdx = fnIsNull(fnReq("bdIdx"),0)

dim cdBoardGB, cdBoaerdGBNM
cdBoardGB = 4000 + cInt(gb)

dim adIdx, bdTit, bdCont, bdFile01, bdFile02, bdFile03, bdVisit, regDT

sql = " select AD_IDX, BD_TIT, BD_CONT, BD_FILE01, BD_FILE02, BD_FILE03, BD_VISIT, REGDT "
sql = sql & " from TBL_BOARD with(nolock) where BD_IDX = " & bdIdx & " "
dim bdInfo : bdInfo = execSqlArrVal(sql)
adIdx = bdInfo(0)
bdTit = bdInfo(1)
bdCont = bdInfo(2)
bdFile01 = bdInfo(3)
bdFile02 = bdInfo(4)
bdFile03 = bdInfo(5)
bdVisit = bdInfo(6)
regDT = bdInfo(7)

sql = " update TBL_BOARD set BD_VISIT = BD_VISIT + 1 where BD_IDX = " & bdIdx & " "
call execSql(sql)

dim adID : adID = fnDBVal("TBL_ADDR", "AD_ID", "AD_IDX = " & adIdx & "") 

cdBoaerdGBNM = fnDBVal("TBL_CODE", "CD_NM", "CD_CODE = " & cdBoardGB & "")

dim arrFile : arrFile = split(bdFile01,"]|[")
%>

<!--#include virtual="/common/header_pop.asp"-->

<div id="popBody">
	
	<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
		<colgroup>
			<col width="15%" />
			<col width="*" />
			<col width="15%" />
			<col width="35%" />
		</colgroup>
		<tr>
			<th>구분</th>
			<td colspan="3"><%=cdBoaerdGBNM%></td>
		</tr>
		<tr>
			<th>제목</th>
			<td colspan="3"><%=bdTit%></td>
		</tr>
		<tr>
			<th>작성자</th>
			<td><%=adID%></td>
			<th>작성일</th>
			<td><%=regDT%></td>
		</tr>
		<tr>
			<td colspan="4"><div style="width:100%;height:400px;"><%=bdCont%></div></td>
		</tr>
		<tr>
			<th>파일첨부</th>
			<td colspan="3">
				<a href="/data/board/<%=arrFile(1)%>" target="_blank" /><%=arrFile(0)%></a>
			</td>
		</tr>
	</table>
	
	<div class="btnBox">
		<% if clng(adIdx) = clng(ss_userIdx) then %>
			<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_green_mod.png" alt="수정" onclick="fnMod()" />
		<% end if %>
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script type="text/javascript">
	
	function fnMod(){
		location.href = 'pop_form.asp?bdIdx=<%=bdIdx%>';
	}
	
</script>