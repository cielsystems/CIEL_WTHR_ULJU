<!--#include virtual="/common/common.asp"-->

<%
dim clGB	: clGB	= fnReq("clGB")
dim tabNo	: tabNo	= fnReq("tabNo")
%>

<!--#include virtual="/common/header_pop.asp"-->

<%
dim arrAddrUpHeader : arrAddrUpHeader = array("이름",arrCallMedia(1),arrCallMedia(2),arrCallMedia(3))

dim arrAddrUpHeaderEx1	: arrAddrUpHeaderEx1	= array("홍길동","010-1234-5678","02-1234-5678","")
dim arrAddrUpHeaderEx2	: arrAddrUpHeaderEx2	= array("홍길동","010-1234-5678","02-1234-5678","")
%>

<form name="frm1" method="post" enctype="multipart/form-data" action="pop_trgUpFile.asp" target="popProcFrame" onsubmit="return false;">
	
	<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
		<colgroup>
			<col width="15%" />
			<col width="45%" />
			<col width="*" />
		</colgroup>
		<tr>
			<th>파일선택</th>
			<td>
				<input type="file" name="upfile" />
				주소록에추가 : 
				<label><input type="radio" name="addrAdd" value="N" checked />추가않함</label>
				<label><input type="radio" name="addrAdd" value="Y" />그룹추가</label>
			</td>
			<td class="aC">
				<img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_upload2.png" onclick="fnAddrUp()" />
				<img class="imgBtn" src="<%=pth_pubImg%>/btn/olive_sample2.png" onclick="fnAddrSample()" />
			</td>
		</tr>
	</table>
	
</form>

<form name="frm2" method="post" action="pop_trgUpProc.asp" target="popProcFrame" onsubmit="return false;">

	<input type="hidden" name="proc" value="" />
	<input type="hidden" name="upFileReal" value="" />
	<input type="hidden" name="addrAdd" value="" />
	
</form>

<p style="margin-top:5px;" class="fnt11 bld colBlue">▶ 연락처를 아래와 같이 지정된 형식의 엑셀파일로 업로드 합니다.</p>
<!--<div class="colRed">
	<div class="bld" style="font-size:15px;">※ 그룹에 엑셀파일 업로드시 기존에 등록되어 있던 연락처는 자동 삭제됩니다.</div>
</div>-->

<table id="xlsExmTbls1" width="100%" border="0" cellpadding="0" cellspacing="0" class="tblXls" style="margin-top:5px;">
	<colgroup>
		<col width="60px" />
		<col width="120px" />
		<col width="120px" />
		<col width="120px" />
		<col width="120px" />
		<col width="*" />
	</colgroup>
	<tr><th class="gb"></th><th>A</th><th>B</th><th>C</th><th>D</th><th>E</th></tr>
	<tr><td class="no fnt11">1</td>
		<% for i = 0 to ubound(arrAddrUpHeader) %>
			<td class="bld fnt11 aC"><%=arrAddrUpHeader(i)%></td>
		<% next %>
		<td></td>
	</tr>
	<%
	response.write	"<tr>"
	response.write	"<td class=""no fnt11"">2</td>"
	for ii = 0 to ubound(arrAddrUpHeaderEx1)
		response.write	"<td class=""fnt11"">" & arrAddrUpHeaderEx1(ii) & "</td>"
	next
	response.write	"<td class=""fnt11""></td>"
	response.write	"</tr>"
	response.write	"<tr>"
	response.write	"<td class=""no fnt11"">3</td>"
	for ii = 0 to ubound(arrAddrUpHeaderEx2)
		response.write	"<td class=""fnt11"">" & arrAddrUpHeaderEx2(ii) & "</td>"
	next
	response.write	"<td class=""fnt11""></td>"
	response.write	"</tr>"
	
	response.write	"<tr>"
	response.write	"<td class=""no fnt11"">4</td>"
	for ii = 0 to ubound(arrAddrUpHeaderEx1)
		response.write	"<td class=""fnt11""></td>"
	next
	response.write	"<td class=""fnt11""></td>"
	response.write	"</tr>"
	%>
</table>

<div style="border-top:2px solid #999999;margin:10px 0 5px 0;"></div>

<p class="fnt11 bld colPurple">▶ 업로드된 데이터 중 일부를 보여줍니다.</p>

<%
arrListHeader = arrAddrUpHeader
arrListWidth = array("25%","25%","25%","*")

call subListTable("listTbl")
%>
<div class="aC" style="margin-top:5px;">
	총 <span id="upCnt" class="bld colRed">0</span>건의 데이터가 업로드 대기중입니다.
</div>

<div class="aR" style="margin-top:10px;">
	<img class="imgBtn" src="<%=pth_pubImg%>/btn/purple_upCnl.png" onclick="fnAddrUpCnl()" />
	<img class="imgBtn" src="<%=pth_pubImg%>/btn/red_upCmp.png" onclick="fnAddrUpCmp()" />
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	$(function(){
		
	});
	
	function fnAddrUp(){
		fnFileUpChek('', 0);
		if($('input[name=upfile]').val().length == 0){
			alert('업로드할 파일을 선택해 주세요.');$('input[name=upfile]').focus();return false;
		}else{
			var file = $('input[name=upfile]').val();
			var arrFile	= file.split('.');
			var fileExt	= arrFile[arrFile.length-1];
			if(fileExt == 'xls' || fileExt == 'xlsx'){
				$('input[name=proc]').val('up');
				document.frm1.submit();
			}else{
				alert('엑셀파일(.xls 또는 .xlsx)만 업로드 가능합니다.');return false;
			}
		}
	}
	
	function fnAddrSample(){
		popProcFrame.location.href = '/data/target_upload_sample.xlsx';
	}
	
	function fnAddrUpCnl(){
		if(	$('input[name=upFileReal]').val().length > 0 && parseInt($('#upCnt').html()) > 0){
			$('input[name=proc]').val('cnl');
			document.frm2.submit();
		}else{
			alert('업로드된 파일이 없습니다.');return false;
		}
	}
	
	function fnAddrUpCmp(){
		if(	$('input[name=upFileReal]').val().length > 0 && parseInt($('#upCnt').html()) > 0){
			$('input[name=proc]').val('cmp');
			document.frm2.submit();
		}else{
			alert('업로드된 파일이 없습니다.');return false;
		}
	}
	
	function fnFileUpChek(upFile, cnt){
		$('form[name=frm2] input[name=addrAdd]').val($('form[name=frm1] input[name=addrAdd]').val());
		$('input[name=upFileReal]').val(upFile);
		$('#upCnt').html(cnt);
		$('#listTbl tbody tr').remove();
	}
	
	function fnViewData(args){
		var arrData	= args.split(']|[');
		var strRow = '<tr>';
		for(var i = 0; i < arrData.length; i++){
			strRow = strRow +'<td class="fnt11">'+arrData[i]+'</td>';
		}
		strRow = strRow + '</tr>';
		$('#listTbl tbody').append(strRow);
	}
	
</script>