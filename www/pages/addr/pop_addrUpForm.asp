<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<%
dim col, row
dim arrSampleWidths : arrSampleWidths = array("60px","80px","80px","80px","80px","90px","90px","90px","90px","80px","80px","*")
dim arrListWidths : arrListWidths = array("100px","100px","100px","100px","100px","80px","90px","90px","90px","100px","*")
dim arrAddrUpHeader : arrAddrUpHeader = array("부서(그룹)1","부서(그룹)2","부서(그룹)3","부서(그룹)4","부서(그룹)5"_
	,"이름",arrCallMedia(1),arrCallMedia(2),arrCallMedia(3),"메모","분류코드")

dim arrSampleRows(2)
arrSampleRows(0) = array("부서1","부서1-1","","","","홍길동","010-1234-5678","02-1234-5678","","","")
arrSampleRows(1) = array("부서1","부서1-1","","","","홍길서","010-5678-1122","02-2323-6767","","","")
arrSampleRows(2) = array("","","","","","","","","","","")
%>

<div id="popBody">
	
	<form name="frm1" method="post" enctype="multipart/form-data" action="pop_addrUpFile.asp" target="popProcFrame" onsubmit="return false;">
		
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>구분</th>
				<td>
					<select name="grupGubn" class="fnt12">
						<option value="D">직원</option>
						<option value="P">개인</option>
					</select>
				</td>
				<th>파일선택</th>
				<td>
					<input type="file" name="upfile" class="fnt12"/>
					기존연락처
					<label><input type="radio" name="oldAddrDel" value="N" checked />유지</label>
					<label><input type="radio" name="oldAddrDel" value="Y" />삭제</label>
				</td>
				<td class="aC">
					<img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_upload2.png" onclick="fnAddrUp()" />
					<img class="imgBtn" src="<%=pth_pubImg%>/btn/olive_sample2.png" onclick="fnAddrSample()" />
				</td>
			</tr>
		</table>
		
	</form>
	
	<form name="frm2" method="post" action="pop_addrUpProc.asp" target="popProcFrame" onsubmit="return false;">
	
		<input type="hidden" name="proc" value="" />
		<input type="hidden" name="grupGubn" value="" />
		<input type="hidden" name="upFileReal" value="" />
		<input type="hidden" name="oldAddrDel" value="" />
		
	</form>
	
	<p style="margin-top:5px;" class="fnt11 bld colBlue">▶ 연락처를 아래와 같이 지정된 형식의 엑셀파일로 업로드 합니다.</p>
	<!--<div class="colRed">
		<div class="bld" style="font-size:15px;">※ 그룹에 엑셀파일 업로드시 기존에 등록되어 있던 연락처는 자동 삭제됩니다.</div>
	</div>-->
	
	<table id="xlsExmTbls1" width="100%" border="0" cellpadding="0" cellspacing="0" class="tblXls" style="margin-top:5px;">
		<colgroup>
<%for col = 0 to ubound(arrSampleWidths)%>
			<col width="<%=arrSampleWidths(col)%>" />
<%next%>
		</colgroup>
		<tr><th class="gb"></th><th>A</th><th>B</th><th>C</th><th>D</th><th>E</th><th>F</th><th>G</th><th>H</th><th>I</th><th>J</th><th>K</th></tr>
		<tr>
			<td class="no fnt11">1</td>
<%for col = 0 to ubound(arrAddrUpHeader)%>
			<td class="bld fnt11 aC"><%=arrAddrUpHeader(col)%></td>
<%next%>
		</tr>
<%for row = 0 to ubound(arrSampleRows)%>
		<tr>
			<td class="no fnt11"><%=row+2%></td>
<% 	for col = 0 to ubound(arrSampleRows(row)) %>
			<td class="fnt11"><%=arrSampleRows(row)(col)%></td>
<% 	next %>
		</tr>
<%next%>
	</table>
	
	<div style="border-top:2px solid #999999;margin:10px 0 5px 0;"></div>
	
	<p class="fnt11 bld colPurple"></p>
	
	<div style="height:380px;">
		<table border="0" cellpadding="0" cellspacing="1" id="listTbl" class="tblList">
			<colgroup>
<%for col = 0 to ubound(arrListWidths)%>
				<col width="<%=arrListWidths(col)%>" />
<%next%>
			</colgroup>
			<thead>
				<tr>
<%for col = 0 to ubound(arrAddrUpHeader)%>
					<th><%=arrAddrUpHeader(col)%></th>
<%next%>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
		<div id="listPaging"></div>
		<div class="aC" style="margin-top:5px;">
			총 <span id="totalCnt" class="bld colRed">0</span>건 중에서 <span id="upCnt" class="bld colBlue">0</span>건의 데이터가 업로드 대기중입니다.
		</div>
	</div>
	
	<div class="aR" style="margin-top:10px;">
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/purple_upCnl.png" onclick="fnAddrUpCnl()" />
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/red_upCmp.png" onclick="fnAddrUpCmp()" />
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script defer type="text/javascript" src="/plugins/SheetJS/xlsx.full.min.js"></script>
<script defer type="text/javascript" src="/plugins/FileSaver.js-2.0.4/FileSaver.min.js"></script>
<script defer type="text/javascript" src="/js/obj_util.js"></script>
<script defer type="text/javascript" src="/js/excel_util.js"></script>
<script defer type="text/javascript" src="/js/page_util.js"></script>
<script type="text/javascript">
	var xlsData = [];
	var uploadData = [];
	var pageNo = 1;
	var pageSize = 10;

	$(function(){
		displayData(1);
	});
	
	// 엑셀 파일 선택
	function fnAddrUp(){
		if($('input[name=upfile]').val().length == 0) {
			alert('업로드할 파일을 선택해 주세요.');
			$('input[name=upfile]').focus();
			return;
		}
		var files = $('form[name=frm1] input[name=upfile]')[0].files;
		if (files.length <= 0) {
			alert('선택된 파일이 없습니다.');
			$('input[name=upfile]').focus();
			return;
		}
		// 업로드 파일 확장자 체크
		var f = files[0];
		var ext = getExtension(f.name);
		if (ext != '.xls' && ext != '.xlsx') {
			alert('xls, xlsx 파일만 업로드 가능합니다.');
			fnFileUpChek('', 0);
			$('input[name=upfile]').focus();
			return;
		}

		// 엑셀 파일 읽기
		var reader = new FileReader();
		reader.onload = function(e) {
			var data = e.target.result;
			var wb = XLSX.read(data, {type: 'binary'});
			readExcel(wb);
		};
		reader.readAsBinaryString(f);
	}

	// 엑셀 데이터 로드
	function readExcel(wb) {
		if (wb.SheetNames.length <= 0) {
			alert('엑셀 파일이 잘 못 되었습니다.');
			return;
		}
		var sheetName = wb.SheetNames[0];
		var ws = wb.Sheets[sheetName];
		var arrData;

		// 업로드 엑셀 컬럼 형식 검사
		if (!checkExcelHeader(ws, 
				['부서(그룹)1', '부서(그룹)2', '부서(그룹)3', '부서(그룹)4', '부서(그룹)5', 
				'이름', '휴대폰', '사무실전화', '기타전화', '메모', 
				'분류코드'])) {
			alert('엑셀 파일의 서식이 일치하지 않습니다.');
			return;
		}
		// 엑셀 데이터를 해더를 제외하고 배열로 가져온다.
		arrData = XLSX.utils.sheet_to_json(ws, {header:1, raw:false});

		xlsData = [];
		uploadData = [];
		pageNo = 1;
		for (var row = 1; row < arrData.length; ++row) {
			if (isEmptyRow(arrData[row])) break;

			xlsData.push(arrData[row]);
			if (arrData[row].length >= 7 && 
					!isNullOrEmpty(arrData[row][0]) && 
					!isNullOrEmpty(arrData[row][5]) && 
					!isNullOrEmpty(arrData[row][6])) {
				uploadData.push({
					grp1: arrData[row][0],
					grp2: arrData[row][1],
					grp3: arrData[row][2],
					grp4: arrData[row][3],
					grp5: arrData[row][4],
					name: arrData[row][5],
					phoneNo1: arrData[row][6],
					phoneNo2: arrData[row][7],
					phoneNo3: arrData[row][8],
					memo: arrData[row][9],
					code: arrData[row][10]
				});
			}
		}
		// console.log('items : ' + JSON.stringify(xlsData));
		// 로드된 데이터 출력
		displayData(1);
	}

	// 로드된 데이터 한 행 전체가 비어 있는지 체크
	function isEmptyRow(rowData) {
		for (var col = 0; col < rowData.length; ++col) {
			if (!isNullOrEmpty(rowData[col])) return false;
		}
		return true;
	}

	// 로드된 데이터 출력
	function displayData(page) {
		var item;
		var startRow, endRow;
		var row, col;

		pageNo = page < 1 ? 1 : page;
		startRow = (pageNo - 1) * pageSize;
		endRow = (pageNo * pageSize) > xlsData.length ? xlsData.length : (pageNo * pageSize);

		$('#listTbl tbody tr').remove();
		for (var i = 0; i < pageSize; ++i) {
			row = startRow + i;
			item = '<tr>';
			if (row < endRow) {
				if (xlsData[row].length >= 7 && 
						!isNullOrEmpty(xlsData[row][0]) && 
						!isNullOrEmpty(xlsData[row][5]) && 
						!isNullOrEmpty(xlsData[row][6])) {
					for (col = 0; col < xlsData[row].length; ++col) {
						item += '<td class="fnt11 aC">' + (isNullOrEmpty(xlsData[row][col]) ? '' : xlsData[row][col]) + '</td>';
					}
					for (;col < 11; ++col) {
						item += '<td class="fnt11 aC"></td>';
					}
				} else {
					for (col = 0; col < xlsData[row].length; ++col) {
						item += '<td class="fnt11 aC bg_err">' + (isNullOrEmpty(xlsData[row][col]) ? '' : xlsData[row][col]) + '</td>';
					}
					for (;col < 11; ++col) {
						item += '<td class="fnt11 aC bg_err"></td>';
					}
				}
			} else {
				item += '<td class="fnt11">&nbsp;</td>';
				for (col = 1; col < 11; ++col) {
					item += '<td class="fnt11"></td>';
				}
			}
			item += '</tr>';
			$('#listTbl tbody').append(item);
		}
		// 페이지네이션 출력
		displayPage(pageNo, pageSize, xlsData.length, 'displayData');
		// 업로드 데이터 건수 출력
		$('#totalCnt').html(xlsData.length);
		$('#upCnt').html(uploadData.length);
	}
	
	// 연락처 업로드 샘플 단운로드
	function fnAddrSample(){
		popProcFrame.location.href = '/data/addr_upload_sample.xlsx';
	}
	
	// 업로드 취소
	function fnAddrUpCnl(){
		if (uploadData.length > 0) {
			if (confirm('업로드된 데이터가 있습니다. 취소하시겠습니까?')) {
				return;
			}
		}
		parent.fnCloseLayer();
	}
	
	// 업로드 완료
	function fnAddrUpCmp(){
		if (uploadData.length <= 0) {
			alert('업로드할 데이터가 없습니다.');
			return;
		}

		$.ajax({
			url: 'pop_addrUpProc.asp',
			type: 'POST',
			dataType: 'json',
			contentType: 'application/json; charset=utf-8',
			data: JSON.stringify({
				grpGb: $('select[name=grupGubn]').val(),
				oldAddrDel: $('input[name=oldAddrDel]:checked').val(),
				data: uploadData
			}),
			success: function(result) {
				if (result.resCode != 0) {
					alert('code : ' + result.resCode + '\r\n' + 'message : ' + result.resMsg);
					return;
				}
				alert('업로드가 완료되었습니다.');
				// parent.fnCloseLayer();
			},
			error: function(error) {
				alert('오류가 발생하였습니다.\r\n' + error.responseText);
			}
		});
	}
	
	// 업로드할 엑셀 파일 체크
	function fnFileUpChek(upFile, cnt){
		$('form[name=frm2] input[name=oldAddrDel]').val($('form[name=frm1] input[name=oldAddrDel]').val());
		$('input[name=upFileReal]').val(upFile);
		$('#upCnt').html(cnt);
		$('#listTbl tbody tr').remove();
	}
	
</script>