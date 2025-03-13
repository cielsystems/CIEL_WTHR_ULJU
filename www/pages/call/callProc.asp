<!--#include virtual="/common/common.asp"-->

<%
dim msgIdx				: msgIdx				= fnIsNull(fnReq("msgIdx"),0)

dim clUpIdx				: clUpIdx				= fnIsNull(fnReq("clUpIdx"),0)
dim	clGB					:	clGB					=	fnReq("clGB")
dim	clTit					:	clTit					=	fnReq("clTit")
dim	clRsvYN				:	clRsvYN				=	fnReq("clRsvYN")
dim	clRsvDT				:	clRsvDT				=	fnReq("clRsvDT")
dim	clMethod			:	clMethod			=	fnReq("clMethod")
dim clARSAnswTime	: clARSAnswTime	= fnIsNull(fnReq("clARSAnswTime"),0)
dim clAnswDTMF		: clAnswDTMF		= fnIsNull(fnReq("clAnswDTMF"),"0")
dim clMedia				: clMedia				= array(fnIsNull(fnReq("clMedia1"),0), fnIsNull(fnReq("clMedia2"),0), fnIsNull(fnReq("clMedia3"),0))
dim clTry					: clTry					= array(fnIsNull(fnReq("clTry1"),0), fnIsNull(fnReq("clTry2"),0), fnIsNull(fnReq("clTry3"),0))
dim clSndNum1			: clSndNum1			= fnReq("clSndNum1")
dim clSndNum2			: clSndNum2			= fnReq("clSndNum2")
dim clSndNum3			: clSndNum3			= fnReq("clSndNum3")

clSndNum1 = replace(clSndNum1,"-","")
clSndNum2 = replace(clSndNum2,"-","")
clSndNum3 = replace(clSndNum3,"-","")

dim	clSMSMsg			:	clSMSMsg			=	fnReq("SMSMsg")	: clSMSMsg = replace(clSMSMsg,chr(13)&chr(10),"<br>")
dim splitYN				: splitYN				= fnIsNull(fnReq("splitYN"),"N")
dim clSMSSplit		: clSMSSplit		= fnIsNull(fnReq("splitNo"),0)

dim	clVMSMsg			:	clVMSMsg			=	fnReq("VMSMsg")	: clVMSMsg = replace(clVMSMsg,chr(13)&chr(10),"<br>")
dim clVMSPlay			: clVMSPlay			= fnIsNull(fnReq("clVMSPlay"),dftVMSPlay)
dim	TTS_pitch			:	TTS_pitch			=	fnIsNull(fnReq("TTS_pitch"),dftTTSPitch)
dim	TTS_speed			:	TTS_speed			=	fnIsNull(fnReq("TTS_speed")	,dftTTSSpeed)
dim	TTS_volume		:	TTS_volume		=	fnIsNull(fnReq("TTS_volume"),dftTTSVolume)
dim	TTS_sformat		:	TTS_sformat		=	fnIsNull(fnReq("TTS_sformat"),dftTTSFormat)
'dim TTS_play			: TTS_play			= fnIsNull(fnReq("TTS_play"),dftVMSPlay)

dim addSMSMsg : addSMSMsg = fnIsNull(fnReq("addSMSMsg"),"N")
dim addVMSMsg : addVMSMsg = fnIsNull(fnReq("addVMSMsg"),"N")

dim clRetSendYN	: clRetSendYN	= fnIsNull(fnReq("clRetSendYN"),"N")

dim clSMS : clSMS = "0"
dim clVMS : clVMS = "0"
dim clFMS : clFMS = "0"

dim clGBFull
if clGB = "E" then
	select case clMethod
		case "0"
			clVMS = "1"
		case "1"
			clSMS = "1"
		case "2"
			clSMS = "1" : clVMS = "1"
		case "3"
			clSMS = "2" : clVMS = "1"
		case "4"
			clSMS = "1" : clVMS = "2"
	end select
	clGBFull = "EMR"
elseif clGB = "S" then
	clSMS = "1"
	clGBFull = "SMS"
elseif clGB = "V" then
	clVMS = "1"
	clGBFull = "VMS"
elseif clGB = "F" then
	clFMS = "1"
	clGBFull = "FMS"
end if

dim clIdx : clIdx = 0
dim cdStatus : cdStatus = 3030

dim clCnt, clCode
if dbType = "mssql" then
	clCnt = fnDBVal("TBL_CALL","count(*)","convert(varchar(10),CL_RSVDT,121) = '" & fnDateToStr(clRsvDT,"yyyy-mm-dd") & "' and CL_GB = '" & clGB & "'")
elseif dbType = "mysql" then
	clCnt = fnDBVal("TBL_CALL","count(*)","convert(CL_RSVDT, char(10)) = '" & fnDateToStr(clRsvDT,"yyyy-mm-dd") & "' and CL_GB = '" & clGB & "'")
end if
clCode = clng(clCnt) + 1
clCode = right("00" & clCode,3)
clCode = clGBFull & "yymmdd" & clCode
clCode = fnDateToStr(clRsvDT,clCode)

if cint(fnDBVal("TBL_CALL","count(*)","CL_CODE = '" & clCode & "'")) > 0 then
	clCode = clng(clCnt) + 2
	clCode = right("00" & clCode,3)
	clCode = clGBFull & "yymmdd" & clCode
	clCode = fnDateToStr(clRsvDT,clCode)
end if

'#	Emr
sql = " insert into TBL_CALL ( "
sql = sql & " 	CL_UPIDX, CL_CODE, AD_IDX, MSG_IDX, CL_GB, CL_METHOD, CL_RSVYN, CL_RSVDT "	'8
sql = sql & " 	, CL_MEDIA1, CL_MEDIA2, CL_MEDIA3, CL_TRY1, CL_TRY2, CL_TRY3, CL_SMSGB, CL_VMSGB, CL_FMSGB "	'9
sql = sql & " 	, CL_SNDNUM1, CL_SNDNUM2, CL_SNDNUM3, CL_TIT, CL_SMSMSG, CL_VMSMSG, CL_FMSMSG, CL_SMSMSGADD, CL_VMSMSGADD "	'9
sql = sql & " 	, CL_SMSSPLIT, CL_VMSPLAY, CL_ARSANSWYN, CL_ARSANSWTIME, CL_STEP "	'5
sql = sql & " 	, CL_TTSPITCH, CL_TTSSPEED, CL_TTSVOLUME, CL_TTSFORMAT, CL_ANSWDTMF "	'5
sql = sql & " 	, CL_RETSENDYN "
sql = sql & " ) values ( "
sql = sql & " 	" & clUpIdx & ", '" & clCode & "', " & ss_userIdx & ", " & msgIdx & ", '" & clGB & "', " & clMethod & ", '" & clRsvYN & "', '" & clRsvDT & "' "	'8
sql = sql & " 	, '" & clMedia(0) & "', '" & clMedia(1) & "', '" & clMedia(2) & "', " & clTry(0) & ", " & clTry(1) & ", " & clTry(2) & ", '" & clSMS & "', '" & clVMS & "', '" & clFMS & "' "	'9
sql = sql & " 	, '" & clSndNum1 & "', '" & clSndNum2 & "', '" & clSndNum3 & "', '" & clTit & "', '" & clSMSMsg & "', '" & clVMSMsg & "', '', '" & addSMSMsg & "', '" & addVMSMsg & "' "	'9
sql = sql & " 	, " & clSMSSplit & ", " & clVMSPlay & ", 'Y', " & clARSAnswTime & ", 0 "	'5
sql = sql & " 	, '" & TTS_pitch & "', '" & TTS_speed & "', '" & TTS_volume & "', '" & TTS_sformat & "', '" & clAnswDTMF & "' "	'5
sql = sql & " 	, '" & clRetSendYN & "' "
sql = sql & " ) "
'response.write	"<div><h2>Insert TBL_CALL</h2><div>" & sql & "</div></div>"
call execSql(sql)

if dbType = "mssql" then
	clIdx = fnDBVal("TBL_CALL", "top 1 CL_IDX", "AD_IDX = " & ss_userIdx & " and CL_GB = '" & clGB & "' and CL_TIT = '" & clTit & "' order by CL_IDX desc")
elseif dbType = "mysql" then
	clIdx = fnDBVal("TBL_CALL", "CL_IDX", "AD_IDX = " & ss_userIdx & " and CL_GB = '" & clGB & "' and CL_TIT = '" & clTit & "' order by CL_IDX desc limit 0, 1")
end if

'#	File
sql = " insert into TBL_CALLFILE (CL_IDX, CLF_GB, CLF_NO, CLF_SORT, CLF_DPNM, CLF_PATH, CLF_FILE, CLF_PAGE) "
sql = sql & " select " & clIdx & ", TMP_GB, TMP_NO, TMP_SORT, TMP_DPNM, TMP_PATH, TMP_FILE, TMP_PAGE "
sql = sql & " from TMP_CALLFILE where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
'response.write	"<div><h2>Insert TBL_CALLFILE</h2><div>" & sql & "</div></div>"
call execSql(sql)

'#	Target
sql = " insert into TBL_CALLTRG (CL_IDX, CLT_NO, CLT_SORT, AD_IDX, CLT_NM, CLT_NUM1, CLT_NUM2, CLT_NUM3, CLT_TIT, CLT_SMSMSG, CLT_VMSMSG, CLT_FMSMSG, CLT_SVRID) "
sql = sql & " select " & clIdx & ", TMP_NO, TMP_SORT, TMP_IDX, TMP_NM, replace(TMP_NUM" & clMedia(0) & ",'-','') "
if cint(clMedia(1)) > 0 then		'=	2차전송매체를 선택한 경우
	sql = sql & ", replace(TMP_NUM" & clMedia(1) & ",'-','') "
else
	sql = sql & ", '' "
end if
if cint(clMedia(2)) > 0 then		'= 3차전송매체를 선택한 경우
	sql = sql & ", replace(TMP_NUM" & clMedia(2) & ",'-','') "
else
	sql = sql & ", '' "
end if
'sql = sql & " , '" & clTit & "', '" & clSMSMsg & "', '" & clVMSMsg & "', '', case when (TMP_NO % 14) >= 1 and (TMP_NO % 14) <= 4 then 1 when (TMP_NO % 14) >= 5 and (TMP_NO % 14) <= 8 then 2 when (TMP_NO % 14) >= 9 and (TMP_NO % 14) <= 12 then 3 else 4 end "
'sql = sql & " , '" & clTit & "', '" & clSMSMsg & "', '" & clVMSMsg & "', '', (TMP_NO % 3) + 1 "
sql = sql & " , '" & clTit & "', '" & clSMSMsg & "', '" & clVMSMsg & "', '', 1 "
sql = sql & " from TMP_CALLTRG where CL_IDX = 0 and AD_IDX = " & ss_userIdx & " and AD_IP = '" & svr_remoteAddr & "' "
'response.write	"<div><h2>Insert TBL_CALLTRG</h2><div>" & sql & "</div></div>"
call execSql(sql)

'#	SMS Target
if cint(clSMS) > 0 then
	
	dim cltsGB
	dim tmpMsg	: tmpMsg = replace(clSMSMsg,"<br>",Chr(13))
	dim nByte		: nByte = 0
	
	arrRs = execProcRs("usp_listTmpFile", array(0, ss_userIdx, svr_remoteAddr, "S", 1, 999999))
	if isarray(arrRs) then
		arrRc2 = ubound(arrRs,2)
	else
		arrRc2 = -1
	end if
	
	if arrRc2 > -1 then
		cltsGB = "M"
	elseif fnByte(tmpMsg) > 239 then
		cltsGB = "L"
	else
		if fnByte(tmpMsg) > 90 then
			if splitYN = "Y" then
				cltsGB = "S"
			else
				cltsGB = "L"
			end if
		else
			cltsGB = "S"
		end if
	end if
	
	
	'function fnSplitMsg(strMsg, intByte)
	'	
	'	dim tChr, tByte, tAllByte, splitCnt
	'	dim arrTmpMsg
	'	
	'	splitCnt = 0
	'	redim arrTmpMsg(splitCnt)
	'	for t = 1 to len(strMsg)
	'		tChr = mid(strMsg,t,1)
	'		if asc(tChr) < 2 then
	'			tByte = 2
	'		else
	'			tByte = 1
	'		end if
	'		if (tByte + tAllByte) < (intByte + 1) then
	'			arrTmpMsg(splitCnt) = arrTmpMsg(splitCnt) & tChr
	'			tAllByte = tAllByte + tByte
	'		else
	'			splitCnt = splitCnt + 1
	'			'response.write	"<div>splitCnt: " & splitCnt & " / arrTmpMsg: " & ubound(arrTmpMsg) & "</div>"
	'			redim Preserve arrTmpMsg(ubound(arrTmpMsg)+1)
	'			tAllByte = tByte
	'			arrTmpMsg(splitCnt) = arrTmpMsg(splitCnt) & tChr
	'		end if
	'	next
	'	
	'	fnSplitMsg = arrTmpMsg
	'	
	'end function
	'
	'
	'sql = " select CL_IDX, CLT_NO, CLT_SORT, CLT_NUM1, CLT_NUM2, CLT_NUM3, CLT_TIT "
	'sql = sql & " 	, (select AD_SMSDVCGB from TBL_ADDR with(nolock) where AD_IDX = TBL_CALLTRG.AD_IDX) SPLITYN "
	'sql = sql & " from TBL_CALLTRG with(nolock) where CL_IDX = " & clIdx & " and (left(CLT_NUM1,2) = '01' or left(CLT_NUM2,2) = '01' or left(CLT_NUM3,2) = '01') "
	''response.write	sql
	'cmdOpen(sql)
	'set rs = cmd.execute
	'cmdClose()
	'if not rs.eof then
	'	arrRs = rs.getRows
	'	arrRc2 = ubound(arrRs,2)
	'else
	'	arrRc2 = -1
	'end if
	'rsClose()
	'
	'dim splitMsg
	'dim arrSplitMsg
	'if fnByte(tmpMsg) > 80 then
	'	redim arrSplitMsg(ubound(fnSplitMsg(tmpMsg, 80)))
	'	arrSplitMsg = fnSplitMsg(tmpMsg, 80)
	'end if
	'
	'sql = " insert into TBL_CALLTRG_SMS (CL_IDX, CLT_NO, CLT_SORT, CLTS_GB, CLTS_RSVDT, CLTS_SNDNUM, CLTS_RCVNUM, CLTS_TIT, CLTS_MSG, CLTS_STATUS, CD_STATUS, CD_RESULT, CD_ERROR) values "
	'
	'for i = 0 to arrRc2
	'	
	'	if arrRs(7,i) = "1" then
	'		
	'		if fnByte(tmpMsg) > 80 then
	'			
	'			splitMsg = arrSplitMsg
	'			
	'		else
	'			
	'			redim splitMsg(0)
	'			splitMsg(0) = tmpMsg
	'			
	'		end if
	'		
	'	else
	'		
	'		redim splitMsg(0)
	'		splitMsg(0) = tmpMsg
	'		
	'	end if
	'	
	'	for ii = 0 to ubound(splitMsg)
	'		sql = sql & " ("
	'		sql = sql & " " & arrRs(0,i) & ", " & arrRs(1,i) & ", " & arrRs(2,i) & ", '" & cltsGB & "' "
	'		if clSMS = "1" then				'= 문자를 1차로 전송할 경우
	'			cdStatus = 3031
	'			sql = sql & "		, '" & clRsvDT & "' "
	'		elseif clSMS = "2" then		'= 문자를 2차로 전송할 경우(음성미응답자 문자전송의 경우) : 10시간을 추가하고 음성전송이 완료된 시점에 시간을 업데이트 해주어 음성전송 완료시 바로 전송되도록한다.
	'			cdStatus = 3030
	'			sql = sql & "		, '" & fnDateToStr(dateadd("d",1,clRsvDT),"yyyy-mm-dd hh:nn:ss") & "' "
	'		end if
	'		sql = sql & " 	, '" & clSndNum2 & "' "
	'		if clMedia(0) = 1 then
	'			sql = sql & " 	, '" & arrRs(3,i) & "' "
	'		elseif clMedia(1) = 1 then
	'			sql = sql & " 	, '" & arrRs(4,i) & "' "
	'		elseif clMedia(2) = 1 then
	'			sql = sql & " 	, '" & arrRs(5,i) & "' "
	'		end if
	'		sql = sql & "		, '" & arrRs(6,i) & "', '" & splitMsg(ii) & "', 0, " & cdStatus & ", 9001, 0 "
	'		sql = sql & "),"
	'	next
	'	
	'next
	'
	'response.write	"<div>" & sql & "</div>"
	'
	'do while right(sql,1) = ","
	'	sql = left(sql,len(sql)-1)
	'loop
	'
	''response.write	"<div><h2>Insert TBL_CALLTRG_SMS</h2><div>" & sql & "</div></div>"
	'call execSql(sql)
	
	clSMSSplit = 0
	dim nChr, tmpByte, splitMsg(3)
	'for i = 1 to len(tmpMsg)
	'	nChr = mid(tmpMsg,i,1)
	'	if asc(nChr) < 2 then
	'		tmpByte = 2
	'	else
	'		tmpByte = 1
	'	end if
	'	'response.write	clSMSSplit & ":" & nChr & "(" & nByte & ") = " & splitMsg(clSMSSplit) & "<br />"
	'	if nByte + tmpByte < 81 then
	'		splitMsg(clSMSSplit) = splitMsg(clSMSSplit) & nChr
	'		nByte = nByte + tmpByte
	'	else
	'		clSMSSplit = clSMSSplit + 1
	'		nByte = tmpByte
	'		splitMsg(clSMSSplit) = splitMsg(clSMSSplit) & nChr
	'	end if
	'next
	splitMsg(0) = tmpMsg
	
	'#	==========================================================================
	'#	MSSQL
	sql = ""
	for i = 0 to clSMSSplit
		
		sql = sql & " insert into TBL_CALLTRG_SMS (CL_IDX, CLT_NO, CLT_SORT, CLTS_GB, CLTS_RSVDT, CLTS_SNDNUM, CLTS_RCVNUM, CLTS_TIT, CLTS_MSG, CLTS_STATUS, CD_STATUS, CD_RESULT, CD_ERROR) "
		sql = sql & " select CL_IDX, CLT_NO, CLT_SORT, '" & cltsGB & "'  "
		if clSMS = "1" then				'= 문자를 1차로 전송할 경우
			cdStatus = 3031
			sql = sql & "		, '" & clRsvDT & "' "
		elseif clSMS = "2" then		'= 문자를 2차로 전송할 경우(음성미응답자 문자전송의 경우) : 10시간을 추가하고 음성전송이 완료된 시점에 시간을 업데이트 해주어 음성전송 완료시 바로 전송되도록한다.
			cdStatus = 3030
			sql = sql & "		, '" & fnDateToStr(dateadd("d",1,clRsvDT),"yyyy-mm-dd hh:nn:ss") & "' "
		end if
		sql = sql & " 	, '" & clSndNum2 & "' "
		if clMedia(0) = 1 then
			sql = sql & " 	, CLT_NUM1 "
		elseif clMedia(1) = 1 then
			sql = sql & " 	, CLT_NUM2 "
		elseif clMedia(2) = 1 then
			sql = sql & " 	, CLT_NUM3 "
		end if
		'sql = sql & " 	, case "
		'sql = sql & " 		when left(CLT_NUM1,2) = '01' then CLT_NUM1 "
		'sql = sql & " 		when left(CLT_NUM2,2) = '01' then CLT_NUM2 "
		'sql = sql & " 		when left(CLT_NUM3,2) = '01' then CLT_NUM3 "
		'sql = sql & " 	end "
		sql = sql & "		, CLT_TIT, '" & splitMsg(i) & "', 0, " & cdStatus & ", 9001, 0 "
		sql = sql & " from TBL_CALLTRG where CL_IDX = " & clIdx & " "
		'sql = sql &" 		and (left(CLT_NUM1,2) = '01' or left(CLT_NUM2,2) = '01' or left(CLT_NUM3,2) = '01'); "
		
	next
	'#	==========================================================================
	
	do while right(sql,1) = ","
		sql = left(sql,len(sql)-1)
	loop
	
	'response.write	"<div><h2>Insert TBL_CALLTRG_SMS</h2><div>" & sql & "</div></div>"
	call execSql(sql)
	
end if

'#	VMS Target
if cint(clVMS) > 0 then
	
	clVMSMsg = replace(clVMSMsg,"<br>"," ")
	
	dim ttsFile : ttsFile = fnCreateTTS("/TTS", clCode, clVMSMsg, TTS_pitch, TTS_speed, TTS_volume, TTS_sformat, 2)
	dim ttsFileWav : ttsFileWav = fnCreateTTS("/TTS", clCode, clVMSMsg, TTS_pitch, TTS_speed, TTS_volume, 545, 2)
	
	dim vmsMediaCnt : vmsMediaCnt = 1
	if cint(clMedia(2)) > 0 then
		vmsMediaCnt = 3
	else
		if cint(clMedia(1)) > 0 then
			vmsMediaCnt = 2
		end if
	end if
	
	' sql = " select CL_IDX, CLT_NO, CLT_SORT "
	''sql = sql & " 	, dbo.ecl_DECRPART(CLT_NUM1,4), dbo.ecl_DECRPART(CLT_NUM2,4), dbo.ecl_DECRPART(CLT_NUM3,4) "
	' sql = sql & " 	, CLT_NUM1, CLT_NUM2, CLT_NUM3 "
	' sql = sql & " from TBL_CALLTRG with(nolock) where CL_IDX = " & clIdx & " "
	' arrRs = execSqlRs(sql)
	' if isarray(arrRs) then
		' arrRc2 = ubound(arrRs,2)
	' else
		' arrRc2 = -1
	' end if
	
	
	' sql = ""
	' for i = 1 to vmsMediaCnt
		
		' for ii = 1 to clTry(i-1)
			
			' for iii = 0 to arrRc2
				
				' 'sql = sql & "(" & arrRs(0,iii) & ", " & arrRs(1,iii) & ", " & arrRs(2,iii) & " "
				' sql = "exec usp_setCallTrgVMS " & arrRs(0,iii) & ", " & arrRs(1,iii) & ", " & arrRs(2,iii) & " "
				' if clVMS = "1" then
					' if i = 1 and ii = 1 then
						' cdStatus = 3031
					' else
						' cdStatus = 3030
					' end if
					' sql = sql & ", '" & clRsvDT & "' "
				' elseif clVMS = "2" then
					' cdStatus = 3030
					' sql = sql & ", '" & fnDateToStr(dateadd("d",1,clRsvDT),"yyyy-mm-dd hh:nn:ss") & "' "
				' end if
				' if i = 1 then
					' sql = sql & " , " & clng(ii) + ((clng(i) - 1) * (vmsMediaCnt-1)) & " "
				' elseif i = 2 then
					' sql = sql & " , " & clng(clTry(0)) + clng(ii)
				' elseif i = 3 then
					' sql = sql & " , " & clng(clTry(0)) + clng(clTry(1)) + clng(ii) & " "
				' end if
				' 'sql = sql & ", " & i & ", " & ii & ", '" & arrRs(2+i,iii) & "', 0, " & cdStatus & ", 9001, 0),"
				' sql = sql & ", " & i & ", " & ii & ", '" & arrRs(2+i,iii) & "', 0, " & cdStatus & ""
				' response.write	sql
				' call execSql(sql)
				
			' next
			
		' next
		
	' next
	
	'--손민경 수정 2017-11-02

	' sql = " select CL_IDX, CLT_NO, CLT_SORT "
	''sql = sql & " 	, dbo.ecl_DECRPART(CLT_NUM1,4), dbo.ecl_DECRPART(CLT_NUM2,4), dbo.ecl_DECRPART(CLT_NUM3,4) "
	' sql = sql & " 	, CLT_NUM1, CLT_NUM2, CLT_NUM3 "
	' sql = sql & " from TBL_CALLTRG with(nolock) where CL_IDX = " & clIdx & " "
	' arrRs = execSqlRs(sql)
	' if isarray(arrRs) then
		' arrRc2 = ubound(arrRs,2)
	' else
		' arrRc2 = -1
	' end if
	
	
	' [dbo].[usp_setCallTrgVMS_BAT](
	' @CL_IDX int
	' , @CLTV_RSVDT varchar(20)
	' , @CLTV_NO int
	' , @CLTV_MEDIA int
	' , @CLTV_TRY int
	' , @CLTV_STATUS int
	' , @CD_STATUS int

	
	sql = ""
	for i = 1 to vmsMediaCnt		
		for ii = 1 to clTry(i-1)			
			'for iii = 0 to arrRc2				
				'sql = sql & "(" & arrRs(0,iii) & ", " & arrRs(1,iii) & ", " & arrRs(2,iii) & " "
				sql = "exec usp_setCallTrgVMS_BAT " & clIdx 
				if clVMS = "1" then
					if i = 1 and ii = 1 then
						cdStatus = 3031
					else
						cdStatus = 3030
					end if
					sql = sql & ", '" & clRsvDT & "' "
				elseif clVMS = "2" then
					cdStatus = 3030
					sql = sql & ", '" & fnDateToStr(dateadd("d",1,clRsvDT),"yyyy-mm-dd hh:nn:ss") & "' "
				end if
				if i = 1 then
					sql = sql & " , " & clng(ii) + ((clng(i) - 1) * (vmsMediaCnt-1)) & " "
				elseif i = 2 then
					sql = sql & " , " & clng(clTry(0)) + clng(ii)
				elseif i = 3 then
					sql = sql & " , " & clng(clTry(0)) + clng(clTry(1)) + clng(ii) & " "
				end if
				'sql = sql & ", " & i & ", " & ii & ", '" & arrRs(2+i,iii) & "', 0, " & cdStatus & ", 9001, 0),"
				sql = sql & ", " & i & ", " & ii & ", 0, " & cdStatus & ""
				response.write	sql
				call execSql(sql)
				
			'next
			
		next
		
	next	
	'sql = " insert into TBL_CALLTRG_VMS (CL_IDX, CLT_NO, CLT_SORT, CLTV_RSVDT, CLTV_NO, CLTV_MEDIA, CLTV_TRY, CLTV_NUM, CLTV_STATUS, CD_STATUS, CD_RESULT, CD_ERROR) values " & sql
	
	'do while right(sql,1) = ","
	'	sql = left(sql,len(sql)-1)
	'loop
	
	response.write	"<div><h2>Insert TBL_CALLTRG_VMS</h2><div>" & sql & "</div></div>"
	'call execSql(sql)
	
end if

'#	FMS Target
if cint(clFMS) > 0 then
	
end if

'#	문자후 음성에서 대상자의 휴대폰번호가 전혀 없는경우 바로 음성전송진행처리
if clMethod = 4 then
	dim smsTrgCnt : smsTrgCnt = fnDBVal("TBL_CALLTRG_SMS","count(*)","CL_IDX = " & clIdx & " ")
	if clng(smsTrgCnt) = 0 then
		sql = " update TBL_CALLTRG_VMS set CLTV_RSVDT = getdate() where CL_IDX = " & clIdx & "; "
		sql = sql & " update TBL_CALLTRG_VMS set CD_STATUS = 3031 where CL_IDX = " & clIdx & " and CD_STATUS = 3030 and CLTV_TRY = 1 and CLTV_MEDIA = 1; "
		call execSql(sql)
	end if
end if

'#	Web에서 전송시 문자일괄전송 [2016.08.30|오태근]
'if ss_userIdx = 1 then
if clSMS = "1" then
	call execProc("usp_SMSSetNuri", array(clIdx))
end if
'end if

sql = " update TBL_CALL set CL_STEP = 1 where CL_IDX = " & clIdx & " "
call execSql(sql)

dim resultUrl
dim strLogTit, strLogMsg
select case clGB
	case "E"
		resultUrl = "emrList"
		strLogTit = "비상전파요청 <" & clTit & ">"
	case "S"
		resultUrl = "smsList"
		strLogTit = "문자전송요청 <" & clTit & ">"
	case "V"
		resultUrl = "vmsList"
		strLogTit = "음성전송요청 <" & clTit & ">"
	case "F"
		resultUrl = "fmsList"
		strLogTit = "팩스전송요청 <" & clTit & ">"
end select

strLogMsg = "Code : " & clCode
call subSetLog(ss_userIdx, 8002, strLogTit, strLogMsg, "")

response.write	"<script>"
response.write	"	alert('전송요청이 완료되었습니다.');"
response.write	"	top.fnLoadingE();"
if clGB = "E" then
	response.write	"	top.fnPop('/pages/call/pop_callMonitor.asp?clIdx=" & clIdx & "', 'callMonitor', 0, 0, 900, 600, 'no');"
	'response.write	"	var objWin = window.open('/pages/call/callMonitor.asp?clIdx=" & clIdx & "','callMonitor','top=0,left=0,width=600,height=400,scrollbars=no');"
	'response.write	"	objWin.focus();"
end if
response.write	"	top.location.href = '/pages/result/" & resultUrl & ".asp';"
response.write	"</script>"
%>