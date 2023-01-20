# MUST USE POWERSHELL 5
#Requires -Module Microsoft.Graph.Reports
#Requires -Module MSOnline

# fill out variables_template.json and save as variables.json
$userVariables = Get-Content -Raw -Path .\variables.json | ConvertFrom-Json

$outFile = ".\CustomUserReport_$(get-date -f yyyy-MM-dd).csv"

Select-MgProfile -Name Beta
Connect-MgGraph -TenantId $userVariables.tenantId -AppId $userVariables.appId -CertificateThumbprint $userVariables.thumbprint

Connect-MsolService 

$users = Get-ADUser -Filter 'Enabled -eq $true' -SearchBase $userVariables.searchBase -Properties PasswordLastSet, EmployeeID, Title, LastLogonDate

$count = 1
$total = $users.Count

$updatedUsers = foreach ( $user in $users ) {
  $upn = $user.UserPrincipalName.ToLower()

  Write-Host "Processing user $($upn) ($count/$total)"
  $count++

  [PSCustomObject]@{
    Name              = $user.Name
    PasswordLastSet   = $user.PasswordLastSet
    Enabled           = $user.Enabled
    PerUserMFAState   = if ((Get-MsolUser -UserPrincipalName $upn).StrongAuthenticationRequirements.State) { (Get-MsolUser -UserPrincipalName $upn).StrongAuthenticationRequirements.State } else { "Disabled" }
    UserPrincipalName = $user.UserPrincipalName
    EmployeeID        = $user.EmployeeID
    Title             = $user.Title
    DistinguishedName = $user.DistinguishedName
    ADLastLogon       = $user.LastLogonDate
    AADLastLogon      = (Get-MgAuditLogSignIn -Filter "UserPrincipalName eq '$upn' and status/errorCode eq 0" -Top 1).CreatedDateTime
  }
}

$updatedUsers | Export-Csv -Path $outFile -NoTypeInformation

Disconnect-MgGraph
