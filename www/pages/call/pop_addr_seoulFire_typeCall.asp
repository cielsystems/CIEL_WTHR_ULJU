<!--#include virtual="/common/common.asp"-->

<%
dim tabNo	: tabNo	= fnReq("tabNo")

dim gb, topGrpCD

select case tabNo
	case "4"	: gb = "D" : topGrpCD = 1
	case "5"	: gb = "E" : topGrpCD = 2
	case "6"	: gb = "P" : topGrpCD = 5
end select

dim cdUsGB : cdUsGB = cint(fnDBVal("TBL_ADDR", "CD_USERGB", "AD_IDX = " & ss_userIdx & ""))
dim adPerAddr : adPerAddr = fnDBVal("TBL_ADDR", "AD_PERADDR", "AD_IDX = " & ss_userIdx & "")

dim sqlProc
if gb = "D" then
	if cdUsGB < 1002 or adPerAddr = "A" then
		sqlProc = "usp_listGrp"
	else
		sqlProc = "usp_listGrpPermit"
	end if
elseif gb = "E" then
	sqlProc = "usp_listGrpEmr"
else
	sqlProc = "usp_listGrp"
end if
	
'response.write	sqlProc & " " & gb & "," & gbUpCode & "," & ss_userIdx

dim grpRs1, grpRc1, grpRs2, grpRc2, grpRs3, grpRc3
dim grpRs4, grpRc4, grpRs5, grpRc5, iiii, iiiii
%>

<!--#include virtual="/common/header_pop.asp"-->

<style>
	.adGrpItemBox {height:200px;overflow-x:hidden;overflow-y:scroll;}
	.adGrpItemBox div {line-height:20px;border-bottom:1px solid #cccccc;padding-left:5px;font-size:11px;}
	.adGrpItemBox .on {background:#ff9900;}
	.upCode {background:#dddddd;font-weight:bold;}
</style>

<form name="callUserGrpFrm" method="post" action="pop_addrProc_callUserGrp.asp" target="popProcFrame2">
	<input type="hidden" name="proc" value="" />
	<input type="hidden" name="gb" value="<%=gb%>" />
	
	<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
		<colgroup>
			<col width="*" />
			<col width="160px" />
			<col width="160px" />
			<col width="160px" />
			<col width="160px" />
			<col width="140px" />
			<col width="140px" />
			<col width="80px" />
		</colgroup>
		<tr>
			<th colspan="5">부서(그룹)</th>
			<% if gb = "D" then %>
				<th>직급</th>
				<th>직위</th>
				<th>순위</th>
			<% else %>
				<th>부서(그룹)4</th>
				<th>부서(그룹)5</th>
				<th>부서(그룹)6</th>
			<% end if %>
		</tr>
		<tr>
			<td style="padding:0px;">
				<div class="adGrpItemBox">
<%
''#	1Depth Start	==============================================================
grpRs1 = execProcRs(sqlProc, array(gb, topGrpCD, ss_userIdx))
if isarray(grpRs1) then
	grpRc1 = ubound(grpRs1,2)
else
	grpRc1 = -1
end if
for i = 0 to grpRc1
	response.write	"<div id=""grpCode1_" & grpRs1(0,i) & """>"
	response.write	"<input type=""checkbox"" name=""grpCode1"" value=""" & grpRs1(0,i) & """ "
	response.write	"onclick=""fnSelCallGrp(1," & grpRs1(0,i) & ",0,0,0,0,this)"" />"
	response.write	" " & grpRs1(2,i) & "</div>"
next
%>
				</div>
			</td>
			<td style="padding:0px;">
				<div class="adGrpItemBox">
<%
'#	2Depth Start	==============================================================
for i = 0 to grpRc1
	grpRs2 = execProcRs(sqlProc, array(gb, grpRs1(0,i), ss_userIdx))
	if isarray(grpRs2) then
		grpRc2 = ubound(grpRs2,2)
	else
		grpRc2 = -1
	end if
	if grpRc2 > -1 then
		response.write	"<div class=""upCode"">" & grpRs1(2,i) & "</div>"
		for ii = 0 to grpRc2
			response.write	"<div id=""grpCode2_" & grpRs1(0,i) & "_" & grpRs2(0,ii) & """>"
			response.write	"<input type=""checkbox"" name=""grpCode2"" value=""" & grpRs2(0,ii) & """ "
			response.write	"onclick=""fnSelCallGrp(2," & grpRs1(0,i) & "," & grpRs2(0,ii) & ",0,0,0,this)"" />"
			response.write	" " & grpRs2(2,ii) & "</div>"
		next
	end if
next
%>
				</div>
			</td>
			<td style="padding:0px;">
				<div class="adGrpItemBox">
<%
'#	3Depth Start	==============================================================
for i = 0 to grpRc1
	grpRs2 = execProcRs(sqlProc, array(gb, grpRs1(0,i), ss_userIdx))
	if isarray(grpRs2) then
		grpRc2 = ubound(grpRs2,2)
	else
		grpRc2 = -1
	end if
	for ii = 0 to grpRc2
		grpRs3 = execProcRs(sqlProc, array(gb, grpRs2(0,ii), ss_userIdx))
		if isarray(grpRs3) then
			grpRc3 = ubound(grpRs3,2)
		else
			grpRc3 = -1
		end if
		if grpRc3 > -1 then
			response.write	"<div class=""upCode"">" & grpRs1(2,i) & " > " & grpRs2(2,ii) & "</div>"
			for iii = 0 to grpRc3
				response.write	"<div id=""grpCode3_" & grpRs1(0,i) & "_" & grpRs2(0,ii) & "_" & grpRs3(0,iii) & """>"
				response.write	"<input type=""checkbox"" name=""grpCode3"" value=""" & grpRs3(0,iii) & """ "
				response.write	"onclick=""fnSelCallGrp(3," & grpRs1(0,i) & "," & grpRs2(0,ii) & "," & grpRs3(0,iii) & ",0,0,this)"" />"
				response.write	" " & grpRs3(2,iii) & "</div>"
			next
		end if
	next
next
%>
				</div>
			</td>  
			<td style="padding:0px;">
				<div class="adGrpItemBox">
<%
'#	4Depth Start	==============================================================
for i = 0 to grpRc1
	grpRs2 = execProcRs(sqlProc, array(gb, grpRs1(0,i), ss_userIdx))
	if isarray(grpRs2) then
		grpRc2 = ubound(grpRs2,2)
	else
		grpRc2 = -1
	end if
	for ii = 0 to grpRc2
		grpRs3 = execProcRs(sqlProc, array(gb, grpRs2(0,ii), ss_userIdx))
		if isarray(grpRs3) then
			grpRc3 = ubound(grpRs3,2)
		else
			grpRc3 = -1
		end if
		for iii = 0 to grpRc3
			grpRs4 = execProcRs(sqlProc, array(gb, grpRs3(0,iii), ss_userIdx))
			if isarray(grpRs4) then
				grpRc4 = ubound(grpRs4,2)
			else
				grpRc4 = -1
			end if
			if grpRc4 > -1 then
				response.write	"<div class=""upCode"">" & grpRs1(2,i) & " > " & grpRs2(2,ii) & " > " & grpRs3(2,iii) & "</div>"
				for iiii = 0 to grpRc4
					response.write	"<div id=""grpCode4_" & grpRs1(0,i) & "_" & grpRs2(0,ii) & "_" & grpRs3(0,iii) & "_" & grpRs4(0,iiii) & """>"
					response.write	"<input type=""checkbox"" name=""grpCode4"" value=""" & grpRs4(0,iiii) & """ "
					response.write	"onclick=""fnSelCallGrp(4," & grpRs1(0,i) & "," & grpRs2(0,ii) & "," & grpRs3(0,iii) & "," & grpRs4(0,iiii) & ",0,this)"" />"
					response.write	" " & grpRs4(2,iiii) & "</div>"
				next
			end if
		next
	next
next
%>
				</div>
			</td>  
			<td style="padding:0px;">
				<div class="adGrpItemBox">
<%
'#	5Depth Start	==============================================================
for i = 0 to grpRc1
	grpRs2 = execProcRs(sqlProc, array(gb, grpRs1(0,i), ss_userIdx))
	if isarray(grpRs2) then
		grpRc2 = ubound(grpRs2,2)
	else
		grpRc2 = -1
	end if
	for ii = 0 to grpRc2
		grpRs3 = execProcRs(sqlProc, array(gb, grpRs2(0,ii), ss_userIdx))
		if isarray(grpRs3) then
			grpRc3 = ubound(grpRs3,2)
		else
			grpRc3 = -1
		end if
		for iii = 0 to grpRc3
			grpRs4 = execProcRs(sqlProc, array(gb, grpRs3(0,iii), ss_userIdx))
			if isarray(grpRs4) then
				grpRc4 = ubound(grpRs4,2)
			else
				grpRc4 = -1
			end if
			for iiii = 0 to grpRc4
				grpRs5 = execProcRs(sqlProc, array(gb, grpRs4(0,iiii), ss_userIdx))
				if isarray(grpRs5) then
					grpRc5 = ubound(grpRs5,2)
				else
					grpRc5 = -1
				end if
				if grpRc5 > -1 then
					response.write	"<div class=""upCode"">" & grpRs1(2,i) & " > " & grpRs2(2,ii) & " > " & grpRs3(2,iii) & " > " & grpRs4(2,iiii) & "</div>"
					for iiiii = 0 to grpRc5
						response.write	"<div id=""grpCode5_" & grpRs1(0,i) & "_" & grpRs2(0,ii) & "_" & grpRs3(0,iii) & "_" & grpRs4(0,iiii) & "_" & grpRs5(0,iiiii) & """>"
						response.write	"<input type=""checkbox"" name=""grpCode5"" value=""" & grpRs5(0,iiiii) & """ "
						response.write	"onclick=""fnSelCallGrp(5," & grpRs1(0,i) & "," & grpRs2(0,ii) & "," & grpRs3(0,iii) & "," & grpRs4(0,iiii) & "," & grpRs5(0,iiiii) & ",this)"" />"
						response.write	" " & grpRs5(2,iiiii) & "</div>"
					next
				end if
			next
		next
	next
next
%>
				</div>
			</td>  
<%
for i = 1 to 3
	%>
	<td style="padding:0;">
		<div class="adGrpItemBox">
			<%
			if tabNo = 4 then
				sql = " select CD_CODE, CD_NM from TBL_CODE with(nolock) where USEYN = 'Y' and CD_UPCODE = 500" & i & " order by CD_SORT "
				arrRs = execSqlRs(sql)
				if isarray(arrRs) then
					arrRc2 = ubound(arrRs,2)
				else
					arrRc2 = -1
				end if
				for ii = 0 to arrRc2
					if arrRs(0,ii) <> "500309" then
						response.write	"<div id=""adGrp0" & i & "_" & arrRs(0,ii) & """>"
						response.write	"<input type=""checkbox"" name=""adGrp0" & i & """ value=""" & arrRs(0,ii) & """ onclick=""fnSelCallUserGrp(" & i & "," & arrRs(0,ii) & ",this)"" /> " & arrRs(1,ii) & "</div>"
					end if
				next
			elseif tabNo = 5 then
				sql = " select distinct AD_ETC" & 2+i & " from TBL_ADDR with(nolock) "
				sql = sql & " where USEYN = 'Y' and len(AD_ETC" & 2+i & ") > 0 "
				sql = sql & " 	and GRP_CODE in ( "
				sql = sql & " 		select GRP_CODE from TBL_GRP with(nolock) where USEYN = 'Y' and GRP_GB = 'E' and AD_IDX in ( "
				sql = sql & " 			select AD_IDX from TBL_ADDR with(nolock) where GRP_CODE = ( "
				sql = sql & " 				select GRP_CODE from TBL_ADDR with(nolock) where AD_IDX = " & ss_userIdx & " "
				sql = sql & " 			) "
				sql = sql & " 		) "
				sql = sql & " 	) order by AD_ETC" & 2+i & " "
				arrRs = execSqlRs(sql)
				if isarray(arrRs) then
					arrRc2 = ubound(arrRs,2)
				else
					arrRc2 = -1
				end if
				for ii = 0 to arrRc2
					response.write	"<div id=""adGrp0" & i & "_" & arrRs(0,ii) & """>"
					response.write	"<input type=""checkbox"" name=""adGrp0" & i & """ value=""" & arrRs(0,ii) & """ onclick=""fnSelCallUserGrp(" & i & ",'" & arrRs(0,ii) & "',this)"" /> " & arrRs(0,ii) & "</div>"
				next
			elseif tabNo = 6 then
				sql = " select distinct AD_ETC" & 2+i & " from TBL_ADDR with(nolock) "
				sql = sql & " where USEYN = 'Y' and len(AD_ETC" & 2+i & ") > 0 and GRP_CODE in ( "
				sql = sql & " 	select GRP_CODE from TBL_GRP with(nolock) where USEYN = 'Y' and GRP_GB = 'P' and AD_IDX = " & ss_userIdx & " "
				sql = sql & " ) order by AD_ETC" & 2+i & " "
				arrRs = execSqlRs(sql)
				if isarray(arrRs) then
					arrRc2 = ubound(arrRs,2)
				else
					arrRc2 = -1
				end if
				for ii = 0 to arrRc2
					response.write	"<div id=""adGrp0" & i & "_" & arrRs(0,ii) & """>"
					response.write	"<input type=""checkbox"" name=""adGrp0" & i & """ value=""" & arrRs(0,ii) & """ onclick=""fnSelCallUserGrp(" & i & ",'" & arrRs(0,ii) & "',this)"" /> " & arrRs(0,ii) & "</div>"
				next
			end if				
			%>
		</div>
	</td>
	<%
next
%>
		</tr>
	</table>
	
	<div class="aR" style="margin-top:5px;"><img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" onclick="fnCallUserGrp()" /></div>
	
	<table border="0" cellpadding="0" cellspacing="1" class="tblList" id="callUserGrpList">
		<colgroup>
			<col width="*" />
			<col width="120px" />
			<col width="120px" />
			<col width="120px" />
			<col width="120px" />
			<col width="120px" />
		</colgroup>
		<thead>
			<tr>
				<th>부서(그룹)</th>
				<% if gb = "P" then %>
					<th>부서(그룹)4</th>
					<th>부서(그룹)5</th>
					<th>부서(그룹)6</th>
				<% else %>
					<th>직급</th>
					<th>직위</th>
					<th>순위</th>
				<% end if %>
				<th>이름</th>
				<th>휴대폰번호</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td colspan="6" class="aC">유형 선택 후 검색버튼을 클릭하시면 상위5명의 대상자만 보여줍니다.</td>
			</tr>
		</tbody>
		<tfoot>
		</tfoot>
	</table>
	
	<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
		<tr>
			<td style="text-align:right;" class="fnt13">총 <b id="selTrgCount_callUserGrp" class="selTrgCount colRed">0</b>명 이 검색되었습니다 </td>
			<td style="text-align:right;width:60px;"><img class="imgBtn" src="<%=pth_pubImg%>/btn/blue_add.png" title="추가" onclick="fnAddTrg_callUserGrp()" /></td>
		</tr>
	</table>

</form>

<iframe id="popProcFrame2" name="popProcFrame2" frameborder="no" scrollbars="no" style="width:0;height:0;"></iframe>

<!--#include virtual="/common/footer_pop.asp"-->

<script type="text/javascript">
	
	$(function(){
		<% if tabNo = 4 then %>
			//parent.tabsFrame5.location.href = 'pop_addr_seoulFire_typeCall.asp?tabNo=5';
		<% elseif tabNo = 5 then %>
			//parent.tabsFrame6.location.href = 'pop_addr_seoulFire_typeCall.asp?tabNo=6';
		<% end if %>
	});
	
	function fnSelCallGrp(depth,grpCode1,grpCode2,grpCode3,grpCode4,grpCode5,trg){
		//alert(depth+'/'+grpCode1+'/'+grpCode2+'/'+grpCode3+'/'+grpCode4+'/'+grpCode5+'/'+$(trg).prop('checked'));
		if($(trg).prop('checked') == true){
			if(depth == 1){
				$('#grpCode'+depth+'_'+grpCode1).addClass('on');
				$('div[id^=grpCode2_'+grpCode1+'_]').addClass('on');
				$('div[id^=grpCode2_'+grpCode1+'_]').find('input[name=grpCode2]').prop('checked',true);
				$('div[id^=grpCode3_'+grpCode1+'_]').addClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_]').find('input[name=grpCode3]').prop('checked',true);
				$('div[id^=grpCode4_'+grpCode1+'_]').addClass('on');
				$('div[id^=grpCode4_'+grpCode1+'_]').find('input[name=grpCode4]').prop('checked',true);
				$('div[id^=grpCode5_'+grpCode1+'_]').addClass('on');
				$('div[id^=grpCode5_'+grpCode1+'_]').find('input[name=grpCode5]').prop('checked',true);
			}else if(depth == 2){
				$('#grpCode'+depth+'_'+grpCode1+'_'+grpCode2).addClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_'+grpCode2+'_]').addClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_'+grpCode2+'_]').find('input[name=grpCode3]').prop('checked',true);
				$('div[id^=grpCode4_'+grpCode1+'_'+grpCode2+'_]').addClass('on');
				$('div[id^=grpCode4_'+grpCode1+'_'+grpCode2+'_]').find('input[name=grpCode4]').prop('checked',true);
				$('div[id^=grpCode5_'+grpCode1+'_'+grpCode2+'_]').addClass('on');
				$('div[id^=grpCode5_'+grpCode1+'_'+grpCode2+'_]').find('input[name=grpCode5]').prop('checked',true);
			}else if(depth == 3){
				$('#grpCode'+depth+'_'+grpCode1+'_'+grpCode2+'_'+grpCode3).addClass('on');
				$('div[id^=grpCode4_'+grpCode1+'_'+grpCode2+'_'+grpCode3+'_]').addClass('on');
				$('div[id^=grpCode4_'+grpCode1+'_'+grpCode2+'_'+grpCode3+'_]').find('input[name=grpCode4]').prop('checked',true);
				$('div[id^=grpCode5_'+grpCode1+'_'+grpCode2+'_'+grpCode3+'_]').addClass('on');
				$('div[id^=grpCode5_'+grpCode1+'_'+grpCode2+'_'+grpCode3+'_]').find('input[name=grpCode5]').prop('checked',true);
			}else if(depth == 4){
				$('#grpCode'+depth+'_'+grpCode1+'_'+grpCode2+'_'+grpCode3+'_'+grpCode4).addClass('on');
				$('div[id^=grpCode5_'+grpCode1+'_'+grpCode2+'_'+grpCode4+'_]').addClass('on');
				$('div[id^=grpCode5_'+grpCode1+'_'+grpCode2+'_'+grpCode4+'_]').find('input[name=grpCode5]').prop('checked',true);
			}else if(depth == 5){
				$('#grpCode'+depth+'_'+grpCode1+'_'+grpCode2+'_'+grpCode3+'_'+grpCode4+'_'+grpCode5).addClass('on');
			}
		}else{
			if(depth == 1){
				$('#grpCode'+depth+'_'+grpCode1).removeClass('on');
				$('div[id^=grpCode2_'+grpCode1+'_]').removeClass('on');
				$('div[id^=grpCode2_'+grpCode1+'_]').find('input[name=grpCode2]').prop('checked',false);
				$('div[id^=grpCode3_'+grpCode1+'_]').removeClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_]').find('input[name=grpCode3]').prop('checked',false);
				$('div[id^=grpCode4_'+grpCode1+'_]').removeClass('on');
				$('div[id^=grpCode4_'+grpCode1+'_]').find('input[name=grpCode4]').prop('checked',false);
				$('div[id^=grpCode5_'+grpCode1+'_]').removeClass('on');
				$('div[id^=grpCode5_'+grpCode1+'_]').find('input[name=grpCode5]').prop('checked',false);
			}else if(depth == 2){
				$('#grpCode'+depth+'_'+grpCode1+'_'+grpCode2).removeClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_'+grpCode2+'_]').removeClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_'+grpCode2+'_]').find('input[name=grpCode3]').prop('checked',false);
				$('div[id^=grpCode4_'+grpCode1+'_'+grpCode2+'_]').removeClass('on');
				$('div[id^=grpCode4_'+grpCode1+'_'+grpCode2+'_]').find('input[name=grpCode4]').prop('checked',false);
				$('div[id^=grpCode5_'+grpCode1+'_'+grpCode2+'_]').removeClass('on');
				$('div[id^=grpCode5_'+grpCode1+'_'+grpCode2+'_]').find('input[name=grpCode5]').prop('checked',false);
			}else if(depth == 3){
				$('#grpCode'+depth+'_'+grpCode1+'_'+grpCode2+'_'+grpCode3).removeClass('on');
				$('div[id^=grpCode4_'+grpCode1+'_'+grpCode2+'_'+grpCode3+'_]').removeClass('on');
				$('div[id^=grpCode4_'+grpCode1+'_'+grpCode2+'_'+grpCode3+'_]').find('input[name=grpCode4]').prop('checked',false);
				$('div[id^=grpCode5_'+grpCode1+'_'+grpCode2+'_'+grpCode3+'_]').removeClass('on');
				$('div[id^=grpCode5_'+grpCode1+'_'+grpCode2+'_'+grpCode3+'_]').find('input[name=grpCode5]').prop('checked',false);
			}else if(depth == 4){
				$('#grpCode'+depth+'_'+grpCode1+'_'+grpCode2+'_'+grpCode3+'_'+grpCode4).removeClass('on');
				$('div[id^=grpCode5_'+grpCode1+'_'+grpCode2+'_'+grpCode3+'_'+grpCode4+'_]').removeClass('on');
				$('div[id^=grpCode5_'+grpCode1+'_'+grpCode2+'_'+grpCode3+'_'+grpCode4+'_]').find('input[name=grpCode5]').prop('checked',false);
			}else if(depth == 5){
				$('#grpCode'+depth+'_'+grpCode1+'_'+grpCode2+'_'+grpCode3+'_'+grpCode4+'_'+grpCode5).removeClass('on');
			}
		}
	}
	
	function fnSelCallUserGrp(depth,val,trg){
		if($(trg).prop('checked') == true){
			$('#adGrp0'+depth+'_'+val).addClass('on');
		}else{
			$('#adGrp0'+depth+'_'+val).removeClass('on');
		}
	}
	
	function fnCallUserGrp(){
		var grpCnt1 = 0;
		var grpCnt2 = 0;
		var grpCnt3 = 0;
		var cnt = 0;
		/*
		$('input[name=grpCode1]').each(function(){
			if($(this).prop('checked') == true){
				grpCnt1 = grpCnt1 + 1;
			}
		});
		$('input[name=grpCode2]').each(function(){
			if($(this).prop('checked') == true){
				grpCnt2 = grpCnt2 + 1;
			}
		});
		$('input[name=grpCode3]').each(function(){
			if($(this).prop('checked') == true){
				grpCnt3 = grpCnt3 + 1;
			}
		});
		if(grpCnt1 < 1 && grpCnt2 < 1 && grpCnt3 < 1){
			alert('부서(그룹)을 하나이상 선택 하세요.');return;
		}else{
			document.callUserGrpFrm.proc.value = 'sch';
			document.callUserGrpFrm.submit();
		}
		*/
		$('form[name=callUserGrpFrm] input[type=checkbox]').each(function(){
			if($(this).prop('checked') == true){
				cnt = cnt+1;
			}
		});
		if(cnt < 1){
			alert('검색할 유형을 체크해 주세요.');return;
		}else{
			document.callUserGrpFrm.proc.value = 'sch';
			document.callUserGrpFrm.submit();
		}
	}
	
	function fnSch_callUserGrp(grpFullName, adGrp01, adGrp02, adGrp03, adNM, adNum1, allCnt){
		var strRow = '<tr>'
		+'<td>'+grpFullName+'</td>'
		+'<td class="aC">'+adGrp01+'</td>'
		+'<td class="aC">'+adGrp02+'</td>'
		+'<td class="aC">'+adGrp03+'</td>'
		+'<td class="aC">'+adNM+'</td>'
		+'<td class="aC">'+adNum1+'</td>'
		+'</tr>';
		$('#callUserGrpList tbody').append(strRow);
	}
	
	function fnAddTrg_callUserGrp(){
		var cnt = 0;
		$('form[name=callUserGrpFrm] input[type=checkbox]').each(function(){
			if($(this).prop('checked') == true){
				cnt = cnt+1;
			}
		});
		if(cnt < 1){
			alert('추가할 유형을 체크해 주세요.');return;
		}else{
			if($('#selTrgCount_callUserGrp').html() == '0'){
				alert('검색된 대상자가 없습니다.');return;
			}else{
				document.callUserGrpFrm.proc.value = 'add';
				document.callUserGrpFrm.submit();
			}
		}
	}
	
</script>