<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<style type="text/css">
	input, textarea {display:none;}
</style>

<div id="popBody">
	
		<div class="tabs">
			
			<ul class="tabsMenu">
				<li id="tabsMenu_1" onclick="fnSelTab(1)">비상발령</li>
				<!--<li id="tabsMenu_2" onclick="fnSelTab(2)">기상특보</li>-->
				<div class="clr"></div>
			</ul>
			<div class="clr"></div>
			
			<div class="tabsContBox">
				
				<div id="tabs-1" class="tabsCont">
					
					<table border="0" cellpadding="0" cellspacing="1" class="tblList">
						<colgroup>
							<col width="10%" />
							<col width="30%" />
							<col width="10%" />
							<col width="*" />
							<col width="80px" />
						</colgroup>
						<tr>
							<th colspan="4">메시지정보</th>
							<th>선택</th>
						</tr>
						<%
						sql = " select MSG_IDX, MSG_TIT, MSG_SMS, MSG_VMS "
						sql = sql & " from TBL_MSG with(nolock) "
						sql = sql & " where USEYN = 'Y' and MSG_GB = 'E' "
						sql = sql & " 	and AD_IDX = " & ss_userIndx & " "
						sql = sql & " order by MSG_SORT, MSG_TIT "
						cmdOpen(sql)
						set rs = cmd.execute
						cmdClose()
						if not rs.eof then
							arrRs		= rs.getRows
							arrRc2	= ubound(arrRs, 2)
						else
							arrRc2	= -1
						end if
						rsClose()
						
						for i = 0 to arrRc2
							response.write	"<tr>"
							response.write	"	<th>제목</th><td colspan=""3"">" & arrRs(1, i) & "</td>"
							response.write	"	<td rowspan=""2"" class=""aC""><button class=""btn btn_sm bg_blue"" onclick=""fnMesgSel(" & arrRs(0, i) & ")"">선택</button></td>"
							response.write	"</tr>"
							response.write	"<tr>"
							response.write	"	<th>문자</th><td>" & arrRs(2, i) & "</td>"
							response.write	"	<th>음성</th><td>" & arrRs(3, i) & "</td>"
							response.write	"</tr>"
							response.write	"<tr><th colspan=""5""></th></tr>"
							response.write	"<input type=""text"" name=""msg_tit_" & arrRs(0, i) & """ value=""" & arrRs(1, i) & """ />"
							response.write	"<textarea name=""msg_sms_" & arrRs(0, i) & """>" & arrRs(2, i) & "</textarea>"
							response.write	"<textarea name=""msg_vms_" & arrRs(0, i) & """>" & arrRs(3, i) & "</textarea>"
						next
						%>
					</table>
					
				</div>
				
				<div id="tabs-2" class="tabsCont">
						
					<table border="0" cellpadding="0" cellspacing="1" class="tblList">
					</table>
					
				</div>
				
			</div>
			
		</div>
		
	</form>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	var nTab = 1;
	
	$(function(){
		
		fnSelTab(nTab);
		
	});
	
	function fnSelTab(n){
		nTab = n;
		$('.tabsCont').css('display','none');
		$('#tabs-'+n).css('display','block');
		$('.tabsMenu li').removeClass('on');
		$('#tabsMenu_'+n).addClass('on');
	}
	
	function fnMesgSel(idx){
		var tit = $('input[name=msg_tit_'+idx+']').val();
		var sms = $('textarea[name=msg_sms_'+idx+']').val();
		var vms = $('textarea[name=msg_vms_'+idx+']').val();
		opener.fnGetMesg(tit, sms, vms);
		self.close();
	}
	
</script>