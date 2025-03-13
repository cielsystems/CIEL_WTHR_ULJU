<%
function fnGetNumber(strNum)
	dim tmpStr
	dim tmpLen : tmpLen = len(strNum)
	dim tmpChar
	for i = 1 to tmpLen
		tmpChar = mid(strNum,i,1)
		if isNumeric(tmpChar) then
			tmpStr = tmpStr & tmpChar
		end if
	next
	fnGetNumber = tmpStr
end function

function fnChkMobile(strNum)
	dim tmpStr : tmpStr = fnGetNumber(strNum)
	dim tmpRtn
	if len(tmpStr) < 10 or len(tmpStr) > 11 then
		tmpRtn = false
	else
		if left(tmpStr,3) = "010" or left(tmpStr,3) = "011" or left(tmpStr,3) = "016" or left(tmpStr,3) = "017" or left(tmpStr,3) = "018" or left(tmpStr,3) = "019" then
			tmpRtn = true
		else
			tmpRtn = false
		end if
	end if
	fnChkMobile = tmpRtn
end function

dim a : a = fnChkMobile("010-1234-1234")
response.write	a
%>

<script>
	
	alert(fnChkMobile("010-1234-1234"));
	
	function fnGetNumber(strNum){
		var tmpStr = '';
		var tmpChar;
		var tmpLen = strNum.length;
		for(i = 0; i < tmpLen; i++){
			tmpChar = strNum.substr(i,1);
			if(parseInt(tmpChar)  || tmpChar == 0){
				tmpStr = tmpStr + tmpChar;
			}
		}
		return tmpStr;
	}
	
	function fnChkMobile(strNum){
		var tmpStr = fnGetNumber(strNum);
		var tmpRtn = false;
		var tmpLeft;
		if(tmpStr.length < 10 || tmpStr.length > 11){
			tmpRtn = false;
		}else{
			tmpLeft = tmpStr.substr(0,3);
			alert(tmpLeft);
		}
	}
	
</script>