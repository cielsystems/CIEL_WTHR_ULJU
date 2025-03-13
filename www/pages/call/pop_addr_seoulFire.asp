<!--#include virtual="/common/common.asp"-->

<%
dim clGB : clGB = fnReq("clGB")
dim nSelGrpCD : nSelGrpCD = fnIsNull(fnReq("nSelGrpCD"),0)
dim cdUsGB : cdUsGB = cint(fnDBVal("TBL_ADDR", "CD_USERGB", "AD_IDX = " & ss_userIdx & ""))
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
	dim arrTabs : arrTabs = arrGrpNames
	dim arrTabsGB : arrTabsGB = arrGrpGubun
	'dim arrTabs : arrTabs = array("직원주소록","동보주소록")
	'dim arrTabsGB : arrTabsGB = array("D","E")
	dim tabNo
	%>
	
	<%
	dim allStfUse : allStfUse = "N"
	'#	타부서 사용권한 처리
	dim userCdUsGB : userCdUsGB = clng(fnDBVal("TBL_ADDR", "CD_USERGB", "AD_IDX = " & ss_userIdx & ""))
	dim userAdPerAddr : userAdPerAddr = fnDBVal("TBL_ADDR", "AD_PERADDR", "AD_IDX = " & ss_userIdx & "")
	if userCdUsGB < 1002 or userAdPerAddr = "A" then
		allStfUse = "Y"
	end if
	%>
	<% if allStfUse = "Y" then %>
		<div class="aR" style="margin-bottom:5px;"><img class="imgBtn" src="<%=pth_pubImg%>/btn/red_allAdd.png" onclick="fnAllStfAdd()" /></div>
	<% end if %>
	<div class="tabs">
		<ul class="tabsMenu">
			<%
			for i = 0 to ubound(arrTabs)
				tabNo = i + 1
				response.write	"<li id=""tabsMenu_" & tabNo & """ onclick=""fnTabMenu(" & tabNo & ")"">" & arrTabs(i) & "</li>" & vbCrLf
			next
			%>
			<% if clGB = "E" then %>
				<li id="tabsMenu_4" onclick="fnTabMenu(4)">유형발령(소방포털연계)</li>
			<% else %>
				<li id="tabsMenu_4" onclick="fnTabMenu(4)">대상추가</li>
			<% end if %>
			<li id="tabsMenu_5" onclick="fnTabMenu(5)">유형발령(사용자별)</li>
			<div class="clr"></div>
		</ul>
		<div class="clr"></div>
		<div class="tabsContBox">
				
			<%
			dim adIdx
			dim nTopGrpInfo, arrTopGrpCD(4), arrTopGrpNM(4)
			dim arrGrpImg : arrGrpImg = array("book-","book-","book-","book-","book-")
			
			for i = 0 to ubound(arrTabs)
				
				tabNo = i + 1
					
				if i = 3 then
					adIdx = ss_userIdx
				end if
				
				arrCols = array("GRP_CODE","GRP_NM")
				nTopGrpInfo = fnDBArrVal("TBL_GRP", arrCols, "USEYN = 'Y' and GRP_UPCODE = '' and GRP_GB = '" & arrTabsGB(i) & "'")
				if ubound(nTopGrpInfo) > 0 then
					arrTopGrpCD(i) = nTopGrpInfo(0)
					arrTopGrpNM(i) = nTopGrpInfo(1)
				end if
				%>
				
				<div id="tabs-<%=tabNo%>" class="tabsCont">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="410px"><h3><%=arrTabs(i)%></h3></td>
							<td>
								<table width="100%">
									<tr>
										<td>
											<select name="schKey">
												<option value="NM">이름</option>
												<option value="NUM">번호</option>
											</select>
											<input type="text" name="schVal" value="" onkeypress="if(event.keyCode==13){fnSch()}" />
											<img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" title="검색" onclick="fnSch()" />
										</td>
										<td class="aR">
											연락처 <span id="addrRowCnt<%=tabNo%>">0</span>건 | <input type="checkbox"" name="allChk<%=tabNo%>" onclick="fnTrgAllSel(<%=tabNo%>)" style="" /> 전체선택
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<div id="addrBox<%=tabNo%>">
						<form name="frmTrg<%=tabNo%>" method="post" action="pop_addrProc.asp" target="popProcFrame">
							<input type="hidden" name="proc" value="addrAdd" />
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<colgroup>
									<col width="400px" />
									<col width="10px" />
									<col width="*" />
								</colgroup>
								<tr>
									<td valign="top">
										<div id="tree<%=tabNo%>" class="treeBox">
											<div class="treeItem treeDepth1" id="item_<%=arrTopGrpCD(i)%>">
												<!--<div class="item" onclick="fnSelTreeTop(<%=tabNo%>,'<%=arrTabsGb(i)%>',this)">-->
												<div class="item">
													<img src="<%=pth_pubImg%>/tree/address-book_<%=i%>.png" />
													<input type="hidden" name="grpGB" value="<%=tabNo%>" />
													<input type="hidden" name="grpDepth" value="1" />
													<input type="hidden" name="grpCD" value="<%=arrTopGrpCD(i)%>" />
													<span><%=arrTopGrpNM(i)%></span>
												</div>
												<div class="subItem" id="treeSub_<%=arrTopGrpCD(i)%>">
<%
dim grpRs1, grpRc1, grpRs2, grpRc2, grpRs3, grpRc3
dim jj, jjj
dim gb : gb = arrTabsGB(i)
dim topGrpCD : topGrpCD = arrTopGrpCD(i)
'#	1Depth Start	==============================================================
sql = " select GRP_CODE, GRP_UPCODE, GRP_NM from TBL_GRP "
sql = sql & " where USEYN = 'Y' and GRP_GB = '" & gb & "' and GRP_UPCODE = " & topGrpCD & " "
if gb = "D" then
	dim adPerAddr : adPerAddr = fnDBVal("TBL_ADDR", "AD_PERADDR", "AD_IDX = " & ss_userIdx & "")
	if cdUsGB < 1002 or adPerAddr = "A" then
	else
		sql = sql & " 	and GRP_CODE = (select GRP_CODE from TBL_ADDR where AD_IDX = " & ss_userIdx & ") "
	end if
elseif gb = "P" then
	sql = sql & " 	and AD_IDX = " & ss_userIdx & " "
end if
sql = sql & " order by GRP_SORT "
grpRs1 = execSqlRs(sql)
if isarray(grpRs1) then
	grpRc1 = ubound(grpRs1,2)
else
	grpRc1 = -1
end if
for j = 0 to grpRc1
	response.write	"<div class=""treeItem treeDepth2"" id=""item_" & grpRs1(0,j) & """>"
	response.write	"	<div class=""item"" onclick=""fnSelGrp(3," & grpRs1(0,j) & ")"">"
	response.write	"		<img class=""imgBtn"" src=""" & pth_pubImg & "/tree/folder.png"" />"
	response.write	"		<input type=""hidden"" name=""grpDepth"" value=""3"" />"
	response.write	"		<input type=""hidden"" name=""grpCD"" value=""" & grpRs1(0,j) & """ />"
	response.write	"		<span id=""itemSpan_" & grpRs1(0,j) & """>" & grpRs1(2,j) & "</span>"
	response.write	"	</div>"
	'#	2Depth Start	==============================================================
	sql = " select GRP_CODE, GRP_UPCODE, GRP_NM from TBL_GRP "
	sql = sql & " where USEYN = 'Y' and GRP_GB = '" & gb & "' and GRP_UPCODE = " & grpRs1(0,j) & " "
	sql = sql & " order by GRP_SORT "
	grpRs2 = execSqlRs(sql)
	if isarray(grpRs2) then
		grpRc2 = ubound(grpRs2,2)
	else
		grpRc2 = -1
	end if
	if grpRc2 > -1 then
		response.write	"	<div class=""subItem"" id=""treeSub_" & grpRs1(0,j) & """ "
		response.write	"style=""display:none;"""
		response.write	">"
		for jj = 0 to grpRc2
			response.write	"<div class=""treeItem treeDepth3"" id=""item_" & grpRs2(0,jj) & """>"
			response.write	"	<div class=""item"" onclick=""fnSelGrp(4," & grpRs2(0,jj) & ")"">"
			response.write	"		<img class=""imgBtn"" src=""" & pth_pubImg & "/tree/folder.png"" />"
			response.write	"		<input type=""hidden"" name=""grpDepth"" value=""4"" />"
			response.write	"		<input type=""hidden"" name=""grpCD"" value=""" & grpRs2(0,jj) & """ />"
			response.write	"		<span id=""itemSpan_" & grpRs2(0,jj) & """>" & grpRs2(2,jj) & "</span>"
			response.write	"	</div>"
			'#	3Depth Start	==============================================================
			sql = " select GRP_CODE, GRP_UPCODE, GRP_NM from TBL_GRP "
			sql = sql & " where USEYN = 'Y' and GRP_GB = '" & gb & "' and GRP_UPCODE = " & grpRs2(0,jj) & " "
			sql = sql & " order by GRP_SORT "
			grpRs3 = execSqlRs(sql)
			if isarray(grpRs3) then
				grpRc3 = ubound(grpRs3,2)
			else
				grpRc3 = -1
			end if
			if grpRc3 > -1 then
				response.write	"	<div class=""subItem"" id=""treeSub_" & grpRs2(0,jj) & """ "
				response.write	"style=""display:none;"""
				response.write	">"
				for jjj = 0 to grpRc3
					response.write	"<div class=""treeItem treeDepth4"" id=""item_" & grpRs3(0,jjj) & """>"
					response.write	"	<div class=""item"" onclick=""fnSelGrp(5," & grpRs3(0,jjj) & ")"">"
					response.write	"		<img class=""imgBtn"" src=""" & pth_pubImg & "/tree/folder.png"" />"
					response.write	"		<input type=""hidden"" name=""grpDepth"" value=""5"" />"
					response.write	"		<input type=""hidden"" name=""grpCD"" value=""" & grpRs3(0,jjj) & """ />"
					response.write	"		<span id=""itemSpan_" & grpRs3(0,jjj) & """>" & grpRs3(2,jjj) & "</span>"
					response.write	"	</div>"
					response.write	"</div>"
				next
				response.write	"	</div>"
			end if
			'#	3Depth Start	==============================================================
			response.write	"</div>"
		next
		response.write	"	</div>"
	end if
	'#	2Depth Start	==============================================================
	response.write	"</div>"
next
'#	1Depth Start	==============================================================
%>
												</div>
											</div>
										</div>
									</td>
									<td></td>
									<td>
										<div class="addrList">
											<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tblList" style="margin-top:0;">
												<thead>
													<colgroup>
														<col width="*" />
														<col width="100px" />
														<col width="120px" />
														<col width="120px" />
														<col width="120px" />
														<col width="40px" />
													</colgroup>
													<tr>
														<th>이름</th>
														<th>계급</th>
														<% for j = 1 to ubound(arrCallMedia) %>
															<th><%=arrCallMedia(j)%>번호</th>
														<% next %>
														<th>제외</th>
													</tr>
												</thead>
											</table>
											<table width="100%" border="0" cellpadding="0" cellspacing="1" id="addrList<%=tabNo%>" class="tblList" style="margin-top:1px;border:0;">
												<thead>
													<colgroup>
														<col width="*" />
														<col width="100px" />
														<col width="120px" />
														<col width="120px" />
														<col width="120px" />
														<col width="40px" />
													</colgroup>
												</thead>
												<tbody>
												</tbody>
											</table>
										</div>
									</td>
								</tr>
							</table>
							<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-top:10px;">
								<tr>
									<td style="text-align:left;font-size:12px;">총 <b id="selTrgCount<%=tabNo%>" class="selTrgCount">0</b>명 선택</td>
									<td style="text-align:right;"><img class="imgBtn" src="<%=pth_pubImg%>/btn/blue_add.png" title="추가" onclick="fnAddTrg(<%=tabNo%>)" /></td>
								</tr>
							</table>
						</form>
					</div>
				</div>
				
				<%
			next
			%>
			
			<% if clGB = "E" then %>
				<!-- 유형발령 -->
				<div id="tabs-4" class="tabsCont">
					
					<form name="callUserGrpFrm" method="post" action="pop_addrProc_callUserGrp.asp" target="popProcFrame">
						<input type="hidden" name="proc" value="" />
						<input type="hidden" name="gb" value="D" />
						
						<h3>유형발령(소방포털연계)</h3>
						<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
							<colgroup>
								<col width="*" />
								<col width="200px" />
								<col width="200px" />
								<col width="140px" />
								<col width="140px" />
								<col width="140px" />
							</colgroup>
							<tr>
								<th colspan="3">부서(그룹)</th>
								<th>직급</th>
								<th>직위</th>
								<th>순위</th>
							</tr>
							<tr>
								<%
								'dim grpRs1, grpRc1, grpRs2, grpRc2, grpRs3, grpRc3
								
								dim sqlProc : sqlProc = "usp_listGrp"
								
								'#	타부서 사용권한 처리
								'dim cdUsGB : cdUsGB = cint(fnDBVal("TBL_ADDR", "CD_USERGB", "AD_IDX = " & ss_userIdx & ""))
								'dim adPerAddr : adPerAddr = fnDBVal("TBL_ADDR", "AD_PERADDR", "AD_IDX = " & ss_userIdx & "")
								
								if cdUsGB < 1002 or adPerAddr = "A" then
									sqlProc = "usp_listGrp"
								else
									sqlProc = "usp_listGrpPermit"
								end if
								
								'#	1Depth
								response.write	"<td style=""padding:0;""><div class=""adGrpItemBox"">"
								
								'sql = " select GRP_CODE, GRP_NM from TBL_GRP with(nolock) where USEYN = 'Y' and GRP_UPCODE = 1 order by GRP_SORT "
								'grpRs1 = execSqlRs(sql)
								grpRs1 = execProcRs(sqlProc, array("D", 1, ss_userIdx))
								if isarray(grpRs1) then
									grpRc1 = ubound(grpRs1,2)
								else
									grpRc1 = -1
								end if
								for i = 0 to grpRc1
									response.write	"<div id=""grpCode1_" & grpRs1(0,i) & """>"
									response.write	"<input type=""checkbox"" name=""grpCode1"" value=""" & grpRs1(0,i) & """ onclick=""fnSelCallGrp(1," & grpRs1(0,i) & ",0,0,this)"" />"
									response.write	" " & grpRs1(2,i) & "</div>"
								next
								
								response.write	"</div></td>"
								
								'#	2Depth
								response.write	"<td style=""padding:0;""><div class=""adGrpItemBox"">"
								
								for i = 0 to grpRc1
									'sql = " select GRP_CODE, GRP_NM from TBL_GRP with(nolock) where USEYN = 'Y' and GRP_UPCODE = " & grpRs1(0,i) & " order by GRP_SORT "
									'grpRs2 = execSqlRs(sql)
									grpRs2 = execProcRs(sqlProc, array("D", grpRs1(0,i), ss_userIdx))
									if isarray(grpRs2) then
										grpRc2 = ubound(grpRs2,2)
									else
										grpRc2 = -1
									end if
									if grpRc2 > -1 then
										response.write	"<div class=""upCode"">" & grpRs1(2,i) & "</div>"
										for ii = 0 to grpRc2
											response.write	"<div id=""grpCode2_" & grpRs1(0,i) & "_" & grpRs2(0,ii) & """>"
											response.write	"<input type=""checkbox"" name=""grpCode2"" value=""" & grpRs2(0,ii) & """ onclick=""fnSelCallGrp(2," & grpRs1(0,i) & "," & grpRs2(0,ii) & ",0,this)"" />"
											response.write	" " & grpRs2(2,ii) & "</div>"
										next
									end if
								next
								
								response.write	"</div></td>"
								
								'#	3Depth
								response.write	"<td style=""padding:0;""><div class=""adGrpItemBox"">"
								
								for i = 0 to grpRc1
									'sql = " select GRP_CODE, GRP_NM from TBL_GRP with(nolock) where USEYN = 'Y' and GRP_UPCODE = " & grpRs1(0,i) & " order by GRP_SORT "
									'grpRs2 = execSqlRs(sql)
									grpRs2 = execProcRs(sqlProc, array("D", grpRs1(0,i), ss_userIdx))
									if isarray(grpRs2) then
										grpRc2 = ubound(grpRs2,2)
									else
										grpRc2 = -1
									end if
									for ii = 0 to grpRc2
										'sql = " select GRP_CODE, GRP_NM from TBL_GRP with(nolock) where USEYN = 'Y' and GRP_UPCODE = " & grpRs2(0,ii) & " order by GRP_SORT "
										'grpRs3 = execSqlRs(sql)
										grpRs3 = execProcRs(sqlProc, array("D", grpRs2(0,ii), ss_userIdx))
										if isarray(grpRs3) then
											grpRc3 = ubound(grpRs3,2)
										else
											grpRc3 = -1
										end if
										if grpRc3 > -1 then
											response.write	"<div class=""upCode"">" & grpRs1(2,i) & " > " & grpRs2(2,ii) & "</div>"
											for iii = 0 to grpRc3
												response.write	"<div id=""grpCode3_" & grpRs1(0,i) & "_" & grpRs2(0,ii) & "_" & grpRs3(0,iii) & """>"
												response.write	"<input type=""checkbox"" name=""grpCode3"" value=""" & grpRs3(0,iii) & """ onclick=""fnSelCallGrp(3," & grpRs1(0,i) & "," & grpRs2(0,ii) & "," & grpRs3(0,iii) & ",this)"" />"
												response.write	" " & grpRs3(2,iii) & "</div>"
											next
										end if
									next
								next
								
								response.write	"</div></td>"
								
								for i = 1 to 3
									%>
									<td style="padding:0;">
										<div class="adGrpItemBox">
											<%
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
											%>
										</div>
									</td>
									<%
								next
								%>
							</tr>
						</table>
						
					</form>
					
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
								<th>직급</th>
								<th>직위</th>
								<th>순위</th>
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
				</div>
				<!-- 유형발령 -->
				<!-- 유형발령 -->
				<div id="tabs-5" class="tabsCont">
					
					<form name="callUserGrpFrm2" method="post" action="pop_addrProc_callUserGrp.asp" target="popProcFrame">
						<input type="hidden" name="proc" value="" />
						<input type="hidden" name="gb" value="P" />
						
						<h3>유형발령(상황실직원수정)</h3>
						<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
							<colgroup>
								<col width="*" />
								<col width="200px" />
								<col width="200px" />
								<col width="140px" />
								<col width="140px" />
								<col width="140px" />
							</colgroup>
							<tr>
								<th colspan="3">부서(그룹)</th>
								<th>직급</th>
								<th>직위</th>
								<th>순위</th>
							</tr>
							<tr>
								<%
								'dim grpRs1, grpRc1, grpRs2, grpRc2, grpRs3, grpRc3
								
								sqlProc = "usp_listGrp"
								
								response.write	"<td style=""padding:0;""><div class=""adGrpItemBox"">"
								
								'sql = " select GRP_CODE, GRP_NM from TBL_GRP with(nolock) where USEYN = 'Y' and GRP_UPCODE = 1 order by GRP_SORT "
								'grpRs1 = execSqlRs(sql)
								grpRs1 = execProcRs(sqlProc, array("P", 5, ss_userIdx))
								if isarray(grpRs1) then
									grpRc1 = ubound(grpRs1,2)
								else
									grpRc1 = -1
								end if
								for i = 0 to grpRc1
									response.write	"<div id=""grpCode1_" & grpRs1(0,i) & """>"
									response.write	"<input type=""checkbox"" name=""grpCode1"" value=""" & grpRs1(0,i) & """ onclick=""fnSelCallGrp2(1," & grpRs1(0,i) & ",0,0,this)"" />"
									response.write	" " & grpRs1(2,i) & "</div>"
								next
								
								response.write	"</div></td>"
								
								'#	2Depth
								response.write	"<td style=""padding:0;""><div class=""adGrpItemBox"">"
								
								for i = 0 to grpRc1
									'sql = " select GRP_CODE, GRP_NM from TBL_GRP with(nolock) where USEYN = 'Y' and GRP_UPCODE = " & grpRs1(0,i) & " order by GRP_SORT "
									'grpRs2 = execSqlRs(sql)
									grpRs2 = execProcRs(sqlProc, array("P", grpRs1(0,i), ss_userIdx))
									if isarray(grpRs2) then
										grpRc2 = ubound(grpRs2,2)
									else
										grpRc2 = -1
									end if
									if grpRc2 > -1 then
										response.write	"<div class=""upCode"">" & grpRs1(2,i) & "</div>"
										for ii = 0 to grpRc2
											response.write	"<div id=""grpCode2_" & grpRs1(0,i) & "_" & grpRs2(0,ii) & """>"
											response.write	"<input type=""checkbox"" name=""grpCode2"" value=""" & grpRs2(0,ii) & """ onclick=""fnSelCallGrp2(2," & grpRs1(0,i) & "," & grpRs2(0,ii) & ",0,this)"" />"
											response.write	" " & grpRs2(2,ii) & "</div>"
										next
									end if
								next
								
								response.write	"</div></td>"
								
								'#	3Depth
								response.write	"<td style=""padding:0;""><div class=""adGrpItemBox"">"
								
								for i = 0 to grpRc1
									'sql = " select GRP_CODE, GRP_NM from TBL_GRP with(nolock) where USEYN = 'Y' and GRP_UPCODE = " & grpRs1(0,i) & " order by GRP_SORT "
									'grpRs2 = execSqlRs(sql)
									grpRs2 = execProcRs(sqlProc, array("P", grpRs1(0,i), ss_userIdx))
									if isarray(grpRs2) then
										grpRc2 = ubound(grpRs2,2)
									else
										grpRc2 = -1
									end if
									for ii = 0 to grpRc2
										'sql = " select GRP_CODE, GRP_NM from TBL_GRP with(nolock) where USEYN = 'Y' and GRP_UPCODE = " & grpRs2(0,ii) & " order by GRP_SORT "
										'grpRs3 = execSqlRs(sql)
										grpRs3 = execProcRs(sqlProc, array("P", grpRs2(0,ii), ss_userIdx))
										if isarray(grpRs3) then
											grpRc3 = ubound(grpRs3,2)
										else
											grpRc3 = -1
										end if
										if grpRc3 > -1 then
											response.write	"<div class=""upCode"">" & grpRs1(2,i) & " > " & grpRs2(2,ii) & "</div>"
											for iii = 0 to grpRc3
												response.write	"<div id=""grpCode3_" & grpRs1(0,i) & "_" & grpRs2(0,ii) & "_" & grpRs3(0,iii) & """>"
												response.write	"<input type=""checkbox"" name=""grpCode3"" value=""" & grpRs3(0,iii) & """ onclick=""fnSelCallGrp2(3," & grpRs1(0,i) & "," & grpRs2(0,ii) & "," & grpRs3(0,iii) & ",this)"" />"
												response.write	" " & grpRs3(2,iii) & "</div>"
											next
										end if
									next
								next
								
								response.write	"</div></td>"
								
								for i = 1 to 3
									%>
									<td style="padding:0;">
										<div class="adGrpItemBox">
											<%
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
													response.write	"<input type=""checkbox"" name=""adGrp0" & i & """ value=""" & arrRs(0,ii) & """ onclick=""fnSelCallUserGrp2(" & i & "," & arrRs(0,ii) & ",this)"" /> " & arrRs(1,ii) & "</div>"
												end if
											next
											%>
										</div>
									</td>
									<%
								next
								%>
							</tr>
						</table>
						
					</form>
					
					<div class="aR" style="margin-top:5px;"><img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" onclick="fnCallUserGrp2()" /></div>
					
					<table border="0" cellpadding="0" cellspacing="1" class="tblList" id="callUserGrpList2">
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
								<th>직급</th>
								<th>직위</th>
								<th>순위</th>
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
							<td style="text-align:right;" class="fnt13">총 <b id="selTrgCount_callUserGrp2" class="selTrgCount colRed">0</b>명 이 검색되었습니다 </td>
							<td style="text-align:right;width:60px;"><img class="imgBtn" src="<%=pth_pubImg%>/btn/blue_add.png" title="추가" onclick="fnAddTrg_callUserGrp2()" /></td>
						</tr>
					</table>
				</div>
				<!-- 유형발령 -->
			<% else %>
				<!-- 엑셀업로드 및 개별입력 -->
				<div id="tabs-4" class="tabsCont">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<colgroup>
							<col width="*" />
							<col width="10px" />
							<col width="10px" />
							<col width="320px" />
						</colgroup>
						<tr>
							<td valign="top">
								<h3>엑셀업로드</h3>
								
								<div style="height:485px;">
								
									<div style="background:#eeeeee;border:1px solid #cccccc;padding:10px;">
										<form name="xlsFrm" method="post" enctype="multipart/form-data" action="/pages/public/addrXlsUp.asp" target="popProcFrame">
											<input type="hidden" name="clGB" value="<%=clGB%>" />
											<table border="0" cellpadding="0" cellspacing="0" align="left">
												<tr>
													<td><label>파일업로드</label>&nbsp;&nbsp;:&nbsp;&nbsp;</th>
													<td>
														<input type="file" name="xlsUp" />
														<img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_upload.png" title="업로드" onclick="fnXlsUpload()" />
													</td>
												</tr>
											</table>
										</form>
										<div class="clr"></div>
									</div>
									
									<p style="margin-top:10px;">
										전송대상을 지정된 형식의 엑셀파일로 업로드 합니다.
										<img class="imgBtn" src="<%=pth_pubImg%>/btn/olive_sample.png" title="샘플다운로드" onclick="fnSampleDown()" />
										<div class="colBlue fnt11" style="margin-top:5px;">★ 업로드된 대상은 개인주소록에 <b class="colRed">"대상자_0000년00월00일_0"</b>의 형식의 이름으로 생성된 그룹에 추가되므로 다음에 사용하실때 다시 업로드할 필요 없이 불러와서 전송할 수 있습니다.</div>
									</p>
									<% if clGB = "S" then %>
										<table id="xlsExmTbls1" width="100%" border="0" cellpadding="0" cellspacing="0" class="tblXls" style="margin-top:10px;">
											<colgroup>
												<col width="40px" />
												<col width="100px" />
												<col width="100px" />
												<col width="100px" />
												<col width="100px" />
											</colgroup>
											<tr><th class="gb"></th><th>A</th><th>B</th><th>C</th><th>D</th></tr>
											<tr><td class="no">1</td><td>이름</td><td>휴대폰번호</td><td></td><td></td></tr>
											<tr><td class="no">2</td><td>연락처1</td><td>010-1111-1111</td><td></td><td></td></tr>
											<tr><td class="no">3</td><td>연락처2</td><td>010-2222-2222</td><td></td><td></td></tr>
											<tr><td class="no">4</td><td>연락처3</td><td>010-3333-3333</td><td></td><td></td></tr>
											<tr><td class="no">5</td><td></td><td></td><td></td><td></td></tr>
										</table>
									<% elseif clGB = "V" then %>
										<table id="xlsExmTbls1" width="100%" border="0" cellpadding="0" cellspacing="0" class="tblXls" style="margin-top:10px;">
											<colgroup>
												<col width="40px" />
												<col width="100px" />
												<col width="100px" />
												<col width="100px" />
												<col width="100px" />
											</colgroup>
											<tr><th class="gb"></th><th>A</th><th>B</th><th>C</th><th>D</th></tr>
											<tr><td class="no">1</td><td>이름</td><td>전화번호</td><td></td><td></td></tr>
											<tr><td class="no">2</td><td>연락처1</td><td>02-1111-1111</td><td></td><td></td></tr>
											<tr><td class="no">3</td><td>연락처2</td><td>031-2222-2222</td><td></td><td></td></tr>
											<tr><td class="no">4</td><td>연락처3</td><td>010-3333-3333</td><td></td><td></td></tr>
											<tr><td class="no">5</td><td></td><td></td><td></td><td></td></tr>
										</table>
									<% end if %>
									
									<% call infoBox("trgXls") %>
								
								</div>
								
							</td>
							<td></td>
							<td style="border-left:1px solid #cccccc;"></td>
							<td valign="top">
								<h3>개별번호추가</h3>
								
								<% call infoBox("trgInpAdd") %>
								
								<div class="colBlue fnt11" style="margin-top:5px;">★ 개별번호는 1회성 이므로 저장되지 않습니다.</div>
								
								<form name="frmInp" method="post" action="pop_addrProc.asp" target="popProcFrame">
									<input type="hidden" name="proc" value="inpAdd" />
									<table border="0" cellpadding="0" cellspacing="1" class="tblForm" style="margin-top:10px;">
										<colgroup>
											<col width="*" />
											<col width="200px" />
										</colgroup>
										<tr><th>이름</th><td><input type="text" name="inpNM" value="" size="14" maxlength="50" /></td></tr>
										<% if clGB = "S" then %>
											<tr><th>휴대폰번호</th><td><input type="text" name="inpNum1" value="" maxlength="20" /></td></tr>
										<% elseif clGB = "V" then %>
											<tr><th>전화번호</th><td><input type="text" name="inpNum1" value="" maxlength="20" /></td></tr>
										<% end if %>
									</table>
									<div class="aR" style="margin-top:5px;"><img class="imgBtn" src="<%=pth_pubImg%>/btn/blue_add.png" onclick="fnInpAdd()" /></div>
								</form>
							</td>
						</tr>
					</table>
				</div>
				<!-- 엑셀업로드 및 개별입력 -->
			<% end if %>
			
		</div>
		
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	var nTab = 1;			// 최초 선택된 Tab 번호
	var trgType = '0';		// 주소록 타입 0 : 전부, 1 : App, 2 : 문자
	
	//	주소록 Tree용 변수
	var nGrpNo = '';
	var nGrpCD = <%=topGrpCD%>;					// 최 상위 그룹코드
	var nTreeID = 'tree';			// Tree DIV 아이디
	var nTreeImg = new Array;	// Tree 아이콘 배열
	var arrGrpGB = new Array;	// Tree 그룹 구분 배열
	
	var selTrg = 0;
	
	$(function(){
		
		fnSelTab();			// 최초 선택텝
		
	});
	
	function fnSelTreeTop(grpNo,grpCD,trg){
		$('.treeItem .item').find('span').removeClass('on');
		$(trg).find('span').addClass('on');
		fnLoadAddr(grpNo,grpCD);
	}
	
	function fnSelGrp(trg,upcd){
		if(nGrpCD != upcd){
			$('#treeSub_'+upcd).css('display','block');
			$('.treeItem .item').find('span').removeClass('on');
			$('#itemSpan_'+upcd).addClass('on');
			nGrpCD = upcd;
			fnLoadAddr(nTab,nGrpCD);
		}else{
			$('#treeSub_'+upcd).css('display','none');
			$('.treeItem .item').find('span').removeClass('on');
			nGrpCD = 0;
		}
	}
	
	function fnSch(){
		if(nGrpCD.length == 0){
			alert('검색할 부서를 선택하세요.');
		}else{
			fnLoadAddr(nGrpNo, nGrpCD);
		}
	}
	
	function fnLoadAddr(grpNo,grpCD){	// 연락처 가져오기
		var grpGB = arrGrpGB[grpNo-1];
		var schKey = $('#tabs-'+grpNo).find('select[name=schKey]').val();
		var schVal = $('#tabs-'+grpNo).find('input[name=schVal]').val();
		schVal = encodeURI(schVal);
		var url = '/pages/public/ajxAddrList_trg.asp?grpGB='+grpGB+'&grpCD='+grpCD+'&schKey='+schKey+'&schVal='+schVal;
		var result = fnGetHttp(url);
		var arrResult = result.split('}|{');
		$('#addrList'+grpNo+' tbody tr').remove();
		var rowCnt = arrResult[0];
		$('#addrRowCnt'+grpNo).html(rowCnt);
		if(rowCnt > 0){
			var arrVal, strRow;
			for(var i = 2; i < arrResult.length; i++){
				arrVal = arrResult[i].split(']|[');
				//	AD_IDX(0), AD_NM(1), AD_NUM1(2), AD_NUM2(3), AD_NUM3(4), AD_EMAIL(5), AD_MEMO(6), TRGYN(7)
				if(arrVal[7] == 'Y'){
					strRow = '<tr>'
					+'	<td class="colGray"><input type="checkbox" name="adIdx" value="'+arrVal[0]+'" onclick="fnCountTrg('+grpNo+')" disabled />'+arrVal[1]+'</td>'
					+'	<td class="aC colGray">'+arrVal[5]+'</td>'
					+'	<td class="aC colGray">'+arrVal[2]+'</td>'
					+'	<td class="aC colGray">'+arrVal[3]+'</td>'
					+'	<td class="aC colGray">'+arrVal[4]+'</td>'
					+'	<td class="aC"><img class="imgBtn" src="<%=pth_pubImg%>/icons/cross.png" onclick="fnDelTrg('+arrVal[0]+')" /></td>'
					+'</tr>';
				}else{
					strRow = '<tr>'
					+'	<td><input type="checkbox" name="adIdx" value="'+arrVal[0]+'" onclick="fnCountTrg('+grpNo+')" />'+arrVal[1]+'</td>'
					+'	<td class="aC">'+arrVal[5]+'</td>'
					+'	<td class="aC">'+arrVal[2]+'</td>'
					+'	<td class="aC">'+arrVal[3]+'</td>'
					+'	<td class="aC">'+arrVal[4]+'</td>'
					+'	<td></td>'
					+'</tr>';
				}
				$('#addrList'+grpNo+' tbody').append(strRow);
			}
		}
		selTrg = 0;
		$('input[name=allChk1]').prop('checked',false);
		$('input[name=allChk2]').prop('checked',false);
		$('input[name=allChk3]').prop('checked',false);
		$('input[name=allChk4]').prop('checked',false);
		$('input[name=allChk5]').prop('checked',false);
	}
	
	function fnCountTrg(tp){		// 선택 대상 Count
		selTrg = 0;
		$('#addrList'+tp+' tbody tr input[type=checkbox]').each(function(){
			if($(this).prop('checked') == true){
				selTrg = selTrg + 1;
			}
		});
		$('#selTrgCount'+tp).html(selTrg);
	}
	
	function fnTrgAllSel(tp){		// 전체선택
		if($('input[name=allChk'+tp).prop('checked') == true){
			$('#addrList'+tp+' tbody tr').find('input[type=checkbox]').prop('checked',true);
		}else{
			$('#addrList'+tp+' tbody tr').find('input[type=checkbox]').prop('checked',false);
		}
		fnCountTrg(tp);
	}
	
	function fnAddTrg(tp){		// 대상 추가
		if(selTrg > 0){
			//fnLoadingS();
			eval('document.frmTrg'+tp).submit();
			$('#addrList'+tp+' tbody tr input[type=checkbox]').prop('checked',false);
			$('input[name=allChk'+tp+']').prop('checked',false);
			fnCountTrg(tp);
		}else{
			alert('추가할 연락처를 선택하세요.');return;
		}
	}
	
	function fnDelTrg(idx){		// 대상제외
		popProcFrame.location.href = 'pop_addrProc.asp?proc=delTrg&adIdx='+idx;
	}
	
	function fnAllStfAdd(){
		if(confirm('전직원을 대상자로 추가하시겠습니까?')){
			popProcFrame.location.href = 'pop_addrProc.asp?proc=allStf';
		}
	}
	
	function fnXlsUpload(){		// 엑셀업로드
		if(document.xlsFrm.xlsUp.value == ''){
			alert('업로드할 파일을 선택하세요.');return false;
		}
		document.xlsFrm.submit();
	}
	
	function fnSampleDown(){	// 샘플다운로드
		var file = '/data/targetUpload.xls';
		popProcFrame.location.href = '/public/etc/fileDown.asp?file='+file;
	}
	
	function fnInpAdd(){		// 개별번호입력
		var inpNum1 = document.frmInp.inpNum1.value;
		if(inpNum1.length == 0){
			alert('번호를 입력해 주세요.');document.frmInp.inpNum1.focus();return false;
		}else{
			if(fnChkMobile(inpNum1) != true && fnChkPhone(inpNum1) != true){
				alert('번호를 정확히 입력하세요.');document.frmInp.inpNum1.focus();return false;
			}
		}
		document.frmInp.submit();
	}
	
	function fnTabMenu(no){
		nTab = no;
		fnSelTab();
	}
	
	function fnSelTab(){
		$('.tabs .tabsMenu li').removeClass('on');
		$('.tabs .tabsContBox .tabsCont').css('display','none');
		$('.tabs .tabsMenu #tabsMenu_'+nTab).addClass('on');
		$('.tabs .tabsContBox #tabs-'+nTab).css('display','block');
		nGrpCD = '';
	}
	
	//	==============================================================================================
	//	유형발령
	function fnSelCallGrp(depth,grpCode1,grpCode2,grpCode3,trg){
		if($(trg).prop('checked') == true){
			if(depth == 1){
				$('#grpCode'+depth+'_'+grpCode1).addClass('on');
				$('div[id^=grpCode2_'+grpCode1+'_]').addClass('on');
				$('div[id^=grpCode2_'+grpCode1+'_]').find('input[name=grpCode2]').prop('checked',true);
				$('div[id^=grpCode3_'+grpCode1+'_]').addClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_]').find('input[name=grpCode3]').prop('checked',true);
			}else if(depth == 2){
				$('#grpCode'+depth+'_'+grpCode1+'_'+grpCode2).addClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_'+grpCode2+'_]').addClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_'+grpCode2+'_]').find('input[name=grpCode3]').prop('checked',true);
			}else if(depth == 3){
				$('#grpCode'+depth+'_'+grpCode1+'_'+grpCode2+'_'+grpCode3).addClass('on');
			}
		}else{
			if(depth == 1){
				$('#grpCode'+depth+'_'+grpCode1).removeClass('on');
				$('div[id^=grpCode2_'+grpCode1+'_]').removeClass('on');
				$('div[id^=grpCode2_'+grpCode1+'_]').find('input[name=grpCode2]').prop('checked',false);
				$('div[id^=grpCode3_'+grpCode1+'_]').removeClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_]').find('input[name=grpCode3]').prop('checked',false);
			}else if(depth == 2){
				$('#grpCode'+depth+'_'+grpCode1+'_'+grpCode2).removeClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_'+grpCode2+'_]').removeClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_'+grpCode2+'_]').find('input[name=grpCode3]').prop('checked',false);
			}else if(depth == 3){
				$('#grpCode'+depth+'_'+grpCode1+'_'+grpCode2+'_'+grpCode3).removeClass('on');
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
		/*
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
		*/
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
	function fnSelCallGrp2(depth,grpCode1,grpCode2,grpCode3,trg){
		if($(trg).prop('checked') == true){
			if(depth == 1){
				$('#grpCode'+depth+'_'+grpCode1).addClass('on');
				$('div[id^=grpCode2_'+grpCode1+'_]').addClass('on');
				$('div[id^=grpCode2_'+grpCode1+'_]').find('input[name=grpCode2]').prop('checked',true);
				$('div[id^=grpCode3_'+grpCode1+'_]').addClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_]').find('input[name=grpCode3]').prop('checked',true);
			}else if(depth == 2){
				$('#grpCode'+depth+'_'+grpCode1+'_'+grpCode2).addClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_'+grpCode2+'_]').addClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_'+grpCode2+'_]').find('input[name=grpCode3]').prop('checked',true);
			}else if(depth == 3){
				$('#grpCode'+depth+'_'+grpCode1+'_'+grpCode2+'_'+grpCode3).addClass('on');
			}
		}else{
			if(depth == 1){
				$('#grpCode'+depth+'_'+grpCode1).removeClass('on');
				$('div[id^=grpCode2_'+grpCode1+'_]').removeClass('on');
				$('div[id^=grpCode2_'+grpCode1+'_]').find('input[name=grpCode2]').prop('checked',false);
				$('div[id^=grpCode3_'+grpCode1+'_]').removeClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_]').find('input[name=grpCode3]').prop('checked',false);
			}else if(depth == 2){
				$('#grpCode'+depth+'_'+grpCode1+'_'+grpCode2).removeClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_'+grpCode2+'_]').removeClass('on');
				$('div[id^=grpCode3_'+grpCode1+'_'+grpCode2+'_]').find('input[name=grpCode3]').prop('checked',false);
			}else if(depth == 3){
				$('#grpCode'+depth+'_'+grpCode1+'_'+grpCode2+'_'+grpCode3).removeClass('on');
			}
		}
	}
	
	function fnSelCallUserGrp2(depth,val,trg){
		if($(trg).prop('checked') == true){
			$('#adGrp0'+depth+'_'+val).addClass('on');
		}else{
			$('#adGrp0'+depth+'_'+val).removeClass('on');
		}
	}
	
	function fnCallUserGrp2(){
		var grpCnt1 = 0;
		var grpCnt2 = 0;
		var grpCnt3 = 0;
		var cnt = 0;
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
			document.callUserGrpFrm2.proc.value = 'sch';
			document.callUserGrpFrm2.submit();
		}
		/*
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
		*/
	}
	
	function fnSch_callUserGrp2(grpFullName, adGrp01, adGrp02, adGrp03, adNM, adNum1, allCnt){
		var strRow = '<tr>'
		+'<td>'+grpFullName+'</td>'
		+'<td class="aC">'+adGrp01+'</td>'
		+'<td class="aC">'+adGrp02+'</td>'
		+'<td class="aC">'+adGrp03+'</td>'
		+'<td class="aC">'+adNM+'</td>'
		+'<td class="aC">'+adNum1+'</td>'
		+'</tr>';
		$('#callUserGrpList2 tbody').append(strRow);
	}
	
	function fnAddTrg_callUserGrp2(){
		var cnt = 0;
		$('form[name=callUserGrpFrm2] input[type=checkbox]').each(function(){
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
				document.callUserGrpFrm2.proc.value = 'add';
				document.callUserGrpFrm2.submit();
			}
		}
	}
	//	==============================================================================================
	
</script>