"=========================================================================================" | Out-File log.txt -Append
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
"$(Get-Date) ==>> Logging started: " | Out-File log.txt -Append
$portName = "SafeQE001"
"$(Get-Date) ==>> PortName set to ""$portName""" | Out-File log.txt -Append
$printDriverName = "Xerox GPD PCL V5.617.7.0"
"$(Get-Date) ==>> DriverName set to ""$printDriverName""" | Out-File log.txt -Append
$queueName = "Xerox Wydruk Poufny"
"$(Get-Date) ==>> QueueName set to ""$queueName""" | Out-File log.txt -Append
$settingsfile = "$scriptPath\xerox.dat"
"$(Get-Date) ==>> Queue settings set to file: ""$settingsFile""" | Out-File log.txt -Append

$safeqPort = "$scriptPath\sq_port\Install.exe"
$safeqPortarg = "-a"
$safeqPortuninstall = "-u"
"$(Get-Date) ==>> SafeQ Port file location: ""$safeqPort""" | Out-File log.txt -Append


$printDriverExists = Get-PrinterDriver -name $printDriverName -ErrorAction SilentlyContinue
if (-not $printDriverExists) {
    "$(Get-Date) ==>> Printer Driver Not Exist" | Out-File log.txt -Append
    "$(Get-Date) ==>> Adding Drivers to DriverStore" | Out-File log.txt -Append
	   Get-ChildItem $scriptPath -Recurse -Filter "*.inf" | ForEach-Object { PNPUtil.exe /add-driver $_.FullName /install } | Out-Null
	   "$(Get-Date) ==>> Drivers added to DriverStore" | Out-File log.txt -Append
	   "$(Get-Date) ==>> Installing Printer Driver" | Out-File log.txt -Append
    Add-PrinterDriver -Name $printDriverName
    "$(Get-Date) ==>> Printer Driver installed succesfully" | Out-File log.txt -Append
}
else {
    "$(Get-Date) ==>> Printer Driver Exist, we are going a step further" | Out-File log.txt -Append
}
$portExists = Get-Printerport -Name $portname -ErrorAction SilentlyContinue
if (-not $portExists) {
    "$(Get-Date) ==>> Printer Port Not Exist" | Out-File log.txt -Append
    "$(Get-Date) ==>> Adding Printer Port..." | Out-File log.txt -Append
    & $safeqPort $safeqPortarg
    "$(Get-Date) ==>> Printer Port added succesfully" | Out-File log.txt -Append
}
else {
    $printerUsedByPort = Get-Printer | Where-Object { $_.PortName -eq $portName }
    "$(Get-Date) ==>> Printer Port Exist. Used by $($printerUsedByPort.name -join ', ')" | Out-File log.txt -Append
    "$(Get-Date) ==>> Removing Queues: $($printerUsedByPort.name -join ', ')" | Out-File log.txt -Append
    Remove-Printer -Name $($printerUsedByPort).name
    "$(Get-Date) ==>> Queues: $($printerUsedByPort.name -join ', ') removed" | Out-File log.txt -Append
    "$(Get-Date) ==>> Removing Existing Port" | Out-File log.txt -Append
    & $safeqPort $safeqPortuninstall
    "$(Get-Date) ==>> Existing Port Removed" | Out-File log.txt -Append
    & $safeqPort $safeqPortarg
    "$(Get-Date) ==>> New Printer Port added succesfully" | Out-File log.txt -Append
}
$queueExists = Get-Printer -Name $queueName -ErrorAction SilentlyContinue
if (-not $queueExists) {
    "$(Get-Date) ==>> Printer Queue Not Exist" | Out-File log.txt -Append
    "$(Get-Date) ==>> Adding Printer Queue" | Out-File log.txt -Append
    Add-Printer -Name $queueName -PortName $portName -DriverName $printDriverName
    "$(Get-Date) ==>> Printer Queue added succesfully" | Out-File log.txt -Append
}
else {
    "$(Get-Date) ==>> Printer Queue Exist" | Out-File log.txt -Append
    "$(Get-Date) ==>> Removing existing Printer Queue" | Out-File log.txt -Append
    Remove-Printer -Name $queueName
    "$(Get-Date) ==>> Existing Printer Queue removed" | Out-File log.txt -Append
    "$(Get-Date) ==>> Adding New Printer Queue" | Out-File log.txt -Append
    Add-Printer -Name $queueName -PortName $portName -DriverName $printDriverName
    "$(Get-Date) ==>> New Printer Queue added succesfully" | Out-File log.txt -Append
}

"$(Get-Date) ==>> Checking status of LegacyDefaultPrinterMode" | Out-File log.txt -Append
$value = (Get-ItemProperty -Path "hkcu:\Software\Microsoft\Windows NT\CurrentVersion\Windows").LegacyDefaultPrinterMode
If ($value -ne 1) {
    "$(Get-Date) ==>> LegacyDefaultPrinterMode is OFF, turning it ON" | Out-File log.txt -Append
    Set-ItemProperty -Path "hkcu:\Software\Microsoft\Windows NT\CurrentVersion\Windows" -Name "LegacyDefaultPrinterMode" -Value 1
    "$(Get-Date) ==>> LegacyDefaultPrinterMode is turned ON" | Out-File log.txt -Append 
}
else {
    "$(Get-Date) ==>> LegacyDefaultPrinterMode is ON, we are going a step further" | Out-File log.txt -Append
}

"$(Get-Date) ==>> Get the specified printer info." | Out-File log.txt -Append 
$Printer = Get-WmiObject Win32_Printer -Filter "Name = '$queueName'" -ErrorAction SilentlyContinue
If ($Printer) { 
    "$(Get-Date) ==>> Setting the default printer." | Out-File log.txt -Append 
    $Printer.SetDefaultPrinter() | Out-Null
    "$(Get-Date) ==>> Successfully set the default printer." | Out-File log.txt -Append 
} 
Else { 
    "$(Get-Date) ==>> Cannot find the specified printer, something went wrong" | Out-File log.txt -Append 
}

"$(Get-Date) ==>> Restoring Printer Settings from file" | Out-File log.txt -Append
printui.exe /Sr /n $queueName /a $settingsfile  /q 7 d g u r p
"$(Get-Date) ==>> Printer Settings restored from file succesfully" | Out-File log.txt -Append


"$(Get-Date) ==>> Installation succesfully" | Out-File log.txt -Append
"$(Get-Date) ==>> Log Ended" | Out-File log.txt -Append