<!--#include virtual="/common/common.asp"-->

<% mnCD = "0104" %>

<!--#include virtual="/common/header_htm.asp"-->

<%
dim clGB : clGB = "V"

if fnDBVal("TBL_ADDR", "CD_USERGB", "AD_IDX = " & ss_userIdx & "") > 1005 then
	response.write	"<script>alert('사용권한이 없습니다.');history.back();</script>"
end if

'#	임시 대상자 및 파일 삭제
call execProc("usp_delTmpTrg",array(0, ss_userIdx, svr_remoteAddr))
call execProc("usp_delTmpFile",array(0, ss_userIdx, svr_remoteAddr))

'#	예약일시 값 설정
dim rsvDT : rsvDT = now
if minute(now) > 55 then
	rsvDT = fnDateToStr(dateAdd("h",1,now),"yyyy-mm-dd hh:00:00")
end if
dim rsvDate : rsvDate = fnDateToStr(rsvDT,"yyyy-mm-dd")
dim rsvHH : rsvHH = hour(rsvDT)
dim rsvNN : rsvNN = minute(rsvDT)
if right(rsvNN,1) > 4 then
	rsvNN = fix(left(rsvNN+5,1)) & "0"
else
	if len(rsvNN) > 1 then
		rsvNN = fix(left(rsvNN+5,1)) & "5"
	else
		rsvNN = 5
	end if
end if

'#	발신번호
'dim clSndNum : clSndNum = fnDBVal("TBL_ADDR", "dbo.ecl_DECRPART(dbo.ufn_getSndNum('V', AD_IDX),4)", "AD_IDX = '" & ss_userIdx & "'")
dim clSndNum : clSndNum = fnDBVal("TBL_ADDR", "dbo.ufn_getSndNum('V', AD_IDX)", "AD_IDX = '" & ss_userIdx & "'")
if clSndNum = "" then
	clSndNum = dftSndNum
end if
'clSndNum = dftSndNum

'#	재전송
dim clIdx : clIdx = fnReq("clIdx") : if clIdx = "" then clIdx = 0 end if

dim msgIdx, VMSMsg, msgTit
if clIdx > 0 then
	'#	기본전송정보
	sql = " select MSG_IDX, CL_SNDNUM1, CL_VMSMSG, CL_TIT from TBL_CALL with(nolock) "
	sql = sql & " where CL_IDX = " & clIdx & " "
	cmdOpen(sql)
	set rs = cmd.execute
	cmdClose()
	if not rs.eof then
		msgIdx = rs(0)
		clSndNum = rs(1)
		VMSMsg = replace(rs(2), "<br>", chr(13))
		msgTit = rs(3)
	end if
	rsClose()
	if msgIdx > 0 then
		if dbType = "mssql" then
			msgInfo = fnDBArrVal("TBL_MSG", array("dbo.ufn_getCodeName(left(convert(varchar(10),CD_MSGTP),4))","dbo.ufn_getCodeName(CD_MSGTP)"), "MSG_IDX = " & msgIdx & "")
		elseif dbType = "mysql" then
			msgInfo = fnDBArrVal("TBL_MSG", array("ufn_getCodeName(left(convert(CD_MSGTP, char(10)),4))","ufn_getCodeName(CD_MSGTP)"), "MSG_IDX = " & msgIdx & "")
		end if
		cdMsgTP1 = msgInfo(0)
		cdMsgTP2 = msgInfo(1)
	end if
	'#	대상자
	sql = " insert into TMP_CALLTRG (CL_IDX, AD_IDX, AD_IP, TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, TMP_NUM1, TMP_NUM2, TMP_NUM3, TMP_TIT, TMP_SMSMSG, TMP_VMSMSG, TMP_FMSMSG) "
	sql = sql & " select 0, " & ss_userIdx & ", '" & svr_remoteAddr & "', clt.CLT_NO, clt.CLT_SORT, clt.AD_IDX, clt.CLT_NM, clt.CLT_NUM1, clt.CLT_NUM2, clt.CLT_NUM3, '', '', '', '' "
	sql = sql & " from TBL_CALLTRG as clt with(nolock) "
	sql = sql & " where clt.CL_IDX = " & clIdx & " "
	call execSql(sql)
	'#	첨부파일
	sql = " insert into TMP_CALLFILE (CL_IDX, AD_IDX, AD_IP, TMP_GB, TMP_NO, TMP_SORT, TMP_DPNM, TMP_PATH, TMP_FILE, TMP_PAGE) "
	sql = sql & " select 0, " & ss_userIdx & ", '" & svr_remoteAddr & "', CLF_GB, CLF_NO, CLF_SORT, CLF_DPNM, CLF_PATH, CLF_FILE, CLF_PAGE "
	sql = sql & " from TBL_CALLFILE with(nolock) "
	sql = sql & " where CL_IDX = " & clIdx & " "
	call execSql(sql)
end if

'#	임시대상자수
dim trgCnt : trgCnt = fnDBVal("TMP_CALLTRG", "count(*)", " CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' ")

%>

<style>
	.cke {border:0;}
</style>

<table width="100%" border="0" cellpadding="0" cellspacing="0" style="table-layout:fixed;">
	<colgroup>
		<col width="280px" />
		<col width="20px" />
		<col width="" />
	</colgroup>
	<tr>
		<td valign="top">

			<div id="phoneBox">

				<div style="padding:10px 17px;">
					
					<form name="frm" method="post" action="callProc.asp" target="procFrame">
						<input type="hidden" name="clGB" value="<%=clGB%>" />
						<input type="hidden" name="clMethod" value="0" />
						<input type="hidden" name="clMedia1" value="1" />
						<input type="hidden" name="clMedia2" value="0" />
						<input type="hidden" name="clMedia3" value="0" />
						<input type="hidden" name="clTry" value="3" />
						<input type="hidden" name="schdYN" value="N" />
						<input type="hidden" name="schdDT" value="" />
						<input type="hidden" name="tmpTrg" value="0" />
						
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="30%" />
								<col width="*" />
								<col width="30%" />
							</colgroup>
							<tr>
								<td class="aL">
								</td>
								<td class="aC"><div id="prntTime" style="color:#fff;font-weight:bold">00:00</div></td>
								<td class="aR">
									<img class="imgBtn" src="<%=pth_pubImg%>/btn/green_prevLit.png" onclick="fnVMSPreLit()" />
								</td>
							</tr>
						</table>
	
						<div style="height:7px;"></div>
						
						<input type="text" name="tit" style="width:242px;border:0;background:none;color:#eeeeee;" maxlength="50" value="<%=msgtit%>" />
						
						<div style="height:215px;overflow-x:hidden;overflow-y:scroll;border-top:2px solid #888888;">
							<div id="addImg"></div>
							
							<textarea id="msg" name="msg" style="width:99%;height:200px;background:none;font-size:12px;font-family:맑은 고딕;line-height:24px;border:0;color:#ffffff;overflow:hidden;"
								onkeyup="fnCheckByteSMS(this)" onkeydown="fnCheckByteSMS(this)" onkeypress="fnCheckByteSMS(this)"><%=VMSMsg%></textarea>
						</div>
						
						<div style="padding:2px 3px 3px;background:#cccccc;">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td>
										<img id="btnDocsOpen" class="imgBtn" src="<%=pth_sitImg%>/phn_btn_msgOpen.png" title="불러오기" />
										<img id="btnDocsSave" class="imgBtn" src="<%=pth_sitImg%>/phn_btn_msgSave.png" title="저장" />
										<img id="btnDocsDel" class="imgBtn" src="<%=pth_sitImg%>/phn_btn_msgRemove.png" title="지우기" />
									</td>
									<td class="aR" style="font-size:11px;"><span id="bytePrint" style="font-weight:bold;">0</span> Byte&nbsp;</td>
								</tr>
							</table>
						</div>
	
						<div style="background:#cccccc;padding:2px;height:24px;margin-top:1px;">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td>
										<input class="h18" type="text" name="add_num" onkeypress="if (event.keyCode==13) {fnAddInputNum();}" style="width:140px;" maxlength="20" />
									</td>
									<td class="aR"><img class="imgBtn" src="<%=pth_sitImg%>/phone_addNum.png" title="입력" onclick="fnAddInputNum()" /></td>
								</tr>
							</table>
						</div>
	
						<div style="background:#cccccc;padding:4px 2px;height:20px;margin-top:1px;">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td width="80px"><img id="btnLastNum" class="imgBtn" src="<%=pth_sitImg%>/phone_lastedNum.png" title=="최근발신번호" /></td>
									<td width="5px"></td>
									<td width="80px"><img class="imgBtn" src="<%=pth_sitImg%>/phone_removeNum.png" title="모두지우기" onclick="fnAllNumDel()" /></td>
									<td class="aR"><b><span id="trgCnt">0</span></b>건</td>
								</tr>
							</table>
						</div>
						
						<div style="background:#ffffff;margin-top:1px;">
							<iframe name="trgList" src="frm_tmpTrgList.asp" frameborder="0" style="width:100%;height:110px;"></iframe>
						</div>
						
						<div style="background:#0080FF;height:30px;margin-top:1px;">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td style="padding-left:5px;color:#ffffff;font-size:11px;">보내는번호</td>
									<td class="aR" style="padding:4px;color:#ffffff;">[ <input type="text" id="snd_num" name="snd_num" value="<%=clSndNum%>" style="width:130px;background:#000;border:1px solid #a2a2a2;color:#eee;"
										onkeyup="fnPrntAllByte()" onkeydown="fnPrntAllByte()" onkeypress="fnPrntAllByte()" /> ]</td>
								</tr>
							</table>
						</div>
						
						<div style="margin-top:4px;">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td><img id="btnSchd" class="imgBtn" src="<%=pth_sitImg%>/phn_btn_schdSnd.png" /></td>
									<td class="aR"><img id="btnSend" class="imgBtn" src="<%=pth_sitImg%>/phn_btn_nowSnd.png" /></td>
								</tr>
							</table>
						</div>
						
					</form>
					
				</div>
				
			</div>

		</td>
		<td></td>
		<td valign="top">
			
			<div id="subPageBox">
				
				<div class="aR" style="margin-bottom:5px;">
					<img id="trgSet" class="imgBtn" src="<%=pth_pubImg%>/btn/purple_targetSet.png" onclick="fnTargetSet()" />
					<img id="trgChk" class="imgBtn" src="<%=pth_pubImg%>/btn/red_targetChk.png" onclick="fnTargetChk()" />
				</div>
				
				<%
				'#	권한설정
				dim adPerAddr : adPerAddr = fnDBVal("TBL_ADDR", "AD_PERADDR", "AD_IDX = " & ss_userIdx & "")

				dim arrAddrs : arrAddrs = arrAddrBooksNm'array("직원 주소록","부서 주소록","개인 주소록")
				dim arrAddrsGb : arrAddrsGb = arrAddrBooksCD'array("D","E","P")
				dim arrAddrsListPer : arrAddrsListPer = array("M","A","A","A")'array("M","A","A")
				if adPerAddr = "A" then
					arrAddrsListPer = array("A","A","A")'array("A","A","A")
				end if
				'dim arrAddrs : arrAddrs = array("직원주소록","개인주소록")
				'dim arrAddrsGb : arrAddrsGb = array("D","P")
				%>
				
				<div id="tabs">
					<ul id="tabsMenu">
						<li id="tabsMenu_1" onclick="fnSelTab(1)" style="font-size:11px;">자주쓰는메시지</li>
						<%
						for i = 0 to ubound(arrAddrs)
							response.write	"<li id=""tabsMenu_" & i+2 & """ onclick=""fnSelTab(" & i+2 & ")"" style=""font-size:11px;"">" & arrAddrs(i) & "</li>"
						next
						%>
						<!--<li id="tabsMenu_<%=i+2%>" onclick="fnSelTab(<%=i+2%>)">엑셀업로드</li>-->
						<div class="clr"></div>
					</ul>
					<div class="clr"></div>
					<div class="tabsContBox">
						<div id="tabs-1" class="tabsCont">
							<%
							dim msgRs
							if dbType = "mssql" then
								sql = " select top 6 MSG_IDX, MSG_TIT, MSG_VMS from TBL_MSG where USEYN = 'Y' and CD_MSGTP = 200302 and MSG_PERMIT = 'Y' order by MSG_IDX desc "
							elseif dbType = "mysql" then
								sql = " select MSG_IDX, MSG_TIT, MSG_VMS from TBL_MSG where USEYN = 'Y' and CD_MSGTP = 200302 and MSG_PERMIT = 'Y' order by MSG_IDX desc limit 0, 6 "
							end if
							msgRs = execSqlRs(sql)
							%>
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<colgroup>
									<col width="33%" />
									<col width="*" />
									<col width="33%" />
								</colgroup>
								<%
								if isarray(msgRs) then
									for t = 0 to ubound(msgRs,2)
										if t mod 3 = 0 then
											response.write	"<tr>"
										end if
										%>
											<td>
												<div style="font-weight:bold;margin:5px;"><img src="<%=pth_pubImg%>/icons/pin-small.png" />&nbsp;<%=msgRs(1,t)%></div>
												<div style="background:url(<%=pth_sitImg%>/msgBg.png);width:150px;height:160px;padding:20px 5px 0 5px;">
													<div style="height:155px;overflow:hidden;word-break:break-all;">
														<%=msgRs(2,t)%>
													</div>
												</div>
												<div style="margin:5px 10px;">
													<table width="100%" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td class="aL fnt11"><b><%=fnByte(replace(msgRs(2,t),"<br>",Chr(10)))%></b> Byte</td>
															<td class="aR">
																<!--<img class="imgBtn" src="<%=pth_pubImg%>/icons/acceptBold.png" onclick="fnDocsAccept('<%=msgRs(1,t)%>','<%=msgRs(2,t)%>')" />-->
																<img class="imgBtn" src="<%=pth_pubImg%>/icons/acceptBold.png" onclick="fnDocsAccept(<%=msgRs(0,t)%>)" />
															</td>
														</tr>
													</table>
												</div>
											</td>
										<%
										if t mod 3 = 2 then
											response.write	"</tr><tr><td colspan=""3""><div style=""background:url(" & pth_pubImg & "/line.png);height:2px;margin:5px 0;""></div></td></tr>"
										end if
									next
									if ubound(msgRs,2) < 2 then    
										for t = 1 to 2 - ubound(msgRs,2)
											%>
											<td>
												<div style="font-weight:bold;margin:5px;"><img src="<%=pth_pubImg%>/icons/pin-small.png" />&nbsp;</div>
												<div style="background:url(<%=pth_sitImg%>/msgBg.png);width:150px;height:160px;padding:20px 5px 0 5px;"><div style="height:155px;overflow:hidden;word-break:break-all;"></div></div>
												<div style="margin:5px 10px;">
													<table width="100%" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td class="aL fnt11"><b>0</b> Byte</td>
															<td class="aR">
															</td>
														</tr>
													</table>
												</div>
											</td>
											<%
										next
									end if
								end if
								%>
							</table>
						</div>
						<%
						dim adIdx : adIdx = 0
						dim subRs, subRs2
						for i = 0 to ubound(arrAddrs)
							
							if i = 1 or i = 2 then
								adIdx = ss_userIdx
							end if
							%>
							<div id="tabs-<%=i+2%>" class="tabsCont">
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td><h3><%=arrAddrs(i)%></h3></td>
										<td class="aR"><input type="checkbox" name="allChk<%=i+2%>" onclick="fnTrgAllSel(<%=i+2%>)" style="" /> 전체선택</td>
									</tr>
								</table>
								<div id="addrBox<%=i+2%>" class="addrBox">
									<form name="frmTrg<%=i+2%>" method="post" action="trgProc.asp" target="procFrame">
										<input type="hidden" name="tp" value="<%=i+2%>" />
										<table width="100%" border="0" cellpadding="0" cellspacing="0">
											<colgroup>
												<col width="58%" />
												<col width="10px" />
												<col width="*" />
											</colgroup>
											<tr>
												<td>
													<ul id="grp<%=i+2%>" class="selectBox">
														<%
														dim nGrpNM
														'arrVals = array(arrAddrsGb(i), ss_userIdx)
														'arrRs = execProcRs("usp_getGrpListNew", arrVals)
														arrRs = execProcRs("usp_listGrp_IWEST", array(arrAddrsGb(i), 1, ss_userIdx, arrAddrsListPer(i), "A"))
														'response.write	"exec usp_listGrp_IWEST '" & arrAddrsGb(i) & "', 1, " & ss_userIdx & ", '" & arrAddrsListPer(i) & "', 'A'"
														if isarray(arrRs) then
															for ii = 0 to ubound(arrRs,2)
																'nGrpNM = arrRs(1,ii)
																'if len(arrRs(2,ii)) > 0 then
																'	nGrpNM = nGrpNM & " > " & arrRs(2,ii)
																'end if
																'if len(arrRs(3,ii)) > 0 then
																'	nGrpNM = nGrpNM & " > " & arrRs(3,ii)
																'end if
																'if len(arrRs(9,ii)) > 0 then
																'	nGrpNM = nGrpNM & " > " & arrRs(9,ii)
																'end if
																'if len(arrRs(10,ii)) > 0 then
																'	nGrpNM = nGrpNM & " > " & arrRs(10,ii)
																'end if
																nGrpNM = arrRs(8,ii)
																response.write	"<li><input type=""checkbox"" name=""grpCode"" value=""" & arrRs(0,ii) & """ />" & nGrpNM & "<input type=""hidden"" name=""nNm"" value=""" & nGrpNM & """ /></li>"
																'response.write	"<li><input type=""hidden"" name=""grpCode"" value=""" & arrRs(0,ii) & """ />" & nGrpNM & "</li>"
															next
														end if
														%>
													</ul>
												</td>
												<td></td>
												<td>
													<div id="trg<%=i+2%>" class="selectBox" style="width:200px;">
														<table width="180px" border="0" cellpadding="0" cellspacing="0">
															<colgroup>
																<col width="40%" />
																<col width="50%" />
																<col width="10%" />
															</colgroup>
															<tbody>
															</tbody>
														</table>
													</div>
												</td>
											</tr>
										</table>
										<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-top:10px;">
											<tr>
												<td style="text-align:left;font-size:12px;">
													<img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_grpAdd.png" title="선택추가" onclick="fnAddGrpTrg(<%=i+2%>)" />
												</td>
												<td style="text-align:right;">
													총 <b id="selTrgCount<%=i+2%>" class="selTrgCount">0</b>명 선택
													<img class="imgBtn" src="<%=pth_pubImg%>/btn/blue_add.png" title="추가" onclick="fnAddTrg(<%=i+2%>)" />
												</td>
											</tr>
										</table>
									</form>
								</div>
							</div>
						<% next %>
						<div id="tabs-<%=i+2%>" class="tabsCont">
							<h3>엑셀업로드</h3>
							<div style="padding:5px 10px;border-top:2px solid #999999;border-bottom:2px solid #999999;">
							
								<div style="background:#eeeeee;border:1px solid #cccccc;padding:10px;margin:10px 0;">
									<dl class="noticeMsgList">
										<dt>엑셀업로드 주의사항</dt>
										<dd>업로드된 대상자는 <span>개인주소록</span>에 <b>"아이디_날짜"</b> 그룹으로 생성되므로 동일한 대상자를 여러번 업로드 할 필요없이 <span>개인주소록에서 <b>불러와</b> 전송</span>할 수 있습니다.</dd>
										<!--<dd>엑셀파일을 업로드하여 전송할 경우 <span>대상자의 <b>App설치 여부</b>를 확인하여 전송</span>하므로 전송요청까지 시간이 <b>지연</b>될 수 있습니다.</dd>-->
										<dd>1회 업로드 시 <span>최대 <b>1,000</b>건</span> 까지만 업로드가 가능합니다. 1,000건 이상의 대상자에게 전송 할 시에는 1,000건 씩 <span><b>분할</b>해서 업로드</span> 하시기 바랍니다.</dd>
										<!--<dd>페이지 좌측 입력란에 입력된 내용보다 <span>엑셀파일의 내용이 <b>우선</b>적으로 전송</span>됩니다.(엑셀파일에 내용이 없을경우에는 입력란의 내용이 전송됨)</dd>-->
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
													<input type="radio" name="xlsUpGb" value="1" checked /> 번호만
													<!--<input type="radio" name="xlsUpGb" value="2" /> 번호+메시지-->
												</td>
												<td style="padding-left:30px;"><img class="imgBtn" src="<%=pth_pubImg%>/btn/orange_upload.png" title="업로드" onclick="fnXlsUpload()" /></td>
											</tr>
										</table>
									</form>
									<div class="clr"></div>
								</div>
								
								<p style="margin-top:10px;">
									지정된 형식의 엑셀파일을 업로드하여 대상자를 전송합니다.
									<img class="imgBtn" src="<%=pth_pubImg%>/btn/olive_sample.png" title="샘플다운로드" onclick="fnSampleDown()" />
								</p>
								
								<table id="xlsExmTbls1" width="100%" border="0" cellpadding="0" cellspacing="0" class="tblXls" style="margin-top:10px;">
									<colgroup>
										<col width="40px" />
										<col width="100px" />
										<col width="100px" />
										<col width="150px" />
										<col width="120px" />
									</colgroup>
									<tr><th class="gb"></th><th>A</th><th>B</th><th>C</th><th>D</th></tr>
									<tr><td class="no">1</td><td>이름</td><td>전화번호</td><td></td><td></td></tr>
									<tr><td class="no">2</td><td>연락처1</td><td>010-1111-1111</td><td></td><td></td></tr>
									<tr><td class="no">3</td><td>연락처2</td><td>010-2222-2222</td><td></td><td></td></tr>
									<tr><td class="no">4</td><td>연락처3</td><td>010-3333-3333</td><td></td><td></td></tr>
									<tr><td class="no">5</td><td></td><td></td><td></td><td></td></tr>
								</table>
								
								<div style="background:#eeeeee;border:1px solid #cccccc;padding:10px;margin:10px 0;">
									<dl class="noticeMsgList">
										<dt>주의사항</dt>
										<dd>메시지 파일 양식(엑셀파일)에 따라 목록(전화번호)과 내용을 작성하신 후 엑셀파일 형식(.xls, .xlsx)으로 저장하여 업로드 해주세요.</dd>
										<dd>양식파일의 모든 필드는 <span>텍스트</span> 형식으로 변경해야 합니다.(셀서식 -> 표시형식 텝 "텍스트")</dd>
										<dd>휴대폰번호는 <span>숫자와 하이픈(-)</span>만 사용할 수 있습니다.(이외의 문자가 들어간 경우 오류가 발생할 수 있습니다.)</dd>
										<dd>전송할 목록은 Sheet1에만 작성해 주세요.</dd>
									</dl>
								</div>
							
							</div>
						</div>
						
					</div>
				</div>
				
			</div>

		</td>
	</tr>
</table>

<!--#include virtual="/common/footer_htm.asp"-->

<script>
	
	var selTrg = 0;
	var trgType = '0';
	var grpCode = '';
	var nTab = 1;
	
	$(function(){
		
		$('input[name=tit]').focus();
		
		// Tab Menu	==============================================================================
		$('#tabsMenu_1').addClass('on');
		$('#tabs-1').css('display','block');
		$('#tabsMenu li').bind('mouseover',function(){
			$(this).addClass('on');
		});
		$('#tabsMenu li').bind('mouseout',function(){
			if($(this).prop('id') != 'tabsMenu_'+nTab){
				$(this).removeClass('on');
			}
		});
		// Tab Menu	==============================================================================
		
		//	Default Image Buttons	==============================================================================
		$('.imgBtn').bind('click',function(e){
			var nId = $(this).prop('id');
			posX = e.pageX;
			posY = e.pageY;
			if(nId == 'btnDocsOpen'){
				posY = posY - 200;
				layContW = 580;
				fnOpenLayerContBox('layerDocs2');
			}else if(nId == 'btnDocsSave'){
				if(document.frm.msg.value == ''){
					alert('내용을 입력해 주세요.');document.frm.msg.focus();return;
				}
				document.frm.action = 'docsProc.asp?proc=add';
				document.frm.submit();
			}else if(nId == 'btnDocsDel'){
				document.frm.tit.value = '';
				document.frm.msg.value = '';
				$('#addImg').html('');
				fnPrntAllByte();
				procFrame.location.href = 'fileProc.asp?proc=delAll';
			}else if(nId == 'btnSchd'){
				posY = posY - 240;
				layContW = 360;
				fnOpenLayerContBox('layerSchd');
			}else if(nId == 'btnSend'){
				fnSend();
			}
		});
		//	Default Image Buttons	==============================================================================
		
		$('#btnLastNum').bind('click',function(e){
			posX = e.pageX;
			posY = e.pageY;
			layContW = 240;
			fnOpenLayerContBox('layerLastNum');
		});
		
		//	Address Select	==============================================================================
		<% for i = 2 to 4 %>
			$('#grp<%=i%> li').bind('click',function(){
				$('#grp<%=i%> li').removeClass('on');
				$(this).addClass('on');
				grpCode = $(this).find('input[name=grpCode]').val();
				fnLoadAddr(<%=i%>);
				fnCountTrg(<%=i%>);
			});
		<% next %>
		//	Address Select	==============================================================================
		
		fnPrntAllByte();	
		fnPrntTime();
	});
	
	function fnPrntTime(){
		var dt = new Date();
		var tm = dt.getHours() + ':' + dt.getMinutes();
		$('#prntTime').html(tm);
		setTimeout('fnPrntTime()',500);
	}
	
	function fnSelTab(n){
		nTab = n;
		$('.tabsCont').css('display','none');
		$('#tabs-'+n).css('display','block');
		$('#tabsMenu li').removeClass('on');
		$('#tabsMenu_'+n).addClass('on');
		$('.selectBox li').removeClass('on');
		$('.selectBox input[type=checkbox]').prop('checked',false);
		selTrg = 0;
		$('.selTrgCount').html(selTrg);
		$('input[name=allChk1]').prop('checked',false);
		$('input[name=allChk2]').prop('checked',false);
		$('input[name=allChk3]').prop('checked',false);
		grpCode = '';
	}
	
	function fnVMSPreLit(){		// TTS미리듣기
		if(document.frm.msg.value == ''){
			alert('내용을 입력해 주세요.');document.frm.msg.focus();return;
		}
		document.frm.action = '/pages/public/ttsCreate.asp?proc=prev';
		document.frm.submit();
	}
	
	function fnLoadAddr(tp){
		//var result = fnGetHttp('/pages/public/ajxAddrList.asp?grpCD='+grpCode+'&page=1&pageSize=999999');
		var result = fnGetHttp('/pages/public/ajxAddrList.asp?grpCD='+grpCode+'&page=1&pageSize=999999');
		var arrResult = result.split('}|{');
		$('#trg'+tp+' table tbody tr').remove();
		if(result.length > 0){
			var arrVal, strRow;
			for(var i = 2; i < arrResult.length; i++){
				if(arrResult[i].length > 0){
					arrVal = arrResult[i].split(']|[');
					strRow = '<tr>'
					+'	<td class="fnt11" style="text-align:left;"><input type="checkbox" name="trg'+tp+'" value="'+arrVal[2]+'||'+arrVal[3]+'||'+arrVal[4]+'" onclick="fnCountTrg('+tp+')" />'+cutStr(arrVal[3],8)+'</td>'
					+'	<td class="fnt11" style="text-align:left;">'+cutStr(arrVal[4],13)+'&nbsp;</td>'
					+'	<td class="aC"></td>'
					+'</tr>';
					$('#trg'+tp+' table tbody').append(strRow);
				}
			}
		}
		selTrg = 0;
		$('input[name=allChk1]').prop('checked',false);
		$('input[name=allChk2]').prop('checked',false);
		$('input[name=allChk3]').prop('checked',false);
	}
	
	function fnSelTrgType(val){
		trgType = val;
		var tp = nTab;
		fnLoadAddr(tp);
		fnCountTrg(tp);
	}
	
	//	Phone Buttons	==============================================================================
	function fnAddNum(nm,num){
		var param = encodeURI('proc=input&addNm='+nm+'&addNum='+num);
		procFrame.location.href = 'numProc.asp?'+param;
	}
	function fnAddInputNum(){
		if($('input[name="add_num"]').val() == ''){
			alert('추가할 번호를 입력하세요.');$('input[name="add_num"]').focus(); return;
		}else{
			//if(fnNumberCheck(document.frm.add_num.value) != true){
			//	alert('숫자만 입력해 주세요.');document.frm.add_num.focus();return;
			//}
			if(fnChkMobile(document.frm.add_num.value) == false && fnChkPhone(document.frm.add_num.value) == false){
				alert('번호를 정확히 입력해 주세요.');  document.frm.add_num.focus(); return;
			}else{
				fnLoadingS();
				procFrame.location.href = 'numProc.asp?proc=input&addNum='+document.frm.add_num.value;
				document.frm.add_num.value = '';
			}
		}
	}
	function fnAllNumDel(){
		procFrame.location.href = 'numProc.asp?proc=delAll';
	}
	function fnSelNumDel(no,num){
		procFrame.location.href = 'numProc.asp?proc=delNum&no='+no+'&num='+num;
	}
	function fnLoadTrg(){
		trgList.location.reload();
	}
	//	Phone Buttons	==============================================================================
	
	//	Address Select	==============================================================================
	function fnCountTrg(tp){
		selTrg = 0;
		$('#trg'+tp+' input[type=checkbox]').each(function(){
			if($(this).prop('checked') == true){
				selTrg = selTrg + 1;
			}
		});
		$('#selTrgCount'+tp).html(selTrg);
	}
	function fnTrgAllSel(tp){
		if($('input[name=allChk'+tp+']').prop('checked') == true){
			$('#trg'+tp).find('input[type=checkbox]').prop('checked',true);
		}else{
			$('#trg'+tp).find('input[type=checkbox]').prop('checked',false);
		}
		fnCountTrg(tp);
	}
	function fnSelGrp(tp,trg){
		$('#grp'+tp+' li').removeClass('on');
		$(trg).addClass('on');
	}
	function fnAddTrg(tp){
		if(selTrg > 0){
			//fnLoadingS();
			eval('document.frmTrg'+tp).submit();
			$('#trg'+tp+' input[type=checkbox]').prop('checked',false);
			$('input[name=allChk'+tp+']').prop('checked',false);
			selTrg = 0;
		}else{
			alert('추가할 연락처를 선택하세요.');return;
		}
	}
	function fnAddGrpTrg(tp){
		var arrGrp = '';
		$('#grp'+tp+' input[name=grpCode]').each(function(){
			if($(this).prop('checked') == true){
				if(arrGrp.length > 0){
					arrGrp = arrGrp + ',';
				}
				arrGrp = arrGrp + $(this).val();
			}
		});
		if(arrGrp.length == 0){
			alert('그룹을 선택하세요.');
		}else{
			procFrame.location.href = 'grpTrgProc.asp?arrGrp='+arrGrp;
			$('#grp'+tp+' input[name=grpCode]').prop('checked',false);
		}
	}
	//	Address Select	==============================================================================
	
	//	Xls Upload	==============================================================================
	function fnSampleDown(){
		procFrame.location.href = '/public/fileDown.asp?file=/data/sample03.xls';
	}
	function fnXlsUpload(){
		if(document.xlsFrm.xlsUp.value == ''){
			alert('업로드할 파일을 선택해 주세요.');document.xlsFrm.xlsUp.focus();return;
		}
		document.xlsFrm.submit();
	}
	//	Xls Upload	==============================================================================
	
	//	Textarea Check	==============================================================================
	function fnCheckByteSMS(trg){
		fnPrntAllByte();
	}
	//	Textarea Check	==============================================================================
	
	function fnPrntAllByte(){
		$('#bytePrint').html(fnByte($('#msg').val()));
	}
	
	//	불러오기, 저장, 지우기	==============================================================================
	//function fnDocsAccept(strTit,strMsg){
	function fnDocsAccept(idx){
		var result = fnGetHttp('ajxMsg.asp?idx='+idx);
		var arrResult = result.split(']|[');
		var strTit = arrResult[0];
		var strMsg = arrResult[1];
		document.frm.tit.value = strTit;
		strMsg = strMsg.replace(/<br>/g,'\n');
		document.getElementById('msg').value = strMsg;
		fnCheckByteSMS(document.getElementById('msg'));
		fnCloseLayerContBox();
	}
	//	불러오기, 저장, 지우기	==============================================================================
	
	//	최근발신번호	==============================================================================
	function fnAddLastNum(no){
		fnAddNum($('#lastNm_'+no).val(),$('#lastNum_'+no).val());
		fnCloseLayerContBox();
	}
	//	최근발신번호	==============================================================================
	
	//	전송	==============================================================================
	function fnSend(){
		if(document.frm.msg.value == ''){
			alert('내용을 입력하세요.');document.frm.msg.focus();return;
		}
		if(document.frm.tmpTrg.value < 1){
			alert('대상자를 선택하세요.');return;
		}
		if(document.frm.snd_num.value.length < 1){
			alert('보내는번호를 입력하세요.');document.frm.snd_num.focus();return;
		}
		var tmpTrg = document.frm.tmpTrg.value;
		if(confirm(tmpTrg+'건의 메시지를 전송하시겠습니까?')){
			document.frm.action = 'vmsProc.asp';
			document.frm.target = 'procFrame';
			document.frm.submit();
			//fnLoadingS();
		}
	}
	//	전송	==============================================================================
	
	//	예약전송	==============================================================================
	function fnSendSchd(){
		var schdDate = $('#schdDate').val();
		var schdHH = $('#schdHH').val();
		var schdNN = $('#schdNN').val();
		document.frm.schdYN.value = 'Y';
		document.frm.schdDT.value = schdDate + ' ' + schdHH + ':' + schdNN + ':00';
		fnCloseLayerContBox();
		fnSend();
	}
	//	예약전송	==============================================================================
		
	function fnTargetSet(){	// 전송대상설정 Popup Open
		layerW = 1200;
		layerH = 680;
		var url = '/pages/setTrg/pop_trgDetail.asp?clGB=<%=clGB%>';
		fnOpenLayer('전송대상설정',url);
	}
	
	function fnTargetChk(){	// 전송대상확인 Popup Open 
		layerW = 800;
		layerH = 540;
		var url = '/pages/setTrg/pop_trgList.asp?clGB=<%=clGB%>';
		fnOpenLayer('전송대상확인',url);
	}
	
</script>