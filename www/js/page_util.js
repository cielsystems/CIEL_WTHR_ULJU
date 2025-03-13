function displayPage(pageNo, pageSize, totalCount, displayFnc) {
    const maxPageBlock = 10;
    var pageBlock = parseInt(((totalCount < 1 ? 1 : totalCount) + (pageSize - 1)) / pageSize);
    var page = '';
    var startBlock, endBlock;
/*
    if (pageBlock < maxPageBlock) {
        startBlock = 1;
        endBlock = pageBlock;
    } else {
        if (pageNo <= 5) {
            startBlock = 1;
            endBlock = startBlock + (maxPageBlock - 1);
        } else if (pageNo > 5 && pageNo + 4 < pageBlock) {
            endBlock = pageNo + 4;
            startBlock = endBlock - (maxPageBlock - 1);
        } else {
            endBlock = pageBlock;
            startBlock = endBlock - (maxPageBlock - 1);
        }
    }
/*/
    startBlock = parseInt((pageNo - 1) / maxPageBlock) * maxPageBlock + 1;
    endBlock = startBlock + maxPageBlock - 1 > pageBlock ? pageBlock : startBlock + maxPageBlock - 1;
//*/    
    page += '<div id="paging">';
    if (pageNo > 1) {
        page += '<a href="javascript:' + displayFnc + '(1)"><img src="/public/images/icons/control-left-stop.png"/></a>';
    } else {
        page += '<img src="/public/images/icons/control-left-stop.png"/>';
    }
    if (pageNo > 1) {
        page += '<a href="javascript:' + displayFnc + '(' + (pageNo - 1) + ')"><img src="/public/images/icons/control-left.png"/></a>';
    } else {
        page += '<img src="/public/images/icons/control-left.png" />';
    }
    page += '&nbsp;&nbsp;';
    for (var i = startBlock; i <= endBlock; i++) {
        if (i > startBlock) page += '&nbsp;&nbsp;|&nbsp;&nbsp';
        if (i == pageNo) {
            page += '<span class="on">' + i + '</span>';
        } else {
            page += '<span><a href="javascript:' + displayFnc + '(' + i + ')">' + i + '</a></span>';
        }
    }
    page += '&nbsp;&nbsp;';
    if (pageNo < pageBlock) {
        page += '<a href="javascript:' + displayFnc + '(' + (pageNo + 1) + ')"><img src="/public/images/icons/control-right.png"/></a>';
    } else {
        page += '<img src="/public/images/icons/control-right.png"/>';
    }
    if (pageNo < pageBlock) {
        page += '<a href="javascript:' + displayFnc + '(' + pageBlock + ')"><img src="/public/images/icons/control-right-stop.png"/></a>';
    } else {
        page += '<img src="/public/images/icons/control-right-stop.png"/>';
    }
    page += '</div>';
    $('#listPaging').html(page);
}