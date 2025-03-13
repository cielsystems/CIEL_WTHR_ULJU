<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<style>
	#popBody {margin:0;padding:0;}
</style>

<%
'arrRs = fnDBRs("TMP_CALLTRG","TMP_NO, TMP_IDX, TMP_NM, dbo.ecl_DECRPART(TMP_NUM1,4)","AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
arrRs = fnDBRs("TMP_CALLTRG","TMP_NO, TMP_IDX, TMP_NM, dbo.ufn_prntNumb(TMP_NUM1)","AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "'")
%>

<div id="trgListBox" style="background:#eee;color:#333;">
	<dl id="trgList">
		<%
		if isarray(arrRs) then
			arrRc2 = ubound(arrRs,2)
			for i = 0 to arrRc2
				response.write	"<dt>" & fnCutStr(arrRs(2,i),5) &"&nbsp;</dt><dd class=""num"">" & arrRs(3,i) & "</dd>"
				response.write	"<dd class=""btnIcon""><img class=""imgBtn"" onclick=""fnSelNumDel('" & arrRs(0,i) & "', '" & arrRs(3,i) & "')"" src=""" & pth_pubImg & "/icons/cross.png"" /></dd>"
			next
		else
			arrRc2 = -1
		end if
		%>
	</dl>
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	$(function(){
		
		top.document.frm.tmpTrg.value = <%=arrRc2+1%>;
		top.document.getElementById('trgCnt').innerHTML = '<%=arrRc2+1%>';
		top.fnLoadingE();
		
	});
	
	function fnSelNumDel(no, num){
		top.fnSelNumDel(no, num);
	}
	
</script>