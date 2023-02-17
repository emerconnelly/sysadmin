$PowerRegPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power'
$PowerRegName = 'HiberbootEnabled'
if (((Get-ItemProperty -Path $PowerRegPath -Name $PowerRegName).$PowerRegName) -ne 0) {
    Set-ItemProperty -Path $PowerRegPath -Name $PowerRegName -Value 0 -Force -Confirm:$false
}
