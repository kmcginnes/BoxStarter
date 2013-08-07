
$PoshGitLocation = "C:\tools\poshgit\dahlbyk-posh-git-22f4e77"
Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Load posh-git module from current directory
$poshGitIsInstalled = Test-Path $PoshGitLocation
if($poshGitIsInstalled -eq $true) {
    Import-Module $PoshGitLocation\posh-git
    Write-Host "PoshGit loaded" -ForegroundColor Green
}
else {
    Write-Host "PoshGit not installed" -ForegroundColor Yellow
}

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
# Import-Module posh-git

#Set environment variables for Visual Studio Command Prompt
$visualStudioPath = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio 11.0\VC"
$visualStudioVersion = "2012"
if(!(Test-Path $visualStudioPath)) {
    $visualStudioPath = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio 10.0\VC"
    $visualStudioVersion = "2010"
}
$visualStudioIsInstalled = Test-Path $visualStudioPath
if($visualStudioIsInstalled -eq $true) {
    pushd $visualStudioPath
    cmd /c "vcvarsall.bat&set" |
    foreach {
      if ($_ -match "=") {
        $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
      }
    }
    popd
    write-host "Visual Studio $visualStudioVersion Command Prompt variables set." -ForegroundColor Green
}
else {
    Write-Host "Visual Studio not installed" -ForegroundColor Yellow
}

# Set up a simple prompt, adding the git prompt parts inside git repos
function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    if($poshGitIsInstalled -eq $true) {
        $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor
    }
    
    $newline = [Environment]::NewLine

    $dt= "`n[{0:ddd, MMM d hh:mm:ss}] " -f (get-date)
    Write-Host $dt -NoNewline -ForegroundColor Cyan

    Write-Host($pwd) -nonewline -ForegroundColor Green


    if($poshGitIsInstalled -eq $true) {
        Write-VcsStatus
    }

    $global:LASTEXITCODE = $realLASTEXITCODE
    return $newline + "--> "
}

if($poshGitIsInstalled -eq $true) {
    Enable-GitColors
}

Pop-Location

if($poshGitIsInstalled -eq $true) {
    Start-SshAgent -Quiet
}

# Load posh-git example profile
#. 'C:\tools\poshgit\dahlbyk-posh-git-22f4e77\profile.example.ps1'

