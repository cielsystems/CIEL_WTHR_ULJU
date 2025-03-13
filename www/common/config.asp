<%
'#	============================================================================
'#	DB
'#	============================================================================
dim dbType : dbType = "mssql"

dim db_host	: db_host	= "127.0.0.1,11433"'fnBDec("MTkyLjE2OC4yNTMuMTI1")
dim db_name	: db_name	= "CIEL_WTHR_ULJU"'fnBDec("Q0lFTF9FTVJfVUxTQU5fVUxKVSAg")
dim db_id		: db_id		= "sql_admin"'fnBDec("c3FsX2FkbWlu")
dim db_pw		: db_pw		= "!QAZ2wsx"'fnBDec("IVFBWjJ3c3gg")

dim strDBConn : strDBConn = "provider=sqloledb;data source=" & db_host & ";initial catalog=" & db_name & ";user id=" & db_id & ";password=" & db_pw & ";"
'===================================================================================================
'dim dbDriver		: dbDriver		= "MySQL ODBC 5.2 Unicode driver"
'dim dbServer		: dbServer		= "123.142.231.170"
'dim dbDatabase	: dbDatabase	= "seoulMetro"
'dim dbUid				: dbUid				= "root"
'dim dbPwd				: dbPwd				= "1qaz"
'
'dim strDBConn : strDBConn = "Driver={" & dbDriver & "};Server=" & dbServer & ";Database=" & dbDatabase & ";Uid=" & dbUid & ";Pwd=" & dbPwd & ";"
'#	============================================================================



'#	============================================================================
'#	Site
'#	============================================================================
dim siteTitle		: siteTitle		= "비상발령시스템"
dim siteWelMsg	: siteWelMsg	= "비상발령시스템"
dim siteName		: siteName		= ""
dim siteCi			: siteCi			= "<img src=""/images/logo.png"" style=""height:65px;"" />"'<table border=""0"" cellpadding=""0"" cellspacing=""0"" align=""left"" style=""margin-top:10px;""><tr>"
'siteCi = siteCi & "<td valign=""middle""><img src=""/images/logo.png"" style=""width:100px;"" /></td><td width=""20px""></td>"
'siteCi = siteCi & "<td valign=""middle""><img src=""/images/logo_text.png"" style=""width:240px;"" /></td></tr></table>"
dim siteIp			: siteIp			= "104.1.71.216"
dim sitePort		: sitePort		= ""
dim siteUrl			: siteUrl			= siteIp : if len(sitePort) > 0 then siteUrl = siteUrl & ":" & sitePort end if
'#	============================================================================



'#	============================================================================
'#	Default Variables
'#	============================================================================
dim arrCallGubun		: arrCallGubun		= array("E","A","S","V","F")		'= 비상/대기/문자/음성/팩스
dim arrCallStep			: arrCallStep			= array("대기","진행","진행","진행","취소","완료")
dim arrCallStepCls	: arrCallStepCls	= array("colGreen","colOrange","colOrange","colOrange","colGray","colBlue")
dim arrCallMethod		: arrCallMethod		= array("음성만","문자만","음성+문자","음성 후 (미응답자) 문자","문자 후 (미응답자) 음성")
dim arrCallMedia		: arrCallMedia		= array("-","휴대폰","사무실전화","기타전화")
dim arrUserCallGrp	: arrUserCallGrp	= array("직위/직급","근무형태","순위")',"상태")

dim arrAddrBooksNm	: arrAddrBooksNm	= array("직원주소록","공용주소록","개인주소록")
dim arrAddrBooksCD	: arrAddrBooksCD	= array("D","E","P")

dim g_useGrpDepth		: g_useGrpDepth		= 5
dim g_dftUserPass		: g_dftUserPass		= "qwer1234"

dim arrAddrClass		: arrAddrClass		= array("소방총감","소방정감","소방감","소방준감","소방정","소방령","소방경","소방위","소방장","소방교","소방사","주무관","일반직","기타")
'#	============================================================================



'#	============================================================================
'#	Session & Cookies
'#	============================================================================
if session("ss_userIdx") = "" or isnull(session("ss_userIdx")) then
	session("ss_userIdx")	= request.cookies("ss_userIdx")
	session("ss_userId")		= request.cookies("ss_userId")
	session("ss_userNm")		= request.cookies("ss_userNm")
	if session("ss_userIdx") = "" or isnull(session("ss_userIdx")) then
		session("ss_userIdx") = 0
		session("ss_userId") = "NoID"
		session("ss_userNm") = "NoName"
	end if
end if

'session("ss_userIdx") = 2
'session("ss_userId") = "admin"
'session("ss_userNm") = "관리자"

dim ss_userIdx	: ss_userIdx	= session("ss_userIdx")
dim ss_userId		: ss_userId		= session("ss_userId")
dim ss_userNm		: ss_userNm		= session("ss_userNm")

dim ss_userIndx	: ss_userIndx	= ss_userIdx
'#	============================================================================



'#	============================================================================
'#	기능 사용여부
'#	============================================================================
dim totUseYN : totUseYN = "Y"
dim smsUseYN : smsUseYN = "Y"
dim vmsUseYN : vmsUseYN = "Y"
dim fmsUseYN : fmsUseYN = "N"

dim appUseYN : appUseYN = "N"			'= 스마트폰 Push 어플 사용여부

dim smsFileUP : smsFileUP = "Y"		'= 문자전송 파일업로드 사용여부
dim vmsFileUP : vmsFileUP = "N"		'= 음성전송 파일업로드 사용여부
dim ARSAnswUseYN : ARSAnswUseYN = "Y"		'= ARS응답 사용여부
if ARSAnswUseYN = "N" then
	arrCallMethod		= array("음성만","문자만","음성+문자","음성 후 (미응답자) 문자")
end if
dim ARSAnswTimeUseYN : ARSAnswTimeUseYN = "N"		'= ARS추가응답시간 사용여부

dim arrAnswDtmf	: arrAnswDtmf	= array("0","1","2","3","4","5","6","7","8","9","*","#","X")',"")
dim arrAnswDtmfName	: arrAnswDtmfNAme	= array("0번","1번","2번","3번","4번","5번","6번","7번","8번","9번","*","#","아무버튼")',"바로응답")

dim smsUseCntYN : smsUseCntYN = "Y"
dim smsSplitUseYN : smsSplitUseYN = "N"
'#	============================================================================



'#	============================================================================
'#	기타 설정
'#	============================================================================

'#	Request Sql Injection YN
dim injectYN	: injectYN	= "N"

'#	디버깅용 iframe 출력 여부
dim devYN	: devYN	= "N"

'#	AES 암호화 키 설정
dim aesK : aesK = "ciel"

'#	초기비밀번호
dim dftPass : dftPass = g_dftUserPass

'#	로그인 초기 페이지
dim firstPage : firstPage = "/pages/call/sms/txtForm.asp"'"/pages/call/msgList.asp?gb=1"'"/pages/home.asp"

'#	TTS설정
dim dftTTSHost : dftTTSHost = "127.0.0.1"
dim dftTTSPort : dftTTSPort = "6789"

'#	web path
dim webPath : webPath = "D:\CIEL\www"

dim strDRMMsg	: strDRMMsg	= "<div style=""margin:5px 0;color:red;"">* DRM 해제 후 업로드 해주세요.</div>"
'#	============================================================================

%>
<!--#include virtual="/public/common/inc.asp"-->
<%

'#	================================================================================================
'#	
'#	------------------------------------------------------------------------------------------------
'# 계정별 권한설정
dim ss_userGubn	: ss_userGubn	= fnDBVal("NTBL_USER", "USER_GUBN", "USER_INDX = " & ss_userIndx & "")

'= 1:시스템관리자/10:전체관리자/20:부서관리자/50:일반사용자/90:문자사용자
dim arrUserGubn	: arrUserGubn	= array(array(1,"시스템관리자","purple"), array(10,"전체관리자","red"), array(20,"부서관리자","teal"), array(50,"일반사용자","blue"))', array(90,"문자사용자","green"))
dim arrUserStep	: arrUserStep	= array(array(0,"미사용","gray"), array(1,"사용","blue"), array(9,"중지","red"))

dim gruplistPrmt		: gruplistPrmt		= "A"
dim prmtGrup	: prmtGrup	= "N"
dim prmtAddr	: prmtAddr	= "N"
dim prmtAddrDown	: prmtAddrDown	= "N"
'#	================================================================================================



'#	============================================================================
'#	TTS Option
'#	============================================================================
dim arrTTSPitch			: arrTTSPitch		= array(80,90,100,110,120)
dim dftTTSPitch			: dftTTSPitch		= 100
dim arrTTSSpeed			: arrTTSSpeed		= array(50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200)
dim dftTTSSpeed			: dftTTSSpeed		= 90
dim arrTTSVolume		: arrTTSVolume		= array(50,60,70,80,90,100,110,120,130,140,150)
dim dftTTSVolume		: dftTTSVolume		= 100
dim arrTTSFormat		: arrTTSFormat		= array(273,274,275,276,277,289,290,291,292,305,306,307,308,321,4385,529,530,531,532,533,545,546,547,548,561,562,563,564,577,4641)
dim dftTTSFormat		: dftTTSFormat		= 545
dim arrTTSFormatNm	: arrTTSFormatNm	= array("8K 16bit Linear PCM","8K 8bit Linear PCM","8K u-Law PCM","8K a-Law PCM","8K VOX","8K 16bit Linear WAVE","8K 8bit Linear WAVE"_
	,"8K u-Law WAVE","8K a-Law WAVE","8K 16bit Linear AU","8K 8bit Linear AU","8K u-Law AU","8K a-Law AU","8K OGG","8K ASF","16K 16bit Linear PCM","16K 8bit Linear PCM"_
	,"16K u-Law PCM","16K a-Law PCM","16K VOX","16K 16bit Linear WAVE","16K 8bit Linear WAVE","16K u-Law WAVE","16K a-Law WAVE","16K 16bit Linear AU","16K 8bit Linear AU"_
	,"16K u-Law AU","16K a-Law AU","16K OGG","16K ASF")
'#	============================================================================



'#	============================================================================
'#	Checker
'#	============================================================================
dim arrEmrChecker : arrEmrChecker = array("Cheker-A","Cheker-B","Cheker-C","Cheker-D","Cheker-E")
'#	============================================================================
%>


<%
dim strSMSAddMsg	: strSMSAddMsg	= "수신하신 분은 [통화]버튼을 눌러주세요."
dim strVMSAddMsg	: strVMSAddMsg	= "수신하신 분은 {[DTMF]}을 눌러주세요."
%>

