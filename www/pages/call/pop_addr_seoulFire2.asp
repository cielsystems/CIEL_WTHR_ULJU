<!--#include virtual="/common/common.asp"-->

<%
dim clGB : clGB = fnReq("clGB")
dim nSelGrpCD : nSelGrpCD = fnIsNull(fnReq("nSelGrpCD"),0)
%>

<!--#include virtual="/common/header_pop.asp"-->

<style>
	.adGrpItemBox {height:200px;overflow-x:hidden;overflow-y:scroll;}
	.adGrpItemBox div {line-height:20px;border-bottom:1px solid #cccccc;padding-left:5px;font-size:11px;}
	.adGrpItemBox .on {background:#ff9900;}
	.upCode {background:#dddddd;font-weight:bold;}
</style>

<div id="popBody">
	
	<%
	dim allStfUse : allStfUse = "N"
	'#	타부서 사용권한 처리
	dim cdUsGB : cdUsGB = cint(fnDBVal("TBL_ADDR", "CD_USERGB", "AD_IDX = " & ss_userIdx & ""))
	dim adPerAddr : adPerAddr = fnDBVal("TBL_ADDR", "AD_PERADDR", "AD_IDX = " & ss_userIdx & "")
	if cdUsGB < 1002 or adPerAddr = "A" then
		allStfUse = "Y"
	end if
	
	dim arrTabs : arrTabs = array("직원주소록","부서주소록","나의주소록","유형발령(직원주소록)")',"유형발령(부서별)","유형발령(사용자별)")
	dim tabNo
	
	if allStfUse = "Y" then
		response.write	"<div class=""aR"" style=""margin-bottom:5px;""><img class=""imgBtn"" src=""" & pth_pubImg & "/btn/red_allAdd.png"" onclick=""fnAllStfAdd()"" /></div>"
	end if
	%>
	
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
				
				dim tabsUrl
				if i < 3 then
					tabsUrl = "pop_addr_seoulFire_tree.asp"
				else
					tabsUrl = "pop_addr_seoulFire_typeCall.asp"
				end if
				response.write	"<iframe id=""tabsFrame" & tabNo & """ name=""tabsFrame" & tabNo & """ "
				if i = 0 then
					response.write	"src=""" & tabsUrl & "?tabNo=" & tabNo & """ "
				end if
				response.write	"frameborder=""0"" scrolling=""no"" marginwidth=""0"" marginheight=""0"" style=""width:100%;height:500px;""></iframe>"
				
				response.write	"</div>"
			
			next
			%>
			
		</div>
		
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	var nTab = 1;			// 최초 선택된 Tab 번호
	
	$(function(){
		
		fnSelTab();			// 최초 선택텝
		
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
			popProcFrame.location.href = 'pop_addrProc.asp?proc=allStf';
		}
	}
	
</script>