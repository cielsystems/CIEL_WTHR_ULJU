<!--#include virtual="/common/common.asp"-->

<%
dim proc	: proc	= fnReq("proc")

dim upcode	: upcode	= fnReq("upcode")
dim nm			: nm			= fnReq("nm")
dim code		: code		= fnReq("code")

dim cnt, cdCode, cdSort
dim strScript

if proc = "add" then
	
	cnt	= fnDBVal("TBL_CODE", "count(*)", "USEYN = 'Y' and CD_UPCODE = " & upcode & " and CD_NM = '" & nm & "'")
	
	if cnt > 0 then
		
		strScript = "alert('동일한 코드가 존재합니다.');"
		
	else
		
		cdCode	= fnIsNull(fnDBVal("TBL_CODE", "max(CD_CODE)", "CD_UPCODE = " & upcode & ""),0) + 1
		cdSort	= fnIsNull(fnDBVal("TBL_CODE", "max(CD_SORT)", "CD_UPCODE = " & upcode & ""),0) + 1
		
		sql = " insert into TBL_CODE (CD_CODE, CD_UPCODE, CD_SORT, CD_NM) "
		sql = sql & " values (" & cdCode & ", " & upcode & ", " & cdSort & ", '" & nm & "') "
		call execSql(sql)
		
		strScript = "alert('코드가 등록되었습니다.');parent.location.reload();"
		
	end if
	
elseif proc = "del" then
	
	sql = " update TBL_CODE set USEYN = 'N', UPTDT = getdate() where CD_CODE = " & code & " "
	call execSql(sql)
	
	strScript	= "alert('코드가 삭제되었습니다.');parent.location.reload();"
	
end if

response.write	"<script type=""text/javascript"">"
response.write	strScript
response.write	"</script>"
%>