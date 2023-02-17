# assumes GlobalProtect64-5.2.12 installed
# compliant when script returns $true

# change the portal address to the one you want to use
$old_portal = ""
$new_portal = ""

###### HKEY_LOCAL_MACHINE #####
# if registry key exists continue
if (Get-ItemProperty -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\PanSetup" -Name "Portal") {
    # if Portal is not pointing to $new_portal then non-compliant
    $key_value = Get-ItemProperty -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\PanSetup" -Name "Portal"
    if ($key_value.Portal -ne $new_portal) {
        return $false
    }
}
# if registry key exists continue
if (Get-ItemProperty -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings" -Name "LastUrl") {
    # if LastUrl is not pointing to $new_portal then non-compliant
    $key_value = Get-ItemProperty -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings" -Name "LastUrl"
    if ($key_value.LastUrl -ne $new_portal) {
        return $false
    }
}
# if registry key exists then non-compliant
if (Test-Path -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings\$($old_portal)") {
    return $false
}

# if all tests pass then compliant
return $true