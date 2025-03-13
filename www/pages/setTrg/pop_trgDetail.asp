<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<%
dim clGB	: clGB	= fnIsNull(fnReq("clGB"), "")

dim allStfUse	: allStfUse	= "N"
%>

<div id="popBody">
	
	<%
	dim arrTabs : arrTabs = array("전체주소록","분류별주소록","발령그룹","엑셀업로드")
	dim arrTabsUrl	: arrTabsUrl	= array("tree", "code", "callGrup", "xlsup")
	dim tabNo
	%>
	
	<table border="0" cellpadding="0" cellspacing="0" style="width:100%;margin:0 0 5px 0;">
		<tr>
			<td width="50%">
			</td>
			<td class="aR">
				<%
				'#	전직원 추가
				if allStfUse = "Y" then
					response.write	"<img class=""imgBtn"" src=""" & pth_pubImg & "/btn/red_allAdd.png"" onclick=""fnAllStfAdd()"" />"
				end if
				%>
			</td>
		</tr>
	</table>
	
	<div class="tabs">
		<ul class="tabsMenu">
			<%
			for i = 0 to ubound(arrTabs)
				tabNo = i + 1
				response.write	"<li id=""tabsMenu_" & tabNo & """ onclick=""fnTabMenu(" & tabNo & ")"">" & arrTabs(i) & "</li>" & vbCrLf
			next
			%>
			<div class="clr"></div>
		</ul>
		<div class="clr"></div>
		<div class="tabsContBox">
				
			<%
			for i = 0 to ubound(arrTabs)
			
				tabNo = i + 1
				
				response.write	"<div id=""tabs-" & tabNo & """ class=""tabsCont"">"
				
				response.write	"<h3>" & arrTabs(i) & "</h3>"
				
				response.write	"<iframe id=""tabsFrame" & tabNo & """ name=""tabsFrame" & tabNo & """ "
				if i = 0 then
					response.write	"src=""pop_trgDetail_" & arrTabsUrl(i) & ".asp?clGB=" & clGB & "&tabNo=" & tabNo & """ "
				end if
				response.write	"frameborder=""0"" scrolling=""no"" marginwidth=""0"" marginheight=""0"" style=""width:100%;height:540px;""></iframe>"
				
				response.write	"</div>"
			
			next
			%>
			
		</div>
		
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	var nTab = 1;			// 최초 선택된 Tab 번호
	
	var exceptGB = 'N';
	
	$(function(){
		
		fnSelTab();			// 최초 선택텝
		
		$('#exceptGB').click(function(){
			if($(this).prop('checked') == true){
				exceptGB = 'Y';
			}else{
				exceptGB = 'N';
			}
		});
		
	});
	
	function fnTabMenu(no){
		nTab = no;
		fnSelTab();
	}
	
	function fnSelTab(){
		$('.tabs .tabsMenu li').removeClass('on');
		$('.tabs .tabsContBox .tabsCont').css('display','none');
		$('.tabs .tabsMenu #tabsMenu_'+nTab).addClass('on');
		$('.tabs .tabsContBox #tabs-'+nTab).css('display','block');
	}
	
	function fnAllStfAdd(){
		if(confirm('전직원을 대상으로 추가하시겠습니까?')){
			popProcFrame.location.href = 'pop_trgDetail_proc.asp?proc=allStf';
		}
	}		
	
</script>