<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<%
dim no : no = fnReq("no")

dim strTit

select case no
	case 1 : strTit = "메뉴얼 다운로드"
	case 2 : strTit = "팩스 드라이버"
	case 3 : strTit = "팩스 알리미"
end select
%>

<style>
	a {text-decoration:none;}
	#dnList {border:5px solid #cccccc;padding:10px;text-align:center;}
	#dnList ul {margin:0;padding:0;list-style-type:none;}
	#dnList ul li {margin:20px 0;}
</style>

<div id="popBox">
	
	<div id="dnList">
		<ul>
		
			<% if no = 1 then %>
				
				<li><a href="/data/일제동보전체매뉴얼.ppt" target="popProcFrame" class="bld"><img src="<%=pth_pubImg%>/icons/disk.png" /> 일제동보 전체매뉴얼</a></li>
				<li><a href="/data/일제동보요약매뉴얼.ppt" target="popProcFrame" class="bld"><img src="<%=pth_pubImg%>/icons/disk.png" /> 일제동보 요약매뉴얼</a></li>
				<!--<li><a href="/data/통합비상동보시스템개요.hwp" target="popProcFrame" class="bld"><img src="<%=pth_pubImg%>/icons/disk.png" /> 통합 비상동보시스템 개요</a></li>-->
				
				
			<% elseif no = 2 then %>
				
				<!--<li><a href="/data/PrinterDriverSetupXP.zip" target="popProcFrame" class="bld"><img src="<%=pth_pubImg%>/icons/disk.png" /> Windows XP 팩스드라이버</a></li>-->
				<li><a href="/data/PrinterDriverSetup32k.zip" target="popProcFrame" class="bld"><img src="<%=pth_pubImg%>/icons/disk.png" /> <!--Windows 7 -->팩스드라이버 & 알리미 32비트</a></li>
				<!--<li><a href="/data/PrinterDriverSetup64k.zip" target="popProcFrame" class="bld"><img src="<%=pth_pubImg%>/icons/disk.png" /> --><!--Windows 7 --><!--팩스드라이버 64비트</a></li>-->
				<li><a href="/data/faxArimiSetup.zip" target="popProcFrame" class="bld"><img src="<%=pth_pubImg%>/icons/disk.png" /> <!--Windows 7 -->팩스알리미 32비트/64비트 공용</a></li>

				<li><a href="/data/20140422150906_1.exe" target="popProcFrame" class="bld"><img src="<%=pth_pubImg%>/icons/disk.png" /> <!--Windows 7 -->XP용 setup 실행시 "응용프로그램을 제대로 초기화~" <br> 메시지 발생시 닷넷프레임워크3.5 설치</a></li>
			<% elseif no = 3 then %>
				
				
				
			<% end if %>
			
		</ul>
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->