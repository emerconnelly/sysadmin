# $(Get-AzureADUser -SearchString "emer connelly").UserPrincipalName >> user-upns.txt
Write-Host ""

while ($true) {
    Write-Host "Is your list of user UPNs, one per line, located at .\user-upns.txt? (Y/N): " -NoNewLine
    $answer = Read-Host
    if ($answer -eq "Y") {
        $userUPNs = Get-Content -Path ".\user-upns.txt"
        break
    }
    elseif ($answer -eq "N") {
        Write-Host "Please create your list of user UPNs, one per line, located at .\user-upns.txt`n"
    }
    else {
        Write-Host "Invalid answer`n"
    }
}

# if not already connected then connect to the Azure AD tenant 
try {
    Get-MgUser > $null
}
catch [System.Security.Authentication.AuthenticationException] {
    Write-Host "`nLog in to the Azure AD tenant..."
    Connect-Graph
}

<# # create custom class for a clean license list
class customLicenseClass {
    [string]$skuPartNumber
    [int]$available
    [int]$enabled
    [int]$consumed
}
$licenseTable = New-Object System.Collections.Generic.List[customLicenseClass]

# list the tenant license details
$licenses = Get-AzureADSubscribedSku | Select-Object -Property SkuPartNumber, ConsumedUnits -ExpandProperty PrepaidUnits
foreach ($license in $licenses) {
    $licenseTable += @([customLicenseClass]@{`
                skuPartNumber = $license.SkuPartNumber; `
                available     = $($license.Enabled - $license.ConsumedUnits); `
                enabled       = $license.Enabled; `
                consumed      = $license.ConsumedUnits
        })
}
Write-Host "`nCurrent tenant licenses:"
$licenseTable | Format-Table -AutoSize

# user input and verify the license skuPartNumber
while ($true) {
    Write-Host "https://docs.microsoft.com/en-us/azure/active-directory/enterprise-users/licensing-service-plan-reference"
    Write-Host "License skuPartNumber: " -NoNewLine
    $skuPartNumber = Read-Host

    if ($licenseTable.SkuPartNumber -contains $skuPartNumber) {
        break
    }
    else {
        Write-Host "Invalid or unsubscribed, try again.`n"
    }
}

# verify assingment of license to the desired users
Write-Host "`nAssigning $skuPartNumber to the following users:"
$userUPNs
Write-Host "`nContinue? (Y/N): " -NoNewLine
while ($true) {
    $answer = Read-Host
    if ($answer -eq "Y") {
        Write-Host ""
        break
    }
    elseif ($answer -eq "N") {
        Write-Host "`nExiting...`n"
        exit
    }
    else {
        Write-Host "Invalid answer`n"
    }
}

while ($true) {
    # create the AssignedLicense object, designed to include one license
    $license = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
    # assign the AssignedLicense object's skuID the skuPartNumber provided earlier
    $license.skuId = (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value $skuPartNumber -EQ).SkuID
    #create the AssignedLicenses object, designed to add or remove multiple liceneses in a single operation
    $licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
    # assign the AssignedLicense object the AssignedLicenses object as an add license operation
    $licenses.AddLicenses = $license
    # assign the AssignedLicenses object to the user
    foreach ($userUPN in $userUPNs) {
        Write-Host "Assigning $skuPartNumber to $userUPN..."
        try {
            Set-AzureADUserLicense -ObjectId $userUPN -AssignedLicenses $licenses
            Write-Host "License assignment successful.`n" -ForegroundColor Green
        }
        catch {
            Write-Host $PSItem.Exception.Message -ForegroundColor Red
        }
    }
    break
}

Write-Host ""
 #>