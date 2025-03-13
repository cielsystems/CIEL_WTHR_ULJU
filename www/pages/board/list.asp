<!--#include virtual="/common/common.asp"-->

<%
dim gb : gb = fnIsNull(fnReq("gb"),1)

mnCD = "04" & right("0" & gb, 2)

dim cdBoardGB : cdBoardGB = 4000 + cInt(gb)


dim cdUsGB : cdUsGB = cInt(fnDBVal("TBL_ADDR", "CD_USERGB", "AD_IDX = " & ss_userIdx & ""))
%>

<!--#include virtual="/common/header_htm.asp"-->

<div id="subPageBox">
	
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<table align="left">
						<tr>
							<td><label>검색</label></td>
							<td>
								<select id="schKey" name="schKey">
									<option value="tit">제목</option>
									<option value="cont">내용</option>
									<option value="ID">아이디</option>
								</select>
								<input type="text" id="schVal" name="schVal" onkeypress="if(event.keyCode==13){fnLoadPage(1)}" />
							</td>
							<td><img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" title="검색" onclick="fnLoadPage(1)" /></td>
						</tr>
					</table>
						
				</td>
				<td class="aR">
					총 <b><span id="cntAll">0</span></b>건
				</td>
			</tr>
		</table>
		
	</div>
	
	<div class="aR">
		<%
		if gb = 1 then
			if cdUsGB < 1002 then
				%><img class="imgBtn" src="<%=pth_pubImg%>/btn/blue_add.png" onclick="fnBoardForm(0)" /><%
			end if
		else
			%><img class="imgBtn" src="<%=pth_pubImg%>/btn/blue_add.png" onclick="fnBoardForm(0)" /><%
		end if
		%>
	</div>
		
	<%
	arrListHeader = array("번호","제목","작성자","작성일","조회수")
	arrListWidth = array("100px","*","120px","160px","80px")
	
	call subListTable("listTbl")
	%>
	
</div>

<!--#include virtual="/common/footer_htm.asp"-->

<script>
	
	var page = 1;
	var pageSize = 10;
	var rowCnt = 0;
	
	$(function(){
		
		fnLoadPage(1);
		
	});
	
	function fnLoadPage(p){
		page = p;
		var param = 'proc=boardList&param=<%=cdBoardGB%>]|['+$('#schKey').val()+']|['+$('#schVal').val()+'&page='+page+'&pageSize='+pageSize;
		param = encodeURI(param);
		var list = fnGetHttp('/pages/public/ajxList.asp?'+param);
		var arrList = list.split('}|{');
		rowCnt = arrList[0];
		$('#cntAll').html(rowCnt);
		$('#listTbl tbody tr').remove();
		if(rowCnt > 0){
			var strRow, arrVal, fileYN = '';
			for(i = 2; i < arrList.length; i++){
				arrVal = arrList[i].split(']|[');
				//	BD_IDX(2), BD_TIT(3), BD_FILEYN(4), BD_VISIT(5), AD_ID(6), REGDT(7)
				if(arrVal[4] == 'Y')	fileYN = ' <img src="<%=pth_pubImg%>/icons/paper-clip.png" />';
				strRow = '<tr style="cursor:pointer;" onclick="fnBoardView('+arrVal[2]+')" onmouseover="fnListOver(this)" onmouseout="fnListOut(this)">'
				+'	<td class="aC">'+(arrVal[0]-arrVal[1]+1)+'</td>'
				+'	<td class="aL">'+arrVal[3]+fileYN+'</td>'
				+'	<td class="aC">'+arrVal[6]+'</td>'
				+'	<td class="aC">'+arrVal[7]+'</td>'
				+'	<td class="aR">'+arrVal[5]+'</td>'
				+'</tr>';
				$('#listTbl tbody').append(strRow);
			}
		}
		$('#listPaging').html(arrList[1]);
	}
	
	function fnListOver(trg){
		$(trg).css('background','#EEF5F9');
	}
	
	function fnListOut(trg){
		$(trg).css('background','#ffffff');
	}
	
	function fnBoardForm(idx){
		layerW = 800;
		layerH = 700;
		var url = 'pop_form.asp?gb=<%=gb%>&bdIdx='+idx;
		var strProc = '수정';
		if(idx == 0)	strProc = '작성';
		fnOpenLayer('게시판 글'+strProc,url);
	}
	
	function fnBoardView(idx){
		layerW = 800;
		layerH = 700;
		var url = 'pop_view.asp?bdIdx='+idx;
		fnOpenLayer('게시판 글보기',url);
	}
	
</script>