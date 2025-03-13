<!--#include virtual="/common/common.asp"-->

<%
dim clIdx : clIdx = fnReq("clIdx")

dim clTit, clRsvDT, clMethod, trgCnt, msgSMS, msgVMS

sql = " select CL_TIT, CL_RSVDT, CL_METHOD, (select count(*) from TBL_CALLTRG with(nolock) where CL_IDX = TBL_CALL.CL_IDX) "
sql = sql & " 	, CL_SMSMSG, CL_VMSMSG "
sql = sql & " from TBL_CALL with(nolock) where CL_IDX = " & clIdx & " "
dim clInfo : clInfo = execSqlArrVal(sql)
clTit = clInfo(0)
clRsvDT = clInfo(1)
clMethod = clInfo(2)
trgCnt = clInfo(3)
msgSMS = clInfo(4)
msgVMS = clInfo(5)

dim strIconBlue	: strIconBlue	= "<td style=""padding:5px;""><img src=""" & pth_pubImg & "/button-check.png"" width=""40px"" /></td>"
dim strIconRed	: strIconRed	= "<td style=""padding:5px;""><img src=""" & pth_pubImg & "/button-cross.png"" width=""40px"" /></td>"

sub subIcon(strGB, intSize)
	if strGB = "Y" then
		response.write	"<td style=""padding:5px;""><img src=""" & pth_pubImg & "/button-check.png"" width=""" & intSize & "px"" /></td>"
	else
		response.write	"<td style=""padding:5px;""><img src=""" & pth_pubImg & "/button-cross.png"" width=""" & intSize & "px"" /></td>"
	end if
end sub
%>

<!--#include virtual="/common/header_pop.asp"-->

<style>
	#tblMonitor {background:#999999;margin-top:5px;}
	#tblMonitor tr {background:#ffffff;}
	#tblMonitor th {font-size:15px;}
	
	.bgYellow {background:#FFFF00;color:#333333;
		/*filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FF3737', endColorstr='#E30000'); /* for IE */
		background-image:linear-gradient(to bottom,  #FFFF00,  #B5B500); /* for IE 10 */
		background: -webkit-gradient(linear, left top, left bottom, from(#FFFF00), to(#B5B500)); /* for webkit browsers */
		background: -moz-linear-gradient(top,  #FFFF00,  #B5B500); /* for firefox 3.6+ */
		/*-pie-background:linear-gradient(-90deg, #FFFF00,  #B5B500); /* for IE 9 */
		/*behavior: url(/public/pie/PIE.htc);*/
	}
	.bgRed {background:#ff1e1e;color:#ffffff;
		/*filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FF3737', endColorstr='#E30000'); /* for IE */
		background-image:linear-gradient(to bottom,  #ff1e1e,  #AE0000); /* for IE 10 */
		background: -webkit-gradient(linear, left top, left bottom, from(#ff1e1e), to(#AE0000)); /* for webkit browsers */
		background: -moz-linear-gradient(top,  #ff1e1e,  #AE0000); /* for firefox 3.6+ */
		/*-pie-background:linear-gradient(-90deg, #ff1e1e,  #AE0000); /* for IE 9 */
		/*behavior: url(/public/pie/PIE.htc);*/
	}
	.bgBlue {background:#0057E8;color:#ffffff;
		/*filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FF3737', endColorstr='#E30000'); /* for IE */
		background-image:linear-gradient(to bottom,  #3581FF,  #0057E8); /* for IE 10 */
		background: -webkit-gradient(linear, left top, left bottom, from(#3581FF), to(#0057E8)); /* for webkit browsers */
		background: -moz-linear-gradient(top,  #3581FF,  #0057E8); /* for firefox 3.6+ */
		/*-pie-background:linear-gradient(-90deg, #3581FF,  #0057E8); /* for IE 9 */
		/*behavior: url(/public/pie/PIE.htc);*/
	}
	.bgGray {background:#dddddd;color:#333333;
		/*filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FF3737', endColorstr='#E30000'); /* for IE */
		background-image:linear-gradient(to bottom,  #EBEBEB,  #BCBCBC); /* for IE 10 */
		background: -webkit-gradient(linear, left top, left bottom, from(#EBEBEB), to(#BCBCBC)); /* for webkit browsers */
		background: -moz-linear-gradient(top,  #EBEBEB,  #BCBCBC); /* for firefox 3.6+ */
		/*-pie-background:linear-gradient(-90deg, #EBEBEB,  #BCBCBC); /* for IE 9 */
		/*behavior: url(/public/pie/PIE.htc);*/
	}
	
	.tblGraph {}
	.tblGraph td {}
	.tblGraph .tit {width:100px;background:#000000;color:#ffffff;font-size:15px;font-weight:bold;text-align:center;border:3px solid #999999;
		-moz-border-radius:10px 0 0 10px;
		-webkit-border-radius:10px 0 0 10px;
		border-radius:10px 0 0 10px;
		/*behavior: url(/public/pie/PIE.htc);*/
	}
	.tblGraph .tit2 {width:100px;background:#000000;color:#ffffff;font-size:15px;font-weight:bold;text-align:center;border:3px solid #999999;
		-moz-border-radius:10px;
		-webkit-border-radius:10px;
		border-radius:10px;
		/*behavior: url(/public/pie/PIE.htc);*/
	}
	.tblGraph .bar {background:#000000;border:3px solid #999999;border-left:0;}
	.tblGraph .bar table th {}
	.tblGraph .bar table td {background:#000000;}
	.tblGraph .cnt {width:80px;background:#000000;color:red;font-size:15px;font-weight:bold;text-align:center;border:3px solid #999999;border-left:0;
		-moz-border-radius:0 10px 10px 0;
		-webkit-border-radius:0 10px 10px 0;
		border-radius:0 10px 10px 0;
		/*behavior: url(/public/pie/PIE.htc);*/
	}
	.tblGraph .per {width:80px;padding-left:10px;}
	.tblGraph .per div {background:#0060fe;color:#ffffff;font-size:15px;font-weight:bold;text-align:center;padding:5px;border:3px solid #999999;
		-moz-border-radius:10px;
		-webkit-border-radius:10px;
		border-radius:10px;
		/*behavior: url(/public/pie/PIE.htc);*/
	}
	
	
</style>

<div id="popBody">
	
	<div class="aC bld fnt15">비상발령 모니터링</div>
	
	<table border="0" cellpadding="0" cellspacing="1" class="tblForm">
		<colgroup>
			<col width="15%" />
			<col width="*" />
			<col width="15%" />
			<col width="30%" />
		</colgroup>
		<tr>
			<th>제목</th>
			<td><%=clTit%></td>
			<th>전송시간</th>
			<td><%=fnDateToStr(clRsvDT,"yyyy년 mm월 dd일 hh시 nn분 ss초")%></td>
		</tr>
		<tr>
			<th>대상인원</th>
			<td><%=formatNumber(trgCnt,0)%>명</td>
			<th>전송방법</th>
			<td><%=arrCallMethod(clMethod)%></td>
		</tr>
	</table>
	
	<table width="100%" border="0" cellpadding="0" cellspacing="1" id="tblMonitor">
		<colgroup>
			<col width="40px" />
			<col width="160px" />
			<col width="*" />
			<col width="40px" />
		</colgroup>
		<!--문자메시지-->
		<% if clMethod <> "0" then %>
			<tr>
				<% call subIcon("Y",30) %>
				<th class="bgYellow">문자메시지</th>
				<td style="padding:5px;">
					<table width="90%" border="0" cellpadding="0" cellspacing="0" class="tblGraph" align="left" id="grp01">
						<tr>
							<td class="tit">문자</td>
							<td class="bar">
								<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr><th style="width:0%" class="bgRed">&nbsp;</th><td>&nbsp;</td></tr></table>
							</td>
							<td class="cnt">0</td>
							<td class="per"><div>0%</div></td>
						</tr>
					</table>
				</td>
				<% call subIcon("Y",30) %>
			</tr>
		<% end if %>
		<!--문자응답-->
		<%
		'if clMethod <> "0" and ARSAnswUseYN = "Y" then
		if clMethod = "4" and ARSAnswUseYN = "Y" then
		%>
			<tr>
				<% call subIcon("Y",30) %>
				<th class="bgYellow">문자응답</th>
				<td style="padding:5px;">
					<table width="90%" border="0" cellpadding="0" cellspacing="0" class="tblGraph" align="left" id="grp02">
						<tr>
							<td class="tit">문자응답</td>
							<td class="bar">
								<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr><th style="width:0%" class="bgBlue">&nbsp;</th><td>&nbsp;</td></tr></table>
							</td>
							<td class="cnt">0</td>
							<td class="per"><div>0%</div></td>
						</tr>
					</table>
				</td>
				<% call subIcon("Y",30) %>
			</tr>
		<% end if %>
		<!--비상동보-->
		<% if clMethod <> "1" then %>
			<tr>
				<% call subIcon("Y",30) %>
				<th class="bgYellow">비상발령</th>
				<td style="padding:5px;">
					<table width="90%" border="0" cellpadding="0" cellspacing="0" class="tblGraph" align="left" id="grp03">
						<tr>
							<td class="tit">음성</td>
							<td class="bar">
								<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr><th style="width80%" class="bgYellow">&nbsp;</th><td>&nbsp;</td></tr></table>
							</td>
							<td class="cnt">0</td>
							<td class="per"><div>0%</div></td>
						</tr>
					</table>
				</td>
				<% call subIcon("Y",30) %>
			</tr>
		<% end if %>
		<!--발령문자-->
		<% if clMethod <> "0" then %>
			<tr>
				<% call subIcon("Y",30) %>
				<th class="bgBlue">전송문자</th>
				<td style="padding:5px;"><div style="height:100px;overflow-x:hidden;overflow-y:scroll;"><%=msgSMS%></div></td>
				<% call subIcon("Y",30) %>
			</tr>
		<% end if %>
		<!--발령TTS-->
		<tr>
			<% call subIcon("Y",30) %>
			<th class="bgBlue">전송TTS</th>
			<td style="padding:5px;"><div style="height:100px;overflow-x:hidden;overflow-y:scroll;"><%=msgVMS%></div></td>
			<% call subIcon("Y",30) %>
		</tr>
		<!--장비상태-->
		<tr>
			<% call subIcon("Y",30) %>
			<th class="bgGray">장비상태</th>
			<td style="padding:5px;">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<table border="0" cellpadding="0" cellspacing="0" class="tblGraph" align="left" id="grp04">
								<tr>
									<td class="tit2">음성</td>
									<td style="padding:5px;"><img class="sysIcon" src="<%=pth_pubImg%>/button-check.png" width="30px" /></td>
								</tr>
							</table>
						</td>
						<td>
							<table border="0" cellpadding="0" cellspacing="0" class="tblGraph" align="left" id="grp05">
								<tr>
									<td class="tit2">문자</td>
									<td style="padding:5px;"><img class="sysIcon" src="<%=pth_pubImg%>/button-check.png" width="30px" /></td>
								</tr>
							</table>
						</td>
						<td>
							<table border="0" cellpadding="0" cellspacing="0" class="tblGraph" align="left" id="grp06">
								<tr>
									<td class="tit2">DB</td>
									<td style="padding:5px;"><img class="sysIcon" src="<%=pth_pubImg%>/button-check.png" width="30px" /></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
			<% call subIcon("Y",30) %>
		</tr>
	</table>
	
	<div style="margin:10px;" class="aC" id="stopBtnBox">
		<img class="imgBtn" src="<%=pth_pubImg%>/btn/b_red_callstop.png" onclick="fnStop()" />
	</div>
	
</div>

<!--#include virtual="/common/footer_pop.asp"-->

<script>
	
	$(function(){
		fnLoad();
		setInterval('fnLoad();',5000);
	});
	
	function fnLoad(){
		var result = fnGetHttp('pop_callMonitorAjx.asp?clIdx=<%=clIdx%>');
		var arrResult = result.split(']|[');
		$('#grp01 .bar th').css('width',arrResult[0]+'%');
		//$('#grp01 .bar th').html(arrResult[0]+'%');
		$('#grp01 .bar td').css('width',(100-arrResult[0])+'%');
		$('#grp01 .cnt').html(arrResult[1]);
		$('#grp01 .per div').html(arrResult[0]+'%');
		
		$('#grp02 .bar th').css('width',arrResult[2]+'%');
		//$('#grp02 .bar th').html(arrResult[2]+'%');
		$('#grp02 .bar td').css('width',(100-arrResult[2])+'%');
		$('#grp02 .cnt').html(arrResult[3]);
		$('#grp02 .per div').html(arrResult[2]+'%');
		
		$('#grp03 .bar th').css('width',arrResult[4]+'%');
		//$('#grp03 .bar th').html(arrResult[4]+'%');
		$('#grp03 .bar td').css('width',(100-arrResult[4])+'%');
		$('#grp03 .cnt').html(arrResult[5]);
		$('#grp03 .per div').html(arrResult[4]+'%');
		
		$('#grp04 .sysIcon').prop('src','<%=pth_pubImg%>/button-'+arrResult[6]+'.png');
		$('#grp05 .sysIcon').prop('src','<%=pth_pubImg%>/button-'+arrResult[7]+'.png');
		$('#grp06 .sysIcon').prop('src','<%=pth_pubImg%>/button-'+arrResult[8]+'.png');
		
		if(arrResult[9] == '5'){
			$('#stopBtnBox').html('');
			if(confirm('전송이 완료되었습니다.')){
				window.close();
			}
		}
	}
	
	function fnStop(){
		if(confirm('중지하시겠습니까?')){
			popProcFrame.location.href = 'pop_callStopProc.asp?clIdx=<%=clIdx%>';
		}
	}
	
</script>