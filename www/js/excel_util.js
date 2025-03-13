// 확장자 추출
function getExtension(fileName) {
    var pos, fileExt;
    pos = fileName.lastIndexOf('.');
    fileExt = fileName.substring(pos, fileName.length).toLowerCase();
    return fileExt;
}

// 엑셀 해더 검사
function checkExcelHeader(sheet, headers) {
    range = XLSX.utils.decode_range(sheet['!ref']);
    var row = range.s.r;
    var maxCol;
    var colCnt = range.e.c - range.s.c + 1;
    if (headers.length < colCnt) {
        maxCol = headers.length;
    } else if (headers.length > colCnt) {
        return false;
    } else {
        maxCol = colCnt - range.s.c;
    }
    var cell, val;
    for (var col = range.s.c; col < maxCol; col++) {
        cell = sheet[XLSX.utils.encode_cell({c:col, r:row})];
        val = '';
        if (cell && cell.t) val = XLSX.utils.format_cell(cell);
        if (val != headers[col]) {
            return false;
        }
    }
    return true;
}

