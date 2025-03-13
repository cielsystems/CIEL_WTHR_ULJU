<!--#include virtual="/common/common.asp"-->

<%
dim wrkIdx	: wrkIdx	= fnIsNull(fnReq("wrkIdx"),0)

dim schKey	: schKey	= fnReq("schKey")
dim schVal	: schVal	= fnReq("schVal")

if len(schVal) > 1 then
	
	sql = " select "
	sql = sql & " 	ad.AD_IDX, dbo.ufn_getGrpFullName(ad.GRP_CODE) as GRPFULLNM, ad.AD_NM, ad.AD_NUM1 "
	sql = sql & " 	, (case when wrkt.WRK_IDX is null then 'N' else 'Y' end) as YN "
	sql = sql & " from viw_addrList as ad "
	sql = sql & " 	left join TBL_WORK_TRG as wrkt on (ad.AD_IDX = wrkt.AD_IDX) "
	sql = sql & " where ad.USEYN = 'Y' and ad.CD_USERGB > 1000 "
	sql = sql & " 	and ad.AD_GB = 'U' "
	sql = sql & " 	and ad.AD_" & schKey & " like '%" & schVal & "%' "
	sql = sql & " order by ad.GRPSORT1, ad.GRPSORT2, ad.GRPSORT3, ad.GRPSORT4, ad.GRPSORT5, ad.AD_SORT, ad.AD_NM "
	
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
	
end if
%>

<!--#include virtual="/common/header_pop.asp"-->

<div id="popBody">
	
	<form name="frm" method="post" action="" target="">
		
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="15%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>검색</th>
				<td>
					<select name="schKey">
						<option value="NM" <% if schKey = "NM" then %>selected<% end if %>>이름</option>
						<option value="NUM1" <% if schKey = "NUM1" then %>selected<% end if %>>휴대폰</option>
					</select>
					<input type="text" name="schVal" value="<%=schVal%>" onkeypress="if(event.keyCode==13){fnSearch()}" />
					<img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" title="검색" onclick="fnSearch()" />
					<span class="color_red">
						* 사용자만 검색됩니다.
					</span>
				</td>
			</tr>
		</table>
		
	</form>
	
	<table border="0" cellpadding="0" cellspacing="1" class="tblList">
		<colgroup>
			<col width="*" />
			<col width="100px" />
			<col width="120px" />
			<col width="40px" />
		</colgroup>
		<tr>
			<th>부서</th>
			<th>이름</th>
			<th>휴대폰</th>
			<th></th>
		</tr>
		<%
		dim strClass
		
		if arrRc2 > -1 then
			
			for i = 0 to arrRc2
				
				if arrRs(4, i) = "Y" then
					strClass	= "colGray"
				else
					strClass	= ""
				end if
				
				response.write	"<tr id=""addr_" & arrRs(0, i) & """>"
				response.write	"	<input type=""hidden"" name=""ad_nm"" value=""" & arrRs(2, i) & """ />"
				response.write	"	<input type=""hidden"" name=""ad_num1"" value=""" & arrRs(3, i) & """ />"
				response.write	"	<td class=""" & strClass & """>" & arrRs(1, i) & "</td>"
				response.write	"	<td class=""aC " & strClass & """>" & arrRs(2, i) & "</td>"
				response.write	"	<td class=""aC " & strClass & """>" & arrRs(3, i) & "</td>"
				
				response.write	"	<td class=""aC"">"
				response.write	"		<img class=""trgDelBtn imgBtn"" src=""" & pth_pubImg & "/icons/minus.png"" onclick=""fnTrgSet('D', " & arrRs(0, i) & ")"""
				if arrRs(4, i) = "N" then
					response.write	" style=""display:none;"""
				end if
				response.write	" />"
				response.write	"		<img class=""trgAddBtn imgBtn"" src=""" & pth_pubImg & "/icons/plus.png"" onclick=""fnTrgSet('A', " & arrRs(0, i) & ")"""
				if arrRs(4, i) = "Y" then
					response.write	" style=""display:none;"""
				end if
				response.write	" />"
				response.write	"	</td>"
				
				response.write	"</tr>"
				
			next
			
		else
			
			response.write	"<tr><td colspan=""4"" class=""aC"">검색결과가 없습니다.</td></tr>"
			
		end if
		%>
	</table>
	
	<div class="aR mgT05">
		<button class="btn btn_sm bg_gray" onclick="window.self.close()">닫기</button>
	</div>
		
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	$(function(){
		
	});
	
	function fnSearch(){
		if($('input[name=schVal]').val().length < 2){
			alert('검색어는 2자이상 입력해 주세요.');$('input[name=schVal]').focus();return false;
		}else{
			document.frm.submit();
		}
	}
	
	function fnTrgSet(proc, idx){
		var nm = $('#addr_'+idx+' > input[name=ad_nm]').val();
		var num = $('#addr_'+idx+' > input[name=ad_num1]').val();
		opener.fnPrevSet(proc, idx, nm, num);
		if(proc == 'D'){
			$('#addr_'+idx+' > td').removeClass('colGray');
			$('#addr_'+idx+' > td > .trgDelBtn').css('display','none');
			$('#addr_'+idx+' > td > .trgAddBtn').css('display','block');
		}else{
			$('#addr_'+idx+' > td').addClass('colGray');
			$('#addr_'+idx+' > td > .trgAddBtn').css('display','none');
			$('#addr_'+idx+' > td > .trgDelBtn').css('display','block');
		}
	}
	
</script>