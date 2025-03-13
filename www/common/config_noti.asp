<%
dim ntDBPrev	: ntDBPrev	= "CIEL_WTHR.dbo."

dim ntCateRs, ntCateRc, ntCateLoop

sql = " select CD_CODE, CD_NM from " & ntDBPrev & "TBL_CODE with(nolock) where USEYN = 'Y' and CD_UPCODE = 91 order by CD_SORT "
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
if not rs.eof then
	ntCateRs	= rs.getRows
	ntCateRc	= ubound(ntCateRs, 2)
else
	ntCateRc	= -1
end if
rsClose()


dim ntRankRs, ntRankRc, ntRankLoop

sql = " select CD_CODE, CD_NM from " & ntDBPrev & "TBL_CODE with(nolock) where USEYN = 'Y' and CD_UPCODE = 92 and CD_SORT > 1 order by CD_SORT "
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
if not rs.eof then
	ntRankRs	= rs.getRows
	ntRankRc	= ubound(ntRankRs, 2)
else
	ntRankRc	= -1
end if
rsClose()


dim ntTypeRs, ntTypeRc, ntTypeLoop

sql = " select CD_CODE, CD_NM from " & ntDBPrev & "TBL_CODE with(nolock) where USEYN = 'Y' and CD_UPCODE = 93 order by CD_SORT "
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
if not rs.eof then
	ntTypeRs	= rs.getRows
	ntTypeRc	= ubound(ntTypeRs, 2)
else
	ntTypeRc	= -1
end if
rsClose()


dim ntAreaRs, ntAreaRc, ntAreaLoop

sql = " select AREACODE, AREAGUBN, AREAUPER, AREANAME from NTBL_NOTI_AREA with(nolock) where USEYN = 'Y' "
cmdOpen(sql)
set rs = cmd.execute
cmdClose()
if not rs.eof then
	ntAreaRs	= rs.getRows
	ntAreaRc	= ubound(ntAreaRs, 2)
else
	ntAreaRc	= -1
end if
rsClose()


dim ntTimeRs, ntTimeRc, ntTimeLoop
ntTimeRs	= array(array(1,"검사시각"), array(2,"발표시각"), array(3,"발효시각"))


dim ntEqkTypeRs, ntEqkTypeRc, ntEqkTypeLoop
ntEqkTypeRs	= array(array(2,"국외지진정보"), array(3,"국내지진정보"), array(5,"국내지진정보(재통보)")_
	, array(11,"국내지진조기경보"), array(12,"국외지진조기경보"), array(13,"조기경보정밀분석"), array(14,"지진속보(조기분석)"))
%>