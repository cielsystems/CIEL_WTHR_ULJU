<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<%
dim addrIndx	: addrIndx	= fnIsNull(nFnReq("addrIndx", 0), 0)

dim userIndx, addrGubn, addrSync, addrSort, addrName, addrNum1, addrNum2, addrNum3, addrMemo

if addrIndx > 0 then
	
	set rs = server.createobject("adodb.recordset")
	set cmd = server.createobject("adodb.command")
	with cmd

		.activeconnection = strDBConn
		.commandtext = "nusp_infoAddr"
		.commandtype = adCmdStoredProc
		
		.parameters.append .createParameter("@addrIndx",	adInteger,	adParamInput,		0)
		
		.parameters("@addrIndx")			= addrIndx
		
		set rs = .execute
		
	end with
	set cmd = nothing
	
	if not rs.eof then
		userIndx	= rs("USER_INDX")
		addrGubn	= rs("ADDR_GUBN")
		addrSync	= rs("ADDR_SYNC")
		addrSort	= rs("ADDR_SORT")
		addrName	= rs("ADDR_NAME")
		addrNum1	= rs("ADDR_NUM1")
		addrNum2	= rs("ADDR_NUM2")
		addrNum3	= rs("ADDR_NUM3")
		addrMemo	= rs("ADDR_MEMO")
	end if
	set rs = nothing

else
	
	userIndx	= ss_userIndx
	
end if

if userIndx = ss_userIndx or ss_userGubn < 21 then
	prmtAddr = "M"
end if

if ss_userGubn < 11 then
	prmtAddr = "A"
end if

'# 수정.삭제 권한 : 전체관리자, 부서관리자, 생성자, 최초생성
%>

<style type="text/css">
	
	select[name=grupIndx]	{width:80%;border:1px solid #ccc;background-color:#eee;color:#999;}
	select[name=grupIndx].on	{border:1px solid #666;background-color:#fff;color:#333;}
	
</style>

<div id="popBody">
	
	<form name="frm" method="post" action="pop_addrProc.asp" target="popProcFrame" onsubmit="return false;">
		
		<input type="hidden" name="proc" value="" />
		<input type="hidden" name="addrIndx" value="<%=addrIndx%>" />
		<input type="hidden" name="addrGubn" value="<%=addrGubn%>" />
		
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="15%" />
				<col width="*" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr>
				<th>이름</th>
				<td><input type="text" name="addrName" value="<%=addrName%>" /></td>
				<th><%=arrCallMedia(1)%></th>
				<td><input type="text" name="addrNum1" value="<%=addrNum1%>" class="phoneNumb" /></td>
			</tr>
			<tr>
				<th><%=arrCallMedia(2)%></th>
				<td><input type="text" name="addrNum2" value="<%=addrNum2%>" class="phoneNumb" /></td>
				<th><%=arrCallMedia(3)%></th>
				<td><input type="text" name="addrNum3" value="<%=addrNum3%>" class="phoneNumb" /></td>
			</tr>
			<!--
			<tr>
				<th>연계정보</th>
				<td colspan="3">
					<select name="addrGubn">
						<option value="N">일반</option>
						<option value="S">연계</option>
					</select>
					연계ID : <input type="text" name="addrSync" value="<%=addrSync%>" />
				</td>
			</tr>
			-->
			<tr>
				<th>메모</th>
				<td colspan="3"><textarea name="addrMemo" style="width:99%;height:60px;"><%=addrMemo%></textarea></td>
			</tr>
			<tr>
				<th>그룹<div class="mgT05"><button class="btn btn_sm bg_purple" onclick="fnOpenRel('G')">관리</button></div></th>
				<td colspan="3">
					<div class="scrollBox" style="height:60px">
						<ul class="itemList" id="addrRelList_G">
						</ul>
					</div>
				</td>
			</tr>
			<tr>
				<th>분류코드<div class="mgT05"><button class="btn btn_sm bg_purple" onclick="fnOpenRel('C')">관리</button></div></th>
				<td colspan="3">
					<div class="scrollBox" style="height:60px">
						<ul class="itemList" id="addrRelList_C">
						</ul>
					</div>
				</td>
			</tr>
		</table>
		
	</form>
	
	<div class="aC mgT10">
		<% if prmtAddr = "A" or prmtAddr = "M" then %>
			<% if addrIndx > 0 then %>
				<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_red_del.png" onclick="fnAddrProc('D')" />
			<% end if %>
			<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_blue_save.png" onclick="fnAddrProc('S')" />
		<% end if %>
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script type="text/javascript">
	
	$(function(){
		
		fnLoadRel('G');
		fnLoadRel('C');
		
		$('body').on('click', '.relItem', function(){
			$(this).parent().parent().remove();
		});
		
	});
	
	function fnLoadRel(gubn){
		var strInput	= '';
		if(gubn == 'G'){
			strInput = 'grupIndx';
		}else if(gubn == 'C'){
			strInput = 'addrCode';
		}
		$('#addrRelList_'+gubn+' li').remove();
		var params	= 'proc=list&relGubn='+gubn+'&addrIndx=<%=addrIndx%>';
		$.ajax({
			url	: 'ajxAddrRelProc.asp',
			type	: 'POST',
			data	: params,
			success	: function(rslt){
				console.log(rslt);
				var arrRslt	= rslt.split('}|{');
				if(arrRslt[0] > -1){
					var arrVal, strRow;
					for(var i = 1; i < arrRslt.length; i++){
						arrVal	= arrRslt[i].split(']|[');
						strRow = '<li class="type'+arrVal[3]+'">'+fnReplace(arrVal[1], '|', ' > ')+' > <strong>'+arrVal[2]+'</strong>';
						if(arrVal[4] == 'Y'){
							strRow = strRow +'	<span class="butn_box"><a class="relItem"><i class="fa fa-close"></i></a></span>';
						}
						strRow = strRow +'	<input type="hidden" name="'+strInput+'" value="'+arrVal[0]+'" />'
						+'</li>';
						$('#addrRelList_'+gubn).append(strRow);
					}
				}
			}
		});
	}
	
	function fnProcRel(proc, gubn, args){
		console.log(proc);
		console.log(gubn);
		console.log(args);
		var strInput	= '';
		if(gubn == 'G'){
			strInput = 'grupIndx';
		}else if(gubn == 'C'){
			strInput = 'addrCode';
		}
		var arrVal	= args.split(']|[');
		if(proc == 'A'){
			if($('input[name='+strInput+'][value='+arrVal[0]+']').length == 0){
				var strRow = '<li class="type'+arrVal[3]+'">'+fnReplace(arrVal[1], '|', ' > ')+' > <strong>'+arrVal[2]+'</strong>'
				if(arrVal[4] == 'Y'){
					strRow = strRow +'	<span class="butn_box"><a class="relItem"><i class="fa fa-close"></i></a></span>'
				}
				strRow = strRow +'	<input type="hidden" name="'+strInput+'" value="'+arrVal[0]+'" />'
				+'</li>';
				$('#addrRelList_'+gubn).append(strRow);
			}
		}else if(proc == 'D'){
			$('input[name='+strInput+'][value='+arrVal[0]+']').parent().remove();
		}
	}
	
	function fnOpenRel(gubn){
		fnPop('pop_addrRelForm.asp?relGubn='+gubn+'&addrIndx=<%=addrIndx%>', 'addrRelForm', 0, 0, 400, 500, 'no');
	}
	
	function fnAddrProc(proc){
		if(proc == 'S'){
			if($('input[name=addrName]').val().length == 0){
				alert('이름을 입력해 주세요.');$('input[name=addrName]').focus();return false;
			}
		}
		$('input[name=proc]').val(proc);
		document.frm.submit();
	}
	
</script>