<#
.SYNOPSIS
This PowerShell script is designed to check all Git repositories within the current working directory for uncommitted changes and unpushed commits. It outputs a list of repositories that have either uncommitted changes or commits that are ahead of the remote branch, indicating they haven't been pushed yet.

.DESCRIPTION
When executed, the script:
- Iterates through each subdirectory of the current working directory.
- Checks if a subdirectory is a Git repository.
- Within each Git repository, it checks for uncommitted changes and whether the local branch is ahead of its remote counterpart.
- Collects and displays a list of repositories with uncommitted changes or unpushed commits.

.NOTES
Make sure you have Git installed and accessible from your PowerShell environment.
Run this script from the root of your workspace where all your Git repositories are located.
#>

# Use the current working directory as the TridentWorkspace path
$TridentWorkspacePath = Get-Location

# Initialize an array to hold names of directories with changes or ahead of origin
$reposWithChangesOrAhead = @()

# Get all directories within TridentWorkspace
$directories = Get-ChildItem -Directory

foreach ($dir in $directories) {
    # Change to the directory
    Set-Location -Path $dir.FullName
    
    # Check if the directory is a git repository by looking for the .git folder
    if (Test-Path ".git") {
        # Execute git status and capture the output
        $gitStatus = git status
        
        # Check if the git status indicates there are changes or if the branch is ahead of the remote
        if ($gitStatus -match "Changes not staged for commit:" -or
            $gitStatus -match "Untracked files:" -or
            $gitStatus -match "Your branch is ahead of") {
            # Add the directory to the list
            $reposWithChangesOrAhead += $dir.Name
        }
    }
    
    # Change back to the TridentWorkspace directory
    Set-Location -Path $TridentWorkspacePath
}

# Prepare the summary message
$reposCount = $reposWithChangesOrAhead.Count
if ($reposCount -gt 0) {
    Write-Host "$reposCount repositories found with uncommitted/unpushed git changes:"
    $reposWithChangesOrAhead | ForEach-Object { Write-Host $_ }
} else {
    Write-Host "No changes found in any repositories, and all are up to date with origin."
}
