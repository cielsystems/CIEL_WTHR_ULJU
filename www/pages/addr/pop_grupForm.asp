<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<%
dim proc	: proc	= fnIsNull(nFnReq("proc", 4), "S")

dim grupGubn	: grupGubn	= fnIsNull(nFnReq("grupGubn", 1), "")
dim grupUper	: grupUper	= fnIsNull(nFnReq("grupUper", 0), 0)
dim grupIndx	: grupIndx	= fnIsNull(nFnReq("grupIndx", 0), 0)

dim grupDpth, grupSort, grupName, grupUperName, addrRelCnt

set rs = server.createobject("adodb.recordset")
set cmd = server.createobject("adodb.command")
with cmd

	.activeconnection = strDBConn
	.commandtext = "nusp_infoGrup"
	.commandtype = adCmdStoredProc
	
	.parameters.append .createParameter("@grupIndx",	adInteger,	adParamInput,		0)
	.parameters.append .createParameter("@grupUper",	adInteger,	adParamInput,		0)
	
	.parameters("@grupIndx")			= grupIndx
	.parameters("@grupUper")			= grupUper
	
	set rs = .execute
	
end with
set cmd = nothing
if not rs.eof then
	grupGubn	= rs("GRUP_GUBN")
	grupUper	= rs("GRUP_UPER")
	grupDpth	= rs("GRUP_DPTH")
	grupSort	= rs("GRUP_SORT")
	grupName	= rs("GRUP_NAME")
	grupDpth	= rs("GRUP_DPTH")
	grupSort	= rs("GRUP_SORT")
	grupUperName	= rs("GRUP_UPER_NAME")
	addrRelCnt	= rs("ADDRRELCNT")
end if
set rs = nothing

'= 0:시스템관리자/10:전체관리자/20:부서관리자/50:일반사용자/90:문자사용자
if grupGubn = "D" then
	if ss_userGubn < 11 then	'= 직원주소록은 전체관리자 이상 모든권한
		prmtGrup	= "A"
	elseif ss_userGubn < 21 then	'= 직원주소록은 부서관리자 이상 자기부서권한
		prmtGrup	= "M"
	end if
elseif grupGubn = "C" then
	if ss_userGubn < 21 then	'= 발령주소록은 부서관리자 이상 모든권한
		prmtGrup	= "A"
	end if
elseif grupGubn = "P" then
	'= 개인주소록은 모두에게 모든권한
	prmtGrup	= "A"
end if

'#	자기부서권한인 경우 해당 상위부서의 권한을 확인한다.
if prmtGrup = "M" then
	if proc = "A" then
		if fnDBVal("NTBL_USER_GRUP_PRMT", "count(*)", "USER_INDX = " & nFnChekLeng(ss_userIndx, 0) & " and GRUP_INDX = " & nFnChekLeng(grupUper, 0) & "") = 0 then
			response.write	"<script type=""text/javascript"">"
			response.write	"alert('해당 그룹에 권한이 없습니다.');top.fnCloseLayer();"
			response.write	"</script>"
			response.end
		end if
	else
		if fnDBVal("NTBL_USER_GRUP_PRMT", "count(*)", "USER_INDX = " & nFnChekLeng(ss_userIndx, 0) & " and GRUP_INDX = " & nFnChekLeng(grupIndx, 0) & "") = 0 then
			response.write	"<script type=""text/javascript"">"
			response.write	"alert('해당 그룹에 권한이 없습니다.');top.fnCloseLayer();"
			response.write	"</script>"
			response.end
		end if
	end if
end if

'#	최상위그룹 제한
if grupDpth = 0 then
	response.write	"<script type=""text/javascript"">"
	response.write	"alert('최상위 그룹은 편집할수 없습니다.');top.fnCloseLayer();"
	response.write	"</script>"
	response.end
end if

'#	Depth 제한
if grupDpth > g_useGrpDepth then
	response.write	"<script type=""text/javascript"">"
	response.write	"alert('더이상 하위그룹을 생성할 수 없습니다.');top.fnCloseLayer();"
	response.write	"</script>"
	response.end
end if
%>

<style type="text/css">
	
	.addrCodeBox	{width:99%;}
	
</style>

<div id="popBody">
	
	<form name="frm" method="post" action="pop_grupProc.asp" target="popProcFrame" onsubmit="return false;">
		
		<input type="hidden" name="proc" value="<%=proc%>" />
		<input type="hidden" name="grupGubn" value="<%=grupGubn%>" />
		<input type="hidden" name="grupUper" value="<%=grupUper%>" />
		<input type="hidden" name="grupIndx" value="<%=grupIndx%>" />
		
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="30%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>상위그룹</th>
				<td><%=grupUperName%></td>
			</tr>
			<tr>
				<th>그룹명</th>
				<td><input type="text" name="grupName" value="<%=grupName%>" maxlength="30" /></td>
			</tr>
			<tr>
				<th>정렬순서</th>
				<td><input type="text" name="grupSort" value="<%=grupSort%>" class="onlyNumb" maxlength="10" /></td>
			</tr>
			<tr>
				<th>인원수</th>
				<td><strong><%=formatNumber(addrRelCnt, 0)%></strong>명 <span class="color_red">(중복제외)</span></td>
			</tr>
		</table>
		
		<% if grupGubn = "C" then %>
			
			<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
				<tr>
					<th>주소록그룹 <button class="btn btn_sm bg_purple" onclick="fnOpenRel('G')">관리</button></th>
				</tr>
				<tr>
					<td>
						<div class="scrollBox" style="height:80px;">
							<ul class="itemList" id="addrRelList_G">
							</ul>
						</div>
					</td>
				</tr>
			</table>
			
			<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
				<tr>
					<th>분류코드 <button class="btn btn_sm bg_purple" onclick="fnOpenRel('C')">관리</button></th>
				</tr>
				<tr>
					<td>
						<div class="scrollBox" style="height:80px;">
							<ul class="itemList" id="addrRelList_C">
							</ul>
						</div>
					</td>
				</tr>
			</table>
			
			<div class="color_red">
				* 주소록그룹과 분류코드는 <b>and 조건(교집합)</b>으로 처리됩니다.
			</div>
			
		<% end if %>
		
	</form>
	
	<div class="aC mgT10">
		<% if prmtGrup = "A" or prmtGrup = "M" then %>
			<% if grupIndx > 0 then %>
				<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_red_del.png" onclick="fnGrupProc('D')" />
			<% end if %>
			<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_blue_save.png" onclick="fnGrupProc('S')" />
		<% end if %>
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script type="text/javascript">
	
	$(function(){
		
		fnLoadRel('G');
		fnLoadRel('C');
		
	});
	
	function fnLoadRel(gubn){
		var strInput	= '';
		if(gubn == 'G'){
			strInput = 'grupIndxRel';
		}else if(gubn == 'C'){
			strInput = 'addrCode';
		}
		$('#addrRelList_'+gubn+' li').remove();
		var params	= 'proc=list&relGubn='+gubn+'&grupIndx=<%=grupIndx%>';
		$.ajax({
			url	: 'ajxGrupRelProc.asp',
			type	: 'POST',
			data	: params,
			success	: function(rslt){
				console.log(rslt);
				var arrRslt	= rslt.split('}|{');
				if(arrRslt[0] > -1){
					var arrVal, strRow;
					for(var i = 1; i < arrRslt.length; i++){
						arrVal	= arrRslt[i].split(']|[');
						strRow = '<li id="addrCode_'+arrVal[0]+'" class="type'+arrVal[3]+'">'+fnReplace(arrVal[1], '|', ' > ')+' > <strong>'+arrVal[2]+'</strong>'
						+' 	<span class="color_teal">'+arrVal[5]+'명</span>'
						+'	<span class="butn_box"><a href="javascript:fnTrgtGrupDel('+arrVal[0]+')"><i class="fa fa-close"></i></a></span>'
						+'	<input type="hidden" name="'+strInput+'" value="'+arrVal[0]+'" />'
						+'</li>';
						$('#addrRelList_'+gubn).append(strRow);
					}
				}
			}
		});
	}
	
	function fnProcRel(proc, gubn, args){
		var strInput	= '';
		if(gubn == 'G'){
			strInput = 'grupIndxRel';
		}else if(gubn == 'C'){
			strInput = 'addrCode';
		}
		var arrVal	= args.split(']|[');
		if(proc == 'A'){
			if($('input[name='+strInput+'][value='+arrVal[0]+']').length == 0){
				var strRow = '<li id="addrCode_'+arrVal[0]+'" class="type'+arrVal[3]+'">'+fnReplace(arrVal[1], '|', ' > ')+' > <strong>'+arrVal[2]+'</strong>'
				+' 	<span class="color_teal">'+arrVal[5]+'명</span>'
				+'	<span class="butn_box"><a href="javascript:fnTrgtGrupDel('+arrVal[0]+')"><i class="fa fa-close"></i></a></span>'
				+'	<input type="hidden" name="'+strInput+'" value="'+arrVal[0]+'" />'
				+'</li>';
				$('#addrRelList_'+gubn).append(strRow);
			}
		}else if(proc == 'D'){
			$('input[name='+strInput+'][value='+arrVal[0]+']').parent().remove();
		}
	}
	
	function fnTrgtGrupDel(indx){
		$('#addrCode_'+indx).remove();
	}
	
	function fnOpenRel(gubn){
		fnPop('pop_addrRelForm.asp?relGubn='+gubn+'&grupIndx=<%=grupIndx%>', 'grupRelForm', 0, 0, 400, 500, 'no');
	}
	
	function fnGrupProc(proc){
		if(proc == 'S'){
			if($('input[name=grupName]').val().length == 0){
				alert('그룹명을 입력해 주세요.');$('input[name=grupName]').focus();return false;
			}
		}
		$('input[name=proc]').val(proc);
		$.ajax({
			url	: 'pop_grupProc.asp',
			type	: 'POST',
			data	: $('form[name=frm]').serialize(),
			success	: function(rslt){
				console.log(rslt);
				var arrRslt	= rslt.split('|');
				alert(arrRslt[1]);
				console.log(arrRslt[0]);
				if(arrRslt[0] == 0){
					top.fnReloadGrup(arrRslt[2], arrRslt[3]);
				}
			},
			fail	: function(rslt){
				alert('오류가 발생했습니다.');
			}
		});
	}
	
</script>