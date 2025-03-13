<% call subLoginCheck() %>

<%
arrVals = array("U", "", ss_userIdx)
dim mainMenuRs : mainMenuRs = execProcRs("usp_listMenu", arrVals)

dim arrMnInfo : arrMnInfo = execProcArrVal("usp_getMenuInfo", array(left(mnCD,2)))
dim mnCD, mnSort, mnNM
mnSort = arrMnInfo(1)
mnNM = arrMnInfo(2)

dim arrSnInfo : arrSnInfo = execProcArrVal("usp_getMenuInfo", array(mnCD))
dim snCD, snSort, snNM
snSort = arrSnInfo(1)
snNM = arrSnInfo(2)

dim userGB	: userGB	= fnDBVal("NTBL_USER", "USER_GUBN", "USER_INDX = " & ss_userIndx & "")

'response.write	"if " & fnDBVal("TBL_MENU", "CD_USERGB", "MN_CODE = '" & mnCD & "'") & " < " & userGB & " then "

dim mnUserGB	: mnUserGB = fnDBVal("TBL_MENU", "CD_USERGB", "MN_CODE = '" & mnCD & "'")

if mnUserGB > 0 and mnUserGB < userGB then
	response.write	"<script type=""text/javascript"">alert('사용권한이 없습니다.');history.back(-1);</script>"
	response.end
end if
%>

<!doctype html>
<html lang="utf-8">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />

<title><%=siteTitle%></title>

<script src="<%=pth_pubJs%>/jquery-1.10.2.min.js"></script>

<link rel="stylesheet" type="text/css" href="/plugins/font-awesome-4.7.0/css/font-awesome.min.css" />

<link rel="stylesheet" type="text/css" href="<%=pth_pubCss%>/public.css" />
<link rel="stylesheet" type="text/css" href="<%=pth_sitCss%>/site.css" />

<script src="<%=pth_pubJs%>/public.js"></script>
<script src="<%=pth_sitJs%>/default.js"></script>

<title><%=siteTitle%></title>

<script>
	
	$(function(){
		
		//	Gnb Over Class
		$('.mnItem').eq(<%=mnSort-1%>).addClass('on');
		$('.mnItem').bind('mouseover',function(){
			$(this).addClass('on');
			$('.snItemBox').css('display','none');
			$('#subMenu_'+$(this).index()).css('display','block');
		});
		$('.mnItem').bind('mouseout',function(){
			if($(this).index() != <%=mnSort-1%>){
				$(this).removeClass('on');
			}
		});
		
		//	Sub Menu Over Class
		$('#subMenu_<%=mnSort-1%>').css('display','block');
		$('#subMenu_<%=mnSort-1%> td').eq(<%=snSort-1%>).addClass('on');
		$('.snItemBox td').bind('mouseover',function(){
			$(this).addClass('on');
		});
		$('.snItemBox td').bind('mouseout',function(){
			if($(this).index() != <%=snSort-1%>){
				$(this).removeClass('on');
			}
		});

		//	Left Menu Over Class
		$('#leftMenu li').eq(<%=snSort-1%>).addClass('on');
		$('#leftMenu li').bind('mouseover',function(){
			$(this).addClass('on');
		});
		$('#leftMenu li').bind('mouseout',function(){
			if($(this).index() != <%=snSort-1%>){
				$(this).removeClass('on');
			}
		});
		
		$('.calBtn').bind('click',function(e){
			posX = e.pageX;
			posY = e.pageY;
			var trg = $(this).prev().attr('id');
			fnOpenCal(trg);
		});
		
	});
	
</script>

</head>
<body>
<div id="wRap">
	
	<div id="areaTop">
		
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="250px" height="70px"><%=siteCi%></td>
				<td width="25px"></td>
				<td valign="bottom" class="fnt12 aR">
					<% call subTopCont() %></td>
				<td width="300px" valign="bottom" class="aR">
					<!--<div style="margin-bottom:5px;"><img src="/images/sublogo.png" style="height:40px;" /></div>-->
					<b class="colBlue"><%=ss_userNm%></b>님 환영합니다.
					<img id="btnMyInfo" class="imgBtn" src="<%=pth_pubImg%>/btn/myinfo.png" style="vertical-align:bottom;" onclick="fnPop('/pages/env/myinfo.asp','myInfo',0,0,800,500,'no');" />
					<img id="btnLogout" class="imgBtn" src="<%=pth_pubImg%>/btn/logout.png" style="vertical-align:bottom;" onclick="procFrame.location.href='/pages/logoutProc.asp';" />
				
				</td>
			</tr>
		</table>
		
		<div id="gnb">
			<% if isarray(mainMenuRs) then %>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr style="height:40px;">
						<%
						dim subMenuRs
						redim strSubMenu(ubound(mainMenuRs,2))
						for i = 0 to ubound(mainMenuRs,2)
							response.write	"<th class=""mnItem"" onclick=""fnHref('/pages" & mainMenuRs(4,i) & "')"">" & mainMenuRs(2,i) & "</th>"
							arrVals = array("U", mainMenuRs(0,i), ss_userIdx)
							subMenuRs = execProcRs("usp_listMenu", arrVals)
							if isarray(subMenuRs) then
								strSubMenu(i) = "<table border=""0"" cellpadding=""0"" cellspacing=""0"" class=""snItemBox"" id=""subMenu_" & i & """ align=""left""><tr>"
								for ii = 0 to ubound(subMenuRs,2)
									strSubMenu(i) = strSubMenu(i) & "<td onclick=""fnHref('/pages" & subMenuRs(4,ii) & "')"">" & subMenuRs(2,ii) & "</td>"
								next
								strSubMenu(i) = strSubMenu(i) & "</tr></table>"
							end if
						next
						
						if userGb < 11 then
							response.write	"<th class=""mnItem"" onclick=""fnPop('/pages/admin/index.asp','admin',0,0,1340,860,'yes')"">관리자</th>"
						end if
						%>
						<td>&nbsp;</td>
					</tr>
					<tr style="height:30px;">
						<td colspan="<%=ubound(mainMenuRs,2)+2%>">
							<% for i = 0 to ubound(mainMenuRs,2) %>
								<%=strSubMenu(i)%>
							<% next %>
						</td>
					</tr>
				</table>
			<% end if %>
		</div>
		
	</div>
	
	<div id="areaMid">
		
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="200px" />
				<col width="25px" />
				<col width="*" />
			</colgroup>
			<tr>
				<td valign="top">
					<div id="leftCont">
						<div id="leftMenuBox">
							<div class="nm"><%=mnNM%>
								<!--<div class="memo"><%=siteWelMsg%></div>-->
							</div>
						</div>
						<div id="leftMenu">
							<ul>
								<%
								arrVals = array("U", left(mnCD,2), ss_userIdx)
								subMenuRs = execProcRs("usp_listMenu", arrVals)
								if isarray(subMenuRs) then
									for i = 0 to ubound(subMenuRs,2)
										response.write	"<li onclick=""fnHref('/pages" & subMenuRs(4,i) & "')"">" & subMenuRs(2,i) & "</li>"
									next
								end if
								%>
							</ul>
						</div>
						<div>
							<% call subLeftBanner() %>
						</div>
						<div style="border:1px solid #cccccc;padding:5px;margin-top:10px;">
							<iframe name="leftCal" src="<%=pth_pub%>/etc/calendar.asp?gb=1" frameborder="0" style="width:188px;height:190px;"></iframe>
						</div>
					</div>
				</td>
				<td></td>
				<td valign="top">
					<div id="mainCont">
						<div id="subTit"><img src="<%=pth_pubImg%>/subTitDot.png" width="18px" /> <%=snNM%></div>
						