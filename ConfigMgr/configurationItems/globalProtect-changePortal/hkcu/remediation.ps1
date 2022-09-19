# assumes GlobalProtect64-5.2.12 installed

# change the portal address to the one you want to use
$old_portal = ""
$new_portal = ""

##### HKEY_CURRENT_USER #####
if (Test-Path -Path "HKCU:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings") {
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings" -Name "LastUrl" -Value "$new_portal" -Type "String" -Force
}
if (Test-Path -Path "HKCU:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings\$($old_portal)") {
    Remove-Item -Path "HKCU:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings\$($old_portal)" -Force
}