<%
dim retn

'#	================================================================================================
'#	
'#	------------------------------------------------------------------------------------------------
'	adBigint		: 20
'	adChar			: 129
'	adDate			: 7
'	adInteger		: 3
'	adTinyint		: 16
'	adVarBinary	: 204
'	adVarChar		: 200
'#	================================================================================================
sub subProcExec(strProc, arrParam)
	
	dim arrTempParams(2), tempLoop
	
	select case strProc
		
		case "nusp_procAddr"
			arrTempParams(0)	= array("proc",	"addrIndx",	"addrGubn",	"addrSync",	"addrSort",	"addrName",	"addrNum1",	"addrNum2",	"addrNum3",	"addrMemo",	"grupIndx",	"addrCode",	"userIndx",	"userIP")
			arrTempParams(1)	= array(129,		3,					129,				200,				3,					200,				200,				200,				200,				200,				200,				200,				3,					200)
			arrTempParams(2)	= array(1,			0,					1,					50,					0,					50,					255,				255,				255,				1000,				4000,				4000,				0,					20)
			
		case "nusp_procGrup"
			arrTempParams(0)	= array("proc",	"grupGubn",	"grupUper",	"grupIndx",	"grupSort",	"grupName",	"grupIndxRel", "arrCodes",	"userIndx",	"userIP")
			arrTempParams(1)	= array(129,		129,				3,					3,					3,					200,				200,						200,				3,					200)
			arrTempParams(2)	= array(1,			1,					0,					0,					0,					50,					4000,						4000,				0,					20)
		
		case "nusp_procAddrCode"
			arrTempParams(0)	= array("proc",	"addrCode",	"addrCodeUper",	"addrCodeGubn",	"addrCodeName",	"addrCodeSort",	"userIndx",	"userIP")
			arrTempParams(1)	= array(129,		3,					3,							129,						200,						3,							3,					200)
			arrTempParams(2)	= array(1,			0,					0,							1,							50,							0,							0,					20)
			
		case "nusp_procScdl"
			arrTempParams(0)	= array("proc",	"scdlIndx",	"scdlGubn",	"scdlType",	"scdlValu",	"scdlSDT",	"scdlEDT",	"scdlMethod",	"scdlMedia1",	"scdlMedia2",	"scdlMedia3",_
				"scdlTry1",	"scdlTry2",	"scdlTry3",	"scdlSMSGB",	"scdlVMSGB",	"scdlTit",	"scdlSMSMsg",	"scdlVMSMsg",	"scdlSMSMsgAdd",	"scdlVMSMsgAdd",	"scdlVMSPlay",_
				"scdlARSAnswYN",	"scdlARSAnswTime",	"scdlAnswDTMF",	"scdlSndNum1",	"scdlSndNum2",	"scldAddVMSMsgText",	"scdlStat",	"grupIndx",	"userIndx",	"userIP")
			arrTempParams(1)	= array(129,		3,					129,				129,				3,					7,					7,					16,						16,						16,						16,_
				16,					16,					16,					129,					129,					200,				200,					200,					129,							129,							16,_
				129,							3,									129,						200,						200,						200,									16,					200,				3,					200)
			arrTempParams(2)	= array(1,			0,					1,					1,					0,					20,					20,					0,						0,						0,						0,_
				0,					0,					0,					1,						1,						100,				2000,					4000,					1,								1,								0,_
				1,								0,									1,							20,							20,							100,									0,					4000,					0,				20)
			
	end select
	
	set cmd = server.createobject("adodb.command")  
	with cmd

		.activeconnection = strDBConn
		.commandtext = strProc
		.commandtype = adCmdStoredProc
		
		'response.write	"declare @retn int" & vbCrLf
		'response.write	"exec " & strProc & " "
		
		for tempLoop = 0 to ubound(arrTempParams(0))
			.parameters.append .createParameter("@" & arrTempParams(0)(tempLoop),	arrTempParams(1)(tempLoop),	adParamInput,	arrTempParams(2)(tempLoop))
			.parameters("@" & arrTempParams(0)(tempLoop))			= arrParam(tempLoop)
			'response.write	"'" & arrParam(tempLoop) & "', "
		next
		
		.parameters.append .createParameter("@retn", adInteger, adParamOutput, 0)
		.parameters("@retn")			= 0
		
		'response.write	"@retn output" & vbCrLf
		'response.write	"select @retn"
		
		.execute
		
		retn	= .parameters("@retn")
		
	end with
	set cmd = nothing
	
end sub

sub dbSubProcExec(strProc, arrParam)
	'SetEucKR()
	dim arrTempParams(2), tempLoop, strParam
	
	strParam = ""
	for i = 0 to ubound(arrParam)
		if i > 0 then
			strParam = strParam & ", "
		end if
		strParam = strParam & "[" & arrParam(i) & "]"
	next

	select case strProc
		case "nusp_procAddr"
			arrTempParams(0)	= array("proc",	"addrIndx",	"addrGubn",	"addrSync",	"addrSort",	"addrName",	"addrNum1",	"addrNum2",	"addrNum3",	"addrMemo",	"grupIndx",	"addrCode",	"userIndx",	"userIP")
			arrTempParams(1)	= array(129,	3,			129,		200,		3,			200,		200,		200,		200,		200,		200,		200,		3,			200)
			arrTempParams(2)	= array(1,		0,			1,			50,			0,			50,			255,		255,		255,		1000,		4000,		4000,		0,			20)
		case "nusp_procGrup"
			arrTempParams(0)	= array("proc",	"grupGubn",	"grupUper",	"grupIndx",	"grupSort",	"grupName",	"grupIndxRel", "arrCodes",	"userIndx",	"userIP")
			arrTempParams(1)	= array(129,	129,		3,			3,			3,			200,		200,			200,		3,			200)
			arrTempParams(2)	= array(1,		1,			0,			0,			0,			50,			4000,			4000,		0,			20)
		case "nusp_procAddrCode"
			arrTempParams(0)	= array("proc",	"addrCode",	"addrCodeUper",	"addrCodeGubn",	"addrCodeName",	"addrCodeSort",	"userIndx",	"userIP")
			arrTempParams(1)	= array(129,	3,			3,				129,			200,			3,				3,			200)
			arrTempParams(2)	= array(1,		0,			0,				1,				50,				0,				0,			20)
		case "nusp_procScdl"
			arrTempParams(0)	= array("proc",	"scdlIndx",	"scdlGubn",	"scdlType",	"scdlValu",	"scdlSDT",	"scdlEDT",	"scdlMethod",	"scdlMedia1",	"scdlMedia2",	"scdlMedia3",	"scdlTry1",	"scdlTry2",	"scdlTry3",	"scdlSMSGB",	"scdlVMSGB",	"scdlTit",	"scdlSMSMsg",	"scdlVMSMsg",	"scdlSMSMsgAdd",	"scdlVMSMsgAdd",	"scdlVMSPlay",	"scdlARSAnswYN",	"scdlARSAnswTime",	"scdlAnswDTMF",	"scdlSndNum1",	"scdlSndNum2",	"scldAddVMSMsgText",	"scdlStat",	"grupIndx",	"userIndx",	"userIP")
			arrTempParams(1)	= array(129,	3,			129,		129,		3,			7,			7,			16,				16,				16,				16,				16,			16,			16,			129,			129,			200,		200,			200,			129,				129,				16,				129,				3,					129,			200,			200,			200,					16,			200,		3,			200)
			arrTempParams(2)	= array(1,		0,			1,			1,			0,			20,			20,			0,				0,				0,				0,				0,			0,			0,			1,				1,				100,		2000,			4000,			1,					1,					0,				1,					0,					1,				20,				20,				100,					0,			4000,		0,			20)
	end select

	set cmd = server.createobject("adodb.command")  
	with cmd
		.activeconnection = dbConn
		.commandtext = strProc
		.commandtype = adCmdStoredProc
		strParam = ""
		for tempLoop = 0 to ubound(arrTempParams(0))
			.parameters.append .createParameter("@" & arrTempParams(0)(tempLoop), _
				arrTempParams(1)(tempLoop), adParamInput, arrTempParams(2)(tempLoop))
			.parameters("@" & arrTempParams(0)(tempLoop)) = arrParam(tempLoop)
			
			if tempLoop > 0 then
				strParam = strParam & ", "
			end if
			strParam = strParam & "[[" & arrTempParams(0)(tempLoop) & "], " 
			strParam = strParam & arrTempParams(1)(tempLoop) & ", " 
			strParam = strParam & arrTempParams(2)(tempLoop) & ", " 
			strParam = strParam & "[" & arrParam(tempLoop) & "]]"
		next
		.parameters.append .createParameter("@retn", adInteger, adParamOutput, 0)
		.parameters("@retn")			= 0
		.execute
		retn = .parameters("@retn")
		call subWebLog("INFO. dbSubProcExec([" & strProc & "], [" & strParam & "]) - [" & retn & "]")
	end with
	set cmd = nothing
	
end sub
%>