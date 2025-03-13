
var xmlhttp = null;
var posX, posY;
var layerW, layerH;

//	================================================================================================
//	HTTP Response
//	------------------------------------------------------------------------------------------------
function fnGetHttp(url){
	if(window.XMLHttpRequest){
		xmlhttp = new XMLHttpRequest();
	}else{
		xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.open('GET', url, false);
	xmlhttp.onreadystratechange = function(){
		if(xmlhttp.readyState == 4 && xmlhttp.stetus == 200 && xmlhttp.statusText == 'OK'){
			responseText = xmlhttp.responseText;
			xmlhttp = null;
		}
	}
	xmlhttp.send();
	return responseText = xmlhttp.responseText;
}
//	================================================================================================



//	================================================================================================
//	Location Href
//	------------------------------------------------------------------------------------------------
function fnHref(url){
	location.href = url;
}
//	================================================================================================



//	================================================================================================
//	Popup Open
//	------------------------------------------------------------------------------------------------
function fnPop(url,nm,t,l,w,h,scrollYN){
	if(scrollYN == 'Y')	scrollYN = 'yes';
	var objWin = window.open(url,nm,'top='+t+',left='+l+',width='+w+',height='+h+',scrollbars='+scrollYN+'');
	objWin.focus();
}
//	================================================================================================



//	================================================================================================
//	Mask Layer Open & Close
//	------------------------------------------------------------------------------------------------
function fnOpenLayer(tit,contUrl){

	var maskPop = '<div id="mask"></div>'
	+'<div id="layerBox">'
	+	'<table width="100%" border="0" cellpadding="0" cellspacing="0">'
	+		'<tr>'
	+			'<td id="layerHeader"></td>'
	+			'<td id="layerBtn" class="aR"><a href="javascript:fnCloseLayer()"><img src="/public/images/close.png" title="닫기" /></a></td>'
	+		'</tr>'
	+		'<tr><td colspan="2" id="layerCont"></td></tr>'
	+	'</table>'
	+'</div>';
	$('body').append(maskPop);

	var cont = '<iframe class="layerFrame" name="layerFrame" src="'+contUrl+'" frameborder="0" scrolling="no" style="width:'+(layerW)+'px;height:'+(layerH-40)+'px;"></iframe>';

	var mask = $('#mask');
	var id = $('#layerBox');

	var maskHeight = $(document).height();
	var maskWidth = $(window).width();

	mask.css({'width':maskWidth,'height':maskHeight});
	mask.fadeTo("fast",0.7);

	$('#layerHeader').html(tit);
	$('#layerCont').html(cont);

	var winH = $(window).height();
	var winW = $(window).width();
	$(id).css('width', layerW);
	$(id).css('height', layerH);

	layerW = layerW - 20;

	$('#layerHeader').find('li').eq(0).css('width',(layerW*0.2)+'px');
	$('#layerHeader').find('li').eq(1).css('width',(layerW*0.6)+'px');
	$('#layerHeader').find('li').eq(2).css('width',(layerW*0.2)+'px');

	var top = (document.body.scrollTop + document.documentElement.scrollTop) + (winH/2-id.height()/2);
	var left = (document.body.scrollLeft + document.documentElement.scrollLeft) + (winW/2-id.width()/2);

	$(id).css('top',top+'px');
	$(id).css('left',left+'px');

	$(id).fadeIn(100);
}
//	------------------------------------------------------------------------------------------------
function fnCloseLayer(){
	var mask = $('#mask');
	var id = $('#layerBox');
	mask.fadeOut(100);
	id.fadeOut(100);
	$('#mask').remove();
	$('#layerBox').remove();
	//$('#layerHeader').html('');
	//$('#layerCont').html('');
	$('input[type=text]:first').focus();
}
//	================================================================================================



//	================================================================================================
//	Position Layer Open & Close
//	------------------------------------------------------------------------------------------------
function fnOpenPosLayer(w,h,url){
	var posLayer = '<div id="posLayer"><iframe name="posLayerFrame" frameborder="0" scrolling="no" src=""></iframe></div>';
	$('body').append(posLayer);
	$('#posLayer').css('display','block');
	$('#posLayer').css('top',posY);
	$('#posLayer').css('left',posX);
	$('#posLayer').css('width',w+'px');
	$('#posLayer').css('height',h+'px');
	posLayerFrame.location.href = url;
}
//	------------------------------------------------------------------------------------------------
function fnClosePosLayer(){
	$('#posLayer').remove();
}
//	================================================================================================



//	================================================================================================
//	Calendar Open
//	------------------------------------------------------------------------------------------------
function fnOpenCal(trg){
	fnOpenPosLayer(200,210,'/public/etc/calendar.asp?trg='+trg)
}
//	================================================================================================



//	================================================================================================
//	List Table Header Print
//	------------------------------------------------------------------------------------------------
function fnTblListHeader(strTrg,arrHeader){
	var arrVal = arrHeader.split('|');
	var strRow = '<tr>'
	for(i=0; i<arrVal.length; i++){
		strRow = strRow + '<th>'+arrVal[i]+'</th>';
	}
	strRow = strRow + '</tr>';
	$('#'+strTrg+' tr').remove();
	$('#'+strTrg).append(strRow);
}
//	================================================================================================



//	================================================================================================
//	List Checkbox AllCheck
//	------------------------------------------------------------------------------------------------
function fnAllCheck(nm,trg){
	var chk = document.getElementsByName(nm);
	if($(trg).is(':checked')){
		for(i=0; i<chk.length; i++){
			chk[i].checked = true;
		}
	}else{
		for(i=0; i<chk.length; i++){
			chk[i].checked = false;
		}
	}
}
//	================================================================================================



//	================================================================================================
//	Checkbox Checked Count
//	------------------------------------------------------------------------------------------------
function fnChecked(nm){
	var chk = document.getElementsByName(nm);
	var rtn = 0;
	for(i=0; i<chk.length; i++){
		if(chk[i].checked == true){
			rtn++;
		}
	}
	return rtn;
}
//	================================================================================================



//	================================================================================================
//	Number Check
//	------------------------------------------------------------------------------------------------
function fnNumberCheck(str){
	var rtn = true;
	for(i=0; i<str.length; i++){
		if((str.charAt(i) < "0") || (str.charAt(i) > "9")){
			rtn = false;
			break;
		}
	}
	return rtn;
}
//	================================================================================================



//	================================================================================================
//	Byte Count
//	------------------------------------------------------------------------------------------------
function fnByte(objMsg){
	var nbytes = 0;
	for(i=0; i<objMsg.length; i++){
		var ch = objMsg.charAt(i);
		if(escape(ch).length > 4) { // 한글일경우
			nbytes += 2;
		}else if (ch == '\n') { // 줄바꿈일경우
			if (objMsg.charAt(i-1) != '\r') { // 하지만 밀려서 줄이 바뀐경우가 아닐때
				nbytes += 1;
			}
		//}else if (ch == '<' || ch == '>') { // 특수문자는 4byte
		//	nbytes += 4;
		} else { //나머지는 모두 1byte
			nbytes += 1;
		}
	}//END FOR
	return nbytes;
}
function fnByteNew(objMsg){
	var strLen = objMsg.length;
	var nbyte = 0;
	var nChar, escChar;
	for(i=0; i<strLen; i++){
		nChar = objMsg.charAt(i);
		escChar = escape(nChar);
		if(nChar == '`' || nChar == '¨' || nChar == '¸' || nChar == '§'){
			nbyte++;
		}
		if(escChar.length > 4){
			nbyte += 2;
		}else if(nChar != '\r'){
			nbyte += 1;
		}
	}
	return nbyte;
}
//	================================================================================================



//	================================================================================================
//	Byte Maxlength
//	------------------------------------------------------------------------------------------------
function fnByteMaxlength(nm,len){
	var objMsg = $('#'+nm).val();
	var objBytePrint = $('#'+nm+'_printByte');
	var nbytes = fnByte(objMsg);
	if(nbytes > len-1){
		alert(len+'Byte 가 초과된 내용은 잘립니다.');
		$('#'+nm).val(fnCutString(objMsg,len));
		$(objBytePrint).html(fnByte($('#'+nm).val()));
	}else{
		$(objBytePrint).html(nbytes);
	}
}
//	================================================================================================



//	================================================================================================
//	String Split Count
//	------------------------------------------------------------------------------------------------
function fnSplit(str,len){
	str = encodeURI(str);
	var nLen = fnGetHttp('/pages/public/ajxCheckByte.asp?proc=split&len='+len+'&msg='+str);
	return nLen;
}
//	================================================================================================



//	================================================================================================
//	String Cut
//	------------------------------------------------------------------------------------------------
function fnCutString(strVal, intLen){
	var s = '';
	var i = 0;
	for(k = 0; k < strVal.length; k++){
		if(escape(strVal.charAt(k)).length > 4){
			i += 2;
		}else{
			i++;
		}
		if(i > intLen){
			return unescape(s);
		}else{
			s += escape(strVal.charAt(k));
		}
	}
	return unescape(s);
}
//	================================================================================================



//	================================================================================================
//	------------------------------------------------------------------------------------------------
function fnNumberFormat(intVal){
	return intVal;
}
//	================================================================================================



//	================================================================================================
//	------------------------------------------------------------------------------------------------
function cutStr(str,limit){
	var tmpStr = str;
	var byte_count = 0;
	var len = str.length;
	var dot = "";

	for(i=0; i<len; i++){
		byte_count += chr_byte(str.charAt(i));
		if(byte_count == limit-1){
			if(chr_byte(str.charAt(i+1)) == 2){
				tmpStr = str.substring(0,i+1);
				dot = "...";
			}else {
				if(i+2 != len) dot = "..";
				tmpStr = str.substring(0,i+2);
			}
			break;
		}else if(byte_count == limit){
			if(i+1 != len) dot = "...";
			tmpStr = str.substring(0,i+1);
			break;
		}
	}
	return tmpStr+dot;
}
//	================================================================================================



//	================================================================================================
//	------------------------------------------------------------------------------------------------
function chr_byte(chr){
	if(escape(chr).length > 4)
		return 2;
	else
		return 1;
}
//	================================================================================================



//	================================================================================================
//	Loading Layer Start & End
//	------------------------------------------------------------------------------------------------
function fnLoadingS(){
	$('body').append('<div class="loadingModal"></div>');
	$("body").addClass("loading");
}
function fnLoadingE(){
	$('.loadingModal').remove();
	$("body").removeClass("loading");
}
//	================================================================================================



//	================================================================================================
//	Replace All
//	------------------------------------------------------------------------------------------------
function fnReplace(strNum,str1,str2){
	var tmpStr = '';
	var tmpChar;
	var tmpLen = strNum.length;
	for(i = 0; i < tmpLen; i++){
		tmpChar = strNum.substr(i,str1.length);
		if(tmpChar == str1){
			tmpStr = tmpStr + str2;
		}else{
			tmpStr = tmpStr + tmpChar;
		}
	}
	return tmpStr;
}
//	================================================================================================



//	================================================================================================
//	Number Check
//	------------------------------------------------------------------------------------------------
function fnNumberCheck2(str){
	var rtn = true;
	for(i=0; i<str.length; i++){
		if((str.charAt(i) < "0") || (str.charAt(i) > "9") || str.charAt(i) != '-'){
			rtn = false;
			break;
		}
	}
	return rtn;
}
//	================================================================================================



//	================================================================================================
//	String Get Only Number
//	------------------------------------------------------------------------------------------------
function fnGetNumber(strNum){
	var tmpStr = '';
	var tmpChar;
	var tmpLen = strNum.length;
	for(i = 0; i < tmpLen; i++){
		tmpChar = strNum.substr(i,1);
		if(parseInt(tmpChar) || tmpChar == 0){
			tmpStr = tmpStr + tmpChar;
		}
	}
	return tmpStr;
}
//	================================================================================================



//	================================================================================================
//	Check Mobile Number
//	------------------------------------------------------------------------------------------------
function fnChkMobile(strNum){
	var tmpRtn = false;
	strNum = fnReplace(strNum,'-','');
	if(fnNumberCheck(strNum) != true){
		tmpRtn = false;
	}else{
		var tmpStr = fnGetNumber(strNum);
		var tmpLeft;
		if(tmpStr.length < 10 || tmpStr.length > 11){
			tmpRtn = false;
		}else{
			tmpLeft = tmpStr.substr(0,3);
			if(tmpLeft == '010' || tmpLeft == '011' || tmpLeft == '016' || tmpLeft == '017' || tmpLeft == '018' || tmpLeft == '019'){
				tmpRtn = true;
			}else{
				tmpRtn = false;
			}
		}
	}
	return tmpRtn;
}
//	================================================================================================



//	================================================================================================
//	Check Phnoe Number
//	------------------------------------------------------------------------------------------------
function fnChkPhone(strNum){
	var tmpRtn = false;
	strNum = fnReplace(strNum,'-','');
	if(fnNumberCheck2(strNum) != true){
		tmpRtn = false;
	}else{
		var tmpStr = fnGetNumber(strNum);
		var tmpLeft;
		if(tmpStr.length < 7 || tmpStr.length > 12){
			tmpRtn = false;
		}else{
			tmpRtn = true;
		}
	}
	return tmpRtn;
}
//	================================================================================================


function fnPrtNums(str){
	str = str.replace(/[^0-9]/g,'');
	var tmp = '';
	if(str.substr(0,1) == '0'){
		tmp = str.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
	}else{
		tmp = str.replace(/(^[0-9]+)([0-9]{4})/,"$1-$2");
	}
	return tmp;
}