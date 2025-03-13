<!--#include virtual="/common/common.asp"-->

<% mnCD = "0106" %>

<%
'#	임시 파일 삭제
call execProc("usp_delTmpMsgFile",array(0, ss_userIdx, svr_remoteAddr))

dim msgIdx : msgIdx = fnIsNull(fnReq("msgIdx"),0)

dim proc
dim cdMsgTP, cdMSgTP1, cdMsgTP2, msgPermit, msgTit, SMSMsg, VMSMSg, FMSMsg

if msgIdx = 0 then
	
	proc = "I"
	msgPermit = "N"
	
else
	
	'#	메시지파일을 임시파일로 복사
	sql = " insert into TMP_MSGFILE (MSG_IDX, AD_IDX, AD_IP, TMP_GB, TMP_NO, TMP_SORT, TMP_DPNM, TMP_PATH, TMP_FILE, TMP_PAGE) "
	sql = sql & " select 0, " & ss_userIdx & ", '" & svr_remoteAddr & "', MSGF_GB, MSGF_NO, MSGF_SORT, MSGF_DPNM, MSGF_PATH, MSGF_FILE, MSGF_PAGE "
	sql = sql & " from TBL_MSGFILE with(nolock) "
	sql = sql & " where MSG_IDX = " & msgIdx & " "
	call execSql(sql)
	
	sql = " select CD_MSGTP, MSG_PERMIT, MSG_TIT, MSG_VMS, MSG_SMS, MSG_FMS from TBL_MSG with(nolock) where MSG_IDX = " & msgIdx & " "
	cmdOpen(sql)
	set rs = cmd.execute
	cmdClose()
	if not rs.eof then
		cdMsgTP = rs(0)
		cdMsgTP1 = left(rs(0),4)
		cdMsgTP2 = right(rs(0),2)
		msgPermit = rs(1)
		msgTit = rs(2)
		VMSMsg = rs(3)
		SMSMsg = rs(4)
		FMSMsg = rs(5)
	end if
	rsClose()
	
	proc = "U"
	
end if
%>

<!--#include virtual="/common/header_htm.asp"-->

<div id="subPageBox">
		
	<form name="frm" method="post" action="msgProc.asp" target="procFrame">
		<input type="hidden" name="proc" value="<%=proc%>" />
		<input type="hidden" name="msgIdx" value="<%=msgIdx%>" />
		
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="12%" />
				<col width="21%" />
				<col width="12%" />
				<col width="21%" />
				<col width="12%" />
				<col width="*" />
			</colgroup>
			<input type="hidden" name="cdMsgTP1" value="2001" />
			<input type="hidden" name="cdMsgTP2" value="200102" />
			<tr>
				<th>제목</th>
				<td colspan="5"><input type="text" name="msgTit" value="<%=msgTit%>" size="80" /></td>
			</tr>
		</table>
		
		<%
		'#	비상(E:2001) : 문자, 음성
		'#	대기(A:2002) : 문자, 음성, 팩스
		'#	일반(N:2003) : 문자, 음성, 팩스
		dim arrTabs : arrTabs = array("문자전송","음성전송","팩스전송")
		if fmsUseYN <> "Y" then
			arrTabs = array("문자전송","음성전송")
		end if
		dim tabNo
		%>
		
		<div class="tabs" style="margin-top:10px;">
			<ul class="tabsMenu">
				<%
				for i = 0 to ubound(arrTabs)
					tabNo = i + 1
					'response.write	"<li id=""tabsMenu_" & tabNo & """ onclick=""fnTabMenu(" & tabNo & ")"">" & arrTabs(i) & "</li>" & vbCrLf
				next
				%>
				<div class="clr"></div>
			</ul>
			<div class="clr"></div>
			<div class="tabsContBox">
				                       
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="250px" />
						<col width="*" />
						<col width="500px" />
					</colgroup>
					<tr>
						<td valign="top">
							<div style="margin:2px 0 5px 0;"><img id="SMSMsgTypeIcon" src="<%=pth_pubImg%>/phn_btn_sms_on.png" /> 문자메시지입력</div>
							<div style="background:url(/images/phone_bg_light.png);width:250px;height:300px;">
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td>
											<div style="width:238px;height:265px;border:1px solid #cccccc;overflow-x:hidden;overflow-y:scroll;margin:25px 5px 10px 5px;">
												<div id="smsFileView"></div>
												<textarea id="SMSMsg" name="SMSMsg" style="width:218px;height:250px;margin:5px;background:none;overflow:hidden;border:0;"
													onkeypress="fnChkByte('SMSMsg');" onkeydown="fnChkByte('SMSMsg');" onkeyup="fnChkByte('SMSMsg');"
												><%=SMSMsg%></textarea>
											</div>
										</td>
									</tr>
								</table>
							</div>
							<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
								<tr>
									<td>
										<img id="btnEmt" class="imgBtn" src="<%=pth_pubImg%>/btn/phn_btn_emt.png" />
										<% if smsFileUP = "Y" then %>
											<img class="imgBtn" src="<%=pth_pubImg%>/btn/phn_btn_file.png" onclick="fnSMSAddFileOpen()" />
										<% end if %>
									</td>
									<td class="aR"><span id="smsByte" class="bld">0</span> Byte</td>
								</tr>
							</table>
							<!--
							<div style="margin-top:5px;" class="aR colBlue">
								<input type="checkbox" name="splitYN" value="Y" <% if dftSMSSplit = "Y" then %>checked<% end if %> onclick="fnChkByte('SMSMsg')" />	단문(SMS)으로 분할 전송
							</div>
							-->
							<input type="hidden" name="splitYN" value="N" />
						</td>
						<td>
							<div style="border-left:1px solid #cccccc;height:360px;margin-left:30px;"></div>
						</td>
						<td valign="top">
							<div class="aL" style="margin:0 0 5px;height:20px;">음성입력</div>
							<div style="background:url(/images/tts_bg_light.png);width:500px;height:300px;">
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td>
											<div style="width:488px;height:265px;border:1px solid #cccccc;overflow-x:hidden;overflow-y:scroll;margin:25px 5px 10px 5px;">
												<textarea id="VMSMsg" name="VMSMsg" style="width:468px;height:250px;margin:5px;background:none;overflow:hidden;border:0;"
													onkeypress="fnChkByte('VMSMsg');" onkeydown="fnChkByte('VMSMsg');" onkeyup="fnChkByte('VMSMsg');"
												><%=VMSMsg%></textarea>
											</div>
										</td>
									</tr>
								</table>
							</div>
							<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:5px 0 10px;">
								<tr>
									<td></td>
									<td class="aR"><span id="vmsByte" class="bld">0</span> Byte</td>
								</tr>
							</table>
							<div style="margin-top:5px;" class="aR colBlue"><img class="imgBtn" src="<%=pth_pubImg%>/btn/green_prevLit.png" onclick="fnVMSPreLit()" /></div>
						</td>
					</tr>
				</table>
				
				<%
				''# 문자, 음성 전송 폼 : Start
				'for i = 0 to ubound(arrTabs)
				'	tabNo = i + 1
				'	response.write	"<div id=""tabs-" & tabNo & """ class=""tabsCont"">" & vbCrLf
				'	
				'	call subMsgForm(i)
				'	
				'	response.write	"</div>" & vbCrLf
				'next
				''# 문자, 음성 전송 폼 : End
				%>
				
			</div>
			
		</div>
		
	</form>
		
	<div class="aR" style="margin-top:10px;">
		<% if msgIdx > 0 then %>
			<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_red_del.png" onclick="fnDel()" />
		<% end if %>
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/B_blue_save.png" onclick="fnSave()" />
	</div>

</div>

<!--#include virtual="/common/footer_htm.asp"-->

<script>
	
	var trgCnt = 0;		// 선택된 전송 대상 수
	var nTab = 1;			// 최초 선택된 Tab 번호
	
	var smsFileCnt = 0;
	var vmsFileCnt = 0;
	var fmsFileCnt = 0;
	
	$(function(){
		
		fnSelTab();			// 최초 선택텝
		
		$('#cdMsgTP1').bind('change',function(){
			fnLoadSubTP($(this).val());
		});
		
		$('#cdMsgTP2').bind('change',function(){
			fnSelSubTP($(this).val());
		});
		
		<% if msgIdx > 0 then %>
			fnLoadSubTP(<%=cdMsgTP1%>);
			fnSelSubTP(<%=cdMsgTP%>);
		<% end if %>
		
		fnChkByte('VMSMsg');
		fnChkByte('SMSMsg');
		
		fnVMSLoadFile();
		fnSMSLoadFile();
		fnFMSLoadFile();
		
		$('.imgBtn').bind('click',function(e){
			var nId = $(this).prop('id');
			posX = e.pageX+200;
			posY = e.pageY-100;
			if(nId == 'btnEmt'){
				fnOpenLayerContBox('layerEmt');
			}
		});
		
	});
	
	function fnLoadSubTP(upcode){
		var strRow;
		$('#cdMsgTP2 option').remove();
		$('#cdMsgTP2').append('<option value ="">::::: 선택 :::::</option>');
		<%
		dim arrRs2
		arrRs = execProcRs("usp_listCode", array(20))
		if isarray(arrRs) then
			arrRc1 = ubound(arrRs,2)
		else
			arrRc1 = -1
		end if
		for i = 0 to arrRc1
			response.write	"if(upcode == '" & arrRs(0,i) & "'){"
			arrRs2 = execProcRs("usp_listCode",array(arrRs(0,i)))
			if isarray(arrRs2) then
				arrRc2 = ubound(arrRs2,2)
			else
				arrRc2 = -1
			end if
			for ii = 0 to arrRc2
				response.write	"	strRow = '<option value=""" & arrRs2(0,ii) & """>" & arrRs2(1,ii) & "</option>';"
				response.write	"	$('#cdMsgTP2').append(strRow);"
			next
			response.write	"}"
		next
		%>
	}
	
	function fnSelSubTP(n){
		$("#cdMsgTP2").val(n);
	}
	
	function fnTabMenu(no){
		nTab = no;
		fnSelTab();
	}
	
	function fnSelTab(){
		$('.tabs .tabsMenu li').removeClass('on');
		$('.tabs .tabsContBox .tabsCont').css('display','none');
		$('.tabs .tabsMenu #tabsMenu_'+nTab).addClass('on');
		$('.tabs .tabsContBox #tabs-'+nTab).css('display','block');
		$('.tabs .tabsMenu li input[name=snd'+nTab+']').prop('checked',true);
	}
	
	function fnChkByte(trg){
		var h = 250;
		if(trg == 'SMSMsg'){
			$('#smsByte').html(fnByte($('#SMSMsg').val()));
			var splitNo = fnSplit($('#SMSMsg').val());
			if(fnByte($('#SMSMsg').val()) > 140 || smsFileCnt > 0 || splitNo > 2){
				$('input[name=splitYN]').prop('checked',false);
				$('input[name=splitYN]').prop('disabled',true);
				if(smsFileCnt > 0){
					$('#SMSMsgTypeIcon').prop('src','<%=pth_pubImg%>/phn_btn_mms_on.png');
				}else{
					$('#SMSMsgTypeIcon').prop('src','<%=pth_pubImg%>/phn_btn_lms_on.png');
				}
			}else{
				$('input[name=splitYN]').prop('disabled',false);
				if($('input[name=splitYN]').prop('checked') == true || fnByte($('#SMSMsg').val()) < 141){
					$('#SMSMsgTypeIcon').prop('src','<%=pth_pubImg%>/phn_btn_sms_on.png');
				}else{
					$('#SMSMsgTypeIcon').prop('src','<%=pth_pubImg%>/phn_btn_lms_on.png');
				}
			}
		}else if(trg == 'VMSMsg'){
			$('#vmsByte').html(fnByte($('#VMSMsg').val()));
		}
		fnAutoHeight(trg,h);
	}
	
	function fnAutoHeight(trg,h){	// textarea 높이조정
		var trg = eval('document.all.'+trg);
		var nHeight = trg.scrollHeight;
		if(nHeight > h){
			trg.style.height = (24+trg.scrollHeight)+"px";
		}
	}
	
	//	SMS	==========================================================================================
	function fnSMSAddEmt(val){		// 이모티콘 입력
		var nSMSMsg = $('#SMSMsg').val();
		$('#SMSMsg').val(nSMSMsg+val);
		fnChkByte('SMSMsg');
	}
	function fnSMSAddFileOpen(){		// 문자 첨부파일 업로드 레이어 오픈
		layerW = 600;
		layerH = 300;
		var url = 'pop_fileUpForm.asp?proc=SMSMsg';
		fnOpenLayer('파일업로드',url);
	}
	
	function fnSMSLoadFile(){				// 문자 첨부파일 로드
		var param = 'proc=TmpMsgFile&param=0]|[<%=ss_userIdx%>]|[<%=svr_remoteAddr%>]|[S&page=1&pageSize=999';
		param = encodeURI(param);
		var list = fnGetHttp('/pages/public/ajxList.asp?'+param);
		var arrList = list.split('}|{');
		smsFileCnt = arrList[0];
		$('#smsFileView').html('');
		$('#smsFileList tr').remove();
		if(smsFileCnt > 0 ){
			var arrVal, strRowView, strRowList;
			for(i = 2; i < arrList.length; i++){
				arrVal = arrList[i].split(']|[');
				// TMP_NO(1), TMP_DPNM(2), TMP_PATH(3), TMP_FILE(4), TMP_PAGE(5)
				strRowView = '<div id="smsImg_'+arrVal[1]+'"><img src="/data/'+arrVal[3]+'/'+arrVal[4]+'" /><div class="aR"><img class="imgBtn" src="<%=pth_pubImg%>/icons/smsImgDel.png" onclick="fnSMSDelFile('+arrVal[1]+')" /></div></div>';
				$('#smsFileView').append(strRowView);
			}
		}
		fnChkByte('SMSMsg');
	}
	function fnSMSDelFile(no){			// 첨부파일 삭제
		procFrame.location.href = 'tmpFileDel.asp?proc=smsMsg&no='+no;
	}
	//	SMS	==========================================================================================
	
	//	VMS	==========================================================================================
	function fnVMSAddFileOpen(){		// 음성 첨부파일 업로드 레이어 오픈
		layerW = 600;
		layerH = 300;
		var url = 'pop_fileUpForm.asp?proc=VMSMsg';
		fnOpenLayer('파일업로드',url);
	}
	function fnVMSLoadFile(){				// 음성 첨부파일 로드
		var param = 'proc=TmpMsgFile&param=0]|[<%=ss_userIdx%>]|[<%=svr_remoteAddr%>]|[V&page=1&pageSize=999';
		param = encodeURI(param);
		var list = fnGetHttp('/pages/public/ajxList.asp?'+param);
		var arrList = list.split('}|{');
		vmsFileCnt = arrList[0];
		$('#vmsFileList tr').remove();
		if(vmsFileCnt > 0){
			var arrVal, strRowList;
			for(i = 2; i < arrList.length; i++){
				arrVal = arrList[i].split(']|[');
				// TMP_NO(1), TMP_DPNM(2), TMP_PATH(3), TMP_FILE(4), TMP_PAGE(5)
				strRowList = '<tr>'
				+'<td style="background:#ffffff;padding:3px 5px;"><img src="<%=pth_pubImg%>/icons/speaker-volume.png" /> '+arrVal[2]+' <img class="imgBtn" src="<%=pth_pubImg%>/icons/cross.png" onclick="fnVMSMsgDelFile('+arrVal[1]+')" /></td>'
				+'</tr>';
				$('#vmsFileList').append(strRowList);
			}
			//$('#VMSMsg').val('');
		}
	}
	
	function fnVMSMsgDelFile(no){			// 음성 첨부파일 삭제
		procFrame.location.href = 'msgProc.asp?proc=F&gb=V&no='+no;
	}
	function fnVMSPreLit(){		// TTS미리듣기
		if(document.frm.VMSMsg.value == ''){
			alert('내용을 입력해 주세요.');document.frm.VMSMsg.focus();return;
		}
		document.frm.action = '/pages/public/ttsCreate.asp?proc=prev';
		document.frm.submit();
	}
	//	VMS	==========================================================================================
	
	//	FMS	==========================================================================================
	function fnFMSAddFileOpen(){		// 음성 첨부파일 업로드 레이어 오픈
		layerW = 600;
		layerH = 400;
		var url = 'pop_fileUpForm.asp?proc=FMSMsg';
		fnOpenLayer('파일업로드',url);
	}
	
	function fnFMSLoadFile(){				// 음성 첨부파일 로드
		var param = 'proc=TmpMsgFile&param=0]|[<%=ss_userIdx%>]|[<%=svr_remoteAddr%>]|[F&page=1&pageSize=999';
		param = encodeURI(param);
		var list = fnGetHttp('/pages/public/ajxList.asp?'+param);
		var arrList = list.split('}|{');
		vmsFileCnt = arrList[0];
		$('#vmsFileList tr').remove();
		if(vmsFileCnt > 0){
			var arrVal, strRowList;
			for(i = 2; i < arrList.length; i++){
				arrVal = arrList[i].split(']|[');
				// TMP_NO(1), TMP_DPNM(2), TMP_PATH(3), TMP_FILE(4), TMP_PAGE(5)
				strRow = '<ul class="addFileBox">';
				strRow = strRow + '	<li><img src="<%=pth_pubImg%>/icons/paper-clip.png" /> <span class="fileItem" id="fileItem_'+arrVal[1]+'" onclick="fnSelFileItem('+arrVal[1]+')">'+arrVal[2]+' ';
				if(arrVal[4].length > 0){
					strRow = strRow + '('+arrVal[4]+')';
				}
				strRow = strRow + '</span> <a href="javascript:fnFMSMsgDelFile('+arrVal[1]+')"><img src="<%=pth_pubImg%>/icons/cross.png" title="삭제" /></a></li>';
				strRow = strRow +'</ul>';
				$('#addFileList').append(strRow);
			}
			//$('#VMSMsg').val('');
		}
	}
	
	function fnFMSMsgDelFile(no){			// 음성 첨부파일 삭제
		procFrame.location.href = 'msgProc.asp?proc=F&gb=F&no='+no;
	}
	
	function fnSelFileItem(no){
		$('.fileItem').css('background','none');
		$('#fileItem_'+no).css('background','lightblue');
		fileNo = no;
	}
	
	function fnFileMove(gb){
		if(fileNo > 0){
			procFrame.location.href = 'fileProc.asp?proc='+gb+'&no='+fileNo;
		}else{
			//alert('파일을 선택하세요.');return;
			alert('파일을 선택하세요.\n\n커버는 이동할 수 없습니다.');return;
		}
	}
	//	FMS	==========================================================================================
	
	function fnDel(){
		if(confirm('삭제하시겠습니까?')){
			document.frm.proc.value = 'D';
			document.frm.submit();
		}
	}
	
	function fnSave(){
		if(document.frm.cdMsgTP1.value == ''){
			alert('업무를 선택해 주세요.');document.frm.cdMsgTP1.focus();return;
		}
		if(document.frm.cdMsgTP2.value == ''){
			alert('구분을 선택해 주세요.');document.frm.cdMsgTP2.focus();return;
		}
		if(document.frm.msgTit.value == ''){
			alert('제목을 입력해 주세요.');document.frm.msgTit.focus();return;
		}
		if((document.frm.VMSMsg.value == '' && smsFileCnt == 0) && (document.frm.SMSMsg.value == '' && vmsFileCnt == 0)){
			alert('음성, 또는 문자의 내용이나 파일이 없습니다.\n음성, 또는 문자의 내용을 입력하거나 파일을 업로드 해주세요.');
			return;
		}
		document.frm.action = 'msgProc.asp';
		document.frm.submit();
	}
	
</script>