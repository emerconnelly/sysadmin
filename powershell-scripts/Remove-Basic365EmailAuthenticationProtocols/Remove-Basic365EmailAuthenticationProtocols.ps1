#Requires ExchangeOnlineManagement

$mailboxes = Get-Mailbox -ResultSize unlimited
$count = 1
$total = ($mailboxes | Measure-Object).Count
foreach ($mailbox in $mailboxes) {
  Write-Host "($count/$total) $($mailbox.UserPrincipalName)"
  $count++
  Set-CasMailbox -Identity $mailbox.Guid -PopEnabled $false -ImapEnabled $false -ActiveSyncEnabled $false -SmtpClientAuthenticationDisabled $true
}
