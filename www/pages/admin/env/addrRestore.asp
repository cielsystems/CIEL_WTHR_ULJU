<!--#include virtual="/common/common.asp"-->

<%
mnCD = "1004"
%>

<!--#include virtual="/common/header_adm.asp"-->

<%
dim schSDate : schSDate = fnIsNull(fnReq("schSDate"),dateserial(year(date),month(date),1))
dim schEDate : schEDate = fnIsNull(fnReq("schEDate"),dateadd("d",7,date))

sql = " select ADB_IDX, ADB_DT, dbo.ufn_getAddrID(US_IDX), US_IP "
sql = sql & " 	, (select top 1 dbo.ufn_getGrpFullName(GRP_CODE) from TBL_ADDR_BACKUPGRP where ADB_IDX = TBL_ADDR_BACKUP.ADB_IDX) as GRPNM "
sql = sql & " 	, (select count(*) from TBL_ADDR_BACKUPITEM where ADB_IDX = TBL_ADDR_BACKUP.ADB_IDX and GRP_CODE = (select top 1 GRP_CODE from TBL_ADDR_BACKUPGRP where ADB_IDX = TBL_ADDR_BACKUP.ADB_IDX)) as GRPADDRCNT "
sql = sql & " 	, (select count(*) from TBL_ADDR_BACKUPGRP where ADB_IDX = TBL_ADDR_BACKUP.ADB_IDX) as GRPCNT "
sql = sql & " 	, (select count(*) from TBL_ADDR_BACKUPITEM where ADB_IDX = TBL_ADDR_BACKUP.ADB_IDX) as ADCNT "
sql = sql & " 	, (select top 1 REGDT from TBL_ADDR_BACKUPHIST where ADB_IDX = TBL_ADDR_BACKUP.ADB_IDX order BY REGDT desc) as RESTOREDT "
sql = sql & " 	, (select count(*) from TBL_ADDR_BACKUPHIST where ADB_IDX = TBL_ADDR_BACKUP.ADB_IDX) as RESTORECNT "
sql = sql & " from TBL_ADDR_BACKUP "
sql = sql & " where ADB_DT between '" & schSDate & " 00:00:00' and '" & schEDate & " 23:59:59' "
sql = sql & " order by ADB_DT desc "
'response.write	sql
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
if not rs.eof then
	arrRs = rs.getRows
	arrRc2 = ubound(arrRs,2)
else
	arrRc2 = -1
end if
rsClose()
%>

<div id="subPageBox">
	
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<form name="frm" method="post" action="" target="">
						
						<table align="left">
							<tr>
								<td><label>기간</label></td>
								<td colspan="7">
									<input type="text" id="schSDate" name="schSDate" value="<%=schSDate%>" size="10" readonly />
									<img class="calBtn" src="<%=pth_pubImg%>/icons/calendar-select.png" title="달력" /> ~
									<input type="text" id="schEDate" name="schEDate" value="<%=schEDate%>" size="10" readonly />
									<img class="calBtn" src="<%=pth_pubImg%>/icons/calendar-select.png" title="달력" />
								</td>
								<td><img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" title="검색" onclick="fnSch()" /></td>
							</tr>
						</table>
						
					</form>
						
				</td>
				<td class="aR">
					총 <b><span id="cntAll"><%=arrRc2+1%></span></b>건
				</td>
			</tr>
		</table>
	</div>
	
	<table border="0" cellpadding="0" cellspacing="1" class="tblList">
		<colgroup>
			<col width="120px" />
			<col width="100px" />
			<col width="100px" />
			<col width="*" />
			<col width="140px" />
			<col width="60px" />
		</colgroup>
		<tr>
			<th>일시</th>
			<th>아이디</th>
			<th>IP</th>
			<th>연락처수</th>
			<th>최종복원</th>
			<th>복원</th>
		</tr>
		<%
		if arrRc2 > -1 then
			for i = 0 to arrRc2
				response.write	"<tr>"
				response.write	"	<td class=""aC"">" & fnDateToStr(arrRs(1,i),"yyyy.mm.dd hh:nn") & "</td>"
				response.write	"	<td class=""aC"">" & arrRs(2,i) & "</td>"
				response.write	"	<td class=""aC"">" & arrRs(3,i) & "</td>"
				response.write	"	<td class=""aL""><b>[" & arrRs(4,i) & "] " & arrRs(5,i) & "명</b> 외 <b>" & arrRs(6,i) & "</b>개 그룹 총 <b>" & arrRs(7,i) & "</b>명</td>"
				response.write	"	<td class=""aC"">" & fnDateToStr(arrRs(8,i),"yyyy.mm.dd hh:nn") & "(" & arrRs(9,i) & ")</td>"
				response.write	"	<td class=""aC""><button onclick=""fnRestore(" & arrRs(0,i) & ")"">복원</button></td>"
				response.write	"</tr>"
			next
		else
			response.write	"<tr><td colspan=""6"" class=""aC"">Nothing</td></tr>"
		end if
		%>
	</table>
	
</div>

<!--#include virtual="/common/footer_adm.asp"-->

<script>
	
	function fnSch(){
		document.frm.submit();
	}
	
	function fnRestore(idx){
		if(confirm('현재 연락처를 삭제하고 해당 데이터를 복원하시겠습니까?')){
			procFrame.location.href = 'addrRestoreProc.asp?idx='+idx;
		}
	}
	
</script>