<!--#include virtual="/common/common.asp"-->

<%
mnCD = "1001"
%>

<!--#include virtual="/common/header_adm.asp"-->

<div id="subPageBox">
	
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<table align="left">
						<colgroup>
							<col width="50px" />
							<col width="*" />
							<col width="20px" />
							<col width="50px" />
							<col width="300px" />
							<col width="60px" />
						</colgroup>
						<tr>
							<td><label>구분</label></td>
							<td>
								<select id="userGubn" name="userGubn">
									<option value="0">::: 전체 :::</option>
									<%
									for i = 1 to ubound(arrUserGubn)
										response.write	"<option value=""" & arrUserGubn(i)(0) & """"
										response.write	">" & arrUserGubn(i)(1) & "</option>"
									next
									%>
								</select>
							</td>
							<td width="20px"></td>
							<td><label>검색</label></td>
							<td>
								<select id="schKey" name="schKey">
									<option value="NAME">이름</option>
									<option value="ID">아이디</option>
									<% for i = 1 to ubound(arrCallMedia) %>
										<option value="NUM<%=i%>"><%=arrCallMedia(i)%>번호</option>
									<% next %>
								</select>
								<input type="text" id="schVal" name="schVal" onkeypress="if(event.keyCode==13){fnLoadPage(1)}" />
							</td>
							<td><img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" title="검색" onclick="fnLoadPage(1)" /></td>
						</tr>
					</table>
					
				</td>
				<td class="aR" width="180px">
					총 <b><span id="cntAll">0</span></b>건
					<img class="imgBtn" src="<%=pth_pubImg%>/btn/blue_add2.png" onclick="fnUserForm(0)" />
				</td>
			</tr>
		</table>
	</div>
	
	
	<%
	arrListHeader = array("구분","아이디","이름","상태","관리")
	arrListWidth = array("100px","120px","120px","100px","60px")
	
	call subListTable("listTbl")
	%>
	
</div>

<!--#include virtual="/common/footer_adm.asp"-->

<script>
	
	var page	= 1;
	var rowCnt	= 0;
	
	$(function(){
		
		fnLoadPage(1);
		
	});
	
	function fnLoadPage(p){	// 연락처 가져오기
		page = p;
		var userGubn	= $('select[name=userGubn]').val();
		var schKey		= $('select[name=schKey]').val();
		var schVal		= $('input[name=schVal]').val();
		var pageSize	= <%=g_pageSize%>;
		
		var params	= 'userGubn='+userGubn+'&schKey='+schKey+'&schVal='+schVal+'&page='+page+'&pageSize='+pageSize
		
		$('#listTbl tbody tr').remove();
		
		$.ajax({
			url	: '/pages/admin/env/ajxUserList.asp',
			type	: 'POST',
			data	: params,
			success	: function(rslt){
				//console.log(rslt);
				var arrRslt	= rslt.split('}|{');
				rowCnt	= arrRslt[0];
				if(rowCnt > 0){
					var arrVal, strRow;
					for(var i = 2; i < arrRslt.length; i++){
						arrVal	= arrRslt[i].split(']|[');
						strRow = '<tr>'
						+'	<td class="aC">'+arrVal[3]+'</td>'
						+'	<td class="aC">'+arrVal[4]+'</td>'
						+'	<td class="aC">'+arrVal[5]+'</td>'
						+'	<td class="aC">'+arrVal[6]+'</td>'
						+'	<td class="aC">'
						+'		<button class="btn btn_sm bg_olive" onclick="fnUserForm('+arrVal[2]+')">관리</button>'
						+'	</td>'
						+'</tr>';
						$('#listTbl tbody').append(strRow);
					}
				}
				$('#listPaging').html(arrRslt[1]);
				$('#cntAll').html(rowCnt);
			}
		});
	}
	
	function fnUserForm(indx){
		layerW = 1000;
		layerH = 600;
		fnOpenLayer('사용자관리', 'pop_userForm.asp?userIndx='+indx);
	}
	
</script>