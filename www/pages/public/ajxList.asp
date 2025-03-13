<!--#include virtual="/common/common.asp"-->

<%
dim proc : proc = fnReq("proc")
dim param : param = fnReq("param")
dim page : page = fnIsNull(fnReq("page"),1)
dim pageSize : pageSize = fnIsNull(fnReq("pageSize"),g_pageSize)

dim listProc, listProcParam, tmpArr

select case proc
	
	'#	================================================================================================
	'#	메시지 목록
	case "MsgList"
		
		listProc = "usp_listMsg"	'//	MSG_IDX(2), MSG_GB(3), MSGTP1(4), MSGTP2(5), MSG_CODE(6), MSG_TIT(7), MSG_SMS(8), MSG_VMS(9), MSG_FMS(10), REGDT(11), UPTDT(12)
		
	'#	================================================================================================
	'#	임시대상자 목록
	case "TmpTrg"
		
		listProc = "usp_listTmpTrg"	'//	TMP_NO(2), TMP_NM(3), TMP_NUM1(4), TMP_NUM2(5), TMP_NUM3(6), TMP_IDX(7), AD_EMAIL(8), GRPFULLNM(9)
		
	'#	================================================================================================
	'#	임시파일 목록
	case "TmpFile"
		
		listProc = "usp_listTmpFile"	'// TMP_NO(2), TMP_DPNM(3), TMP_PATH(4), TMP_FILE(5), TMP_PAGE(6)
		
	'#	================================================================================================
	'#	메시지 임시파일 목록
	case "TmpMsgFile"
		
		listProc = "usp_listTmpMsgFile"	'// TMP_NO(2), TMP_DPNM(3), TMP_PATH(4), TMP_FILE(5), TMP_PAGE(6)
		
	'#	================================================================================================
	'#	전송결과 목록
	case "CallResult"
		
		'//	CL_IDX(12), AD_IDX(3), AD_ID(4), MSG_IDX(5), MSG_GB(6), CD_MSGTP(7), CDMSGTPNM(8), CL_METHOD(9), CL_TRY(10), CL_RSVDT(11), CL_SMSGB(12), CL_VMSGB(13), CL_FMSGB(14), CL_SNDNUM(15), CL_TIT(16), CL_STEP(17), TRGCNT(18), REGDT(19), SMSGB(20)
		listProc = "usp_listCallResultNew"
	
	'#	================================================================================================
	'#	전송결과대상자 목록
	case "CallResultTargets"
		
		'//	CLT_NO(2), CLT_NM(3), CLT_SDR(4), CLT_EDT(5), CD_STATUS(6), CDSTATUSNM(7), CD_RESULT(8), CD_RESULTNM(9), CD_ERROR(10), CDERRORNM(11), CLT_ANSWYN(12), CLT_ANSWMEDIA(13), CLT_ANSWDT(14), CD_SMSSTATUS(15), CD_VMSSTATUS(16), CLTSTATUS(17), CLT_NUM1(18), CLT_NUM2(19), CLT_NUM(20)
		listProc = "usp_listCallResultTargets"
	
	'#	================================================================================================
	'#	게시판 목록
	case "boardList"
		
		listProc = "usp_listBoard"	'//	BD_IDX(2), BD_TIT(3), BD_FILEYN(4), BD_VISIT(5), AD_ID(6), REGDT(7)
		
	'#	================================================================================================
	'#	사용로그 목록
	case "logList"
		
		listProc = "usp_listLog"	'//	LOG_IDX(2), CDLOGGBNM(3), LOG_TIT(4), AD_IDX(5), AD_ID(6), AD_NM(7), LOG_IP(8), LOG_DT(9)
		
	'#	================================================================================================
	'#	서울메트로 사용자 Depth
	case "SeoulMetro_Depth"
		
		listProc = "usp_listDepth_seoulMetro"
		
	'#	================================================================================================
	'#	Mo List
	case "MoList"
		
		listProc = "usp_listMoData"
		
	
end select

dim debugSql : debugSql = listProc
tmpArr = split(param,"]|[")
dim arrListParam
redim arrListParam(ubound(tmpArr)+2)
for i = 0 to ubound(tmpArr)
	arrListParam(i) = tmpArr(i)
	debugSql = debugSql & "'" & tmpArr(i) & "',"
next
'response.write	debugSql

arrListParam(i) = page
arrListParam(i+1) = pageSize

arrRs = execProcRs(listProc, arrListParam)
if isarray(arrRs) then
	rowCnt = arrRs(0,0)
	arrRc2 = ubound(arrRs,2)
	arrRc1 = ubound(arrRs,1)
else
	rowCnt = 0
	arrRc2 = -1
end if

response.write	rowCnt & "}|{"

call subPaging()

response.write	"}|{"

for i = 0 to arrRc2
	for ii = 0 to arrRc1
		response.write	arrRs(ii,i)
		if ii < arrRc1 then
			response.write	"]|["
		end if
	next
	if i < arrRc2 then
		response.write	"}|{"
	end if
next

%>