Dim sInstallDriverName
Dim sPathToInf

sInstallDriverName = "Xerox GPD PS V3.6.433.6.0.0"

Dim sOsVersion
Dim sArchitecture
Dim sPrintUI
Dim sCurrentDir

Dim sQueueName
Dim sComment
Dim sIP
Dim strPrinterUri

sQueueName = "FollowMe"
sComment = "Xerox"
sPortIp = "127.0.0.1"
sPortName = "Secure"

Set stdout = CreateObject ("Scripting.FileSystemObject").GetStandardStream (1)
sCurrentDir = CreateObject("Scripting.FileSystemObject").GetAbsolutePathName(".")

sOsVersion = GetOsVersionName
sArchitecture = GetSystemArchitecture
sPrintUI = GetPrintUiType

sPathToInf= sCurrentDir & "\sources\" & sArchitecture & "\" & "x2UNIVP.inf"

Log "Current dir is: " & sCurrentDir
Log "System version: " & sOsVersion
Log "System architecture: " & sArchitecture
Log "Using: " & sPrintUI & " to manage print server."


If IsDriverInstalled(sInstallDriverName) Then
	Log "Driver already installed."
Else
	Log "Driver is not installed."
	InstallPrinterDriver sPathToInf, sInstallDriverName
	Log "Installation DONE."
End If


Log "Restarting spooler"
RestartSpooler
Log "Restarting spooler DONE."


Log "Checking Queue"
If IsQueueInstalled(sQueueName) Then
	Log "Queue is already installed"
Else
	Log "Creating Port"
	AddTcpPort sPortName, sPOrtIp
	Log "Creating Queue"
	InstallQueue sQueueName, sPortName, sInstallDriverName, true
	Log "Creating Queue DONE"
End If

Log "Resotring queue settings"
Dim sSettingsFile
sSettingsFile = sCurrentDir & "\sources\xerox.dat"
RestoreQueueSettings sSettingsFile, sQueueName
Log "Resotring queue settings DONE"

'Log "Setting default printer " + sQueueName
SetDefaultPrinter sQueueName
'Log "Setting default printer DONE"




'
'END OF SCTIPT
'

Sub InstallIppPrinter(strPrinterName, strUrl, strDriverName)
'printui.exe /b "FollowMe" /x /n "part of the n switch" /if /f %windir%\inf\ntprint.inf /r "https://eq5-train-01.im.pl/Printers/FollowMe/.printer" /m "Xerox PullPrn PCL6 V3.5.404.8.0"
	Dim sCommand
	sCommand = sPrintUi & " /b """ & strPrinterName & """ /x /n """ & strPrinterName & """ /if /f %windir%\inf\ntprint.inf /r """ & strUrl & """ /m """ & strDriverName & """ /q"
	Log sCommand
	RunCmdCommand sCommand, 0, True
End Sub



Sub SetPrinterPooling
	Dim sDeviceID
	Dim sPort1
	Dim sPort2
	sDeviceID = Xerox
	sPort1 = OD1
	sPort2 = OD2
	
	strComputer = "."

	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")

	Set colPrinters = objWMIService.ExecQuery _
		("Select * From Win32_Printer Where DeviceID='Xerox'")

	For Each objPrinter in colPrinters
    objPrinter.PortName = "OD1,OD2"
    objPrinter.Put_
	Next
End Sub


Sub SetDefaultPrinter(strQName)
	Dim sCommand
	sCommand = sPrintUi & " /n """ & strQName & """ /y /q"
	RunCmdCommand sCommand, 0, True
	
End Sub


''-----------------------------------------
'Restore queue settings
Sub RestoreQueueSettings(strSettingsFile, strQueueName)
	Dim sCommand
	sCommand = sPrintUi & " /Sr /n """ &  strQueueName & """ /a """ & strSettingsFile &  """ /q 7 d g u r p"
	RunCmdCommand sCommand, 0, True
End Sub


''-----------------------------------------
'Install SafeQClient from provided path
Sub InstallSafeQClient(strInstallFile, bEnterprise)
	Dim strSqInstallCommand
	
	If (bEnterprise) Then
		strSqInstallCommand = strInstallFile & " -a"
	Else
		strSqInstallCommand = strInstallFile
	End If
	Log "running command " & strSqInstallCommand
	RunCmdCommand strSqInstallCommand, 0, True
End Sub


''-----------------------------------------
'UnInstall SafeQClient from provided path
Sub UnInstallSafeQClient(strInstallFile, bEnterprise)
	Dim strSqInstallCommand
	
	If (bEnterprise) Then
		strSqInstallCommand = strInstallFile & " -u -a"
	Else
		strSqInstallCommand = strInstallFile & " -u"
	End If
	
	RunCmdCommand strSqInstallCommand, 0, True
End Sub


''-----------------------------------------
'GetInstalledDrivers sub
'Displays installed drivers in log
Sub GetInstalledDrivers	
	Dim Drivers
	Drivers = GetLocalDrivers()
	For Each Driver in Drivers
		Log Driver
	Next
End Sub


'
''-----------------------------------------
'GetPrintUiType sub
'
Function IsDriverInstalled(strDriverName)
	Dim bResult
	bResult = False
	Dim aDrivers
	aDrivers = GetLocalDrivers()
	For Each Driver In aDrivers
		If (StrComp(Driver, strDriverName, vbTextCompare) = 0) Then
			bResult = True
			Exit For
		End If
	Next
	IsDriverInstalled = bResult
End Function


'Install driver
'%pui% /ia /f "%target%%folder%\%bits%\%infFile%" /m %driverModel%
Sub InstallPrinterDriver(sInfFilePath, sModel)
	Dim sCommand
	sCommand = sPrintUi & " /ia /f """ &  sInfFilePath & """ /m """ & sModel &  """ /q"
	Log "Installing driver " & sModel & " from file " & sInfFilePath
	RunCmdCommand sCommand, 0, True
End Sub

'Uninstall driver
'%pui% /dd /m %model%
Sub UnInstallPrinterDriver(sModel)
	Dim sCommand
	sCommand = sPrintUi & " /dd /m """ &  sModel & """ /q"
	Log "UnInstalling driver " & sModel
	RunCmdCommand sCommand, 0, True
End Sub


''-----------------------------------------
'GetPrintUiType sub
'
Function GetPrintUiType
	Dim sPrnUi
	If InStr(sOsVersion, "Windows 7") <> 0 Or InStr(sOsVersion, "Windows Vista") <> 0 Or InStr(sOsVersion, "Windows 8") <> 0 Or InStr(sOsVersion, "Windows 10") <> 0 Then
		sPrnUi = "printui.exe "
	Else
		sPrnUi = "rundll32.exe printui.dll,PrintUIEntry "
	End If
	GetPrintUiType = sPrnUi
End Function

'
''-----------------------------------------
'GetPrintUiType sub
'
'
'

Function GetSystemArchitecture
	Dim intArchitecture 
	intArchitecture = GetObject("winmgmts:root\cimv2:Win32_Processor='cpu0'").AddressWidth
	GetSystemArchitecture = intArchitecture
End Function

''-----------------------------------------
'GetPrintUiType sub
'
Function GetOsVersionName
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:" _
	& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	 
	Set colOperatingSystems = objWMIService.ExecQuery _
	("Select * from Win32_OperatingSystem")
	
	Dim os
	For Each objOperatingSystem in colOperatingSystems
		os = objOperatingSystem.Caption
	Next
	GetOsVersionName = os
End Function

Function GetLocalDrivers
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:" _
		& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	Set colInstalledPrinters =  objWMIService.ExecQuery _
		("Select * from Win32_PrinterDriver")
	
	Dim arrDriversNames()
	Dim j
	j = 0
	
	For each objPrinter in colInstalledPrinters
		Dim arrTokens
		
		arrTokens = split(objPrinter.Name, ",")
		ReDim Preserve  arrDriversNames(j)
		arrDriversNames(j) = arrTokens(0)	
		'name contains drivername,type, architecture
		j = j + 1
	Next
	GetLocalDrivers = arrDriversNames
End Function


Function GetLocalQueues
	Set WshNetwork = CreateObject("WScript.Network") 
	Set objPrinter = WshNetwork.EnumPrinterConnections
	
	Dim arrQueueNames()
	Dim j
	j = 0

	If objPrinter.Count = 0 Then
		Log "No Printers Mapped "
		ReDim Preserve arrQueueNames(j)
		arrQueueNames(j) = "--no printers--"
	else
		For intDrive = 0 To (objPrinter.Count -1) Step 2
			ReDim Preserve arrQueueNames(j)
			arrQueueNames(j) = objPrinter.Item(intDrive + 1)
			j = j + 1
			'printer = "UNC Path " & objPrinter.Item(intDrive) & " = " & objPrinter.Item(intDrive +1) & " Printer : " & intDrive
		Next
	end if
	GetLocalQueues = arrQueueNames
End Function

Function IsQueueInstalled(strQueueName)
	Dim bResult
	bResult = False
	Dim aQueues
	aQueues = GetLocalQueues()
	For Each queue In aQueues
		If (StrComp(queue, strQueueName, vbTextCompare) = 0) Then
			bResult = True
			Exit For
		End If
	Next
	IsQueueInstalled = bResult
End Function 


Sub InstallQueue(sQueue, sPort, sDriver, bDriverInstalled)
	
	Dim sDriverFile
	If bDriverInstalled = True Then
		sDriverFile = "%windir%\inf\ntprint.inf"
	Else
		sDriverFile = sPathToInf
	End If
	
	Dim command
	command = sPrintUi & " /if /b """ &  sQueue & """ /f """ & sDriverFile & """ /r """ & sPort & """ /m """ & sDriver & """ /q"
	
	'if windows xp required to use /u switch to use installed driver
	If InStr(sOsVersion, "Windows XP") <> 0 Then
		Log "Windows XP detected, using switch u"
		command = command & " /u"
	End If
	
	Log "Installing queue: " & sQueue
	RunCmdCommand command, 1, True
	'SetAPFOff sQueue
End Sub

Sub UnInstallQueue(sQueueName)
	Dim sRemoveQueueCommand
	sRemoveQueueCommand = sPrintUi & " /dl /n """ &  sQueueName & """ /q"
	RunCmdCommand sRemoveQueueCommand, 1, True
End Sub

Sub RunCmdCommand(strCommand, iWindow, bSync)
	Set objShell = CreateObject("Wscript.Shell")
	objShell.Run strCommand, iWindow, bSync
End Sub

Sub RestartSpooler
	RunCmdCommand "cmd /c net stop Spooler > nul", 0, True
	RunCmdCommand "cmd /c net start Spooler > nul", 0, True
End Sub

Sub DispalyPrinterDetail
	For Each row In aPrinters
		If row.Name = sQueue.Value Then
			iTextQueue.Value = row.Name
			iTextPort.Value = row.Port
			itextDriver.Value = row.Driver
			Exit For 
		End If
	Next
End Sub

Sub CopyXmlToProgramFiles
	sXmlConfFileFolder = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%PROGRAMFILES%") & "\Xerox\Common\"
	Dim strFile
	strFile = sCurrentDir & "\sources\CommonConfiguration.xml"
	
	Dim sXmlConfFile
	sXmlConfFile = sXmlConfFileFolder & "CommonConfiguration.xml"
	Log "XML Configuration path: " & sXmlConfFileFolder
	
	Dim oFSO
	Set oFSO = CreateObject("Scripting.FileSystemObject")

	If Not oFSO.FolderExists(sXmlConfFileFolder) Then
	  'oFSO.CreateFolder sXmlConfFileFolder
	  BuildFullPath sXmlConfFileFolder
	  Log "Creating folder for XML."
	End If
	
	If Not oFSO.FileExists(sXmlConfFile) Then
		oFSO.CopyFile strFile, sXmlConfFileFolder, Overwrite
		Log "Copying XML file."
	Else
		Log "XML Configuration already present."
	End If
End Sub

Sub BuildFullPath(ByVal FullPath)
	Set fso = CreateObject("Scripting.FileSystemObject")
	If Not fso.FolderExists(FullPath) Then
		BuildFullPath fso.GetParentFolderName(FullPath)
		fso.CreateFolder FullPath
	End If
End Sub

Sub CreateRegistryForXml
	Dim Return
	const HKEY_LOCAL_MACHINE = &H80000002
	strComputer = "."
	 
	Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
	strKey = "SOFTWARE\Xerox\PrinterDriver\V5.0\Configuration\"
	oReg.CreateKey HKEY_LOCAL_MACHINE, strKey

	oReg.SetStringValue HKEY_LOCAL_MACHINE,strKey,"RepositoryUNCPath",sXmlConfFileFolder
	oReg.SetDWORDValue HKEY_LOCAL_MACHINE,strKey,"CacheExpirationInMinutes",1
	
End Sub

Sub ManageXml
	CopyXmlToProgramFiles()
	Log "Done copying."
	CreateRegistryForXml()
	Log "Done adding registry."
End Sub

Sub Log(sMessage)
	stdout.WriteLine sMessage
End Sub

Sub SetAPFOff(strPrinter)
	const HKEY_LOCAL_MACHINE = &H80000002
	strComputer = "."
	 
	Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
	 
	strKeyPath = "SYSTEM\CurrentControlSet\Control\Print\Printers\" & strPrinter
	strValueName = "Attributes"
	dwValue = &H00001201
	oReg.SetDWORDValue HKEY_LOCAL_MACHINE,strKeyPath,strValueName,dwValue
	oReg = Nothing
End Sub



Sub AddPrinterPort(strPortName, strIp)
	const HKEY_LOCAL_MACHINE = &H80000002
	strComputer = "."
	 
	Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
	strKey = "SYSTEM\CurrentControlSet\Control\Print\Monitors\Standard TCP/IP Port\Ports\" & strPortName
	
	oReg.CreateKey HKEY_LOCAL_MACHINE,strKey
	oReg.SetStringValue HKEY_LOCAL_MACHINE,strKey,"HostName",""
	oReg.SetStringValue HKEY_LOCAL_MACHINE,strKey,"IPAddress",strIp
	oReg.SetStringValue HKEY_LOCAL_MACHINE,strKey,"HWAddress",""
	oReg.SetStringValue HKEY_LOCAL_MACHINE,strKey,"SNMP Community","public"
	oReg.SetStringValue HKEY_LOCAL_MACHINE,strKey,"Queue","lp"
	oReg.SetDWORDValue HKEY_LOCAL_MACHINE,strKey,"Protocol",2
	oReg.SetDWORDValue HKEY_LOCAL_MACHINE,strKey,"Version",1
	oReg.SetDWORDValue HKEY_LOCAL_MACHINE,strKey,"PortNumber",515
	oReg.SetDWORDValue HKEY_LOCAL_MACHINE,strKey,"SNMP Enabled",0
	oReg.SetDWORDValue HKEY_LOCAL_MACHINE,strKey,"SNMP Index",1
	oReg.SetDWORDValue HKEY_LOCAL_MACHINE,strKey,"Double Spool",0
End Sub

Sub CreatePort
	AddPrinterPort "Test_port", "192.168.1.1"
End Sub

Sub AddTcpPort(sPortName, sIp)
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:" _
		& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	Set objNewPort = objWMIService.Get _
		("Win32_TCPIPPrinterPort").SpawnInstance_

	objNewPort.Name = sPortName
	objNewPort.Protocol = 2
	objNewPort.HostAddress = sIp
	objNewPort.PortNumber = "515"
	objNewPort.SNMPEnabled = False
	objNewPort.Queue = "lp"
	objNewPort.ByteCount = False
	objNewPort.Put_
End Sub


Sub SetPrinterComment(p_sQueueName, sComment)
	Dim command
	command = sPrintUi & "/Xs /n " & p_sQueueName & " comment " & """" & sComment  & """"
	Log "Seting comment " & sComment & " for printer " & p_sQueueName
	RunCmdCommand command, 0, True
End Sub