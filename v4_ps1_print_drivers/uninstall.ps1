"=========================================================================================" | Out-File log.txt -Append
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
"$(Get-Date) ==>> Logging started: " | Out-File log.txt -Append
$portName = "SafeQE001"
"$(Get-Date) ==>> PortName set to ""$portName""" | Out-File log.txt -Append
$printDriverName = "Xerox GPD PCL V5.617.7.0"
"$(Get-Date) ==>> DriverName set to ""$printDriverName""" | Out-File log.txt -Append
$queueName = "Xerox Wydruk Poufny"
"$(Get-Date) ==>> QueueName set to ""$queueName""" | Out-File log.txt -Append
$safeqPort = "$scriptPath\sq_port\Install.exe"
"$(Get-Date) ==>> SafeQ Port file location: ""$safeqPort""" | Out-File log.txt -Append
$safeqPortuninstall = "-u"

$queueExists = Get-Printer -Name $queueName -ErrorAction SilentlyContinue
if (-not $queueExists) {
    "$(Get-Date) ==>> Printer Queue Not Exist, we are going a step further" | Out-File log.txt -Append
}
else {
    "$(Get-Date) ==>> Printer Queue Exist" | Out-File log.txt -Append
    "$(Get-Date) ==>> Removing existing Printer Queue" | Out-File log.txt -Append
    Remove-Printer -Name $queueName
    "$(Get-Date) ==>> Existing Printer Queue removed" | Out-File log.txt -Append
}
$portExists = Get-Printerport -Name $portname -ErrorAction SilentlyContinue
if (-not $portExists) {
    "$(Get-Date) ==>> Printer Port Not Exist, we are going a step further" | Out-File log.txt -Append
}
else {
    $printerUsedByPort = Get-Printer | Where-Object { $_.PortName -eq $portName }

    if (-not $printerUsedByPort) {
        "$(Get-Date) ==>> Printer Port Exist, unused" | Out-File log.txt -Append
        "$(Get-Date) ==>> Removing Existing Port" | Out-File log.txt -Append
		& $safeqPort $safeqPortuninstall
        "$(Get-Date) ==>> Existing Port Removed" | Out-File log.txt -Append
    }
    else {
        "$(Get-Date) ==>> Printer Port Exist. Used by $($printerUsedByPort.name -join ', ')" | Out-File log.txt -Append
        "$(Get-Date) ==>> Removing Queues: $($printerUsedByPort.name -join ', ')" | Out-File log.txt -Append
        Remove-Printer -Name $($printerUsedByPort).name
        "$(Get-Date) ==>> Queues: $($printerUsedByPort.name -join ', ') removed" | Out-File log.txt -Append
        "$(Get-Date) ==>> Removing Existing Port" | Out-File log.txt -Append
		& $safeqPort $safeqPortuninstall
        "$(Get-Date) ==>> Existing Port Removed" | Out-File log.txt -Append
    }
}
$printDriverExists = Get-PrinterDriver -name $printDriverName -ErrorAction SilentlyContinue
if (-not $printDriverExists) {
    "$(Get-Date) ==>> Printer Driver not Exist, we are going a step further" | Out-File log.txt -Append
}
else {
    "$(Get-Date) ==>> Printer Driver is installed" | Out-File log.txt -Append
    "$(Get-Date) ==>> I will not Delete Drivers from Workstation" | Out-File log.txt -Append
}
"$(Get-Date) ==>> Uninstallation succesfully" | Out-File log.txt -Append
"$(Get-Date) ==>> Log Ended" | Out-File log.txt -Append