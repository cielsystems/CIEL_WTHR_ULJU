<!--#include virtual="/common/common.asp"-->

<% mnCD = "0105" %>

<!--#include virtual="/common/header_htm.asp"-->

<%
if fnDBVal("TBL_ADDR", "AD_PERSMS", "AD_IDX = " & ss_userIdx & "") <> "Y" then
	response.write	"<script>alert('사용권한이 없습니다.');history.back();</script>"
end if
%>

<style>
	.cke {border:0;}
</style>

<div>

	<div style="background:#eeeeee;border:1px solid #cccccc;padding:10px;margin:10px 0;">
		<dl class="noticeMsgList">
			<dt>업로드 주의사항</dt>
			<dd>1회 업로드 시 <span>최대 <b>1,000</b>건</span> 까지만 업로드가 가능합니다. 1,000건 이상의 대상자에게 전송 할 시에는 1,000건 씩 <span><b>분할</b>해서 업로드</span> 하시기 바랍니다.</dd>
			<dd>메시지 파일 양식(엑셀파일)에 따라 목록(휴대폰번호)과 내용을 작성하신 후 엑셀파일 형식(.xls, .xlsx)으로 저장하여 업로드 해주세요.</dd>
			<dd>양식파일의 모든 필드는 <span>텍스트</span> 형식으로 변경해야 합니다.(셀서식 -> 표시형식 텝 "텍스트")</dd>
			<dd>휴대폰번호는 <span>숫자와 하이픈(-)</span>만 사용할 수 있습니다.(이외의 문자가 들어간 경우 오류가 발생할 수 있습니다.)</dd>
			<dd>전송할 목록은 Sheet1에만 작성해 주세요.</dd>
		</dl>
	</div>
	
	<div style="background:#eeeeee;border:1px solid #cccccc;padding:10px;">
		<form name="xlsFrm" method="post" enctype="multipart/form-data" action="xlsUp.asp" target="procFrame">
			<table border="0" cellpadding="0" cellspacing="0" align="left">
				<tr>
					<td><label>파일업로드</label>&nbsp;&nbsp;:&nbsp;&nbsp;</th>
					<td colspan="2"><input type="file" name="xlsUp" /></td>
				</tr>
				<tr><td colspan="3" height="5px"></td></tr>
				<tr>
					<td><label>전송방법</label>&nbsp;&nbsp;:&nbsp;&nbsp;</th>
					<td>
						<input type="radio" name="xlsUpGb" value="1" checked /> 메시지
						<input type="radio" name="xlsUpGb" value="2" /> 매크로
					</td>
					<td style="padding-left:30px;"><img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_upload.png" title="업로드" onclick="fnXlsUpload()" /></td>
				</tr>
			</table>
		</form>
		<div class="clr"></div>
	</div>
	
	<p style="margin-top:10px;">
		지정된 형식의 엑셀파일을 업로드하여 대상자와 내용을 전송합니다.
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/olive_sample.png" title="샘플다운로드" onclick="fnSampleDown()" />
	</p>
	
	<div id="xlsExmTbls1">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tblXls" style="margin-top:10px;">
			<colgroup>
				<col width="40px" />
				<col width="100px" />
				<col width="140px" />
				<col width="120px" />
				<col width="160px" />
			</colgroup>
			<tr><th class="gb"></th><th>A</th><th>B</th><th>C</th><th>D</th></tr>
			<tr><td class="no">1</td><td>이름</td><td>휴대폰번호</td><td>제목</td><td>내용</td></tr>
			<tr><td class="no">2</td><td>연락처1</td><td>010-1111-1111</td><td>제목입니다.</td><td>내용입니다.</td></tr>
			<tr><td class="no">3</td><td>연락처2</td><td>010-2222-2222</td><td>제목입니다.</td><td>내용입니다.</td></tr>
			<tr><td class="no">4</td><td>연락처3</td><td>010-3333-3333</td><td>제목입니다.</td><td>내용입니다.</td></tr>
			<tr><td class="no">5</td><td>연락처4</td><td>010-4444-4444</td><td>제목입니다.</td><td>내용입니다.</td></tr>
			<tr><td class="no">6</td><td>연락처5</td><td>010-5555-5555</td><td>제목입니다.</td><td>내용입니다.</td></tr>
			<tr><td class="no">7</td><td></td><td></td><td></td><td></td></tr>
		</table>
	</div>
	
	<div id="xlsExmTbls2" style="display:none;">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tblXls" style="margin-top:10px;">
			<colgroup>
				<col width="40px" />
				<col width="100px" />
				<col width="140px" />
				<col width="90px" />
				<col width="90px" />
				<col width="90px" />
			</colgroup>
			<tr><th class="gb"></th><th>A</th><th>B</th><th>C</th><th>D</th><th>E</th></tr>
			<tr><td class="no">1</td><td>이름</td><td>휴대폰번호</td><td>$1</td><td>$2</td><td>$3</td></tr>
			<tr><td class="no">2</td><td>연락처1</td><td>010-1111-1111</td><td>변수1</td><td>변수2</td><td>변수3</td></tr>
			<tr><td class="no">3</td><td>연락처2</td><td>010-2222-2222</td><td>변수1</td><td>변수2</td><td>변수3</td></tr>
			<tr><td class="no">4</td><td>연락처3</td><td>010-3333-3333</td><td>변수1</td><td>변수2</td><td>변수3</td></tr>
			<tr><td class="no">5</td><td>연락처4</td><td>010-4444-4444</td><td>변수1</td><td>변수2</td><td>변수3</td></tr>
			<tr><td class="no">6</td><td>연락처5</td><td>010-5555-5555</td><td>변수1</td><td>변수2</td><td>변수3</td></tr>
			<tr><td class="no">7</td><td></td><td></td><td></td><td></td><td></td></tr>
		</table>
	</div>
	
	<!--
	<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-top:10px;">
		<colgroup>
			<col width="250px" />
			<col width="10px" />
			<col width="*" />
		</colgroup>
		<tr>
			<td valign="top">
				<div style="padding:5px;background:#eefcff;border:1px solid #cccccc;border-radius:5px;margin-bottom:2px;">제목 : <input type="text" name="clTit" size="30" value="" /></div>
				<div style="background:url(/images/phone_bg_light.png);width:250px;height:300px;">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<div style="width:238px;height:265px;border:1px solid #cccccc;overflow-x:hidden;overflow-y:scroll;margin:25px 5px 10px 5px;">
									<div id="smsFileView"></div>
									<textarea id="SMSMsg" name="SMSMsg" style="width:218px;height:250px;margin:5px;background:none;overflow:hidden;border:0;"
										onkeypress="fnChkByte('SMSMsg');" onkeydown="fnChkByte('SMSMsg');" onkeyup="fnChkByte('SMSMsg');"
									></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</td>
			<td></td>
			<td valign="top">
					
				<div style="background:#eeeeee;border:1px solid #cccccc;padding:10px;">
					<form name="xlsFrm" method="post" enctype="multipart/form-data" action="xlsUp.asp" target="procFrame">
						<table border="0" cellpadding="0" cellspacing="0" align="left">
							<tr>
								<td><label>파일업로드</label>&nbsp;&nbsp;:&nbsp;&nbsp;</th>
								<td colspan="2"><input type="file" name="xlsUp" /></td>
							</tr>
							<tr><td colspan="3" height="5px"></td></tr>
							<tr>
								<td><label>전송방법</label>&nbsp;&nbsp;:&nbsp;&nbsp;</th>
								<td>
									<input type="radio" name="xlsUpGb" value="1" checked /> 메시지
									<input type="radio" name="xlsUpGb" value="2" /> 매크로
								</td>
								<td style="padding-left:30px;"><img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_upload.png" title="업로드" onclick="fnXlsUpload()" /></td>
							</tr>
						</table>
					</form>
					<div class="clr"></div>
				</div>
				
				<p style="margin-top:10px;">
					지정된 형식의 엑셀파일을 업로드하여 대상자와 내용을 전송합니다.
					<img class="imgBtn" src="<%=pth_pubImg%>/btn/olive_sample.png" title="샘플다운로드" onclick="fnSampleDown()" />
				</p>
	
				<div id="xlsExmTbls1">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tblXls" style="margin-top:10px;">
						<colgroup>
							<col width="40px" />
							<col width="100px" />
							<col width="140px" />
							<col width="120px" />
							<col width="160px" />
						</colgroup>
						<tr><th class="gb"></th><th>A</th><th>B</th><th>C</th><th>D</th></tr>
						<tr><td class="no">1</td><td>이름</td><td>휴대폰번호</td><td>제목</td><td>내용</td></tr>
						<tr><td class="no">2</td><td>연락처1</td><td>010-1111-1111</td><td>제목입니다.</td><td>내용입니다.</td></tr>
						<tr><td class="no">3</td><td>연락처2</td><td>010-2222-2222</td><td>제목입니다.</td><td>내용입니다.</td></tr>
						<tr><td class="no">4</td><td>연락처3</td><td>010-3333-3333</td><td>제목입니다.</td><td>내용입니다.</td></tr>
						<tr><td class="no">5</td><td>연락처4</td><td>010-4444-4444</td><td>제목입니다.</td><td>내용입니다.</td></tr>
						<tr><td class="no">6</td><td>연락처5</td><td>010-5555-5555</td><td>제목입니다.</td><td>내용입니다.</td></tr>
						<tr><td class="no">7</td><td></td><td></td><td></td><td></td></tr>
					</table>
					<div class="colRed">
						* 제목 및 내용을 입력하지 않아도 됩니다.
					</div>
				</div>
				
				<div id="xlsExmTbls2" style="display:none;">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tblXls" style="margin-top:10px;">
						<colgroup>
							<col width="40px" />
							<col width="100px" />
							<col width="140px" />
							<col width="90px" />
							<col width="90px" />
							<col width="90px" />
						</colgroup>
						<tr><th class="gb"></th><th>A</th><th>B</th><th>C</th><th>D</th><th>E</th></tr>
						<tr><td class="no">1</td><td>이름</td><td>휴대폰번호</td><td>$1</td><td>$2</td><td>$3</td></tr>
						<tr><td class="no">2</td><td>연락처1</td><td>010-1111-1111</td><td>변수1</td><td>변수2</td><td>변수3</td></tr>
						<tr><td class="no">3</td><td>연락처2</td><td>010-2222-2222</td><td>변수1</td><td>변수2</td><td>변수3</td></tr>
						<tr><td class="no">4</td><td>연락처3</td><td>010-3333-3333</td><td>변수1</td><td>변수2</td><td>변수3</td></tr>
						<tr><td class="no">5</td><td>연락처4</td><td>010-4444-4444</td><td>변수1</td><td>변수2</td><td>변수3</td></tr>
						<tr><td class="no">6</td><td>연락처5</td><td>010-5555-5555</td><td>변수1</td><td>변수2</td><td>변수3</td></tr>
						<tr><td class="no">7</td><td></td><td></td><td></td><td></td><td></td></tr>
					</table>
					<div class="colRed">
						* 제목 및 내용을 형식에 맞춰 입력해야 합니다.
					</div>
				</div>
				
			</td>
		</tr>
	</table>
	-->

</div>

<!--#include virtual="/common/footer_htm.asp"-->

<script>
	
	$(function(){
		
		//	Xls Upload Type	==============================================================================
		$('input[name=xlsUpGb]').bind('click',function(){
			if($(this).val() == 1){
				$('#xlsExmTbls2').css('display','none');
				$('#xlsExmTbls1').css('display','block');
			}else if($(this).val() == 2){
				$('#xlsExmTbls1').css('display','none');
				$('#xlsExmTbls2').css('display','block');
			}
		});
		//	Xls Upload Type	==============================================================================
		
	});
	
	//	Xls Upload	==============================================================================
	function fnSampleDown(){
		var xlsUpGb;
		if($('input[name=xlsUpGb]').eq(0).prop('checked') == true){
			xlsUpGb = 1;
		}else if($('input[name=xlsUpGb]').eq(1).prop('checked') == true){
			xlsUpGb = 2;
		}
		procFrame.location.href = '/public/fileDown.asp?file=/data/sampleMCR_0'+xlsUpGb+'.xls';
	}
	function fnXlsUpload(){
		if(document.xlsFrm.xlsUp.value == ''){
			alert('업로드할 파일을 선택해 주세요.');document.xlsFrm.xlsUp.focus();return;
		}
		document.xlsFrm.submit();
	}
	//	Xls Upload	==============================================================================
	
	function fnNextStep(gb){
		layerW = 1000;
		layerH = 700;
		var url = 'popMcrConfirm.asp?gb='+gb;
		fnOpenLayer('매크로전송',url);
	}
	
</script>