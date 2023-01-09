$searchBase = Get-Content -Path .\searchBase.txt

$users = Get-ADUser -Filter "*" -SearchBase $searchBase

foreach ($user in $users) {
  Set-ADUser -Identity "$($user.ObjectGUID)" -EmployeeID "consultant"
}
