' mapdrive.vbs
' VBScript to map a network drive.
' Authors Jakub Sarosiek
' Version 1.1 - September 2016
' ----------------------------------------'
'
Option Explicit
Dim objNetwork, strDrive, objShell, objUNC
Dim strRemotePath, strDriveLetter, strNewName, strUser, strPassword, strProfile
'
strDriveLetter = "W:"
strRemotePath = "\\192.168.0.4\Tank"
strNewName = "Dysk Sieciowy"
strUser = "jsarosiek"
strPassword = "****"
strProfile = "false"

' Section to map the network drive
Set objNetwork = CreateObject("WScript.Network")
objNetwork.MapNetworkDrive strDriveLetter, strRemotePath, strProfile, strUser, strPassword

' Section which actually (re)names the Mapped Drive
Set objShell = CreateObject("Shell.Application")
objShell.NameSpace(strDriveLetter).Self.Name = strNewName


' End of Example VBScript.