# Function to create report email
function SendNotification{
$Msg = New-Object Net.Mail.MailMessage
$Smtp = New-Object Net.Mail.SmtpClient($ExchangeServer)
$Msg.From = $FromAddress
$Msg.To.Add($ToAddress)
$Msg.Subject = "Announcement: PIN number for new printers."
$Msg.Body = $EmailBody
$Msg.IsBodyHTML = $true
$Smtp.Send($Msg)
}

# Define local Exchange server info for message relay. Ensure that any servers running this script have permission to relay.
$ExchangeServer = "1.1.1.1"
$FromAddress = "skaner@intra"

# Import user list and information from .CSV file
$Users = Import-Csv UserList.csv

# Send notification to each user in the list
Foreach ($User in $Users) {
$ToAddress = $User.Email
$Name = $User.FirstName
$Pin = $User.PIN
$EmailBody = @"

Dear $Name,

Here you have PIN number for new printers.

PIN: @Pin
The instruction for activating your printer account will be send later.

Regards,

Office Team



"@
Write-Host "Sending notification to $Name ($ToAddress)" -ForegroundColor Yellow
SendNotification
}