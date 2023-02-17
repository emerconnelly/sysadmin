$PowerRegPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power'
$PowerRegName = 'HiberbootEnabled'
Set-ItemProperty -Path $PowerRegPath -Name $PowerRegName -Value 0 -Force -Confirm:$false
