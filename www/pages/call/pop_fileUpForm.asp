<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<%
dim proc : proc = fnReq("proc")
dim idx : idx = fnIsNull(fnReq("idx"),0)
%>

<div id="popBody">
	
	<% call infoBox(proc) %>
	
	<form name="fileFrm" method="post" enctype="multipart/form-data" action="pop_fileUpProc.asp" target="popProcFrame">
		<input type="hidden" name="proc" value="<%=proc%>" />
		<input type="hidden" name="idx" value="<%=idx%>" />
		
		<div style="background:#dddddd;border:1px solid #cccccc;padding:10px;margin:10px 0;text-align:center;">
			<input type="file" name="upFile" />
			<% if proc = "fms" then %>
				페이지 지정 : <input type="text" name="flePG" size="10" />
			<% end if %>
			<img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_upload.png" onclick="fnUpload()" />
		</div>
		
	</form>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	function fnUpload(){
		if(document.fileFrm.upFile.value == ''){
			alert('파일을 첨부해 주세요.');return false;
		}
		document.fileFrm.submit();
	}
	
</script>