<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<%
%>

<style>
	
	* {margin:0 auto;padding:0 auto;font-family:'맑은 고딕';font-weight:bold;}
	
	.pageTit {font-size:2em;text-align:center;line-height:2.8em;}
	
	img {vertical-align:bottom;}
	
	.obox th, .box td {padding:0;}
	.obox .oboxMT {background:url(images/obox_MT.gif);font-size:1.3em;color:#ffffff;text-align:center;}
	.obox .oboxLM {background:url(images/obox_LM.gif);}
	.obox .oboxCont {background:#eaeaea;}
	.obox .oboxRM {background:url(images/obox_RM.gif);}
	.obox .oboxMB {background:url(images/obox_MB.gif) repeat-x;}
	
	.ibox {background:#0066c5;}
	.ibox th {background:#8CC9FF;padding:0.4em;font-size:1.2em;}
	.ibox td {background:#ffffff;padding:0.4em;font-size:1.2em;}
	.ibox td.tpA {text-align:center;padding:1em;}
	
	.aC {text-align:center;}
	.aR {text-align:right;}
	
	.colRed {color:#FF2424;}
	.colBlue {color:#0058A8;}
	
	#menuList {border:1px solid #999999;background:#dddddd;margin-top:5px;display:none;}
	#menuList ul {list-style-type:none;margin:0;padding:0;}
	#menuList ul li {margin:2px;padding:5px 10px;border:1px solid #999999;background:#eeeeee;color:#777777;;cursor:pointer;}
	#menuList ul li:hover {background:#ffffff;color:#333333;}
	#menuList ul li.on {background:#ffffff;color:#333333;font-style:italic;}
	
	.sysError {text-align:center;font-size:2em;color:red;}
	.sysOK {text-align:center;font-size:2em;color:blue;}
	
	.ibox .ok {color:blue;}
	.ibox .ero {color:red;}
	
</style>	

<div style="text-align:center;margin:1em 0 2em;"><img src="tit.png" /></div>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<colgroup>
		<col width="8%" />
		<col width="25%" />
		<col width="5%" />
		<col width="25%" />
		<col width="5%" />
		<col width="25%" />
		<col width="7%" />
	</colgroup>
	<tr>
		<td></td>
		<td valign="top">
			
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="obox">
				<colgroup>
					<col width="15px" />
					<col width="*" />
					<col width="15px" />
				</colgroup>
				<tr>
					<td><img src="images/obox_LT.gif" /></td>
					<td class="oboxMT">ACS</td>
					<td><img src="images/obox_RT.gif" /></td>
				</tr>
				<tr>
					<td class="oboxLM"></td>
					<td class="oboxCont">
						<div id="sys01"><div class="sysError">장애</div></div>
					</td>
					<td class="oboxRM"></td>
				</tr>
				<tr>
					<td><img src="images/obox_LB.gif" style="vertical-align:top;" /></td>
					<td class="oboxMB"></td>
					<td><img src="images/obox_RB.gif" style="vertical-align:top;" /></td>
				</tr>
			</table>
			
		</td>
		<td></td>
		<td valign="top">
			
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="obox">
				<colgroup>
					<col width="15px" />
					<col width="*" />
					<col width="15px" />
				</colgroup>
				<tr>
					<td><img src="images/obox_LT.gif" /></td>
					<td class="oboxMT">SMS</td>
					<td><img src="images/obox_RT.gif" /></td>
				</tr>
				<tr>
					<td class="oboxLM"></td>
					<td class="oboxCont">
						<div id="sys02"><div class="sysOK">정상</div></div>
					</td>
					<td class="oboxRM"></td>
				</tr>
				<tr>
					<td><img src="images/obox_LB.gif" style="vertical-align:top;" /></td>
					<td class="oboxMB"></td>
					<td><img src="images/obox_RB.gif" style="vertical-align:top;" /></td>
				</tr>
			</table>
			
		</td>
		<td></td>
		<td valign="top">
			
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="obox">
				<colgroup>
					<col width="15px" />
					<col width="*" />
					<col width="15px" />
				</colgroup>
				<tr>
					<td><img src="images/obox_LT.gif" /></td>
					<td class="oboxMT">DB</td>
					<td><img src="images/obox_RT.gif" /></td>
				</tr>
				<tr>
					<td class="oboxLM"></td>
					<td class="oboxCont">
						<div id="sys03"><div class="sysOK">정상</div></div>
					</td>
					<td class="oboxRM"></td>
				</tr>
				<tr>
					<td><img src="images/obox_LB.gif" style="vertical-align:top;" /></td>
					<td class="oboxMB"></td>
					<td><img src="images/obox_RB.gif" style="vertical-align:top;" /></td>
				</tr>
			</table>
			
		</td>
		<td></td>
	</tr>
	<tr>
		<td colspan="7" style="height:3em;"></td>
	</tr>
	<tr>
		<td></td>
		<td colspan="5">
			
			<table width="100%" border="0" cellpadding="0" cellspacing="2" class="ibox" id="listTbl">
				<colgroup>
					<col width="10%" />
					<col width="*" />
					<col width="25%" />
				</colgroup>
				<thead>
					<tr>
						<th>구분</th>
						<th>내용</th>
						<th>일시</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			
			<div id="listPaging"></div>
			
		</td>
		<td></td>
	</tr>
</table>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	var page = 1;
	var pageSize = 10;
	
	$(function(){
		
		fnLoadSystem();
		setInterval('fnLoadSystem();',5000);
		fnLoadPage(1);
		
	});
	
	function fnLoadSystem(){
		var result = fnGetHttp('monitor_system_ajx.asp?proc=sys');
		var arrResult = result.split(']|[');
		if(arrResult[0] == '0'){
			$('#sys01').html('<div class="sysOK">정상</div>');
		}else{
			$('#sys01').html('<div class="sysError">장애</div>');
		}
		if(arrResult[1] == '0'){
			$('#sys02').html('<div class="sysOK">정상</div>');
		}else{
			$('#sys02').html('<div class="sysError">장애</div>');
		}
		if(arrResult[2] == '0'){
			$('#sys03').html('<div class="sysOK">정상</div>');
		}else{
			$('#sys03').html('<div class="sysError">장애</div>');
		}
	}
	
	function fnLoadPage(p){
		page = p;
		var url = 'monitor_system_ajx.asp';
		var param = 'proc=list&page='+page+'&pageSize='+pageSize;
		var list = fnGetHttp(url+'?'+param);
		var arrList = list.split('}|{');
		var arrVal, strRow, strGB, strClass;
		$('#listTbl tbody tr').remove();
		if(arrList[2].length > 0){
			for(i = 2; i < arrList.length; i++){
				arrVal = arrList[i].split(']|[');
				if(arrVal[0] == 'A')	strGB = 'ACS';
				else if(arrVal[0] == 'S')	strGB = 'SMS';
				else if(arrVal[0] == 'D') strGB = 'DB';
				if(arrVal[1] == '0')	strClass = 'ok';
				else	strClass = 'ero';
				strRow = '<tr>'
				+'	<td class="aC '+strClass+'">'+strGB+'</td>'
				+'	<td class="'+strClass+'">'+arrVal[2]+'</td>'
				+'	<td class="aC '+strClass+'">'+arrVal[3]+'</td>'
				+'</tr>';
				$('#listTbl tbody').append(strRow);
			}
		}
		$('#listPaging').html(arrList[1]);
	}
	
</script>