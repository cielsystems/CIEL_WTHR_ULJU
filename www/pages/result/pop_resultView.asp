<!--#include virtual="/common/common.asp"-->

<%
dim gb : gb = fnReq("gb")
dim clGB : clGB = gb
dim formUrl
select case gb
	case "E"	: formUrl = "emr"
	case "S"	: formUrl = "sms/txt"
	case "V"	: formUrl = "vms/vms"
end select

dim clIdx : clIdx = fnReq("clIdx")

'call execProc("sp_callEndCheck", array(clIdx))

sql = "	select "
sql = sql & " 	ad.USER_ID, ad.USER_NAME, dbo.ufn_getCodeName(msg.CD_MSGTP) as CDMSGTPNM "
sql = sql & " 	, cl.CL_RSVDT as CL_SDT, dbo.ufn_getCallEndDT(cl.CL_IDX) as CL_EDT "
sql = sql & " 	, cl.CL_METHOD, cl.CL_TRY1, cl.CL_TRY2, cl.CL_TRY3, cl.CL_MEDIA1, cl.CL_MEDIA2, cl.CL_MEDIA3 "
sql = sql & " 	, cl.CL_SNDNUM1, cl.CL_SNDNUM2, cl.CL_TIT, cl.CL_STEP, cl.CL_ARSANSWTIME, CL_GB "
sql = sql & " from TBL_CALL as cl with(nolock) "
sql = sql & " 	left join NTBL_USER as ad with(nolock) on (cl.AD_IDX = ad.USER_INDX) "
sql = sql & " 	left join TBL_MSG as msg with(nolock) on (cl.MSG_IDX = msg.MSG_IDX) "
sql = sql & " where CL_IDX = " & clIdx & " "
'response.write	sql
dim callInfo : callInfo = execSqlArrVal(sql)
dim adID			: adID			= callInfo(0)
dim adNM			: adNM			= callInfo(1)
dim cdMsgTP		: cdMsgTP		= callInfo(2)
dim clSDT			: clSDT			= callInfo(3)
dim clEDT			: clEDT			= callInfo(4)
dim clMethod	: clMethod	= callInfo(5)
dim clTry1		: clTry1		= callInfo(6)
dim clTry2		: clTry2		= callInfo(7)
dim clTry3		: clTry3		= callInfo(8)
dim clMedia1	: clMedia1	= callInfo(9)
dim clMedia2	: clMedia2	= callInfo(10)
dim clMedia3	: clMedia3	= callInfo(11)
dim clSndNum1	: clSndNum1	= callInfo(12)
dim clSndNum2	: clSndNum2	= callInfo(13)
dim clTit			: clTit			= callInfo(14)
dim clStep		: clStep		= callInfo(15)
dim clARSAnswTime	: clARSAnswTime	= callInfo(16)
clGB			= callInfo(17)

'response.write	clGB
if clGB = "W" then
	formUrl = "noti"
end if

dim printPeriod
if isDate(clEDT) then
	printPeriod = "(" & fnPeriodToStr(clSDT, clEDT) & " 소요)"
else
	printPeriod = "(" & fnPeriodToStr(clSDT, now) & " 소요)"
end if

dim printMedia, mediaCnt
if cint(clMedia1) > 0 then
	printMedia = "1차 " & arrCallMedia(clMedia1)
	mediaCnt = 1
end if
if cint(clMedia2) > 0 then
	printMedia = printMedia & " / 2차 " & arrCallMedia(clMedia2)
	mediaCnt = 2
end if
if cint(clMedia3) > 0 then
	printMedia = printMedia & " / 3차 " & arrCallMedia(clMedia3)
	mediaCnt = 3
end if

sql = " select "
sql = sql & " 	COUNT(*) as CNTALL "
sql = sql & " 	, COUNT(case when CLT_ANSWYN = 'Y' then 1 else null end) as CNTANSW "
sql = sql & " 	, COUNT(case when CLT_ANSWYN = 'N' /*and CD_RESULT = 9003*/ then 1 else null end) as CNTNOANSW "
sql = sql & " 	, COUNT(case when CLT_ANSWYN = 'Y' and CLT_ANSWMEDIA = 'S' then 1 else null end) as CNTSMSANSW "
sql = sql & " 	, COUNT(case when CLT_ANSWYN = 'Y' and CLT_ANSWMEDIA = 'V' then 1 else null end) as CNTVMSANSW "
sql = sql & " 	, COUNT(case when CD_STATUS < 3032 then 1 else null end) as CNTSTAY "
sql = sql & " 	, COUNT(case when CD_STATUS = 3032 then 1 else null end) as CNTING "
sql = sql & " 	, COUNT(case when CD_STATUS = 3033 then 1 else null end) as CNTCMP "
sql = sql & " 	, COUNT(case when CD_STATUS = 3034 then 1 else null end) as CNTCNL "
sql = sql & " 	, COUNT(case when CD_STATUS = 3035 then 1 else null end) as CNTERR "
if clMethod = "0" then
	sql = sql & " 	, 0 as CNTSMSALL "
	sql = sql & " 	, 0 as CNTSMSSTAY "
	sql = sql & " 	, 0 as CNTSMSING "
	sql = sql & " 	, 0 as CNTSMSCMP "
	sql = sql & " 	, 0 as CNTSMSCNL "
	sql = sql & " 	, 0 as CNTSMSERR "
else
	sql = sql & " 	, (select count(*) from TBL_CALLTRG_SMS with(nolock) where CL_IDX = " & clIdx & ") as CNTSMSALL "
	sql = sql & " 	, (select count(*) from TBL_CALLTRG_SMS with(nolock) where CL_IDX = " & clIdx & " and CD_STATUS < 3032) as CNTSMSSTAY "
	sql = sql & " 	, (select count(*) from TBL_CALLTRG_SMS with(nolock) where CL_IDX = " & clIdx & " and CD_STATUS = 3032) as CNTSMSING "
	sql = sql & " 	, (select count(*) from TBL_CALLTRG_SMS with(nolock) where CL_IDX = " & clIdx & " and CD_STATUS = 3033) as CNTSMSCMP "
	sql = sql & " 	, (select count(*) from TBL_CALLTRG_SMS with(nolock) where CL_IDX = " & clIdx & " and CD_STATUS = 3034) as CNTSMSCNL "
	sql = sql & " 	, (select count(*) from TBL_CALLTRG_SMS with(nolock) where CL_IDX = " & clIdx & " and CD_STATUS = 3035) as CNTSMSERR "
	'sql = sql & " 	, COUNT(case when CD_SMSSTATUS < 3032 then 1 else null end) as CNTSMSSTAY "
	'sql = sql & " 	, COUNT(case when CD_SMSSTATUS = 3032 then 1 else null end) as CNTSMSING "
	'sql = sql & " 	, COUNT(case when CD_SMSSTATUS = 3033 then 1 else null end) as CNTSMSCMP "
	'sql = sql & " 	, COUNT(case when CD_SMSSTATUS = 3034 then 1 else null end) as CNTSMSCNL "
	'sql = sql & " 	, COUNT(case when CD_SMSSTATUS = 3035 then 1 else null end) as CNTSMSERR "
end if
if clMethod = "1" then
	sql = sql & " 	, COUNT(*) as CNTVMSNONE "
	sql = sql & " 	, 0 as CNTVMSSTAY "
	sql = sql & " 	, 0 as CNTVMSING "
	sql = sql & " 	, 0 as CNTVMSCMP "
	sql = sql & " 	, 0 as CNTVMSCNL "
	sql = sql & " 	, 0 as CNTVMSERR "
else
	sql = sql & " 	, COUNT(case when CD_VMSSTATUS = 0 and CD_STATUS = 3033 and CLT_ANSWYN = 'Y' and CLT_ANSWMEDIA = 'S' then 1 else null end) as CNTVMSNONE "
	sql = sql & " 	, COUNT(case when CD_VMSSTATUS < 3032 then 1 else null end) as CNTVMSSTAY "
	sql = sql & " 	, COUNT(case when CD_VMSSTATUS = 3032 then 1 else null end) as CNTVMSING "
	sql = sql & " 	, COUNT(case when CD_VMSSTATUS = 3033 or CLT_ANSWYN = 'Y' then 1 else null end) as CNTVMSCMP "
	sql = sql & " 	, COUNT(case when CD_VMSSTATUS = 3034 and CLT_ANSWYN = 'N' then 1 else null end) as CNTVMSCNL "
	sql = sql & " 	, COUNT(case when CD_VMSSTATUS = 3035 and CLT_ANSWYN = 'N' then 1 else null end) as CNTVMSERR "
end if
sql = sql & " from TBL_CALLTRG with(nolock) "
sql = sql & " where CL_IDX = " & clIdx & " "
'response.write	sql
callInfo = execSqlArrVal(sql)
'for i = 0 to ubound(callInfo)
'	response.write	"<div>" & i & ":" & callInfo(i) & "</div>"
'next
dim cntAll			: cntAll			= clng(callInfo(0))
dim cntAnsw			: cntAnsw			= clng(callInfo(1))
dim cntNoAnsw		: cntNoAnsw		= clng(callInfo(2))
dim cntSMSAnsw	: cntSMSAnsw	= clng(callInfo(3))
dim cntVMSAnsw	: cntVMSAnsw	= clng(callInfo(4))
dim cntStay			: cntStay			= clng(callInfo(5))
dim cntIng			: cntIng			= clng(callInfo(6))
dim cntCmp			: cntCmp			= clng(callInfo(7))
dim cntCnl			: cntCnl			= clng(callInfo(8))
dim cntErr			: cntErr			= clng(callInfo(9))

dim cntSMSAll		: cntSMSAll		= clng(callInfo(10))
dim cntSMSStay	: cntSMSStay	= clng(callInfo(11))
dim cntSMSIng		: cntSMSIng		= clng(callInfo(12))
dim cntSMSCmp		: cntSMSCmp		= clng(callInfo(13))
dim cntSMSCnl		: cntSMSCnl		= clng(callInfo(14))
dim cntSMSErr		: cntSMSErr		= clng(callInfo(15))

dim cntVMSAll		: cntVMSAll		= cntAll - clng(callInfo(16))
dim cntVMSStay	: cntVMSStay	= clng(callInfo(17))
dim cntVMSIng		: cntVMSIng		= clng(callInfo(18))
dim cntVMSCmp		: cntVMSCmp		= clng(callInfo(19))
dim cntVMSCnl		: cntVMSCnl		= clng(callInfo(20))
dim cntVMSErr		: cntVMSErr		= clng(callInfo(21))
%>

<!--#include virtual="/common/header_pop.asp"-->

<div id="popBody">
	
	<div class="aR"><img class="imgBtn" src="<%=pth_pubImg%>/refresh.png" width="20px" onclick="location.reload();" /></div>
	
	<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
		<colgroup>
			<col width="10%" />
			<col width="22%" />
			<col width="10%" />
			<col width="22%" />
			<col width="10%" />
			<col width="*" />
		</colgroup>
		<tr>
			<th>제목</th>
			<td colspan="3"><%=clTit%></td>
			<th>발신자</th>
			<td><%=adNM%>(<%=adID%>)</td>
		</tr>
		<tr>
			<th>전송일시</th>
			<td><%=clSDT%><div class="colBlue"><%=printPeriod%></div></td>
			<th>전송방법</th>
			<td>
				<%=arrCallMethod(clMethod)%>
				<% if clMethod = 3 or clMethod = 4 then %>
					<div class="colBlue fnt11">(<%=clARSAnswTime%>분간 응답 대기)</div>
				<% end if %>
			</td>
			<th>발신번호</th>
			<td>문자 : <%=clSndNum2%> / 음성 : <%=clSndNum1%></td>
		</tr>
		<tr>
			<th>1차전송</th>
			<td><%=arrCallMedia(clMedia1)%> (<%=clTry1%>회)</td>
			<th>2차전송</th>
			<td><%=arrCallMedia(clMedia2)%> (<%=clTry2%>회)</td>
			<th>3차전송</th>
			<td><%=arrCallMedia(clMedia3)%> (<%=clTry3%>회)</td>
		</tr>
	</table>
	
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="*" />
			<% if clGB = "E" or clGB = "W" then %>
				<col width="5px" />
				<col width="260px" />
			<% end if %>
		</colgroup>
		<tr>
			<td>
				<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
					<colgroup>
						<col width="*" />
						<col width="125px" />
						<col width="125px" />
						<col width="125px" />
						<col width="125px" />
						<col width="125px" />
					</colgroup>
					<tr>
						<th>구분</th>
						<th><a href="javascript:fnTrgSchStatus(0)">전체</a></th>
						<th><a href="javascript:fnTrgSchStatus(1)">대기</a></th>
						<th><a href="javascript:fnTrgSchStatus(2)">진행중</a></th>
						<th><a href="javascript:fnTrgSchStatus(4)">취소<span class="fnt11">(미처리)</span></a>/<a href="javascript:fnTrgSchStatus(5)">실패</a></th>
						<th><a href="javascript:fnTrgSchStatus(3)">완료</a></th>
					</tr>
					<% if clMethod <> "0" then %>
						<tr>
							<th>문자</th>
							<td class="aR bld"><%=formatNumber(cntSMSAll,0)%> (<%=fnPer(cntSMSAll,cntSMSAll)%>%)</td>
							<td class="aR bld colGreen"><%=formatNumber(cntSMSStay,0)%> (<%=fnPer(cntSMSAll,cntSMSStay)%>%)</td>
							<td class="aR bld colOrange"><%=formatNumber(cntSMSIng,0)%> (<%=fnPer(cntSMSAll,cntSMSIng)%>%)</td>
							<td class="aR bld colRed"><%=formatNumber(cntSMSCnl,0)%>(<%=fnPer(cntSMSAll,cntSMSCnl)%>)/<%=formatNumber(cntSMSErr,0)%>(<%=fnPer(cntSMSAll,cntSMSErr)%>%)</td>
							<td class="aR bld colBlue"><%=formatNumber(cntSMSCmp,0)%> (<%=fnPer(cntSMSAll,cntSMSCmp)%>%)</td>
						</tr>
					<% end if %>
					<% if clMethod <> "1" then %>
						<tr>
							<th>음성</th>
							<td class="aR bld"><%=formatNumber(cntVMSAll,0)%> (<%=fnPer(cntVMSAll,cntVMSAll)%>%)</td>
							<td class="aR bld colGreen"><%=formatNumber(cntVMSStay,0)%> (<%=fnPer(cntVMSAll,cntVMSStay)%>%)</td>
							<td class="aR bld colOrange"><%=formatNumber(cntVMSIng,0)%> (<%=fnPer(cntVMSAll,cntVMSIng)%>%)</td>
							<td class="aR bld colRed"><%=formatNumber(cntVMSCnl,0)%>(<%=fnPer(cntVMSAll,cntVMSCnl)%>)/<%=formatNumber(cntVMSErr,0)%>(<%=fnPer(cntVMSAll,cntVMSErr)%>%)</td>
							<td class="aR bld colBlue"><%=formatNumber(cntVMSCmp,0)%> (<%=fnPer(cntVMSAll,cntVMSCmp)%>%)</td>
						</tr>
					<% end if %>
				</table>
			</td>
			<% if clGB = "E" or clGB = "W" then %>
				<td></td>
				<td>
					<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
						<colgroup>
							<col width="14%" />
							<col width="14%" />
						</colgroup>
						<tr>
							<th><a href="javascript:fnTrgSchAnsw('Y')">응답</a></th>
							<th><a href="javascript:fnTrgSchAnsw('N')">미응답</a></th>
						</tr>
						<% if clMethod = "0" then %>
							<tr>
								<td class="aR bld colPurple"><%=formatNumber(cntVMSAnsw,0)%> (<%=fnPer(cntAll,cntVMSAnsw)%>%)</td>
								<td class="aR bld colOlive"><%=formatNumber(cntNoAnsw,0)%> (<%=fnPer(cntAll,cntNoAnsw)%>%)</td>
							</tr>
						<% elseif clMethod = "1" then %>
							<tr>
								<td class="aR bld colPurple"><%=formatNumber(cntSMSAnsw,0)%> (<%=fnPer(cntAll,cntSMSAnsw)%>%)</td>
								<td class="aR bld colOlive"><%=formatNumber(cntSMSCmp-cntSMSAnsw,0)%> (<%=fnPer(cntAll,cntSMSCmp-cntSMSAnsw)%>%)</td>
							</tr>
						<% else %>
							<% if ARSAnswUSEYN = "Y" then %>
								<tr>
									<td class="aR bld colPurple"><%=formatNumber(cntSMSAnsw,0)%> (<%=fnPer(cntAll,cntSMSAnsw)%>%)</td>
									<td rowspan="2" class="aR bld colOlive"><%=formatNumber(cntAll-cntAnsw,0)%> (<%=fnPer(cntAll,cntAll-cntAnsw)%>%)</td>
								</tr>
								<tr>
									<td class="aR bld colPurple"><%=formatNumber(cntVMSAnsw,0)%> (<%=fnPer(cntAll,cntVMSAnsw)%>%)</td>
								</tr>
							<% else %>
								<tr>
									<td rowspan="2" style="line-height:45px;" class="aR bld colPurple"><%=formatNumber(cntVMSAnsw,0)%> (<%=fnPer(cntAll,cntVMSAnsw)%>%)</td>
									<td rowspan="2" style="line-height:45px;" class="aR bld colOlive"><%=formatNumber(cntAll-cntAnsw,0)%> (<%=fnPer(cntAll,cntAll-cntAnsw)%>%)</td>
								</tr>
							<% end if %>
						<% end if %>
					</table>
				</td>
			<% end if %>
		</tr>
	</table>
	
	<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:5px 0;">
		<tr>
			<td>
				<img class="imgBtn" src="<%=pth_pubImg%>/btn/olive_contView2.png" onclick="fnContView()" />
				<% if gb = "E" then %>
					<% if clStep = 5 or clStep = 4 then %>
						<img class="imgBtn" src="<%=pth_pubImg%>/btn/green_reportPrint.png" onclick="fnReportPrint()" />
						<img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_reportDn.png" onclick="fnHwpDown()" />
					<% end if %>
				<% elseif gb = "S" then %>
					<% if clStep = 5 or clStep = 4 then %>
						<!--<img class="imgBtn" src="<%=pth_pubImg%>/btn/green_reportPrint.png" onclick="fnReportPrintSMS()" />-->
						<img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_reportDn.png" onclick="fnHwpDownSMS()" />
					<% end if %>
				<% elseif gb = "V" then %>
					<% if clStep = 5 or clStep = 4 then %>
						<!--<img class="imgBtn" src="<%=pth_pubImg%>/btn/green_reportPrint.png" onclick="fnReportPrintVMS()" />-->
						<img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_reportDn.png" onclick="fnHwpDownVMS()" />
					<% end if %>
				<% end if %>
			</td>
			<td class="aR">
				<% if clStep = 5 or clStep = 4 then %>
					<% if gb = "E" then %>
						<img class="imgBtn" src="<%=pth_pubImg%>/btn/blue_faleRecall.png" title="미응답자재전송" onclick="fnReCall('F')" />
					<% end if %>
					<img class="imgBtn" src="<%=pth_pubImg%>/btn/red_allResend.png" title="전체재전송" onclick="fnReCall('A')" />
				<% else %>
					<img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_callCancel.png" title="전송취소" onclick="fnCallCancel()" />
				<% end if %>
			</td>
		</tr>
	</table>
	
	<div class="aR">
		<div class="listSchBox">
			<label>검색</label>
			<select id="schKey" name="schKey">
				<option value="nm">이름</option>
				<option value="num">번호</option>
			</select>
			<input type="text" id="schVal" name="schVal" onkeypress="if (event.keyCode==13) {fnLoadPage(1)}" />
			<img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" onclick="fnLoadPage(1)" />
		</div>
	</div>
	
	<div style="margin-top:5px;border:1px solid #cccccc;height:420px;overflow:auto;background:#dddddd;">
		
		<%
		if clGB = "E" or clGB = "W" then
			arrListHeader = array("번호","이름","문자시작일시","문자완료일시","음성시작일시","음성완료일시","문자상태","응답여부","상세보기")
			arrListWidth = array("60px","*","140px","140px","140px","140px","80px","80px","80px")
		else
			arrListHeader = array("번호","이름","대상번호","시작일시","완료일시","상태")
			arrListWidth = array("80px","*","120px","150px","150px","100px")
		end if
		
		call subListTable("listTbl")
		%>
		
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	var page = 1;
	var pageSize = 10;
	var rowCnt = 0;
	
	var statusGB = 0;
	var answGB = 0;
	
	$(function(){
		
		fnLoadPage(1);
		
	});
	
	function fnTrgSchStatus(gb){
		statusGB = gb;
		answGB = 0;
		fnLoadPage(1);
	}
	
	function fnTrgSchAnsw(gb){
		statusGB = 0;
		answGB = gb;
		fnLoadPage(1);
	}
	
	function fnLoadPage(p){
		page = p;
		var param = 'proc=CallResultTargets&param=<%=clIdx%>]|['+statusGB+']|['+answGB+']|['+$('#schKey').val()+']|['+$('#schVal').val()+'&page='+page+'&pageSize='+pageSize;
		param = encodeURI(param);
		var list = fnGetHttp('/pages/public/ajxList.asp?'+param);
		var arrList = list.split('}|{');
		rowCnt = arrList[0];
		$('#cntAll').html(rowCnt);
		$('#listTbl tbody tr').remove();
		if(rowCnt > 0){
			var strRow, arrVal, state, answYN;
			for(i = 2; i < arrList.length; i++){
				arrVal = arrList[i].split(']|[');
				//	CLT_NO(2), CLT_NM(3), CLT_SDR(4), CLT_EDT(5), CD_STATUS(6), CDSTATUSNM(7), CD_RESULT(8), CDRESULTNM(9), 
				//CD_ERROR(10), CDERRORNM(11), CLT_ANSWYN(12), CLT_ANSWMEDIA(13), CLT_ANSWDT(14), CD_SMSSTATUS(15), 
				//CD_VMSSTATUS(16), CLTSTATUS(17)
				<% if gb = "E" or clGB = "W" then %>
					if(arrVal[15] == 3031){
						state = '<span class="colGreen">대기</span>';
					}else if(arrVal[15] == 3032){
						state = '<span class="colOrange">진행중</span>';
					}else if(arrVal[15] == 3033){
						state = '<span class="colBlue">완료</span>';
					}else if(arrVal[15] == 3034){
						state = '<span class="colRed">취소</span>';
					}else if(arrVal[15] == 3035){
						state = '<span class="colRed">실패</span>';
					}else if(arrVal[15] == 0){
						state = '<span class="colGray">미처리</span>';
					}else{
						state = '<span>-</span>';
					}
				<% elseif gb = "S" then %>
					if(arrVal[6] == 3031){
						state = '<span class="colGreen">대기</span>';
					}else if(arrVal[6] == 3032){
						state = '<span class="colOrange">진행중</span>';
					}else if(arrVal[6] == 3033){
						if(arrVal[8] == 9010){
							state = '<span class="colOrange">결과미수신</span>';
						}else{
							state = '<span class="colBlue">완료</span>';
						}
					}else if(arrVal[6] == 3034){
						state = '<span class="colRed">취소</span>';
					}else if(arrVal[6] == 3035){
						state = '<span class="colRed">실패</span>';
					}else{
						state = '<span>-</span>';
					}
				<% elseif gb = "V" then %>
					if(arrVal[6] == 3031){
						state = '<span class="colGreen">대기</span>';
					}else if(arrVal[6] == 3032){
						state = '<span class="colOrange">진행중</span>';
					}else if(arrVal[6] == 3033){
						state = '<span class="colBlue">완료</span>';
					}else if(arrVal[6] == 3034){
						state = '<span class="colRed">취소</span>';
					}else if(arrVal[6] == 3035){
						state = '<span class="colRed">실패</span>';
					}else{
						state = '<span>-</span>';
					}
				<% end if %>
				if(arrVal[12] == 'Y'){
					if(arrVal[13] == 'S'){
						answYN = '<span class="colPurple bld">ARS응답</span>';
					}else if(arrVal[13] == 'V'){
						answYN = '<span class="colPurple bld">음성응답</span>';
					}
				}else{
					answYN = '<span class="colGray bld">미응답</span>';
				}
				strRow = '<tr>'
				+'	<td class="aC">'+(arrVal[0]-(pageSize*(page-1))-(i-2))+'</td>'
				+'	<td class="aC">'+arrVal[3]+'</td>'
				<% if clGB <> "E" and clGB <> "W" then %>
					+'	<td class="aC fnt11">'+arrVal[18]+'</td>'
				<% end if %>
				<% if clGB <> "V" then %>
				+'	<td class="aC fnt11">'+arrVal[26]+'</td>'
				+'	<td class="aC fnt11">'+arrVal[27]+'</td>'
				<% end if%>
				<% if clGB = "E" or clGB = "W" or clGB = "V" then %>
					+'	<td class="aC fnt11">'+arrVal[28]+'</td>'
					+'	<td class="aC fnt11">'+arrVal[29]+'</td>'
				<% end if %>
				+'	<td class="aC">'+state+'</td>'
				<% if clGB = "E" or clGB = "W" then %>
					+'	<td class="aC">'+answYN+'</td>'
					+'	<td class="aC"><img class="imgBtn" src="<%=pth_pubImg%>/btn/purple_detailView2.png" title="상세보기" onclick="fnTargetDetailView('+arrVal[2]+')" /></td>'
				<% end if %>
				+'</tr>';
				$('#listTbl tbody').append(strRow);
			}
		}
		$('#listPaging').html(arrList[1]);
	}
	
	function fnTargetDetailView(no){
		fnPop('pop_resultViewDetail.asp?gb=<%=gb%>&clIdx=<%=clIdx%>&cltNo='+no, 'emrViewDetail_<%=clIdx%>_'+no, 0, 0, 680, 460, 'N');
	}
	
	function fnContView(){
		fnPop('pop_callMsgView.asp?clIdx=<%=clIdX%>','callMsgView_<%=clIdx%>', 0, 0, 800, 500, 'N');
	}
	
	function fnReportPrint(){
		fnPop('pop_callReport.asp?clIdx=<%=clIdX%>','callReport_<%=clIdx%>', 0, 0, 900, 600, 'Y');
	}
	function fnReportPrintSMS(){
		fnPop('pop_callReportSMS.asp?clIdx=<%=clIdX%>','callReport_<%=clIdx%>', 0, 0, 900, 600, 'Y');
	}
	function fnReportPrintVMS(){
		fnPop('pop_callReportVMS.asp?clIdx=<%=clIdX%>','callReport_<%=clIdx%>', 0, 0, 900, 600, 'Y');
	}
	
	
	function fnReCall(proc){
		top.location.href = '/pages/call/<%=formUrl%>Form.asp?clIdx=<%=clIdx%>&reProc='+proc;
	}
	
	function fnCallCancel(){
		if(confirm('전송을 취소하시겠습니까?')){
			popProcFrame.location.href = '/pages/call/pop_callStopProc.asp?clIdx=<%=clIdx%>';
		}
	}
	
	function fnHwpDown(){
		popProcFrame.location.href = 'pop_resultViewHwp.asp?clIdx=<%=clIdx%>';
	}
	function fnHwpDownSMS(){
		popProcFrame.location.href = 'pop_resultViewHwpSMS.asp?clIdx=<%=clIdx%>';
	}
	function fnHwpDownVMS(){
		popProcFrame.location.href = 'pop_resultViewHwpVMS.asp?clIdx=<%=clIdx%>';
	}
	
	function fnXlsDown(){
		popProcFrame.location.href = 'pop_resultViewXls.asp?clIdx=<%=clIdx%>';
	}
	
	function fnXlsDownSMS(){
		popProcFrame.location.href = 'pop_resultViewXlsSMS.asp?clIdx=<%=clIdx%>';
	}
	function fnXlsDownVMS(){
		popProcFrame.location.href = 'pop_resultViewXlsVMS.asp?clIdx=<%=clIdx%>';
	}
	
	function fnReportDN(gb){
		popProcFrame.location.href = 'seoulMetro_report'+gb+'.asp?clIdx=<%=clIdx%>';
	}
	
	function fnARSStop(){
		popProcFrame.location.href = 'pop_resultView_stop.asp?clIdx=<%=clIdx%>';
	}
	
</script>