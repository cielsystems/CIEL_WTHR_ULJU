<%
'#	============================================================================
'#	공통변수 설정
'#	============================================================================
dim cmd, sql, rs, arrRs, arrRc1, arrRc2, i, ii, iii, j, l, m, t
dim sqlC, sqlF, sqlW, sqlO
dim arrCols, arrVals
dim rowCnt, pageRow, pageCnt, pageLimit, pageBlock

dim svr_remoteAddr	: svr_remoteAddr	= request.serverVariables("remote_addr")
dim svr_url					: svr_url					= request.serverVariables("url")
dim svr_domain			: svr_domain			= request.serverVariables("server_name")
if instr(svr_domain,".") then
	arrVals = split(svr_domain,".")
	if ubound(arrVals) = 1 then
		svr_domain = svr_domain
	else
		svr_domain = ""
		for i = 1 to ubound(arrVals)
			svr_domain = svr_domain &arrVals(i)
			if i < ubound(arrVals) then
				svr_domain = svr_domain & "."
			end if
		next
	end if
end if

dim pth_bas			: pth_bas			= ""
dim pth_pub			: pth_pub			= pth_bas & "/public"
dim pth_pubImg	: pth_pubImg	= pth_pub & "/images"
dim pth_pubJs		: pth_pubJs		= pth_pub & "/js"
dim pth_pubCss	: pth_pubCss	= pth_pub & "/css"
dim pth_sitImg	: pth_sitImg	= pth_bas & "/images"
dim pth_sitJs		: pth_sitJs		= pth_bas & "/js"
dim pth_sitCss	: pth_sitCss	= pth_bas & "/css"

dim g_pageSize	: g_pageSize	= 10
dim g_pageBlock	: g_pageBlock	= 5

dim g_demical		: g_demical		= 2

dim g_chanCnt	: g_chanCnt = 30

dim arrListHeader, arrListWidth

function fnTTSFormatToExt(intFormat)
	intFormat = cint(intFormat)
	dim tmpExt : tmpExt = "-"
	select case intFormat
		case 273, 274, 275, 276
			tmpExt = "pcm"
		case 277
			tmpExt = "vox"
		case 289, 290, 291, 292
			tmpExt = "wav"
		case 305, 306, 307, 308
			tmpExt = "au"
		case 529, 530, 531, 532
			tmpExt = "pcm"
		case 533
			tmpExt = "vox"
		case 545, 546, 547, 548
			tmpExt = "wav"
		case 561, 562, 563, 564
			tmpExt = "au"
		case 321, 577
			tmpExt = "ogg"
		case 4385, 4386, 4641, 4642
			tmpExt = "asf"
	end select
	fnTTSFormatToExt = tmpExt
end function
	
dim arrDocFileExt		: arrDocFileExt	= array("xls","xlsx","doc","docx","ppt","pptx","pdf","txt","hwp")
dim arrImgFileExt		: arrImgFileExt	= array("tif","tiff","gif","jpg","jpeg","png","bmp")
dim arrMovFileExt		: arrMovFileExt	= array("mp4")

dim arrNonFileExt		: arrNonFileExt = array("exe","bat","html","htm","asp","aspx","inc","php","php3","php4","php5","java","jsp","cgi")

dim arrMobileNumHeader	: arrMobileNumHeader	= array("010","011","016","017","018","019")
dim arrPhoneNumHeader		: arrPhoneNumHeader		= array("02","031","032","033","041","042","043","044","051","052","053","054","055","061","062","063","064")
dim arrPhoneNumHeaderNM	: arrPhoneNumHeaderNM	= array("서울","경기","인천","강원","충남","대전","충북","세종","부산","울산","대구","경북","경남","전남","광주","전북","제주")

'*	------------------------------------------------------------------------------------------------
dim fileUploadSize	: fileUploadSize = 1024*1024*100
'*	1GByte : 1073741824(1024*1024*1024), 500MByte : 524288000(1024*1024*500), 100MByte : 104857600(1024*1024*100), 10MByte : 10485760(1024*1024*10)
'*	파일업로드 용량변경 시 해당 값 뿐 아니라 IIS에서 변경해야할 사항
'*	- [ASP] > 제한속성 > 응답버퍼링 제한, 최대 요청 엔터티 본문 제한
'*	- [요청필터링] > 기능 설정 편집 > 허용되는 최대 콘텐츠 길이(바이트)(C):
'*	이 두가지도 변경해줘야 함
'*	------------------------------------------------------------------------------------------------

'#	Log Level	(0:Page Access & All Query/1:All Query/2:Insert,Update,Delete/3:None)
'*	실 서버 적용시 파일로그를 사용하지 않는다 : 실 서버에서 파일로그 사용시 오류발생!!!
' dim logLvl : logLvl = 0
dim logLvl : logLvl = 5
'#	============================================================================
%>