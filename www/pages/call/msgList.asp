<!--#include virtual="/common/common.asp"-->

<%
dim gb : gb = fnIsNull(nFnReq("gb", 1), 6)

'if gb = 1 then
'	if fnDBVal("TBL_ADDR", "AD_PEREMR", "AD_IDX = " & ss_userIdx & "") <> "Y" then
'		response.write	"<script>alert('사용권한이 없습니다.');history.back();</script>"
'	end if
'end if

mnCD = "01" & right("0" & gb, 2)

dim msgGB, cdMsgTP, formUrl, adIdx
select case gb
	case 1
		msgGB = "E"
		cdMsgTP = 2001
		formUrl = "emrForm"
		adIdx = ss_userIdx
	case 2
		msgGB = "A"
		cdMsgTP = 2002
		formUrl = "airForm"
		adIdx = 0
	case else
		msgGB = "-"
		cdMsgTP = 20
		formUrl = "msgForm"
		adIdx = ss_userIdx
end select
%>

<!--#include virtual="/common/header_htm.asp"-->

<div id="subPageBox">
	
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<table align="left">
						<tr>
							<td><label>업무</label></td>
							<td>
								<% call subCodeSelet(cdMsgTP, "cdMsgTP", "") %>
							</td>
							<td width="20px"></td>
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
	
	<div class="aR">
	<% if gb = 6 then %>
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/blue_add2.png" title="추가" onclick="fnMsgAdd()" />
	<% elseif gb = 1 then %>
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/red_newWrite.png" title="새로작성" onclick="location.href='emrForm.asp'" />
	<% end if %>
	</div>
	
	<%
	if gb = 6 then
		if fmsUseYN = "Y" then
			arrListHeader = array("업무","구분","제목","문자","음성","팩스","관리")
			arrListWidth = array("100px","100px","*","40px","40px","40px","80px")
		else
			arrListHeader = array("업무","구분","제목","문자","음성","관리")
			arrListWidth = array("100px","100px","*","40px","40px","80px")
		end if
	else
		if fmsUseYN = "Y" then
			arrListHeader = array("업무","제목","문자","음성","팩스","발송")
			arrListWidth = array("120px","*","40px","40px","40px","80px")
		else
			arrListHeader = array("업무","제목","문자","음성","발송")
			arrListWidth = array("120px","*","40px","40px","80px")
		end if
	end if
	
	call subListTable("listTbl")
	%>

</div>

<!--#include virtual="/common/footer_htm.asp"-->

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
				<% if gb = 6 then %>	//	메시지관리
					+'	<td class="aC">'+arrVal[4]+'</td>'
					+'	<td class="aC">'+arrVal[5]+'</td>'
					+'	<td class="bld">'+arrVal[7]+'</td>'
					+'	<td class="aC">'+smsYN+'</td>'
					+'	<td class="aC">'+vmsYN+'</td>'
					<% if fmsUseYN = "Y" then %>
						+'	<td class="aC">'+fmsYN+'</td>'
					<% end if %>
					+'	<td class="aC"><img class="imgBtn" src="<%=pth_pubImg%>/btn/olive_mng2.png" title="관리" onclick="fnMsgSend('+arrVal[2]+')" /></td>'
				<% else %>	// 일반
					+'	<td class="aC">'+arrVal[5]+'</td>'
					+'	<td class="bld">'+arrVal[7]+'</td>'
					+'	<td class="aC">'+smsYN+'</td>'
					+'	<td class="aC">'+vmsYN+'</td>'
					<% if fmsUseYN = "Y" then %>
						+'	<td class="aC">'+fmsYN+'</td>'
					<% end if %>
					+'	<td class="aC"><img class="imgBtn" src="<%=pth_pubImg%>/btn/blue_sel2.png" title="발송" onclick="fnMsgSend('+arrVal[2]+')" /></td>'
				<% end if %>
				+'</tr>';
				$('#listTbl tbody').append(strRow);
			}
		}
		$('#listPaging').html(arrList[1]);
	}
	
	function fnMsgSend(idx){
		location.href = '<%=formUrl%>.asp?msgIdx='+idx;
	}
	
	function fnMsgAdd(){
		location.href = '<%=formUrl%>.asp?msgIdx=0';
	}
	
</script>