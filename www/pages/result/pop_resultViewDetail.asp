<!--#include virtual="/common/common.asp"-->

<%
dim gb : gb = fnReq("gb")
dim clIdx : clIdx = fnReq("clIdx")
dim cltNo : cltNo = fnReq("cltNo")

sql = " select CL_MEDIA1, CL_MEDIA2, CL_MEDIA3, CL_METHOD, CL_TRY1, CL_TRY2, CL_TRY3 from TBL_CALL with(nolock) where CL_IDX = " & clIdx & " "
dim callInfo : callInfo = execSqlArrVal(sql)

dim clMedia1	: clMedia1	= callInfo(0)
dim clMedia2	: clMedia2	= callInfo(1)
dim clMedia3	: clMedia3	= callInfo(2)
dim clMethod	: clMethod	= callInfo(3)
dim clTry1		: clTry1		= callInfo(4)
dim clTry2		: clTry2		= callInfo(5)
dim clTry3		: clTry3		= callInfo(6)

sql = " select "
sql = sql & " 	CLT_NM "
sql = sql & " 	, CD_SMSSTATUS, dbo.ufn_getCodeName(CD_SMSSTATUS) as CDSMSSTATUSNM "
sql = sql & " 	, CD_VMSSTATUS, dbo.ufn_getCodeName(CD_VMSSTATUS) as CDVMSSTATUSNM "
'sql = sql & " 	, CD_RESULT, dbo.ufn_getCodeName(CD_RESULT) as CDRESULTNM "
sql = sql & " 	, CD_ERROR, dbo.ufn_getCodeName(CD_ERROR) as CDERRORNM "
sql = sql & " 	, CLT_ANSWYN, CLT_ANSWTRY, CLT_ANSWMEDIA "
'sql = sql & " 	, dbo.ecl_DECRPART(CLT_NUM1,4), dbo.ecl_DECRPART(CLT_NUM2,4), dbo.ecl_DECRPART(CLT_NUM3,4) "
sql = sql & " 	, CLT_NUM1, CLT_NUM2, CLT_NUM3 "
sql = sql & " 	, dbo.ufn_getCallTrgStatus(CL_IDX, CLT_NO) as CLTSTATUS, CLT_ANSWDT "
sql = sql & " from TBL_CALLTRG with(nolock) "
sql = sql & " where CL_IDX = " & clIdx & " and CLT_NO = " & cltNo & " "
dim trgInfo : trgInfo = execSqlArrVal(sql)

dim cltNM					: cltNM					= trgInfo(0)
dim cdSMSStatus		: cdSMSStatus		= trgInfo(1)
dim cdSMSStatusNM	: cdSMSStatusNM	= trgInfo(2)
dim cdVMSStatus		: cdVMSStatus		= trgInfo(3)
dim cdVMSStatusNM	: cdVMSStatusNM	= trgInfo(4)
'dim cdResult			: cdResult			= trgInfo(3)
'dim cdResultNM		: cdResultNM		= trgInfo(4)
dim cdError				: cdError				= trgInfo(5)
dim cdErrorNM			: cdErrorNM			= trgInfo(6)
dim cltAnswYN			: cltAnswYN			= trgInfo(7)
dim cltAnswTry		: cltAnswTry		= trgInfo(8)
dim cltAnswMedia	: cltAnswMedia	= trgInfo(9)
dim cltNum1				: cltNum1				= trgInfo(10)
dim cltNum2				: cltNum2				= trgInfo(11)
dim cltNum3				: cltNum3				= trgInfo(12)
dim cltStatus			: cltStatus			= trgInfo(13)
dim cltAnswDT			: cltAnswDT = trgInfo(14)

dim strCallTrgStatus

if cltAnswYN = "Y" then
	strCallTrgStatus = "<span class=""colBlue"">완료</span>"
else
	if cint(cltStatus) < 3032 then
		strCallTrgStatus = "<span class=""colGreen"">대기</span>"
	elseif cint(cltStatus) = 3032 then
		strCallTrgStatus = "<span class=""colOrange"">진행중</span>"
	elseif cint(cltStatus) = 3033 then
		strCallTrgStatus = "<span class=""colBlue"">완료</span>"
	elseif cint(cltStatus) = 3034 then
		strCallTrgStatus = "<span class=""colGray"">취소</span>"
	elseif cint(cltStatus) = 3035 then
		strCallTrgStatus = "<span class=""colGray"">실패</span>"
	end if
end if

dim strCallTrgAnsw
if cltAnswYN = "Y" then
	strCallTrgAnsw = "<span class=""colPurple"">응답</span>"
else
	strCallTrgAnsw = "<span class=""colOlive"">미응답</span>"
end if

dim printSMS, printVMS1, printVMS2, printVMS3

'#	문자전송결과
if cint(clMethod) = 0 then
	printSMS = ""
else
	sql = " select CLTS_SDT, CLTS_EDT, CLTS_STATUS, CD_STATUS, CD_RESULT, CD_ERROR "
	sql = sql & " 	, dbo.ufn_getCodeName(CD_STATUS) as CDSTATUSNM "
	sql = sql & " 	, dbo.ufn_getCodeName(CD_RESULT) as CDRESULTNM "
	sql = sql & " 	, dbo.ufn_getCodeName(CD_ERROR) as CDERRORNM "
	sql = sql & " 	, CLTS_ANSWYN "
	sql = sql & " from TBL_CALLTRG_SMS with(nolock) where CL_IDX = " & clIdx & " and CLT_NO = " & cltNo & " "
	dim smsInfo : smsInfo = execSqlArrVal(sql)
	if isarray(smsInfo) and ubound(smsInfo) > 0 then
		printSMS = "<tr>"
		printSMS = printSMS & "	<th>문자</th>"
		printSMS = printSMS & "	<td class=""aC fnt11"">" & fnDateToStr(smsInfo(0), "yyyy.mm.dd hh:nn:ss") & "</td>"
		printSMS = printSMS & "	<td class=""aC fnt11"">" & fnDateToStr(smsInfo(1), "yyyy.mm.dd hh:nn:ss") & "</td>"
		printSMS = printSMS & "	<td class=""aC"">"
		if smsInfo(3) = "3031" then
			printSMS = printSMS & "<span class=""colGreen bld"">대기</span>"
		elseif smsInfo(3) = "3032" then
			printSMS = printSMS & "<span class=""colOrange bld"">전송중</span>"
		elseif smsInfo(3) = "3033" then
			printSMS = printSMS & "<span class=""colBlue bld"">완료</span>"
		elseif smsInfo(3) = "3034" then
			if cdSMSStatus = "0" then
				printSMS = printSMS & "<span class=""colGray bld"">미처리</span>"
			else
				printSMS = printSMS & "<span class=""colRed bld"">취소</span>"
			end if
		elseif smsInfo(3) = "3035" then
			printSMS = printSMS & "<span class=""colGray bld"">실패</span>"
			printSMS = printSMS & "<div class=""fnt11 colRed"">(" & smsInfo(8) & ")</div>"
		end if
		printSMS = printSMS & "</td>"
		printSMS = printSMS & "	<td class=""aC"">"
		if smsInfo(4) = "9003" then
			if smsInfo(9) = "Y" then
				printSMS = printSMS & "<span class=""colPurple bld"">ARS응답</span><div class=""fnt11"">(" & fnDateToStr(cltAnswDT,"yyyy-mm-dd hh:nn:ss") & ")</div>"
			else
				printSMS = printSMS & "<span class=""colOlive bld"">ARS미응답</span>"
			end if
		else
			printSMS = printSMS & "-"
		end if
		printSMS = printSMS & "</td>"
		printSMS = printSMS & "</tr>"
	end if
end if

'#	음성전송결과
function fnSetPrintVMS(intNo)
	dim tmpSql, tmpRtn
	tmpSql = " select CLTV_SDT, CLTV_EDT, CLTV_STATUS, CD_STATUS, CD_RESULT, CD_ERROR "
	tmpSql = tmpSql & " 	, dbo.ufn_getCodeName(CD_STATUS) as CDSTATUSNM "
	tmpSql = tmpSql & " 	, dbo.ufn_getCodeName(CD_RESULT) as CDRESULTNM "
	tmpSql = tmpSql & " 	, dbo.ufn_getCodeName(CD_ERROR) as CDERRORNM "
	tmpSql = tmpSql & " 	, CLTV_ANSWYN, CLTV_TRY "
	tmpSql = tmpSql & " from TBL_CALLTRG_VMS with(nolock) where CL_IDX = " & clIdx & " and CLT_NO = " & cltNo & " and CLTV_MEDIA = " & intNo & " "
	tmpSql = tmpSql & " order by CLTV_TRY asc "
	cmdOpen(tmpSql)
	set rs = cmd.execute
	cmdClose()
	if not rs.eof then
		arrRs = rs.getRows
		arrRc2 = ubound(arrRs,2)
	else
		arrRc2 = -1
	end if
	rsClose()
	tmpRtn = ""
	for i = 0 to arrRc2
		tmpRtn = tmpRtn & "<tr>"
		if i = 0 then
			tmpRtn = tmpRtn & "	<th rowspan=""" & arrRc2+1 & """>음성" & intno & "차</th>"
		end if
		tmpRtn = tmpRtn & "	<td class=""aC fnt11"">" & fnDateToStr(arrRs(0,i),"yyyy.mm.dd hh:nn:ss") & "</td>"
		tmpRtn = tmpRtn & "	<td class=""aC fnt11"">" & fnDateToStr(arrRs(1,i),"yyyy.mm.dd hh:nn:ss") & "</td>"
		tmpRtn = tmpRtn & "	<td class=""aC"">"
		if arrRs(4,i) = "9001" then
			tmpRtn = tmpRtn & "<span class=""colGreen bld"">대기</span>"
		elseif arrRs(4,i) = "9002" then
			tmpRtn = tmpRtn & "<span class=""colOrange bld"">전송중</span>"
		elseif arrRs(4,i) = "9003" then
			tmpRtn = tmpRtn & "<span class=""colBlue bld"">완료</span>"
		elseif arrRs(4,i) = "9004" then
			tmpRtn = tmpRtn & "<span class=""colGray bld"">취소</span>"
		elseif arrRs(4,i) = "9005" then
			tmpRtn = tmpRtn & "<span class=""colGray bld"">실패</span>"
			tmpRtn = tmpRtn & "<div class=""fnt11 colRed"">(" & arrRs(8,i) & ")</div>"
		elseif arrRs(4,i) = "9099" then
			tmpRtn = tmpRtn & "<span class=""colGray bld fnt11"">기응답</span>"
		end if
		tmpRtn = tmpRtn & "</td>"
		tmpRtn = tmpRtn & "	<td class=""aC"">"
		if arrRs(4,i) = "9003" then
			if arrRs(9,i) = "Y" then
				tmpRtn = tmpRtn & "<span class=""colPurple bld"">응답</span>"
			else
				tmpRtn = tmpRtn & "<span class=""colOlive bld"">미응답</span>"
			end if
		else
			tmpRtn = tmpRtn & "-"
		end if
		'tmpRtn = tmpRtn & "(" & arrRs(10,i) & ")</td>"
		tmpRtn = tmpRtn & "</tr>"
	next
	fnSetPrintVMS = tmpRtn
end function

if clMethod = 1 then
	printVMS1 = ""
	printVMS2 = ""
	printVMS3 = ""
else
	'#	1차
	if cint(clMedia1) = 0 then
		printVMS1 = ""
	else
		printVMS1 = fnSetPrintVMS(1)
	end if
	'#	2차
	if cint(clMedia2) = 0 then
		printVMS2 = ""
	else
		printVMS2 = fnSetPrintVMS(2)
	end if
	'#	3차
	if cint(clMedia3) = 0 then
		printVMS3 = ""
	else
		printVMS3 = fnSetPrintVMS(3)
	end if
end if
%>

<!--#include virtual="/common/header_pop.asp"-->

<div id="popupBox">
	
	<h3>전송대상 상세보기</h3>
	
	<div id="popupCont">
		
			<div class="aR">
				<!--<img class="imgBtn" src="<%=pth_pubImg%>/btn/olive_xlsdown2.png" onclick="fnXlsDn()" />-->
			</div>
		
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="12%" />
				<col width="*" />
				<col width="12%" />
				<col width="21%" />
				<col width="12%" />
				<col width="21%" />
			</colgroup>
			<tr>
				<th>이름</th>
				<td class="aC"><%=cltNM%></td>
				<th>상태</th>
				<td class="aC bld"><%=strCallTrgStatus%></td>
				<th>응답여부</th>
				<td class="aC bld"><%=strCallTrgAnsw%></td>
			</tr>
		</table>
		
		<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
			<colgroup>
				<col width="*" />
				<col width="33%" />
				<col width="33%" />
			</colgroup>
			<tr>
				<th>1차(<%=arrCallMedia(clMedia1)%>)</th>
				<th>2차(<%=arrCallMedia(clMedia2)%>)</th>
				<th>3차(<%=arrCallMedia(clMedia3)%>)</th>
			</tr>
			<tr>
				<td class="aC"><%=cltNum1%></td>
				<td class="aC"><%=cltNum2%></td>
				<td class="aC"><%=cltNum3%></td>
			</tr>
		</table>
		
		<div style="margin-top:5px;border:1px solid #cccccc;height:300px;overflow:auto;background:#dddddd;">
			
			<table border="0" cellpadding="0" cellspacing="1" class="tblForm" style="margin-top:0;">
				<colgroup>
					<col width="*" />
					<col width="140px" />
					<col width="140px" />
					<col width="120px" />
					<col width="120px" />
				</colgroup>
				<tr>
					<th>구분</th>
					<th>시작일시</th>
					<th>완료일시</th>
					<th>상태</th>
					<th>응답</th>
				</tr>
				<% if clMethod = 4 then %>
					<%=printSMS%>
					<%=printVMS1%>
					<%=printVMS2%>
					<%=printVMS3%>
				<% else %>
					<%=printVMS1%>
					<%=printVMS2%>
					<%=printVMS3%>
					<%=printSMS%>
				<% end if %>
			</table>
			<br />
			
		</div>
		
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	function fnXlsDn(){
	
	//alert('탄다');
		popProcFrame.location.href = 'seoulMetro_reportD.asp?clIdx=<%=clIdx%>&cltNo=<%=cltNo%>';
	}
	
</script>