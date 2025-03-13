$(function(){
	
	//	Only Number
	$('.onlyNumb').keyup(function(){
		if(fnNumberCheck($(this).val()) != true){
			$(this).val(fnGetNumber($(this).val()));
			alert('숫자만 입력해 주세요.');$(this).focus();
		}
	});
	
});


function fnOpenLayerPop(w,h,tit,url){
	layerW = w;
	layerH = h;
	fnOpenLayer(tit,url);
}

function fnOpenLayerContBox(trg){
	var result;
	$.ajax({
		url:'/pages/public/ajxLayerContBox.asp?proc='+trg
	}).done(function(data){
		result = data;
		var layBox = '<div id="layerContBox" class="layerContBox"></div>';
		$('body').append(layBox);
		$('#layerContBox').html(result);
		$('#layerContBox').css('display','none');
		$('#layerContBox').css('display','block');
		$('#layerContBox').css('top',posY);
		$('#layerContBox').css('left',posX);
	});
}
function fnCloseLayerContBox(trg){
	$('#layerContBox').css('display','none');
}

function fnBanner(){
	layerW = 400;
	layerH = 200;
	var url = '/pages/pop_banner.asp?no=1';
	fnOpenLayer('매뉴얼 다운로드',url);
}


function fnPrntNumb(num){
	
	var retn = num.replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})/,"$1-$2-$3").replace("--", "-");
	
	return retn;
	
}

$(function(){
	
	$('.phoneNumb[type=text]').each(function(){
		$(this).val(fnPrntNumb($(this).val()));
	});
	$('.phoneNumb[type=text]').keyup(function(){
		$(this).val(fnPrntNumb($(this).val()));
	});
	
});
		