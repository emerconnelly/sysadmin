# change these variables to match environment
$driveLetters = @("C", "H")
$shortcutArguments = @("example1.rdp", "example2.rdp")
$remoteAppUrl = "https://test.example.com//rdweb/feed/webfeed.aspx"
# end of custom variables

$WshShell = New-Object -ComObject "WScript.Shell"

# delete RemoteApp shortcuts
foreach ($driveLetter in $driveLetters){
  Write-Output "`nscanning drive: $driveLetter"
  if (Test-Path -Path "$($driveLetter):\") {
    
    $allShortcuts = Get-ChildItem -Path "$($driveLetter):\" -Filter "*.lnk" -Recurse -ErrorAction SilentlyContinue
    
    foreach ($shortcutArgument in $shortcutArguments) {
      Write-Output "parsing argument: $shortcutArgument"
      
      $shortcuts = $allShortcuts | ForEach-Object { $WshShell.CreateShortcut($_.FullName) } | Where-Object { $_.Arguments -like "*$($shortcutArgument)*" }
      foreach ($shortcut in $shortcuts) {
        Write-Output "deleting shortcut: $($shortcut.FullName)"
        Remove-Item $shortcut.FullName -Force
      }
    }
  }
  else {
    Write-Output "drive not found"
  }
}

# delete RemoteApp profile
# https://www.ajtek.ca/guides/remoteapp-and-desktop-connections/
Write-Output "`nsearching for RemoteApp profile: $remoteAppUrl"
Get-ChildItem -Path "HKCU:\Software\Microsoft\Workspaces\Feeds\" | ForEach-Object {
  if ((Get-ItemProperty -Path $_.PSPath).URL -eq $remoteAppUrl) {
    Write-Verbose "WorkspaceID or URL found in $_"
    Get-ItemProperty -Path $_.PSPath | Select-Object * | Format-List | Out-String | Write-Verbose
    
    Write-Output "profile found, WorkspaceID: $((Get-ItemProperty -Path $_.PSPath).WorkspaceID)"
    
    Write-Output "removing from workspace folder"
    Get-ChildItem -Path $(Get-ItemProperty -Path $_.PSPath).WorkSpaceFolder -Recurse | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item $(Get-ItemProperty -Path $_.PSPath).WorkSpaceFolder -ErrorAction SilentlyContinue
    
    Write-Output "removing from Windows menu"
    Get-ChildItem -Path (Get-ItemProperty -Path $_.PSPath).StartMenuRoot | Remove-Item -Recurse -ErrorAction SilentlyContinue
    Remove-Item $(Get-ItemProperty -Path $_.PSPath).StartMenuRoot -ErrorAction SilentlyContinue
    
    Write-Output "removing from registry"
    Get-Item -Path $_.PSPath | Remove-Item -Recurse -ErrorAction SilentlyContinue
  }
}

Write-Output `n