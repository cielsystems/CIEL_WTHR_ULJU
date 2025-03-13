<%
'SetEucKR()
' 에러 코드
const NO_ERROR = 0
const NO_DATA = 1
const REDIRECT_URL = 2
const ERROR_TIMEOUT_USAGE = 1000
const ERROR_NOT_HAVE_PERMISSION = 1001
const ERROR_NOT_ALLOW_TO_ACCESS_IP = 1002
const ERROR_EXIST_CODE = 1010
const ERROR_INVALID_PARAM = 1100
const ERROR_INVALID_TOP_GROUP = 2000
const ERROR_SYSTEM = 9999
%>

<%
' 에러 메시지 출력
function getErrMsg(errCode)
    dim errMsg
    select case errCode
        case NO_ERROR                       errMsg = "성공"
        case NO_DATA                        errMsg = "데이터 없음"
        case REDIRECT_URL                   errMsg = "주소 재전송"
        case ERROR_TIMEOUT_USAGE            errMsg = "사용시간 초과로 로그아웃되었습니다."
        case ERROR_NOT_HAVE_PERMISSION      errMsg = "권한이 없습니다."
        case ERROR_NOT_ALLOW_TO_ACCESS_IP   errMsg = "IP주소는 액세스가 허용되지 않습니다."
        case ERROR_EXIST_CODE               errMsg = "코드가 이미 존재합니다."
        case ERROR_INVALID_PARAM            errMsg = "파라미터가 잘못 되었습니다."
        case ERROR_INVALID_TOP_GROUP        errMsg = "최상위 그룹이 잘못 되었었습니다."
        case ERROR_SYSTEM                   errMsg = "시스템 에러"
        case else:                          errMsg = "알 수 없는 에러가 발생하였습니다."
    end select
    getErrMsg = errMsg
end function
%>