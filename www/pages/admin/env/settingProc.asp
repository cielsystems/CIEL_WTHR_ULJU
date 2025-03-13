<!--#include virtual="/common/common.asp"-->

<%
'#	Create Backup File
dim filePath : filePath = "/data/backup"
dim fileFullPath : fileFullPath = fnCreatePath(filePath)

dim fileName : fileName = "setting_backup_" & fnDatetoStr(now, "yyyymmddhhnnss") & ".sql"

dim backupFile : backupFile = fnCreateFile(fileFullPath, fileName)

sql = " select SET_NO, SET_CD, SET_NM, SET_VAL from TBL_SET with(nolock) order by SET_NO asc "
response.write	sql
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
if not rs.eof then
	arrRs = rs.getRows
	arrRc2 = ubound(arrRs,2)
else
	arrRc2 = -1
end if
rsClose()

dim fso, objFile
set fso = server.createObject("scripting.fileSystemObject")
set objFile = fso.openTextFile(fileFullPath & "/" & fileName,8)

objFile.writeLine(" insert into TBL_SET (SET_NO, SET_CD, SET_NM, SET_VAL) values ")
for i = 0 to arrRc2
	if i = 0 then
		objFile.writeLine(" ('" & arrRs(0,i) & "', '" & arrRs(1,i) & "', '" & arrRs(2,i) & "', '" & arrRs(3,i) & "') ")
	else
		objFile.writeLine(", ('" & arrRs(0,i) & "', '" & arrRs(1,i) & "', '" & arrRs(2,i) & "', '" & arrRs(3,i) & "') ")
	end if
next

objFile.close
set objFile = nothing
set fso = nothing

for i = 0 to arrRc2
	sql = " update TBL_SET set SET_VAL = '" & fnReq("no" & i+1) & "' where SET_NO = '" & arrRs(0,i) & "' "
	response.write	sql
	call execSql(sql)
next

call subSetLog(ss_userIdx, 8008, "설정변경", "", "")
%>

<script>
	alert('설정이 변경되었습니다.');parent.location.reload();
</script>