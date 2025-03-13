<!--#include virtual="/common/common.asp"-->

<%
mnCD = "1005"
%>

<!--#include virtual="/common/header_adm.asp"-->

<%
dim cdUpCode	: cdUpCode	= fnIsNull(fnReq("cdUpCode"),0)
%>

<div id="subPageBox">
	
	<form name="frm" method="post" action="" target="" onsubmit="return false;">
		<input type="hidden" name="proc" value="" />
		<input type="hidden" name="cdUpCode" value="<%=cdUpCode%>" />
		
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="400px" />
				<col width="10px" />
				<col width="*" />
			</colgroup>
			<tr>
				<td valign="top">
					
					<table border="0" cellpadding="0" cellspacing="1" class="tblList">
						<colgroup>
							<col width="*" />
							<col width="80px" />
						</colgroup>
						<tr>
							<th>코드명</th>
							<th>선택</th>
						</tr>
						<%
						sql = " select CD_CODE, CD_NM "
						sql = sql & " 	, (select count(*) from TBL_CODE with(nolock) where USEYN = 'Y' and CD_UPCODE = cd.CD_CODE) as CNT "
						sql = sql & " from TBL_CODE as cd with(nolock) where USEYN = 'Y' and CD_CODE in (5001,5002) "
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
						
						for i = 0 to arrRc2
							response.write	"<tr>"
							if cstr(arrRs(0,i)) = cstr(cdUpCode) then
								response.write	"	<td class=""bld colBlue"" style=""background:#eee;"">" & arrRs(1,i) & "(" & arrRs(2,i) & ")</td>"
								response.write	"	<td class=""aC"" style=""background:#eee;"">-</td>"
							else
								response.write	"	<td>" & arrRs(1,i) & "(" & arrRs(2,i) & ")</td>"
								response.write	"	<td class=""aC""><a href=""javascript:fnSelUpCode(" & arrRs(0,i) & ")""><img src=""" & pth_pubImg & "/btn/blue_sel2.png"" /></a></td>"
							end if
							response.write	"</tr>"
						next
						%>
					</table>
					
				</td>
				<td></td>
				<td>
					
					<div style="height:500px;overflow-y:scroll;overflow-x:hidden;">
						
						<% if cdUpCode > 0 then %>
							
							<table border="0" cellpadding="0" cellspacing="1" class="tblList">
								<colgroup>
									<col width="*" />
									<col width="80px" />
								</colgroup>
								<tr>
									<th>코드명</th>
									<th>관리</th>
								</tr>
								<tr>
									<td><input type="text" name="addCodeNm" /></td>
									<td class="aC"><a href="javascript:fnCodeReg()"><img src="<%=pth_pubImg%>/btn/blue_reg2.png" /></a></td>
								</tr>
								<%
								sql = " select CD_CODE, CD_NM "
								sql = sql & " from TBL_CODE as cd with(nolock) "
								sql = sql & " where USEYN = 'Y' and CD_UPCODE = " & cdUpCode & " "
								sql = sql & " order by CD_SORT "
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
								
								for i = 0 to arrRc2
									response.write	"<tr>"
									response.write	"	<td>" & arrRs(1,i) & "</td>"
									response.write	"	<td class=""aC"">"
									response.write	"<a href=""javascript:fnCodeDel(" & arrRs(0,i) & ")""><img src=""" & pth_pubImg & "/btn/red_del2.png"" /></a>"
									response.write	"</td>"
									response.write	"</tr>"
								next
								%>
							</table>
							
						<% end if %>
							
					</div>
					
				</td>
			</tr>
		</table>
			
	</form>
	
</div>

<!--#include virtual="/common/footer_adm.asp"-->

<script>

	$(function(){
		
	});
	
	function fnSelUpCode(cd){
		document.frm.cdUpCode.value = cd;
		document.frm.submit();
	}
	
	function fnCodeReg(){
		if(document.frm.addCodeNm.value == ''){
			alert('등록할 코드명을 입력하세요.');document.frm.addCodeNm.focus();return false;
		}else{
			if(confirm('코드를 등록하시겠습니까?')){
				var param = 'proc=add&upcode=<%=cdUpCode%>&nm='+document.frm.addCodeNm.value;
				param = encodeURI(param);
				procFrame.location.href = 'codeProc.asp?'+param;
			}
		}
	}
	
	function fnCodeDel(cd){
		if(confirm('해당코드를 삭세하시겠습니까?')){
			var param = 'proc=del&upcode=<%=cdUpCode%>&code='+cd
			param = encodeURI(param);
			procFrame.location.href = 'codeProc.asp?'+param;
		}
	}
	
</script>