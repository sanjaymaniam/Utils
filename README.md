# Utils

This repository stores various PowerShell scripts I've written for my convenience. Feel free to modify them to suit your specific needs.

## Index
1) [OneDriveClonerSetupScript](https://github.com/sanjaymaniam/Utils/blob/master/OneDrive%20Backup%20Scripts/OneDriveClonerSetupScript.ps1): This script downloads the latest stable version of Rclone and walks you through setting up a OneDrive remote. Note that this creates a directory on your Desktop by default, which you might want to change.

2) [OneDriveSyncScript](https://github.com/sanjaymaniam/Utils/blob/master/OneDrive%20Backup%20Scripts/OneDriveSyncScript.ps1): The official OneDrive client does not allow you to auto-backup secondary drives. This script uses Rclone to copy the contents of any local directory to any directory in OneDrive. Please ensure that the previous script has run successfully before running this one. This is a one-way transfer (local -> remote) and only changed/new files are transferred. I use the Windows Task Scheduler to run this script periodically.

TO DO:
- [ ] Script to delete all /bin and /obj folders recursively. Fixes hot-reload failures in Visual Studio.
