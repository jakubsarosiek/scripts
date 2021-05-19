#Replace PRINTSERVER with name of the Print Server
$PrintServer = "\\srvname"

$Printers = Get-WmiObject -Class Win32_Printer

ForEach ($Printer in $Printers){
If ($Printer.SystemName -like "$PrintServer"){
(New-Oject -ComObject WScript.Network).RemovePrinterConnection($($Printer.Name))
}
}
