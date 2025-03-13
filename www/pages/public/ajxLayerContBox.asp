<!--#include virtual="/common/common.asp"-->

<%
dim proc : proc = fnReq("proc")

dim strBoxTitle
dim strBoxCont

if proc = "layerEmt" then
	
	strBoxTitle = "이모티콘"
	
	strBoxCont = "<table border=""0"" cellpadding=""0"" cellspacing=""1"" style=""background:#999999;"">"
	strBoXCont = strBoxCont & "	<tr>"
	for i = 0 to ubound(arrEmt)
		strBoXCont = strBoxCont & "<td style=""background:#ffffff;width:30px;height:30px;text-align:center;cursor:pointer;"" onclick=""fnSMSAddEmt('" & arrEmt(i) & "')"">" & arrEmt(i) & "</td>"
		if i mod 10 = 9 then
			strBoXCont = strBoxCont & "</tr><tr>"
		end if
	next
	strBoXCont = strBoxCont & "	</tr>"
	strBoXCont = strBoxCont & "</table>"
	
elseif proc = "layerFileT" then
	
	strBoxTitle = "파일첨부"
	
	strBoxCont = "<div style=""background:#eeeeee;border:1px solid #cccccc;padding:10px;margin:10px 0;"">"
	strBoxCont = strBoxCont & "	<dl class=""noticeMsgList"">"
	strBoxCont = strBoxCont & "		<dt>MMS 첨부파일 안내</dt>"
	strBoxCont = strBoxCont & "		<dd>MMS 첨부파일은 <span>JPG이미지</span>만 가능합니다.</dd>"
	strBoxCont = strBoxCont & "		<dd>JPG이미지의 규격은 해상도 : <span>220x184</span>, 파일크기 : <span>20kByte</span>이하로 총 <span>3장까지</span> 가능합니다.</dd>"
	strBoxCont = strBoxCont & "		<dd>이미지의 해상도는 변경이 가능하나 특정폰에서 표시하지 못하는 경우가 있습니다.('콘텐츠에 오류가 있음'으로 표기)</dd>"
	strBoxCont = strBoxCont & "		<dd>각 통신사별, 수신폰의 지원여부에 따라 3장의 이미지가 모두 전송되지 않을 수도 있습니다.</dd>"
	strBoxCont = strBoxCont & "	</dl>"
	strBoxCont = strBoxCont & "</div>"
	strBoxCont = strBoxCont & "<form name=""frmFileAdd"" method=""post"" enctype=""multipart/form-data"" action=""fileUpload.asp"" target=""procFrame"">"
	strBoxCont = strBoxCont & "	<input type=""hidden"" name=""proc"" value=""add"" />"
	strBoxCont = strBoxCont & "	<input type=""hidden"" name=""gb"" value=""mms"" />"
	strBoxCont = strBoxCont & "	<label>MMS파일첨부</label>"
	strBoxCont = strBoxCont & "	<input type=""file"" class=""h24"" name=""upfile"" />"
	strBoxCont = strBoxCont & "	<img class=""imgBtn"" src=""" & pth_pubImg & "/btn/orange_upload.png"" title=""업로드"" onclick=""fnFileAdd()"" />"
	strBoxCont = strBoxCont & "	<ul id=""upFileList""></ul>"
	strBoxCont = strBoxCont & "</form>"
	strBoxCont = strBoxCont & "<script>fnFileLoad();</script>"
	
elseif proc = "layerFileA" then
	
	strBoxTitle = "파일첨부"
	
	strBoxCont = "<form name=""frmFileAdd"" method=""post"" enctype=""multipart/form-data"" action=""fileUpload.asp"" target=""procFrame"">"
	strBoxCont = strBoxCont & "	<input type=""hidden"" name=""proc"" value=""add"" />"
	strBoxCont = strBoxCont & "	<input type=""hidden"" name=""gb"" value=""app"" />"
	strBoxCont = strBoxCont & "	<label>MMS파일첨부</label>"
	strBoxCont = strBoxCont & "	<input type=""file"" class=""h24"" name=""upfile"" />"
	strBoxCont = strBoxCont & "	<img class=""imgBtn"" src=""" & pth_pubImg & "/btn/orange_upload.png"" title=""업로드"" onclick=""fnFileAdd()"" />"
	strBoxCont = strBoxCont & "	<ul id=""upFileList""></ul>"
	strBoxCont = strBoxCont & "</form>"
	strBoxCont = strBoxCont & "<script>fnFileLoad();</script>"
	
elseif proc = "layerDocs" then
	
	strBoxTitle = "메시지불러오기"
	
	strBoxCont = "<div style=""width:540px;height:350px;overflow-x:hidden;overflow-y:scroll;"">"
	
	sql = " select MSG_IDX, MSG_TIT, MSG_SMS from TBL_MSG with(nolock) "
	'sql = sql & "where USEYN = 'Y' and AD_IDX = " & ss_userIdx & " and MSG_PERMIT = 'N' and CD_MSGTP = 200301 order by REGDT desc "
	sql = sql & "where USEYN = 'Y' and MSG_PERMIT = 'Y' and CD_MSGTP = 200301 order by REGDT desc "
	arrRs = execSqlRs(sql)
	
	strBoxCont = strBoxCont & "	<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0"">"
	strBoxCont = strBoxCont & "		<colgroup>"
	strBoxCont = strBoxCont & "			<col width=""33%"" />"
	strBoxCont = strBoxCont & "			<col width=""*"" />"
	strBoxCont = strBoxCont & "			<col width=""33%"" />"
	strBoxCont = strBoxCont & "		</colgroup>"
	
	dim fileRs
	
	if isarray(arrRs) then
		for t = 0 to ubound(arrRs,2)
			if t mod 3 = 0 then
				strBoxCont = strBoxCont & "		<tr>"
			end if
			
			strBoxCont = strBoxCont & "			<td>"
			strBoxCont = strBoxCont & "				<div style=""font-weight:bold;margin:5px;""><img src=""" & pth_pubImg & "/icons/pin-small.png"" />&nbsp;" & arrRs(1,t) & "</div>"
			strBoxCont = strBoxCont & "				<div style=""background:url(/images/msgBg.png);width:150px;height:160px;padding:20px 5px 0 5px;"">"
			strBoxCont = strBoxCont & "					<div style=""height:155px;overflow:hidden;word-break:break-all;"">"
			strBoxCont = strBoxCont & "						<div>"
			
			sql = " select MSGF_PATH, MSGF_FILE from TBL_MSGFILE where MSG_IDX = " & arrRs(0,t) & " "
			fileRs = execSqlRs(sql)
			if isarray(fileRs) then
				arrRc2 = ubound(fileRs,2)
			else
				arrRc2 = -1
			end if
			for ii = 0 to arrRc2
				strBoxCont = strBoxCont & "<div><img src=""/data/" & fileRs(0,ii) & "/" & fileRs(1,ii) & """ width=""150px"" /></div>"
			next
			
			strBoxCont = strBoxCont & "						</div>"
			strBoxCont = strBoxCont & "						"	& arrRs(2,t)
			strBoxCont = strBoxCont & "					</div>"
			strBoxCont = strBoxCont & "				</div>"
			strBoxCont = strBoxCont & "				<div style=""margin:5px 10px;"">"
			strBoxCont = strBoxCont & "					<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0"">"
			strBoxCont = strBoxCont & "						<tr>"
			strBoxCont = strBoxCont & "							<td class=""aL fnt11""><b>" & fnByte(replace(arrRs(2,t),"<br>",Chr(10))) & "</b> Byte</td>"
			strBoxCont = strBoxCont & "							<td class=""aR"">"
			'strBoxCont = strBoxCont & "								<img class=""imgBtn"" src=""" & pth_pubImg & "/icons/acceptBold.png"" onclick=""fnDocsAccept('" & arrRs(1,t) & "','" & arrRs(2,t) & "')"" />"
			strBoxCont = strBoxCont & "								<img class=""imgBtn"" src=""" & pth_pubImg & "/icons/acceptBold.png"" onclick=""fnDocsAccept('" & arrRs(0,t) & "')"" />"
			strBoxCont = strBoxCont & "								<img class=""imgBtn"" src=""" & pth_pubImg & "/icons/crossBold.png"" onclick=""fnDocsDeleteN('" & arrRs(0,t) & "')"" />"
			strBoxCont = strBoxCont & "							</td>"
			strBoxCont = strBoxCont & "						</tr>"
			strBoxCont = strBoxCont & "					</table>"
			strBoxCont = strBoxCont & "				</div>"
			strBoxCont = strBoxCont & "			</td>"
			
			if t mod 3 = 2 then
				strBoxCont = strBoxCont & "		</tr><tr><td colspan=""3""><div style=""background:url(" & pth_pubImg & "/line.png);height:2px;margin:5px 0;""></div></td></tr>"
			end if
		next
		if ubound(arrRs,2) < 2 then    
			for t = 1 to 2 - ubound(arrRs,2)
			
				strBoxCont = strBoxCont & "			<td>"
				strBoxCont = strBoxCont & "				<div style=""font-weight:bold;margin:5px;""><img src=""" & pth_pubImg & "/icons/pin-small.png"" />&nbsp;</div>"
				strBoxCont = strBoxCont & "				<div style=""background:url(/images/msgBg.png);width:150px;height:160px;padding:20px 5px 0 5px;""><div style=""height:155px;overflow:hidden;word-break:break-all;""></div></div>"
				strBoxCont = strBoxCont & "				<div style=""margin:5px 10px;"">"
				strBoxCont = strBoxCont & "					<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0"">"
				strBoxCont = strBoxCont & "						<tr>"
				strBoxCont = strBoxCont & "							<td class=""aL fnt11""><b>0</b> Byte</td>"
				strBoxCont = strBoxCont & "							<td class=""aR"">"
				strBoxCont = strBoxCont & "							</td>"
				strBoxCont = strBoxCont & "						</tr>"
				strBoxCont = strBoxCont & "					</table>"
				strBoxCont = strBoxCont & "				</div>"
				strBoxCont = strBoxCont & "			</td>"
				
			next
		end if
	end if
	
	strBoxCont = strBoxCont & "</table></div>"
	
elseif proc = "layerDocs2" then
	
	strBoxTitle = "메시지불러오기"
	
	strBoxCont = "<div style=""width:540px;height:350px;overflow-x:hidden;overflow-y:scroll;"">"
	
	sql = " select MSG_IDX, MSG_TIT, MSG_VMS from TBL_MSG with(nolock) where USEYN = 'Y' and AD_IDX = " & ss_userIdx & " and MSG_PERMIT = 'N' and CD_MSGTP = 200302 order by REGDT desc "
	arrRs = execSqlRs(sql)
	
	strBoxCont = strBoxCont & "	<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0"">"
	strBoxCont = strBoxCont & "		<colgroup>"
	strBoxCont = strBoxCont & "			<col width=""33%"" />"
	strBoxCont = strBoxCont & "			<col width=""*"" />"
	strBoxCont = strBoxCont & "			<col width=""33%"" />"
	strBoxCont = strBoxCont & "		</colgroup>"
	
	if isarray(arrRs) then
		for t = 0 to ubound(arrRs,2)
			if t mod 3 = 0 then
				strBoxCont = strBoxCont & "		<tr>"
			end if
			
			strBoxCont = strBoxCont & "			<td>"
			strBoxCont = strBoxCont & "				<div style=""font-weight:bold;margin:5px;""><img src=""" & pth_pubImg & "/icons/pin-small.png"" />&nbsp;" & arrRs(1,t) & "</div>"
			strBoxCont = strBoxCont & "				<div style=""background:url(/images/msgBg.png);width:150px;height:160px;padding:20px 5px 0 5px;"">"
			strBoxCont = strBoxCont & "					<div style=""height:155px;overflow:hidden;word-break:break-all;"">" & arrRs(2,t) & "</div>"
			strBoxCont = strBoxCont & "				</div>"
			strBoxCont = strBoxCont & "				<div style=""margin:5px 10px;"">"
			strBoxCont = strBoxCont & "					<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0"">"
			strBoxCont = strBoxCont & "						<tr>"
			strBoxCont = strBoxCont & "							<td class=""aL fnt11""><b>" & fnByte(replace(arrRs(2,t),"<br>",Chr(10))) & "</b> Byte</td>"
			strBoxCont = strBoxCont & "							<td class=""aR"">"
			strBoxCont = strBoxCont & "								<img class=""imgBtn"" src=""" & pth_pubImg & "/icons/acceptBold.png"" onclick=""fnDocsAccept('" & arrRs(0,t) & "')"" />"
			strBoxCont = strBoxCont & "								<img class=""imgBtn"" src=""" & pth_pubImg & "/icons/crossBold.png"" onclick=""fnDocsDeleteN('" & arrRs(0,t) & "')"" />"
			strBoxCont = strBoxCont & "							</td>"
			strBoxCont = strBoxCont & "						</tr>"
			strBoxCont = strBoxCont & "					</table>"
			strBoxCont = strBoxCont & "				</div>"
			strBoxCont = strBoxCont & "			</td>"
			
			if t mod 3 = 2 then
				strBoxCont = strBoxCont & "		</tr><tr><td colspan=""3""><div style=""background:url(" & pth_pubImg & "/line.png);height:2px;margin:5px 0;""></div></td></tr>"
			end if
		next
		if ubound(arrRs,2) < 2 then    
			for t = 1 to 2 - ubound(arrRs,2)
			
				strBoxCont = strBoxCont & "			<td>"
				strBoxCont = strBoxCont & "				<div style=""font-weight:bold;margin:5px;""><img src=""" & pth_pubImg & "/icons/pin-small.png"" />&nbsp;</div>"
				strBoxCont = strBoxCont & "				<div style=""background:url(/images/msgBg.png);width:150px;height:160px;padding:20px 5px 0 5px;""><div style=""height:155px;overflow:hidden;word-break:break-all;""></div></div>"
				strBoxCont = strBoxCont & "				<div style=""margin:5px 10px;"">"
				strBoxCont = strBoxCont & "					<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0"">"
				strBoxCont = strBoxCont & "						<tr>"
				strBoxCont = strBoxCont & "							<td class=""aL fnt11""><b>0</b> Byte</td>"
				strBoxCont = strBoxCont & "							<td class=""aR"">"
				strBoxCont = strBoxCont & "							</td>"
				strBoxCont = strBoxCont & "						</tr>"
				strBoxCont = strBoxCont & "					</table>"
				strBoxCont = strBoxCont & "				</div>"
				strBoxCont = strBoxCont & "			</td>"
				
			next
		end if
	end if
	
	strBoxCont = strBoxCont & "</table></div>"
	
elseif proc = "layerLastNum" then
	
	strBoxTitle = "최근발신번호"
	
	strBoxCont = "<div style=""width:220px;background:#ffffff;overflow-x:hidden;overflow-y:scroll;height:150px;color:#333;""><dl style=""font-size:11px;border-top:1px solid #cccccc;"">"
	
	if dbType = "mssql" then
		sql = " select top 10 CLT_NM "
		'sql = sql & " 	, dbo.ecl_DECRPART(CLT_NUM1,4) "
		sql = sql & " 	, CLT_NUM1 "
		sql = sql & " from TBL_CALLTRG with(nolock) where CL_IDX in (select CL_IDX from TBL_CALL with(nolock) where AD_IDX = " & ss_userIdx & ") order by REGDT desc "
	elseif dbType = "mysql" then
		sql = " select CLT_NM, CLT_NUM1 from TBL_CALLTRG where CL_IDX in (select CL_IDX from TBL_CALL where AD_IDX = " & ss_userIdx & ") order by REGDT desc limit 0, 10; "
	end if
	arrRs = execSqlRs(sql)
	
	if isarray(arrRs) then
		arrRc2 =ubound(arrRs,2)
		for i = 0 to arrRc2
			strBoxCont = strBoxCont & "<dt style=""float:left;line-height:20px;border-bottom:1px solid #cccccc;padding:1px 0 2px 0;width:30%;"">&nbsp;" & fnCutStr(arrRs(0,i),4) & "&nbsp;</dt>"
			strBoxCont = strBoxCont & "<dd style=""float:left;line-height:20px;border-bottom:1px solid #cccccc;padding:1px 0 2px 0;width:57%;"">" & arrRs(1,i) & "&nbsp;</dd>"
			strBoxCont = strBoxCont & "<dd style=""float:left;line-height:20px;border-bottom:1px solid #cccccc;padding:1px 0 2px 0;width:10%;"">"
			strBoxCont = strBoxCont & "<input type=""hidden"" id=""lastNm_" & i & """ name=""lastNm_" & i & """ value=""" & arrRs(0,i) & """ />"
			strBoxCont = strBoxCont & "<input type=""hidden"" id=""lastNum_" & i & """ name=""lastNum_" & i & """ value=""" & arrRs(1,i) & """ />"
			strBoxCont = strBoxCont & "<img class=""imgBtn"" style=""vertical-align:middle"" src=""" & pth_pubImg & "/icons/icon_add.png"" onclick=""fnAddLastNum(" & i & ")"" />"
			strBoxCont = strBoxCont & "</dd>"
		next
	end if
	
	strBoxCont = strBoxCont & "</dl></div>"
	
elseif proc = "layerSchd" then
	
	dim schdDT : schdDT = now
	if minute(now) > 55 then
		schdDT = fnDateToStr(dateAdd("h",1,now),"yyyy-mm-dd hh:00:00")
	end if
	dim schdDate : schdDate = fnDateToStr(schdDT,"yyyy-mm-dd")
	dim schdHH : schdHH = hour(schdDT)
	dim schdNN : schdNN = minute(schdDT)
	if right(schdNN,1) > 4 then
		schdNN = fix(left(schdNN+5,1)) & "0"
	else
		if len(schdNN) > 1 then
			schdNN = fix(left(schdNN+5,1)) & "5"
		else
			schdNN = 5
		end if
	end if
	
	strBoxTitle = "예약전송"
	
	strBoxCont = "<table border=""0"" cellpadding=""0"" cellspacing=""0"">"
	strBoxCont = strBoxCont & "	<tr>"
	strBoxCont = strBoxCont & " 	<td rowspan=""3""><iframe name=""calFrame"" src=""/public/etc/calendar.asp?gb=2&trg=schdDate"" frameborder=""0"" style=""width:200px;height:200px;""></iframe></td>"
	strBoxCont = strBoxCont & " 	<td rowspan=""3"" width=""15px"">&nbsp;</td>"
	strBoxCont = strBoxCont & " 	<td width=""170px"" " & pth_pubImg & "=""top""><div style=""height:30px;line-height:26px;background:#BCB7A3;text-align:center;font-weight:bold;"">예약일시</div></td>"
	strBoxCont = strBoxCont & "	</tr>"
	strBoxCont = strBoxCont & " <tr>"
	strBoxCont = strBoxCont & "		<td " & pth_pubImg & "=-""top"">"
	strBoxCont = strBoxCont & "			<input type=""text"" id=""schdDate"" name=""schdDate"" value=""" & date & """ size=""10"" readonly />"
	strBoxCont = strBoxCont & "			<div style=""margin-top:5px;"">"
	strBoxCont = strBoxCont & "			<select id=""schdHH"" name=""schdHH"">"
	for i = 0 to 23
		strBoxCont = strBoxCont & "				<option value=""" & right("0" & i,2) & """"
		if i = schdHH then
			strBoxCont = strBoxCont & " selected "
		end if
		strBoxCont = strBoxCont & ">" & i & "</option>"
	next
	strBoxCont = strBoxCont & "			</select>시 "
	strBoxCont = strBoxCont & "			<select id=""schdNN"" name=""schdNN"">"
	for i = 0 to 59 step 1
		strBoxCont = strBoxCont & "				<option value=""" & right("0" & i,2) & """"
		if i = cint(schdNN) then
			strBoxCont = strBoxCont & " selected "
		end if
		strBoxCont = strBoxCont & ">" & right("0" & i,2) & "</option>"
	next
	strBoxCont = strBoxCont & "			</select>분"
	strBoxCont = strBoxCont & "			<select id=""schdSS"" name=""schdSS"">"
	for i = 0 to 59 step 1
		strBoxCont = strBoxCont & "				<option value=""" & right("0" & i,2) & """"
		strBoxCont = strBoxCont & ">" & right("0" & i,2) & "</option>"
	next
	strBoxCont = strBoxCont & "			</select>초"
	strBoxCont = strBoxCont & "			</div>"
	strBoxCont = strBoxCont & "		</td>"
	strBoxCont = strBoxCont & "	</tr>"
	strBoxCont = strBoxCont & " <tr>"
	strBoxCont = strBoxCont & "		<td class=""aR"" " & pth_pubImg & "=""bottom""><img class=""imgBtn"" src=""" & pth_pubImg & "/btn/B_green_send.png"" title=""전송"" onclick=""fnSendSchd()"" /></td>"
	strBoxCont = strBoxCont & "	</tr>"
	strBoxCont = strBoxCont & "</table>"
	
end if
%>

<div class="layerTit">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td><%=strBoxTitle%></td>
			<td class="aR" onclick="fnCloseLayerContBox()" style="width:36px;cursor:pointer;"><img class="imgBtn" src="<%=pth_pubImg%>/close.png" width="16px" /></td>
		</tr>
	</table>
</div>
<div class="layerCont">
	<%=strBoxCont%>
</div>