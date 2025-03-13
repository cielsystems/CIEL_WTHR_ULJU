<!--#include virtual="/common/common.asp"-->

<%
dim gb : gb = fnReq("gb")
dim bdIdx : bdIdx = fnIsNull(fnReq("bdIdx"),0)

dim cdBoardGB, cdBoaerdGBNM
cdBoardGB = 4000 + cint(gb)

dim proc : proc = "I"
dim bdTit, bdCont, bdFile01, bdFile02, bdFile03

if bdIdx > 0 then
	
	proc = "U"
	
	sql = " select BD_TIT, BD_CONT, BD_FILE01 from TBL_BOARD with(nolock) where BD_IDX = " & bdIdx & " "
	dim bdInfo : bdInfo = execSqlArrVal(sql)
	if isarray(bdInfo) then
		bdTit = bdInfo(0)
		bdCont = bdInfo(1)
		bdFile01 = bdInfo(2)
	end if
	
end if

cdBoaerdGBNM = fnDBVal("TBL_CODE", "CD_NM", "CD_CODE = " & cdBoardGB & "")
%>

<!--#include virtual="/common/header_pop.asp"-->

<script src="<%=pth_pub%>/ckeditor/ckeditor.js"></script>

<div id="popBody">
	
	<form name="frm" method="post" enctype="multipart/form-data" action="pop_proc.asp" target="popProcFrame">
		<input type="hidden" name="proc" value="<%=proc%>" />
		<input type="hidden" name="cdBoardGB" value="<%=cdBoardGB%>" />
		<input type="hidden" name="bdIdx" value="<%=bdIdx%>" />
		
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="120px" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>구분</th>
				<td><%=cdBoaerdGBNM%></td>
			</tr>
			<tr>
				<th>제목</th>
				<td><input type="text" name="bdTit" value="<%=bdTit%>" size="80" maxlength="100" /></td>
			</tr>
			<tr>
				<td colspan="2"><textarea name="bdCont" id="bdCont" class="ckeditor" style="width:100%;height:400px;"><%=bdCont%></textarea></td>
			</tr>
			<tr>
				<th>파일첨부</th>
				<td>
					<input type="file" name="upfile1" />
					<!--<img class="imgBtn" src="<%=pth_pubImg%>/btn/blue_fileup2.png" onclick="fnFileUp()" />-->
				</td>
			</tr>
		</table>
		
	</form>
	
	<div class="btnBox">
		<% if bdIdx > 0 then %>
			<img class="imgBtn" src="<%=pth_pubImg%>/btn/b_red_del.png" alt="삭제" onclick="fnDel()" />
		<% end if %>
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/b_blue_save.png" alt="저장" onclick="fnSave()" />
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script type="text/javascript">
	
	var frm = document.frm;
	
	$('input[name=bdTit]').focus();
	
	function fnSave(){
		if(frm.bdTit.value == ''){
			alert('제목을 입력하세요.');frm.bdTit.focus();return;
		}
		var editor = CKEDITOR.instances.bdCont;
		frm.bdCont.value = editor.getData();
		if(frm.bdCont.value == ''){
			alert('내용을 입력하세요.');frm.bdCont.focus();return;
		}
		frm.submit();
	}
	
	function fnFileDel(){
		if(confirm('파일을 삭제하시겠습니까?')){
			frm.proc.value = 'fileDel';
			frm.submit();
		}
	}
	
	function fnDel(){
		if(confirm('삭제하시겠습니까?')){
			frm.proc.value = 'del';
			frm.submit();
		}
	}
	
</script>