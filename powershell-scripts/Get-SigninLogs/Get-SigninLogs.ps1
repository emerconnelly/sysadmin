#Requires -Module Microsoft.Graph.Reports

$inFile = ".\UsersWithNoEmployeeID.csv"
$outFile = ".\updatedUsers.csv"

$tenantId = Get-Content -Path .\tenantId.txt
$appId = Get-Content -Path .\appId.txt
$thumbprint = Get-Content -Path .\thumbprint.txt

Select-MgProfile -Name Beta
Connect-MgGraph -TenantId $tenantId -AppId $appId -CertificateThumbprint $thumbprint

$users = Import-Csv -Path $inFile

$count = 1
$total = $users.Count

$updatedUsers = foreach ( $user in $users ) {
  $upn = $user.UserPrincipalName.ToLower()

  Write-Host "Processing user $upn ($count/$total)"
  $count += 1

  $adLastLogon = Get-ADUser -Filter { UserPrincipalName -eq $upn } -Properties LastLogon | Select-Object @{name = "LastLogon"; expression = { [DateTime]::FromFileTime($_.LastLogon) } }
  $aadLastLogon = Get-MgAuditLogSignIn -Filter "UserPrincipalName eq '$upn' and status/errorCode eq 0" -Top 1

  [PSCustomObject]@{
    GivenName         = $user.GivenName
    Surname           = $user.Surname
    Name              = $user.Name
    UserPrincipalName = $user.UserPrincipalName
    EmployeeID        = $user.EmployeeID
    adLastLogon       = $adLastLogon.LastLogon
    azureLastLogon    = $aadLastLogon.CreatedDateTime
  }
}

$updatedUsers | Export-Csv -Path $outFile

Disconnect-MgGraph
