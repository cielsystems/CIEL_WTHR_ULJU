<%
function BytesToStr(bytes)
    Dim Stream
    Set Stream = Server.CreateObject("Adodb.Stream")
    Stream.Type = 1 'adTypeBinary
    Stream.Open
    Stream.Write bytes
    Stream.Position = 0
    Stream.Type = 2 'adTypeText
    Stream.Charset = "UTF-8"
    BytesToStr = Stream.ReadText
    Stream.Close
    Set Stream = Nothing
end function

function fnReqJson(reqTotalBytes)
    if reqTotalBytes > 0 then
        dim bytesCount, jsonText
        bytesCount = reqTotalBytes
        fnReqJson = BytesToStr(request.BinaryRead(bytesCount))
    else
        fnReqJson = ""
    end if
end function
%>