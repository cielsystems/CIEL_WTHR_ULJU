<!--#include virtual="/common/common.asp"-->

<% mnCD = "2004" %>

<!--#include virtual="/common/header_adm.asp"-->

<%
dim schSDate : schSDate = dateserial(year(date),month(date),1)
dim schEDate : schEDate = dateadd("d",7,date)
%>

<div id="subPageBox">
	
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<table align="left">
						<tr>
							<td><label>기간</label></td>
							<td>
								<input type="text" id="schSDate" name="schSDate" value="<%=schSDate%>" size="10" readonly />
								<img class="calBtn" src="<%=pth_pubImg%>/icons/calendar-select.png" title="달력" /> ~
								<input type="text" id="schEDate" name="schEDate" value="<%=schEDate%>" size="10" readonly />
								<img class="calBtn" src="<%=pth_pubImg%>/icons/calendar-select.png" title="달력" />
							</td>
							<td>&nbsp;&nbsp;</td>
							<td><label>상태</label></td>
							<td>
								<select id="clStep" name="clStep">
									<option value="0">::::: 전체 :::::</option>
									<option value="1">대기</option>
									<option value="2">진행중</option>
									<option value="5">취소</option>
									<option value="6">완료</option>
								</select>
							</td>
							<td></td>
							<td><label>검색</label></td>
							<td>
								<select id="schKey" name="schKey">
									<option value="tit">제목</option>
									<option value="sndNum">발신번호</option>
									<option value="sndID">발신ID</option>
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
	
	<%
	arrListHeader = array("제목","발신자","대상","전송요청일시","상태","상세보기")
	arrListWidth = array("*","100px","80px","160px","80px","100px")
	
	call subListTable("listTbl")
	%>

</div>

<!--#include virtual="/common/footer_adm.asp"-->

<script>
	
	var page = 1;
	var pageSize = 10;
	var rowCnt = 0;
	
	$(function(){
		
		fnLoadPage(1);
		
	});
	
	function fnLoadPage(p){
		page = p;
		var clMethod = 0;
		var clStep = $('#clStep').val();
		var param = 'proc=CallResult&param=V]|[0]|['+clMethod+']|['+clStep+']|[0]|[0]|[0]|['+$('#schSDate').val()+']|['+$('#schEDate').val()+']|['+$('#schKey').val()+']|['+$('#schVal').val()+'&page='+page+'&pageSize='+pageSize;
		param = encodeURI(param);
		var list = fnGetHttp('/pages/public/ajxList.asp?'+param);
		var arrList = list.split('}|{');
		rowCnt = arrList[0];
		$('#cntAll').html(rowCnt);
		$('#listTbl tbody tr').remove();
		if(rowCnt > 0){
			var strRow, arrVal, clStep;
			for(i = 2; i < arrList.length; i++){
				arrVal = arrList[i].split(']|[');
				//	CL_IDX(2), AD_IDX(3), AD_ID(4), MSG_IDX(5), MSG_GB(6), CD_MSGTP(7), CDMSGTPNM(8), CL_METHOD(9), CL_TRY(10), CL_RSVDT(11), CL_SMSGB(12), CL_VMSGB(13), CL_FMSGB(14), CL_SNDNUM(15), CL_TIT(16), CL_STEP(17), TRGCNT(18), REGDT(19), CL_SMSSPLIT(20)
				if(arrVal[17] == '0'){clStep = '<span class="colGreen">대기</span>';
				}else if(arrVal[17] == '1'){clStep = '<span class="colOrange">진행중</span>';
				}else if(arrVal[17] == '2'){clStep = '<span class="colOrange">진행중</span>';
				}else if(arrVal[17] == '3'){clStep = '<span class="colOrange">진행중</span>';
				}else if(arrVal[17] == '4'){clStep = '<span class="colGray">취소</span>';
				}else if(arrVal[17] == '5'){clStep = '<span class="colBlue">완료</span>';
				}else{clStep = '<span class="colGray">-</span>';
				}
				strRow = '<tr>'
				+'	<td class="aL">'+arrVal[16]+'</td>'
				+'	<td class="aC">'+arrVal[4]+'</td>'
				+'	<td class="aR"><b>'+arrVal[18]+'</b>명</td>'
				+'	<td class="aC fnt11 colGray">'+arrVal[11]+'</td>'
				+'	<td class="aC">'+clStep+'</td>'
				+'	<td class="aC"><img class="imgBtn" src="<%=pth_pubImg%>/btn/purple_detailView2.png" title="상세보기" onclick="fnDetailView('+arrVal[2]+')" /></td>'
				+'</tr>';
				$('#listTbl tbody').append(strRow);
			}
		}
		$('#listPaging').html(arrList[1]);
	}
	
	function fnDetailView(idx){
		layerW = 1000;
		layerH = 700;
		var url = '/pages/result/pop_resultView.asp?gb=V&clIdx='+idx;
		fnOpenLayer('전송결과 상세보기',url);
	}
	
</script>