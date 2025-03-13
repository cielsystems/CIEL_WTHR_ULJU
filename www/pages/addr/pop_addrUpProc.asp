<!--#include virtual="/common/common.asp"-->
<!--#include virtual="/common/errCode.asp"-->
<!--#include virtual="/common/json.asp"-->
<!--#include virtual="/plugins/Json/aspJSON1.19.asp"-->
<!--#include virtual="/public/common/fnc_db_json.asp"-->

<%
call UploadXlsData()
%>

<%
' 주소록 엑셀 업로드
sub UploadXlsData()
	dim resCode : resCode = NO_ERROR
	dim grpGb, oldAddrDel
	dim row
	dim item
	dim grp(4), name, phoneNo(2), memo, code
	dim addrCodes

	On Error Resume Next
	Err.Clear

	' 요청 파라미터 확인
	dim json : json = fnReqJson(request.TotalBytes)
	dim jsonObj
	if json <> "" then
		json = replace(json, "'","''")
	end if

    call subWebLog("DEBUG. UploadXlsData() - [" & json & "]")

	if json = "" then
		call subResErr(ERROR_INVALID_PARAM)
		On Error Goto 0
		exit sub
	end if

	' 요청 파라미터에 JSON으로 넘어온 데이터를 파싱한다.
	set jsonObj = new aspJSON
	jsonObj.loadJSON(json)
	if Err.Number > 0 then
		call subResErr(ERROR_INVALID_PARAM)
		set jsonObj = nothing
		On Error Goto 0
		exit sub
	end if

	grpGb = jsonObj.data("grpGb")
	call subWebLog("DEBUG. GRP_GB : [" & grpGb & "]")

	oldAddrDel = jsonObj.data("oldAddrDel")
	call subWebLog("DEBUG. OLD ADDR DEL : [" & oldAddrDel & "]")

	dbOpen()
	dbBeginTrans()

	row = 0
	for each row in jsonObj.data("data")
		set item = jsonObj.data("data").item(row)
		grp(0) = fnIsNull(item.item("grp1"), "")
		grp(1) = fnIsNull(item.item("grp2"), "")
		grp(2) = fnIsNull(item.item("grp3"), "")
		grp(3) = fnIsNull(item.item("grp4"), "")
		grp(4) = fnIsNull(item.item("grp5"), "")
		name = fnIsNull(item.item("name"), "")
		phoneNo(0) = fnIsNull(item.item("phoneNo1"), "")
		phoneNo(1) = fnIsNull(item.item("phoneNo2"), "")
		phoneNo(2) = fnIsNull(item.item("phoneNo3"), "")
		memo = fnIsNull(item.item("memo"), "")
		code = fnIsNull(item.item("code"), "")

		call subWebLog("DEBUG. [" & (row + 1) & "] [" & grp(0) & "] [" & grp(1) & "] [" & grp(2) & _
			"] [" & grp(3) & "] [" & grp(4) & "] [" & name & "] [" & phoneNo(0) & "] [" & phoneNo(1) & _ 
			"] [" & phoneNo(2) & "] [" & memo & "] [" & code & "]")

		' 부서 그룹
		dim grpIdx(5), lastGrpIdx
		grpIdx(0) = dbDBVal("SELECT GRUP_INDX FROM NTBL_GRUP " & _
			"WHERE USEYN = 'Y' AND GRUP_DPTH = 0 AND GRUP_GUBN = '" & grpGb & "'")
		if grpIdx(0) = 0 then
			call subResErr(ERROR_INVALID_TOP_GROUP)
			On Error Goto 0
			exit sub
		end if
		for i = 0 to 4
			if len(grp(i)) > 0 then
				grpIdx(i + 1) = fnIsNull(dbDBVal("SELECT GRUP_INDX FROM NTBL_GRUP WHERE USEYN = 'Y' AND GRUP_DPTH = " & (i + 1) & _ 
					" AND GRUP_GUBN = '" & grpGb & "' AND GRUP_UPER = " & grpIdx(i) & " AND GRUP_NAME = '" & grp(i) & "'"), 0)
				if grpIdx(i + 1) = 0 then
					grpIdx(i + 1) = createGroup(grpGb, grpIdx(i), grp(i))
				end if
				lastGrpIdx = grpIdx(i + 1)
				if oldAddrDel = "Y" then
					retn = dbExecProc("nusp_backNDeltGrupAddr", array(_
							array("grupIndx", 3, 0, lastGrupIndx), _
							array("userIndx", 3, 0, ss_userIndx), _
							array("userIP", 200, 20, svr_remoteAddr)))
				end if
			else
				exit for
			end if
		next

		' 분류 코드
		addrCodes = ""
		if len(code) > 0 then
			dim arrCodes : arrCodes = split(code, "^")
			dim arrSubCodes
			dim addrUpCode, addrCode

			redim addrUpCode(ubound(arrCodes))
			redim addrCode(ubound(arrCodes))
			for i = 0 to ubound(arrCodes)
				if len(arrCodes(i)) > 0 and inStr(arrCodes(i), "&#62;") > 0 then
					arrSubCodes = split(arrCodes(i), "&#62;")
					addrUpCode(i) = fnIsNull(dbDBVal("SELECT ADDR_CODE FROM NTBL_ADDR_CODE " & _
						"WHERE USEYN = 'Y' AND ADDR_CODE_NAME = '" & trim(arrSubCodes(0)) & "'"), 0)
					if addrUpCode(i) = 0 then
						addrUpCode(i) = createAddrCode(addrUpCode(i), trim(arrSubCodes(0)))
					end if
					addrCode(i) = fnIsNull(dbDBVal("SELECT ADDR_CODE FROM NTBL_ADDR_CODE " & _
						"WHERE USEYN = 'Y' AND ADDR_CODE_UPER = " & addrUpCode(i) & _
						" AND ADDR_CODE_NAME = '" & trim(arrSubCodes(1)) & "'"), 0)
					if addrCode(i) = 0 then
						addrCode(i)	= createAddrCode(addrUpCode(i), trim(arrSubCodes(1)))
					end if
					if len(addrCodes) > 0 then
						addrCodes = addrCodes & ","
					end if
					addrCodes = addrCodes & addrCode(i)
				end if
			next
		end if

		' 주소록 추가
		call dbSubProcExec("nusp_procAddr", array("S", 0, grpGb, "N", 1, _
			name, phoneNo(0), phoneNo(1), phoneNo(2), memo, _
			replace(lastGrpIdx, " ", ""), replace(addrCodes, " ", ""), ss_userIndx, svr_remoteAddr))

		row = row + 1
	next

	dbCommit()
	dbClose()
	' JSON 개체 해제
	set jsonObj = nothing
    resCode = NO_ERROR

	jsonResErr(NO_ERROR)
	On Error Goto 0
end sub
%>

<%
function createGroup(gb, upIdx, name)
	dim sort : sort = (fnIsNull(dbDBVal("SELECT MAX(GRUP_SORT) FROM NTBL_GRUP " & _
		"WHERE USEYN = 'Y' AND GRUP_UPER = " & upIdx & ""),  0) + 1)
	call subWebLog("INFO. createGroup([" & gb & "], " & upIdx & ", [" & name & "])")
	call dbSubProcExec("nusp_procGrup", _
		array("S", gb, upIdx, 0, sort, name, "", "", ss_userIndx, svr_remoteAddr))
	createGroup = retn
end function

function createAddrCode(upIdx, name)
	dim sort : sort = (fnIsNull(dbDBVal("SELECT MAX(ADDR_CODE_SORT) FROM NTBL_ADDR_CODE " & _
		"WHERE USEYN = 'Y' AND ADDR_CODE_UPER = " & upIdx & ""), 0) + 1)
	call subWebLog("INFO. createAddrCode(" & upIdx & ", [" & name & "])")
	call dbSubProcExec("nusp_procAddrCode", _
		array("S", 0, intUper, "P", strName, sort, ss_userIndx, svr_remoteAddr))
	createAddrCode = retn
end function
%>