						
						<!--</div>-->
					</div>
				</td>
			</tr>
		</table>
		
	</div>
	
	<div id="areaBtm">
		<%=siteTitle%>
	</div>
	
</div>

<%
if devYN = "Y" or ss_userIdx < 3 then
	response.write	"<iframe id=""procFrame"" name=""procFrame"" style=""width:90%;border:2px solid red;""></iframe>" & vbcrlf
else
	response.write	"<iframe id=""procFrame"" name=""procFrame"" frameborder=""no"" scrollbars=""no"" style=""width:0;height:0;""></iframe>" & vbcrlf
end if
%>

</body>
</html>