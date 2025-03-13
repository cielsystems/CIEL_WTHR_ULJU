<!--#include virtual="/common/common.asp"-->

<%
dim adbIdx	: adbIdx	= fnReq("idx")

'#	현재 연락처 삭제
sql = " delete from TBL_ADDR where GRP_CODE in (select GRP_CODE from TBL_ADDR_BACKUPGRP where ADB_IDX = " & adbIdx & "); "

'#	기존 연락처 복원
sql = sql & " insert into TBL_ADDR ( "
sql = sql & " 	AD_GB, CD_USERGB, GRP_CODE, SYNCID, AD_SORT, AD_ID, AD_PW, AD_NO, AD_NM, AD_NUM1, AD_NUM2, AD_NUM3 "
sql = sql & " 	, AD_DFTNUM, AD_EMAIL, AD_MEMO, AD_GRP01, AD_GRP02, AD_GRP03, AD_GRP04, AD_GRP05, AD_DVCGB, AD_DVCID "
sql = sql & " 	, AD_ETC1, AD_ETC2, AD_ETC3, AD_ETC4, AD_ETC5, AD_PERADDR, AD_PEREMR, AD_PERLOGIN, AD_PERSMS "
sql = sql & " 	, AD_SMSCNT, AD_LMSCNT, AD_MMSCNT, AD_SYNCYN, USEYN "
sql = sql & " ) "
sql = sql & " select "
sql = sql & " 	AD_GB, CD_USERGB, GRP_CODE, SYNCID, AD_SORT, AD_ID, AD_PW, AD_NO, AD_NM, AD_NUM1, AD_NUM2, AD_NUM3 "
sql = sql & " 	, AD_DFTNUM, AD_EMAIL, AD_MEMO, AD_GRP01, AD_GRP02, AD_GRP03, AD_GRP04, AD_GRP05, AD_DVCGB, AD_DVCID "
sql = sql & " 	, AD_ETC1, AD_ETC2, AD_ETC3, AD_ETC4, AD_ETC5, AD_PERADDR, AD_PEREMR, AD_PERLOGIN, AD_PERSMS "
sql = sql & " 	, AD_SMSCNT, AD_LMSCNT, AD_MMSCNT, AD_SYNCYN, USEYN "
sql = sql & " from TBL_ADDR_BACKUPITEM "
sql = sql & " where ADB_IDX = " & adbIdx & "; "

'#	상태 업데이트
sql = sql & " update TBL_ADDR_BACKUP set ADB_YN = 'Y' where ADB_IDX = " & adbIdx & "; "

'#	Hist Insert
sql = sql & " insert into TBL_ADDR_BACKUPHIST (ADB_IDX) values (" & adbIdx & "); "

call execSql(sql)
%>

<script type="text/javascript">
	alert('복원이 완료되었습니다.');
	parent.location.reload();
</script>