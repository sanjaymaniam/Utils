# Define the path to the OneDriveCloner folder on the user's desktop.
$OneDriveClonerPath = "$env:USERPROFILE\Desktop\OneDrive Backup Scripts\OneDriveCloner"

# Define the path to the local source folder to be backed up.
$LocalSourceFolder = "D:\Docs"

# Define the name of the remote created for your OneDrive account with Rclone. 
# If unsure, check C:\Users\UserName\AppData\Roaming\rclone\rclone.conf.
$RemoteName = "onedrive-remote"

# Define the name of the remote OneDrive folder to copy the files into.
$RemoteFolderName = "\Docs\"

function WaitForUserToCloseWindow()
{
  param
  (
    [bool]$isError = $true
  )

  if ($isError)
  {
    Write-Host "Sorry, something went wrong. Send me a screenshot of this."
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
                                                                                                            
eeeee eeeee eeee eeeee eeeee  e  ee   e eeee    eeeee e    e eeeee eeee    eeeee eeee eeeee  e  eeeee eeeee 
8  88 8   8 8    8   8 8   8  8  88   8 8       8   " 8    8 8   8 8  8    8   " 8  8 8   8  8  8   8   8   
8   8 8e  8 8eee 8e  8 8eee8e 8e 88  e8 8eee    8eeee 8eeee8 8e  8 8e      8eeee 8e   8eee8e 8e 8eee8   8e  
8   8 88  8 88   88  8 88   8 88  8  8  88         88   88   88  8 88         88 88   88   8 88 88      88  
8eee8 88  8 88ee 88ee8 88   8 88  8ee8  88ee    8ee88   88   88  8 88e8    8ee88 88e8 88   8 88 88      88  
                                                                                                                                                                                                                                                                                                                                             
"@

Write-Host $welcomeMessage

try
{
   # Check if rclone exists in the given path.
    $rcloneFolder = Get-ChildItem -Path $OneDriveClonerPath | Where-Object { $_.PSIsContainer -and $_.Name -match "^rclone.*windows-amd64$" }

    if ($rcloneFolder) 
    {
        Write-Host "The OneDriveCloner sub-folder exists."
        cd $OneDriveClonerPath\$rcloneFolder  
        Write-Host "Copying from $LocalSourceFolder to ${RemoteName}:${RemoteFolderName}"
        Write-Host

        # Start copying items in $LocalSourceFolder to given directory in remote.
        # Logs are generated and stored in rcloneFolder\log.txt.
        .\rclone.exe copy $LocalSourceFolder "${RemoteName}:${RemoteFolderName}" --progress --log-file=log.txt -vv
        cd "$env:USERPROFILE\"
        WaitForUserToCloseWindow -isError:$false
    }
    else 
    {
        Write-Host "The OneDriveCloner folder does not exist in your desktop. Please run the setup script."
    }
}
catch
{
    WaitForUserToCloseWindow
}