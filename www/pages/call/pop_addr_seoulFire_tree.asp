<!--#include virtual="/common/common.asp"-->

<%
dim tabNo	: tabNo	= fnReq("tabNo")

dim gb
select case tabNo
	case "1"	: gb = "D"
	case "2"	: gb = "E"
	case "3"	: gb = "P"
end select

arrCols = array("GRP_CODE","GRP_NM")
sqlW = "USEYN = 'Y' and GRP_UPCODE = '0' and GRP_GB = '" & gb & "'"
dim nTopGrpInfo : nTopGrpInfo = fnDBArrVal("TBL_GRP", arrCols, sqlW)
dim topGrpCD, topGrpNM
if ubound(nTopGrpInfo) > 0 then
	topGrpCD = nTopGrpInfo(0)
	topGrpNM = nTopGrpInfo(1)
end if
'response.write	topGrpCD
%>

<!--#include virtual="/common/header_pop.asp"-->

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<colgroup>
		<col width="340px" />
		<col width="10px" />
		<col width="*" />
	</colgroup>
	<tr>
		<td>  
			
			<div id="tree" class="treeBox">
				<div class="treeItem treeDepth1" id="item_<%=topGrpCD%>">
					<div class="item" onclick="fnSelUp()">
						<img src="<%=pth_pubImg%>/tree/address-book_<%=tabNo%>.png" />
						<input type="hidden" name="grpDepth" value="1" />
						<input type="hidden" name="grpCD" value="<%=topGrpCD%>" />
						<span id="itemSpan_<%=topGrpCD%>"><%=topGrpNM%></span>
					</div>
					<div class="subItem" id="treeSub_<%=topGrpCD%>">
<%
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
'#	1Depth Start	==============================================================
'sql = " select GRP_CODE, GRP_UPCODE, GRP_NM from TBL_GRP "
'sql = sql & " where USEYN = 'Y' and GRP_GB = '" & gb & "' and GRP_UPCODE = " & topGrpCD & " "
'if gb = "D" then
'	if cdUsGB < 1002 or adPerAddr = "A" then
'	else
'		sql = sql & " 	and GRP_CODE = (select GRP_CODE from TBL_ADDR where AD_IDX = " & ss_userIdx & ") "
'	end if
'elseif gb = "P" then
'	sql = sql & " 	and AD_IDX = " & ss_userIdx & " "
'end if
'sql = sql & " order by GRP_SORT "
'grpRs1 = execSqlRs(sql)
grpRs1 = execProcRs(sqlProc, array(gb, topGrpCD, ss_userIdx))
if isarray(grpRs1) then
	grpRc1 = ubound(grpRs1,2)
else
	grpRc1 = -1
end if
for i = 0 to grpRc1
	response.write	"<div class=""treeItem treeDepth2"" id=""item_" & grpRs1(0,i) & """>"
	response.write	"	<div class=""item"" onclick=""fnSelGrp(3," & grpRs1(0,i) & ")"">"
	response.write	"		<img class=""imgBtn"" src=""" & pth_pubImg & "/tree/folder.png"" />"
	response.write	"		<input type=""hidden"" name=""grpDepth"" value=""3"" />"
	response.write	"		<input type=""hidden"" name=""grpCD"" value=""" & grpRs1(0,i) & """ />"
	response.write	"		<span id=""itemSpan_" & grpRs1(0,i) & """>" & grpRs1(2,i) & "</span>"
	response.write	"	</div>"
	'#	2Depth Start	==============================================================
	'sql = " select GRP_CODE, GRP_UPCODE, GRP_NM from TBL_GRP "
	'sql = sql & " where USEYN = 'Y' and GRP_GB = '" & gb & "' and GRP_UPCODE = " & grpRs1(0,i) & " "
	'sql = sql & " order by GRP_SORT "
	'grpRs2 = execSqlRs(sql)
	grpRs2 = execProcRs(sqlProc, array(gb, grpRs1(0,i), ss_userIdx))
	if isarray(grpRs2) then
		grpRc2 = ubound(grpRs2,2)
	else
		grpRc2 = -1
	end if
	if grpRc2 > -1 then
		response.write	"	<div class=""subItem"" id=""treeSub_" & grpRs1(0,i) & """ style=""display:none;"">"
		for ii = 0 to grpRc2
			response.write	"<div class=""treeItem treeDepth3"" id=""item_" & grpRs2(0,ii) & """>"
			response.write	"	<div class=""item"" onclick=""fnSelGrp(4," & grpRs2(0,ii) & ")"">"
			response.write	"		<img class=""imgBtn"" src=""" & pth_pubImg & "/tree/folder.png"" />"
			response.write	"		<input type=""hidden"" name=""grpDepth"" value=""4"" />"
			response.write	"		<input type=""hidden"" name=""grpCD"" value=""" & grpRs2(0,ii) & """ />"
			response.write	"		<span id=""itemSpan_" & grpRs2(0,ii) & """>" & grpRs2(2,ii) & "</span>"
			response.write	"	</div>"
			'#	3Depth Start	==============================================================
			'sql = " select GRP_CODE, GRP_UPCODE, GRP_NM from TBL_GRP "
			'sql = sql & " where USEYN = 'Y' and GRP_GB = '" & gb & "' and GRP_UPCODE = " & grpRs2(0,ii) & " "
			'sql = sql & " order by GRP_SORT "
			'grpRs3 = execSqlRs(sql)
			grpRs3 = execProcRs(sqlProc, array(gb, grpRs2(0,ii), ss_userIdx))
			if isarray(grpRs3) then
				grpRc3 = ubound(grpRs3,2)
			else
				grpRc3 = -1
			end if
			if grpRc3 > -1 then
				response.write	"	<div class=""subItem"" id=""treeSub_" & grpRs2(0,ii) & """ style=""display:none;"">"
				for iii = 0 to grpRc3
					response.write	"<div class=""treeItem treeDepth4"" id=""item_" & grpRs3(0,iii) & """>"
					response.write	"	<div class=""item"" onclick=""fnSelGrp(5," & grpRs3(0,iii) & ")"">"
					response.write	"		<img class=""imgBtn"" src=""" & pth_pubImg & "/tree/folder.png"" />"
					response.write	"		<input type=""hidden"" name=""grpDepth"" value=""5"" />"
					response.write	"		<input type=""hidden"" name=""grpCD"" value=""" & grpRs3(0,iii) & """ />"
					response.write	"		<span id=""itemSpan_" & grpRs3(0,iii) & """>" & grpRs3(2,iii) & "</span>"
					response.write	"	</div>"
					'#	4Depth Start	==============================================================
					'sql = " select GRP_CODE, GRP_UPCODE, GRP_NM from TBL_GRP "
					'sql = sql & " where USEYN = 'Y' and GRP_GB = '" & gb & "' and GRP_UPCODE = " & grpRs3(0,iii) & " "
					'sql = sql & " order by GRP_SORT "
					'grpRs4 = execSqlRs(sql)
					grpRs4 = execProcRs(sqlProc, array(gb, grpRs3(0,iii), ss_userIdx))
					if isarray(grpRs4) then
						grpRc4 = ubound(grpRs4,2)
					else
						grpRc4 = -1
					end if
					if grpRc4 > -1 then
						response.write	"	<div class=""subItem"" id=""treeSub_" & grpRs3(0,iii) & """ style=""display:none;"">"
						for iiii = 0 to grpRc4
							response.write	"<div class=""treeItem treeDepth5"" id=""item_" & grpRs4(0,iiii) & """>"
							response.write	"	<div class=""item"" onclick=""fnSelGrp(5," & grpRs4(0,iiii) & ")"">"
							response.write	"		<img class=""imgBtn"" src=""" & pth_pubImg & "/tree/folder.png"" />"
							response.write	"		<input type=""hidden"" name=""grpDepth"" value=""6"" />"
							response.write	"		<input type=""hidden"" name=""grpCD"" value=""" & grpRs4(0,iiii) & """ />"
							response.write	"		<span id=""itemSpan_" & grpRs4(0,iiii) & """>" & grpRs4(2,iiii) & "</span>"
							response.write	"	</div>"
							'#	4Depth Start	==============================================================
							'sql = " select GRP_CODE, GRP_UPCODE, GRP_NM from TBL_GRP "
							'sql = sql & " where USEYN = 'Y' and GRP_GB = '" & gb & "' and GRP_UPCODE = " & grpRs4(0,iiii) & " "
							'sql = sql & " order by GRP_SORT "
							'grpRs5 = execSqlRs(sql)
							grpRs5 = execProcRs(sqlProc, array(gb, grpRs4(0,iiii), ss_userIdx))
							if isarray(grpRs5) then
								grpRc5 = ubound(grpRs5,2)
							else
								grpRc5 = -1
							end if
							if grpRc5 > -1 then
								response.write	"	<div class=""subItem"" id=""treeSub_" & grpRs4(0,iiii) & """ style=""display:none;"">"
								for iiiii = 0 to grpRc5
									response.write	"<div class=""treeItem treeDepth6"" id=""item_" & grpRs5(0,iiiii) & """>"
									response.write	"	<div class=""item"" onclick=""fnSelGrp(5," & grpRs5(0,iiiii) & ")"">"
									response.write	"		<img class=""imgBtn"" src=""" & pth_pubImg & "/tree/folder.png"" />"
									response.write	"		<input type=""hidden"" name=""grpDepth"" value=""7"" />"
									response.write	"		<input type=""hidden"" name=""grpCD"" value=""" & grpRs5(0,iiiii) & """ />"
									response.write	"		<span id=""itemSpan_" & grpRs5(0,iiiii) & """>" & grpRs5(2,iiiii) & "</span>"
									response.write	"	</div>"
									response.write	"</div>"
								next
								response.write	"	</div>"
							end if
							'#	5Depth Start	==============================================================
							response.write	"</div>"
						next
						response.write	"	</div>"
					end if
					'#	4Depth Start	==============================================================
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
		<td valign="bottom">
			
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<select id="schKey" name="schKey">
							<option value="NM">이름</option>
							<option value="NUM">번호</option>
						</select>
						<input type="text" id="schVal" name="schVal" onkeypress="if (event.keyCode==13) {fnSch()}" />
						<img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" title="검색" onclick="fnSch()" />
					</td>
					<td class="aR">
						연락처 <span id="cntAll">0</span>명
					</td>
				</tr>
			</table>
			
			<form name="frmTrg" method="post" action="pop_addrProc.asp" target="popProcFrame">
				<input type="hidden" name="proc" value="selAdd" />
				
				<div class="addrList" style="height:420px;margin-top:8px;">
					<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tblList" style="margin-top:0;">
						<thead>
							<colgroup>
								<col width="30px" />
								<col width="*" />
								<col width="80px" />
								<col width="90px" />
								<col width="90px" />
								<!--<col width="90px" />-->
								<col width="30px" /
							</colgroup>
							<tr>
								<th><input type="checkbox"" name="allChk" onclick="fnTrgAllSel()" style="" /></th>
								<th>부서</th>
								<th>이름</th>
								<th>직급</th>
								<% for j = 1 to ubound(arrCallMedia)-2 %>
									<th><%=arrCallMedia(j)%>번호</th>
								<% next %>
								<th></th>
							</tr>
						</thead>
					</table>
					<table width="100%" border="0" cellpadding="0" cellspacing="1" id="addrList" class="tblList" style="margin-top:1px;border:0;">
						<thead>
							<colgroup>
								<col width="30px" />
								<col width="*" />
								<col width="80px" />
								<col width="90px" />
								<col width="90px" />
								<!--<col width="90px" />-->
								<col width="30px" />
							</colgroup>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
				
			</form>
							
		</td>
	</tr>
</table>       

<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-top:10px;">
	<tr>
		<td class="aR">
			<span style="font-size:12px;">총 <b id="selTrgCount" class="selTrgCount">0</b>명 선택</span>
			&nbsp;&nbsp;&nbsp;
			<img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_selAdd2.png" title="선택추가" onclick="fnSelAddTrg()" />
		</td>
	</tr>
</table>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	var nGrpCD = <%=topGrpCD%>;
	
	$(function(){
		<% if tabNo = 1 then %>
			parent.tabsFrame2.location.href = 'pop_addr_seoulFire_tree.asp?tabNo=2';
		<% elseif tabNo = 2 then %>
			parent.tabsFrame3.location.href = 'pop_addr_seoulFire_tree.asp?tabNo=3';
		<% elseif tabNo = 3 then %>
			parent.tabsFrame4.location.href = 'pop_addr_seoulFire_typeCall.asp?tabNo=4';
		<% end if %>
	});
	
	function fnSch(){
		//if(nGrpCD.length == 0 || nGrpCD == <%=topGrpCD%>){
		//	alert('검색할 부서를 선택하세요.');
		//}else{
			fnLoadAddr(nGrpCD);
		//}
	}
	
	function fnSelGrp(depth,upcd){
		if(nGrpCD != upcd){
			$('#treeSub_'+upcd).css('display','block');
			$('.treeItem .item').find('span').removeClass('on');
			$('#itemSpan_'+upcd).addClass('on');
			nGrpCD = upcd;
			fnLoadAddr(nGrpCD,1);
		}else{
			$('#treeSub_'+upcd).css('display','none');
			$('.treeItem .item').find('span').removeClass('on');
			nGrpCD = 0;
		}
	}
	
	function fnSelUp(){
		nGrpCD = '<%=topGrpCD%>';
		$('.treeItem .item').find('span').removeClass('on');
		$('#itemSpan_<%=topGrpCD%>').addClass('on');
	}
	
	function fnLoadAddr(grpCD){
		$('input[name=allChk]').prop('checked',false);
		var schKey = $('select[name=schKey]').val();
		var schVal = $('input[name=schVal]').val();
		schVal = encodeURI(schVal);
		var url = '/pages/public/ajxAddrList_trg.asp?grpGB=<%=gb%>&grpCD='+grpCD+'&schKey='+schKey+'&schVal='+schVal;
		var result = fnGetHttp(url);
		var arrResult = result.split('}|{');
		$('#addrList tbody tr').remove();
		var rowCnt = arrResult[0];
		$('#cntAll').html(rowCnt);
		if(rowCnt > 0){
			var arrVal, strRow;
			for(var i = 1; i < arrResult.length; i++){
				arrVal = arrResult[i].split(']|[');
				//	AD_IDX(0), AD_NM(1), AD_NUM1(2), AD_NUM2(3), AD_NUM3(4), AD_EMAIL(5), AD_MEMO(6), TRGYN(7)
				if(arrVal[7] == 'Y'){
					strRow = '<tr>'
					+'	<td class="aC colGray"><input type="checkbox" name="adIdx" value="'+arrVal[0]+'" onclick="fnCountTrg()" disabled /></td>'
					+'	<td class="fnt11 colGray">'+arrVal[8]+'</td>'
					+'	<td class="aC colGray">'+arrVal[1]+'</td>'
					+'	<td class="aC colGray">'+arrVal[9]+'</td>'
					//+'	<td class="aC colGray">'+arrVal[5]+'</td>'
					+'	<td class="aC colGray">'+arrVal[2]+'</td>'
					//+'	<td class="aC colGray">'+arrVal[3]+'</td>'
					//+'	<td class="aC colGray">'+arrVal[4]+'</td>'
					+'	<td class="aC"><img class="imgBtn" src="<%=pth_pubImg%>/icons/minus.png" onclick="fnDelTrg('+arrVal[0]+')" /></td>'
					+'</tr>';
				}else{
					strRow = '<tr>'
					+'	<td class="aC"><input type="checkbox" name="adIdx" value="'+arrVal[0]+'" onclick="fnCountTrg()" /></td>'
					+'	<td class="fnt11">'+arrVal[8]+'</td>'
					+'	<td class="aC">'+arrVal[1]+'</td>'
					+'	<td class="aC">'+arrVal[9]+'</td>'
					//+'	<td class="aC">'+arrVal[5]+'</td>'
					+'	<td class="aC">'+arrVal[2]+'</td>'
					//+'	<td class="aC">'+arrVal[3]+'</td>'
					//+'	<td class="aC">'+arrVal[4]+'</td>'
					+'	<td class="aC"><img class="imgBtn" src="<%=pth_pubImg%>/icons/plus.png" onclick="fnAddTrg('+arrVal[0]+')" /></td>'
					+'</tr>';
				}
				$('#addrList tbody').append(strRow);
			}
		}
	}
	
	function fnCountTrg(){		// 선택 대상 Count
		selTrg = 0;
		$('#addrList tbody tr input[type=checkbox]').each(function(){
			if($(this).prop('checked') == true){
				selTrg = selTrg + 1;
			}
		});
		$('#selTrgCount').html(selTrg);
	}
	
	function fnTrgAllSel(){		// 전체선택
		if($('input[name=allChk]').prop('checked') == true){
			$('#addrList tbody tr').find('input[type=checkbox]').prop('checked',true);
		}else{
			$('#addrList tbody tr').find('input[type=checkbox]').prop('checked',false);
		}
		fnCountTrg();
	}
	
	function fnSelAddTrg(tp){		// 선택대상 추가
		if(selTrg > 0){
			//fnLoadingS();
			document.frmTrg.submit();
			$('#addrList tbody tr input[type=checkbox]').prop('checked',false);
			$('input[name=allChk'+tp+']').prop('checked',false);
			fnCountTrg(tp);
		}else{
			alert('추가할 연락처를 선택하세요.');return;
		}
	}
	
	function fnAddTrg(idx){		// 대상추가
		popProcFrame.location.href = 'pop_addrProc.asp?proc=addTrg&adIdx='+idx;
	}
	
	function fnDelTrg(idx){		// 대상제외
		popProcFrame.location.href = 'pop_addrProc.asp?proc=delTrg&adIdx='+idx;
	}
	
	function fnAllStfAdd(){
		if(confirm('전직원을 대상자로 추가하시겠습니까?')){
			popProcFrame.location.href = 'pop_addrProc.asp?proc=allStf';
		}
	}
	
</script>