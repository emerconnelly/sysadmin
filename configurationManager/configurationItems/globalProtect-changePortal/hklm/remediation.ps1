# assumes GlobalProtect64-5.2.12 installed

# change the portal address to the one you want to use
$old_portal = ""
$new_portal = ""

##### HKEY_LOCAL_MACHINE #####
if (Test-Path -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\PanSetup") {
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\PanSetup" -Name "Portal" -Value "$new_portal" -Type "String" -Force
}
if (Test-Path -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings") {
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings" -Name "LastUrl" -Value "$new_portal" -Type "String" -Force
}
if (Test-Path -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings\$($old_portal)") {
    Remove-Item -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings\$($old_portal)" -Force
}

Restart-Service -Name "PanGPS" -Force