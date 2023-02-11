#Requires -Module ActiveDirectory

function Get-StateName {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Abbreviation
  )

  switch ($Abbreviation.ToUpper()) {
    "AL" { return "Alabama" }
    "AK" { return "Alaska" }
    "AZ" { return "Arizona" }
    "AR" { return "Arkansas" }
    "CA" { return "California" }
    "CO" { return "Colorado" }
    "CT" { return "Connecticut" }
    "DE" { return "Delaware" }
    "DC" { return "District of Columbia" }
    "FL" { return "Florida" }
    "GA" { return "Georgia" }
    "HI" { return "Hawaii" }
    "ID" { return "Idaho" }
    "IL" { return "Illinois" }
    "IN" { return "Indiana" }
    "IA" { return "Iowa" }
    "KS" { return "Kansas" }
    "KY" { return "Kentucky" }
    "LA" { return "Louisiana" }
    "ME" { return "Maine" }
    "MD" { return "Maryland" }
    "MA" { return "Massachusetts" }
    "MI" { return "Michigan" }
    "MN" { return "Minnesota" }
    "MS" { return "Mississippi" }
    "MO" { return "Missouri" }
    "MT" { return "Montana" }
    "NE" { return "Nebraska" }
    "NV" { return "Nevada" }
    "NH" { return "New Hampshire" }
    "NJ" { return "New Jersey" }
    "NM" { return "New Mexico" }
    "NY" { return "New York" }
    "NC" { return "North Carolina" }
    "ND" { return "North Dakota" }
    "OH" { return "Ohio" }
    "OK" { return "Oklahoma" }
    "OR" { return "Oregon" }
    "PA" { return "Pennsylvania" }
    "RI" { return "Rhode Island" }
    "SC" { return "South Carolina" }
    "SD" { return "South Dakota" }
    "TN" { return "Tennessee" }
    "TX" { return "Texas" }
    "UT" { return "Utah" }
    "VT" { return "Vermont" }
    "VA" { return "Virginia" }
    "WA" { return "Washington" }
    "WV" { return "West Virginia" }
    "WI" { return "Wisconsin" }
    "WY" { return "Wyoming" }
    default { throw "Invalid state abbreviation" }
  }
}

$rootSearchBase = "OU=Sites,DC=TRUCKDOM,DC=LOCAL"
$states = Get-ADOrganizationalUnit -Filter * -SearchScope OneLevel -SearchBase $rootSearchBase | ? { $_.Name[0] -ne "_" }
$sites = $states | % { Get-ADOrganizationalUnit -Filter * -SearchScope OneLevel -SearchBase "OU=$($_.Name),$rootSearchBase" }

$computers = Get-ADComputer -Filter * -SearchBase "CN=Computers,DC=TRUCKDOM,DC=LOCAL"
foreach ($computer in $computers ) {
  $siteCode = $computer.Name.Substring(0, 6)
  if ($sites.Name.Contains($siteCode)) {
    $state = Get-StateName -Abbreviation $siteCode.Substring(0, 2)
    Move-ADObject -Identity $computer.ObjectGUID -TargetPath "OU=Computers,OU=$siteCode,OU=$state,$rootSearchBase"
  }
}
