<!--#include virtual="/common/common.asp"-->

<%
mnCD = "1002"
%>

<!--#include virtual="/common/header_adm.asp"-->

<div id="subPageBox">
	
	<form name="frm" method="post" action="deptProc.asp" target="procFrame">
		<input type="hidden" name="proc" value="" />
		
		<div class="aR">
			<span class="fnt13 bld"><a href="javascript:fnReSelGrp(0)"><span class="colPurple" style="background:#eeeeee;border:1px solid #cccccc;padding:2px 5px 2px 5px;">부서</span></a> > </span>
			<span id="nGrpFullName" class="fnt13 colPurple bld"></span>
			<input type="hidden" name="grpDepth" value="0" />
			<input type="hidden" name="grpCD" value="1" />
			<input type="text" name="grpNM" style="font-size:13px;height:20px;font-weight:bold;" size="24" />
			사용여부 : <input type="checkbox" name="useYN" value="Y" />
			<img class="imgBtn" src="<%=pth_pubImg%>/btn/green_add.png" onclick="fnGrpAdd()" />
			<img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_mod.png" onclick="fnGrpMod()" />
			<img class="imgBtn" src="<%=pth_pubImg%>/btn/red_del.png" onclick="fnGrpDel()" />
		</div>
		
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<% for i = 1 to g_useGrpDepth %>
					<col width="<%=100/g_useGrpDepth%>%" />
				<% next %>
			</colgroup>
			<tr>
				<% for i = 1 to g_useGrpDepth %>
					<th><%=i%> Depth</th>
				<% next %>
			</tr>
			<tr>
				<% for i = 1 to g_useGrpDepth %>
					<td>
						<select id="grpCode<%=i%>" name="grpCode<%=i%>" size="20" style="width:99%;height:auto;" onchange="fnSelGrp(<%=i+1%>)"></select>
					</td>
				<% next %>
			</tr>
		</table>
	
	</form>
	
</div>

<!--#include virtual="/common/footer_adm.asp"-->

<script>
	
	var selGrp = new Array;
	
	var grpDepth = 0;
	var nGrpCD = 1;
	var nGrpNM = '';
	var nGrpFullName = '';
	
	$(function(){
		
		fnLoadGrp(1,1);
		
	});
	
	function fnReSelGrp(depth){
		for(i = depth+1; i < <%=g_useGrpDepth+1%>; i++){
			$('#grpCode'+i).find('option').remove();
		}
		if(depth == 0){
			nGrpCD = 1;
			nGrpNM = '';
			nGrpFullName = '';
			$('input[name=grpDepth]').val(0);
			$('input[name=grpCD]').val(nGrpCD);
			$('input[name=grpNM]').val(nGrpNM);
			$('#nGrpFullName').html(nGrpFullName);
			fnLoadGrp(1,1);
		}else{
			fnSelGrp(depth+1);
		}
	}
	
	function fnSelGrp(depth){
		grpDepth = depth-1;
		nGrpCD = $('#grpCode'+(depth-1)+' option:selected').val();
		nGrpDepth = depth-1;
		nGrpNM = $('#grpCode'+(depth-1)+' option:selected').text();
		nGrpFullName = fnGetHttp('ajxGrpFullName.asp?proc=up&grpCD='+nGrpCD);
		$('input[name=grpDepth]').val(nGrpDepth);
		$('input[name=grpCD]').val(nGrpCD);
		$('input[name=grpNM]').val(nGrpNM);
		var useYN = fnGetHttp('ajxGrpUseYN.asp?grpCD='+nGrpCD);
		if(useYN == 'Y'){
			$('input[name=useYN]').prop('checked',true);
		}else{
			$('input[name=useYN]').prop('checked',false);
		}
		$('#nGrpFullName').html(nGrpFullName);
		fnLoadGrp(depth,nGrpCD);
	}
	
	function fnLoadGrp(depth,upcd){	// 그룹 가져오기
		var trg = $('#grpCode'+depth);
		for(i = depth; i < <%=g_useGrpDepth+1%>; i++){
			$('#grpCode'+i).find('option').remove();
		}
		var result = fnGetHttp('/pages/public/ajxGrpListAdm.asp?proc=M&grpGB=D&grpUpCD='+upcd);
		var arrResult = result.split('}|{');
		var rowCnt = arrResult[0];
		if(rowCnt > 0){
			var arrVal, strRow;
			for(var i = 1; i < arrResult.length; i++){
				arrVal = arrResult[i].split(']|[');
				//	GRP_CD, GRP_UPCODE, GRP_NM, CNT, USEYN
				strRow = '<option value="'+arrVal[0]+'"';
				if(arrVal[0] == selGrp[depth]){
					strRow = strRow + ' selected ';
				}
				if(arrVal[9] == 'Y'){
					strRow = strRow + ' style="color:blue"';
				}else{
					strRow = strRow + ' style="color:gray"';
				}
				strRow = strRow + ' >'+arrVal[2]+'</option>';
				$(trg).append(strRow);
			}
		}
	}
	
	function fnGrpAdd(){
		if(document.frm.grpNM.value == ''){
			alert('부서명을 입력하세요.');document.frm.grpNM.focus();return;
		}
		document.frm.proc.value = 'I';
		document.frm.submit();
	}
	
	function fnGrpMod(){
		if(nGrpCD == 0){
			alert('수정할 부서를 선택하세요.');return;
		}else{
			if(document.frm.grpNM.value == ''){
				alert('부서명을 입력하세요.');document.frm.grpNM.focus();return;
			}
			document.frm.proc.value = 'U';
			document.frm.submit();
		}
	}
	
	function fnGrpDel(){
		if(nGrpCD == 0){
			alert('삭제할 부서를 선택하세요.');return;
		}else{
			if(confirm('해당부서를 삭제하시겠습니까?')){
				document.frm.proc.value = 'D';
				document.frm.submit();
			}
		}
	}
	
</script>