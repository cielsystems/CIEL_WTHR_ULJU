<!--#include virtual="/common/common.asp"-->

<!--#include virtual="/common/header_pop.asp"-->

<%
dim clGB : clGB = fnReq("clGB")
%>

<div id="popBody">
	
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<table align="left">
						<tr>
							<td><label>검색</label></td>
							<td>
								<select id="schKey" name="schKey">
									<option value="NM">이름</option>
									<option value="NUM">번호</option>
								</select>
								<input type="text" id="schVal" name="schVal" onkeypress="if(event.keyCode==13){fnLoadPage(1)}" />
							</td>
							<td><img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch.png" title="검색" onclick="fnLoadPage(1)" /></td>
						</tr>
					</table>
						
				</td>
				<td class="aR">
					총 <b><span id="cntAll">0</span></b>명
					<img class="imgBtn" src="<%=pth_pubImg%>/btn/red_allDel.png" onclick="fntmpTrgAllDel()" />
				</td>
			</tr>
		</table>
	</div>
	
	<%
	arrListHeader = array("부서","이름","직급","휴대폰번호","삭제")
	arrListWidth = array("*","90px","90px","90px","80px")
	
	call subListTable("listTbl")
	%>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	var page = 1;
	var pageSize = 10;
	var rowCnt = 0;
	
	$(function(){
		
		fnLoadPage(1);
		
	});
	
	function fnLoadPage(p){
		page = p;
		var param = 'proc=TmpTrg&param=0]|[<%=ss_userIdx%>]|[<%=svr_remoteAddr%>]|['+$('#schKey').val()+']|['+$('#schVal').val()+'&page='+page+'&pageSize='+pageSize;
		param = encodeURI(param);
		var list = fnGetHttp('/pages/public/ajxList.asp?'+param);
		var arrList = list.split('}|{');
		rowCnt = arrList[0];
		$('#cntAll').html(rowCnt);
		$('#listTbl tbody tr').remove();
		if(rowCnt > 0){
			var strRow, arrVal;
			for(i = 2; i < arrList.length; i++){
				arrVal = arrList[i].split(']|[');
				//	TMP_NO(2), TMP_NM(3), TMP_NUM1(4), TMP_NUM2(5), TMP_NUM3(6)
				strRow = '<tr>'
				+'	<td class="fnt11">'+arrVal[9]+'</td>'
				+'	<td class="aC">'+arrVal[3]+'</td>'
				+'	<td class="aC">'+arrVal[10]+'</td>'
				<% if clGB = "E" then %>
					+'	<td class="aC">'+arrVal[4]+'</td>'
					//+'	<td class="aC">'+arrVal[5]+'</td>'
					//+'	<td class="aC">'+arrVal[6]+'</td>'
				<% elseif clGB = "S" then %>
					+'	<td class="aC">'+arrVal[4]+'</td>'
					//+'	<td class="aC">-</td>'
					//+'	<td class="aC">-</td>'
				<% elseif clGB = "V" then %>
					//+'	<td class="aC">-</td>'
					+'	<td class="aC">'+arrVal[4]+'</td>'
					//+'	<td class="aC">-</td>'
				<% end if %>
				+'	<td class="aC"><img class="imgBtn" src="<%=pth_pubImg%>/btn/red_del2.png" onclick="fnTmpTrgDel('+arrVal[2]+')" /></td>'
				+'</tr>';
				$('#listTbl tbody').append(strRow);
			}
		}
		$('#listPaging').html(arrList[1]);
	}
	
	function fnTmpTrgDel(no){
		popProcFrame.location.href = 'pop_addrProc.asp?proc=trgDel&no='+no;
	}
	
	function fntmpTrgAllDel(){
		popProcFrame.location.href = 'pop_addrProc.asp?proc=trgAllDel';
	}
	
</script>