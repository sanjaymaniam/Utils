function WaitForUserToCloseWindow()
{
  param
  (
    [bool]$isError = $false
  )

  if ($isError)
  {
    Write-Host "Sorry, something went wrong."
    Write-Host "Sorry, something went wrong."
  }

  Write-Host "Press Esc to exit."

  while ($true) {
    $key = [System.Console]::ReadKey()
    if ($key.Key -eq 'Escape') {
        Write-Host "Exiting shell."
        Exit
    }
  }
}


$welcomeMessage = @"
           _                     _____      _                  _____           _       _   
          | |                   / ____|    | |                / ____|         (_)     | |  
  _ __ ___| | ___  _ __   ___  | (___   ___| |_ _   _ _ __   | (___   ___ _ __ _ _ __ | |_ 
 | '__/ __| |/ _ \| '_ \ / _ \  \___ \ / _ \ __| | | | '_ \   \___ \ / __| '__| | '_ \| __|
 | | | (__| | (_) | | | |  __/  ____) |  __/ |_| |_| | |_) |  ____) | (__| |  | | |_) | |_ 
 |_|  \___|_|\___/|_| |_|\___| |_____/ \___|\__|\__,_| .__/  |_____/ \___|_|  |_| .__/ \__|
                                                     | |                        | |        
                                                     |_|                        |_|                              
"@

Write-Host $welcomeMessage
Write-Host

Write-Host

Write-Host "This script will set up rclone and link it with you Microsoft OneDrive account. Please make sure you have an active internet connection before continuing.."
Write-Host
Write-Host "Press enter to continue."
$null = Read-Host

$desktop = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders').Desktop
$clonerFolderName = "OneDriveCloner"

# Download rclone for Windows x64 AMD/Intel
$rcloneDownloadURL = "https://downloads.rclone.org/rclone-current-windows-amd64.zip"
mkdir $desktop\$clonerFolderName
Write-Host
$downloadDestination = "$desktop\$clonerFolderName\rclone-current-windows-amd64.zip"
$unzipDestination = "$desktop\$clonerFolderName\"

Write-Host
Write-Host "Downloading rclone for Windows x64 running on AMD/Intel..."
Write-Host

try
{
  # Write-Host $downloadDestination
  $response = Invoke-WebRequest -Uri $rcloneDownloadURL -OutFile "$downloadDestination"
  Write-Host "File downloaded successfully to $downloadDestination"\
}
catch 
{
  Write-Host "Error downloading the file: $_"
  WaitForUserToCloseWindow
}

try
{
    # Unzip the downloaded file
    Expand-Archive -Path $downloadDestination -DestinationPath $unzipDestination -Force
    Write-Host "rclone unzipped successfully to $unzipDestination"
}
catch
{
    Write-Host "Error unzipping the file: $_"
    WaitForUserToCloseWindow
}


$latestRcloneFolder = (Get-ChildItem -Path $unzipDestination | Where-Object {$_.Name -match "^rclone.*windows-amd64$"} | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName

Write-Host
Write-Host "Attempting to move to $latestRcloneFolder"
cd $latestRcloneFolder
try
{
    # Create a new remote for OneDrive and get auth tokens
    Write-Host "You now have to login to your OneDrive account. This script will redirect you to your browser."
    $response = .\rclone config create onedrive-remote onedrive env_auth=true
    $filePath = "rcloneConfigResponse.json"
    $response = .\rclone.exe config dump
    Set-Content -Path $filePath -Value $response
}
catch
{
    Write-Host "Error configuring OneDrive remote."
    Write-Host "Error configuring OneDrive remote."
    WaitForUserToCloseWindow
}

Write-Host

$successMessage = @"
      _                  _ 
     | |                | |
   __| | ___  _ __   ___| |
  / _` |/ _ \| '_ \ / _ \ |
 | (_| | (_) | | | |  __/_|
  \__,_|\___/|_| |_|\___(_)                                          
"@

Write-Host $successMessage
Write-Host
Write-Host
Write-Host "Next, run the OneDriveSyncScript or schedule it with Windows Task Scheduler."

cd "$desktop"
WaitForUserToCloseWindow -isError:$false
