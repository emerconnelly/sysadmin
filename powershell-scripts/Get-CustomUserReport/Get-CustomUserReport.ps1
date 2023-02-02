# MUST USE POWERSHELL 5
#Requires -Module Microsoft.Graph.Reports
#Requires -Module Microsoft.Graph.Identity.SignIns
#Requires -Module MSOnline

# fill out variables_template.json and save as variables.json
$userVariables = Get-Content -Raw -Path .\variables.json | ConvertFrom-Json

$outFile = "C:\LRSMicrosoftUserReport\MicrosoftUserReport_$(get-date -f yyyy-MM-dd).csv"

Write-Host "Connecting to Microsoft Graph..."
Select-MgProfile -Name Beta
Connect-MgGraph -TenantId $userVariables.tenantId -AppId $userVariables.appId -CertificateThumbprint $userVariables.thumbprint
Write-Host "`n"

Write-Host "Connecting to Exchange Online..."
Connect-ExchangeOnline # -Organization $userVariables.organization -AppID $userVariables.appId -CertificateThumbPrint $userVariables.thumbprint
Write-Host "Connecteion successful.`n"

Write-Host "Connecting to Azure AD..."
Connect-MsolService
Write-Host "Connecteion successful.`n"

$count = 1
$total = $users.Count

$users = Get-ADUser -Filter 'Enabled -eq $true' -SearchBase $userVariables.searchBase -Properties PasswordLastSet, EmployeeID, Title, LastLogonTimeStamp, Company
$updatedUsers = foreach ( $user in $users ) {
  $upn = $user.UserPrincipalName.ToLower()

  Write-Host "Processing user $($upn) ($count/$total)"
  $count++

  # Legacy Azure Graph - Per-User MFA Status
  $perUserMFAState = (Get-MsolUser -UserPrincipalName $upn).StrongAuthenticationRequirements.State

  # Microsoft Graph - MFA
  $eligibilePerUserMFAMethod = $false
  $authMethods = @()
  $mfaObject = Get-MgUserAuthenticationMethod -UserId $UPN
  foreach ($mfa in $mfaObject) {
    switch ($mfa.AdditionalProperties["@odata.type"]) { 
      "#microsoft.graph.passwordAuthenticationMethod" {
        $authMethod = 'PasswordAuthentication'
      }
      "#microsoft.graph.microsoftAuthenticatorAuthenticationMethod" {
        $authMethod = 'AuthenticatorApp'
        $eligibilePerUserMFAMethod = $true
      }
      "#microsoft.graph.phoneAuthenticationMethod" {
        $authMethod = 'PhoneAuthentication'
        $eligibilePerUserMFAMethod = $true
      }
      "#microsoft.graph.fido2AuthenticationMethod" {
        $authMethod = 'Fido2'
      }
      "#microsoft.graph.windowsHelloForBusinessAuthenticationMethod" {
        $authMethod = 'WindowsHelloForBusiness'
      }
      "#microsoft.graph.emailAuthenticationMethod" {
        $authMethod = 'EmailAuthentication'
      }
      "microsoft.graph.temporaryAccessPassAuthenticationMethod" {
        $authMethod = 'TemporaryAccessPass'
      }
      "#microsoft.graph.passwordlessMicrosoftAuthenticatorAuthenticationMethod" {
        $authMethod = 'PasswordlessMSAuthenticator'
        $eligibilePerUserMFAMethod = $true
      }
      "#microsoft.graph.softwareOathAuthenticationMethod" { 
        $authMethod = 'SoftwareOath'
        $eligibilePerUserMFAMethod = $true
      }
    }
    $authMethods += $authMethod
  }
  $authMethods = $authMethods | Sort-Object | get-unique

  # Exchange Online - Last User Action Time
  try {
    $exoLastUserActionTime = (Get-EXOMailboxStatistics -Identity $upn -Properties LastUserActionTime).LastUserActionTime
  }
  catch {
    Write-Warning $Error[0]
    $exoLastUserActionTime = "mailbox not found"
  }

  [PSCustomObject]@{
    Name                     = $user.Name
    UserPrincipalName        = $user.UserPrincipalName
    AccountEnabled           = $user.Enabled
    EmployeeID               = $user.EmployeeID
    Title                    = $user.Title
    Company                  = $user.Company
    DistinguishedName        = $user.DistinguishedName
    PasswordLastSet          = $user.PasswordLastSet
    ADLastLogonTimeStamp     = [DateTime]::FromFileTimeutc($user.LastLogonTimeStamp)
    AADLastLogon             = (Get-MgAuditLogSignIn -Filter "UserPrincipalName eq '$upn' and status/errorCode eq 0" -Top 1).CreatedDateTime
    EXOLastUserActionTime    = $exoLastUserActionTime
    PerUserMFAState          = if ($perUserMFAState) { $perUserMFAState } else { "Disabled" }
    EligiblePerUserMFAMethod = $eligibilePerUserMFAMethod
  }
}

$updatedUsers | Export-Csv -Path $outFile -Encoding utf8 -NoTypeInformation -Force 

Disconnect-MgGraph
Disconnect-ExchangeOnline -Confirm:$false
