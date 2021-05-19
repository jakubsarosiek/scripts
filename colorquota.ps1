# colorquota.ps1
# PowerShell script to block color usage using Color Quota for domain group.
# Authors Jakub Sarosiek
# Version 1.0 - January 2020
# ----------------------------------------'
#
Import-Module ActiveDirectory

$EQServer = "192.168.4.111"
$logfile = "c:\logfile.txt"
$EQcmd = "C:\Program Files\Equitrac\Office\Tools\EQCmd.exe"
$Groups = Get-ADGroup -Filter * -SearchBase 'CN=color,OU=groups,OU=showroom,DC=xrx,DC=pl'

"================================================================" | Out-File $logfile -Append
"$(Get-Date) ==>> Adres serwera Equitrac to: $($EqServer)" | Out-File $logfile -Append
"$(Get-Date) ==>> Nazwa grupy użytkowników nie mogącej kożystać z koloru to: $($Groups.Name)" | Out-File $logfile -Append
"$(Get-Date) ==>> Zezwalam wszystkim uzytkownikom dostep do koloru." | Out-File $logfile -Append

cmd.exe /c """$EQcmd"" -s$EQServer quota ur All -1"

"$(Get-Date) ==>> Zrobione." | Out-File $logfile -Append

"$(Get-Date) ==>> Zabraniam na kożystanie z koloru użytkownikom z grupy: $($Groups.Name)" | Out-File $logfile -Append

foreach( $Group in $Groups ) {
   
    $Members = Get-ADGroupMember -Identity $Group | select name,samaccountname
   
    foreach ($Member in $Members){

        "$(Get-Date) ==>> Zabraniam na kożystanie z koloru użytkownikowi: $($Member.samaccountname)" | Out-File $logfile -Append
        cmd.exe /c """$EQCmd"" -s$EQServer quota ur $($Member.sAMAccountName) 0"
    }
}
"$(Get-Date) ==>> Zrobione na dziś..." | Out-File $logfile -Append