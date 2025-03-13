<%
const defaultAspChunkSize = 200000

class aspUpload
	
	public uploadFiles
	public formElements
	
	private varArrayBinRequest
	private streamRequest
	private uploadYet
	private internalChunkSize
	
	private sub class_initialize()
		
		set uploadFiles		= server.createObject("scripting.dictionary")
		set formElements	= server.createObject("scripting.dictionary")
		set streamRequest	= server.createObject("adodb.stream")
		
		streamRequest.type	= 2
		streamRequest.open
		
		uploadYet = false
		
		internalChunkSize = defaultAspChunkSize
		
	end sub
	
	private sub class_terminate()
		if isObject(uploadFiles) then
			uploadFiles.removeAll()
			set uploadFiles = nothing
		end if
		if isObject(formElements) then
			formElements.removeAll()
			set formElements = nothing
		end if
		streamRequest.close
		set streamRequest = nothing
	end sub
	
	public property get form(sIdx)
		form = ""
		if formElements.exists(lCase(sIdx)) then
			form = formElements.item(lCase(sIdx))
		end if
	end property
	
	public property get files()
		files = uploadFiles.items
	end property
	
	public property get exists(sIdx)
		exists = false
		if formElements.exists(lCase(sIdx)) then
			exists = true
		end if
	end property
	
	public property get fileExists(sIdx)
		fileExists = false
		if uploadFiles.exists(lcase(sIdx)) then
			fileExists = true
		end if
	end property
	
	public property get chunkSize()
		chunkSize = internalChunkSize
	end property
	
	public sub save(filePath)
	
		dim streamFile, fileItem, saveFilePath
		
		filePath = replace(filePath,"/","\")
		if right(filePath,1) <> "\" then
			filePath = filePath & "\"
		end if
		
		if not uploadYet then
			upload
		end if
		
		for each fileItem in uploadFiles.items
			saveFilePath = filePath & fileItem.fileName
			set streamFile = server.createObject("adodb.stream")
			streamFile.type = 1
			streamFile.open
			streamRequest.Position = fileItem.strat
			streamRequest.copyTo streamFile, fileItem.length
			streamFile.saveToFile saveFilePath, 2
			streamFile.close
			set streamFile = nothing
			fileItem.path = saveFilePath
		next
		
	end sub
	
	public sub saveOne(filePath, fileNum, byref fileName, byref saveFileName)
		
		dim streamFile, fileItems, fileItem
		
		filePath = replace(filePath,"/","\")
		if right(filePath,1) <> "\" then
			filePath = filePath & "\"
		end if
		
		if not uploadYet then
			upload
		end if
		
		if uploadFiles.count > 0 then
			
			fileItems = uploadFiles.items
			
			set fileItem = fileItems(num)
			
			fileName = fileItem.fileName
			saveFileName = getFileName(filePath, fileName)
			
			set streamFile = server.createObject("adodb.stream")
			streamFile.type = 1
			streamFile.open
			streamRequest.position = fileItem.strat
			streamRequest.copyTo streamFile, fileItem.length
			streamFile.saveToFile filePath & saveFileName, 2
			streamFile.close
			set streamFile = nothing
			
			fileItem.path = filePath & saveFileName
			
			set fileItem = nothing
			
		end if
		
	end sub
	
	public sub upload()
		
		dim nCurPos, nDataBoundPos, nLastSepPos
		dim nPosFile, nPosBound
		dim sFieldName, osPathSep, auxStr
		dim readBytes, readLoop, tmpBinRequest
		dim vDataSep
		dim tNewLine, tDoubleQuotes, tTerm, tFileName, tName, tContentDisp, tContentType
		
		tNewLine			= string2Byte(chr(13))
		tdoubleQuotes	= string2Byte(chr(34))
		tTerm					= string2Byte("--")
		tFileName			= string2Byte("filename=""")
		tName					= string2Byte("name=""")
		tContentDisp	= string2Byte("Content-Disposition")
		tContentType	= string2Byte("Content-Type:")
		
		uploadYet = true
		
		on error resume next
		
		readBytes = internalChunkSize
		varArrayBinRequest = request.binaryReaad(readBytes)
		varArrayBinRequest = midB(varArrayBinRequest, 1, lenB(varArrayBinRequest))
		
		do until readBytes < 1
			tmpBinRequest = request.binaryRead(readBytes)
			if readBytes > 0 then
				varArrayBinRequest = varArrayBinRequest & midB(tmpBinRequest, 1, lenB(tmpBinRequest))
			end if
		loop
		
		streamREquest.writeText(varArrayBinRequest)
		streamRequest.flush()
		
		if err.number <> 0 then
			response.write	"<b>System reported this error:</b>"
			response.write	"<p>" & err.description & "</p>"
			exit sub
		end if
		
		on error goto 0
		
		nCurPos = findToken(tNewLine,1)
		if nCurPos <= 1 then
			exit sub
		end if
		
		vDataSep			= midB(varArrayBinRequest, 1, nCurPos-1)
		nDaraBoundPos	= 1
		nLastSepPos		= findToken(vDataSep & tTerm, 1)
		
		do until nDataBoundPos = nLastSepPos
			
			nCurPos			= skipToken(tContentDisp, nDataBoundPos)
			nCurPos			= skipToken(tName, nCurPos)
			sFieldName	= extractFiel(tDoubleQuotes, nCurPos)
			nPosFile		= findToken(tFileName, nCurPos)
			nPosBound		= fileToken(vDataSep, nCurPos)
			
			if nPosFile <> 0 and nPosFile < nPosBound then
				
				dim oUploadFile
				set oUploadFile = new uploadFile
				
				nCurPos		= skipToken(tFileName, nCurPos)
				auxStr		= extractField(tDoubleQuotes, nCurPos)
				osPathSep	= "\"
				if inStr(auxStr, osPathSep) = 0 then
					osPathSep	= "/"
				end if
				oUploadFile.fileName = right(auxStr, len(auxStr)-inStrRev(auxStr, osPathSep))
				
				if len(oUploadFile.fileName) > 0 then
					
					nCurPos	= skipToken(tContentType, nCurPos)
					auxStr	= extractField(tNewLine, nCurPos)
					oUploadFile.contentType = right(auxStr, len(auxStr)-inStrRev(auxStr, " "))
					nCurPos	= findToken(tNewLine, nCurPos)+4
					oUploadFile.start		= nCurPos+1
					oUploadFile.length	= findToken(vDataSep, nCurPos)-2-nCurPos
					
					if oUploadFile.length > 0 then
						uploadedFiles.add lCase(sFieldName), oUploadFile
					end if
					
				end if
			else
				
				dim nEndOfData, fieldValueuniStr
				nCurPos			= findToken(tNewLine, nCurPos)+4
				nEndOfData	= findToken(vDataSep, nCurPos)-2
				fieldValueuniStr	= convertUtf8BytesToStr(nCurPos, nEndOfData-nCurPos)
				if not formElements.exists(lCase(sFieldName)) then
					formElements.add lCase(sFieldName), fieldValueuniStr
				else
					formElements.item(lCase(sFieldName))	= formElements.item(lCase(sFieldName)) & ", " & fieldValueuniStr
				end if
				
			end if
			
			nDataBoundPos	= findToken(vDataSep, nCurPos)
			
		loop
		
	end sub
	
	private function skipToken(sToken, nStart)
		skipToken = inStrB(nStart, varArrayBinRequest, sToken)
		if skipToken = 0 then
			response.write	"Error!"
			response.end
		end if
		skipToken	= skipToken+lenB(sToken)
	end function
	
	private function findToken(sToken, nStart)
		findToken = inStrB(nStart, varArrayBinRequest, sToken)
	end function
	
end class
%>

<%
Class FreeASPUpload

	Private Function SkipToken(sToken, nStart)
		SkipToken = InstrB(nStart, VarArrayBinRequest, sToken)
		If SkipToken = 0 then
			Response.write "Error in parsing uploaded binary request. The most likely cause for this error is the incorrect setup of AspMaxRequestEntityAllowed in IIS MetaBase. Please see instructions in the <A HREF='http://www.freeaspupload.net/freeaspupload/requirements.asp'>requirements page of freeaspupload.net</A>.<p>"
			Response.End
		end if
		SkipToken = SkipToken + LenB(sToken)
	End Function

	Private Function FindToken(sToken, nStart)
		FindToken = InstrB(nStart, VarArrayBinRequest, sToken)
	End Function

	Private Function ExtractField(sToken, nStart)
		Dim nEnd
		nEnd = InstrB(nStart, VarArrayBinRequest, sToken)
		If nEnd = 0 then
			Response.write "Error in parsing uploaded binary request."
			Response.End
		end if
		ExtractField = ConvertUtf8BytesToString(nStart, nEnd-nStart)
	End Function

	'String to byte string conversion
	Private Function String2Byte(sString)
		Dim i
		For i = 1 to Len(sString)
		   String2Byte = String2Byte & ChrB(AscB(Mid(sString,i,1)))
		Next
	End Function

	Private Function ConvertUtf8BytesToString(start, length)	
		StreamRequest.Position = 0

	    Dim objStream
	    Dim strTmp

	    ' init stream
	    Set objStream = Server.CreateObject("ADODB.Stream")
	    objStream.Charset = "windows-1252"
	    objStream.Mode = 3
	    objStream.Type = 1
	    objStream.Open

	    ' write bytes into stream
	    StreamRequest.Position = start+1
	    StreamRequest.CopyTo objStream, length
	    objStream.Flush

	    ' rewind stream and read text
	    objStream.Position = 0
	    objStream.Type = 2
	    strTmp = objStream.ReadText

	    ' close up and return
	    objStream.Close
	    Set objStream = Nothing
	    ConvertUtf8BytesToString = strTmp	
	End Function
End Class

Class UploadedFile
	Public ContentType
	Public Start
	Public Length
	Public Path
	Private nameOfFile

    ' Need to remove characters that are valid in UNIX, but not in Windows
    Public Property Let FileName(fN)
        nameOfFile = fN
        nameOfFile = SubstNoReg(nameOfFile, "\", "_")
        nameOfFile = SubstNoReg(nameOfFile, "/", "_")
        nameOfFile = SubstNoReg(nameOfFile, ":", "_")
        nameOfFile = SubstNoReg(nameOfFile, "*", "_")
        nameOfFile = SubstNoReg(nameOfFile, "?", "_")
        nameOfFile = SubstNoReg(nameOfFile, """", "_")
        nameOfFile = SubstNoReg(nameOfFile, "<", "_")
        nameOfFile = SubstNoReg(nameOfFile, ">", "_")
        nameOfFile = SubstNoReg(nameOfFile, "|", "_")
    End Property

    Public Property Get FileName()
        FileName = nameOfFile
    End Property

    'Public Property Get FileN()ame
End Class


' Does not depend on RegEx, which is not available on older VBScript
' Is not recursive, which means it will not run out of stack space
Function SubstNoReg(initialStr, oldStr, newStr)
    Dim currentPos, oldStrPos, skip
    If IsNull(initialStr) Or Len(initialStr) = 0 Then
        SubstNoReg = ""
    ElseIf IsNull(oldStr) Or Len(oldStr) = 0 Then
        SubstNoReg = initialStr
    Else
        If IsNull(newStr) Then newStr = ""
        currentPos = 1
        oldStrPos = 0
        SubstNoReg = ""
        skip = Len(oldStr)
        Do While currentPos <= Len(initialStr)
            oldStrPos = InStr(currentPos, initialStr, oldStr)
            If oldStrPos = 0 Then
                SubstNoReg = SubstNoReg & Mid(initialStr, currentPos, Len(initialStr) - currentPos + 1)
                currentPos = Len(initialStr) + 1
            Else
                SubstNoReg = SubstNoReg & Mid(initialStr, currentPos, oldStrPos - currentPos) & newStr
                currentPos = oldStrPos + skip
            End If
        Loop
    End If
End Function

Function GetFileName(strSaveToPath, FileName)
'This function is used when saving a file to check there is not already a file with the same name so that you don't overwrite it.
'It adds numbers to the filename e.g. file.gif becomes file1.gif becomes file2.gif and so on.
'It keeps going until it returns a filename that does not exist.
'You could just create a filename from the ID field but that means writing the record - and it still might exist!
'N.B. Requires strSaveToPath variable to be available - and containing the path to save to
    Dim Counter
    Dim Flag
    Dim strTempFileName
    Dim FileExt
    Dim NewFullPath
    dim objFSO, p
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    Counter = 0
    p = instrrev(FileName, ".")
    FileExt = mid(FileName, p+1)
    strTempFileName = left(FileName, p-1)
    NewFullPath = strSaveToPath & "\" & FileName
    Flag = False
    
    Do Until Flag = True
        If objFSO.FileExists(NewFullPath) = False Then
            Flag = True
            GetFileName = Mid(NewFullPath, InstrRev(NewFullPath, "\") + 1)
        Else
            Counter = Counter + 1
            NewFullPath = strSaveToPath & "\" & strTempFileName & Counter & "." & FileExt
        End If
    Loop
End Function 
 
%>