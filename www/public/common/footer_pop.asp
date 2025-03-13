
</div>

<%
if devYN = "Y" or ss_userIdx = 1 then
	response.write	"<iframe id=""popProcFrame"" name=""popProcFrame"" style=""width:90%;border:2px solid red;""></iframe>" & vbcrlf
else
	response.write	"<iframe id=""popProcFrame"" name=""popProcFrame"" frameborder=""no"" scrollbars=""no"" style=""width:0;height:0;""></iframe>" & vbcrlf
end if
%>

</body>
</html>