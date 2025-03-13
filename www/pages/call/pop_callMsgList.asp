<!--#include virtual="/common/common.asp"-->

<%
dim clGB : clGB = fnReq("clGB")
dim msgGB : msgGB = fnReq("clGB")

dim cdMsgTP, adIdx
select case msgGB
	case "E"
		cdMsgTP = 2001
		adIdx = 0
	case "S"
		msgGB = "N"
		cdMsgTP = 200302
		adIdx = ss_userIdx
	case "V"
		msgGB = "N"
		cdMsgTP = 200301
		adIdx = ss_userIdx
end select
%>

<!--#include virtual="/common/header_pop.asp"-->

<div id="popBody">
		
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<table align="left">
						<tr>
							<% if msgGB = "E" then %>
								<td><label>업무</label></td>
								<td>
									<% call subCodeSelet(cdMsgTP, "cdMsgTP", "") %>
								</td>
								<td width="20px"></td>
							<% else %>
								<input type="hidden" id="cdMsgTP" name="cdMsgTP" value="<%=cdMsgTP%>" />
							<% end if %>
							<td><label>검색</label></td>
							<td><input type="hidden" id="schKey" name="schKey" value="ALL" /><input type="text" id="schVal" name="schVal" onkeypress="if(event.keyCode==13){fnLoadPage(1)}" /></td>
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
	arrListHeader = array("업무구분","제목","문자","음성","보기")
	arrListWidth = array("160px","*","40px","40px","60px")
	
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
		var cdMsgTP = $('#cdMsgTP').val();
		if(cdMsgTP.length == 0)	cdMsgTP = '0';
		var param = 'proc=MsgList&param=<%=msgGB%>]|['+cdMsgTP+']|[<%=adIdx%>]|['+$('#schKey').val()+']|['+$('#schVal').val()+'&page='+page+'&pageSize='+pageSize;
		param = encodeURI(param);
		var list = fnGetHttp('/pages/public/ajxList.asp?'+param);
		var arrList = list.split('}|{');
		rowCnt = arrList[0];
		$('#cntAll').html(rowCnt);
		$('#listTbl tbody tr').remove();
		if(rowCnt > 0){
			var strRow, arrVal, smsYN, vmsYN, fmsYN;
			for(i = 2; i < arrList.length; i++){
				arrVal = arrList[i].split(']|[');
				//	MSG_IDX(2), MSG_GB(3), MSGTP1(4), MSGTP2(5), MSG_CODE(6), MSG_TIT(7), MSG_SMS(8), MSG_VMS(9), MSG_FMS(10), REGDT(11), UPTDT(12)
				if(arrVal[8] == 'Y'){smsYN = '<span class="colBlue bld">Y</span>'}else{smsYN = '<span class="colLGray">N</span>'};
				if(arrVal[9] == 'Y'){vmsYN = '<span class="colBlue bld">Y</span>'}else{vmsYN = '<span class="colLGray">N</span>'};
				if(arrVal[10] == 'Y'){fmsYN = '<span class="colBlue bld">Y</span>'}else{fmsYN = '<span class="colLGray">N</span>'};
				strRow = '<tr>'
				+'	<td class="aC">'+arrVal[4]+' > '+arrVal[5]+'</td>'
				+'	<td class="aL">'+arrVal[7]+'</td>'
				+'	<td class="aC">'+smsYN+'</td>'
				+'	<td class="aC">'+vmsYN+'</td>'
				+'	<td class="aC"><img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_view2.png" title="보기" onclick="fnMsgView('+arrVal[2]+')" /></td>'
				+'</tr>';
				$('#listTbl tbody').append(strRow);
			}
		}
		$('#listPaging').html(arrList[1]);
	}
	
	function fnMsgView(idx){
		location.href = 'pop_callMsgView.asp?clGB=<%=clGB%>&msgIdx='+idx;
	}
	
</script>