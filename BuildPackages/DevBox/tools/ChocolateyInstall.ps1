try {
    Install-WindowsUpdate -AcceptEula
    Update-ExecutionPolicy Unrestricted
    Set-ExplorerOptions -showHidenFilesFoldersDrives -showFileExtensions
    & powercfg.exe -h off # Turn off Hibernation
    Disable-LockScreen

    # # cinstm VisualStudio2012Ultimate
    # # if((Get-Item "$($Boxstarter.programFiles86)\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe").VersionInfo.ProductVersion -lt "11.0.60115.1") 
    # # {
    # #     if(Test-PendingReboot){Invoke-Reboot}
    # #     cinstm Dogtail.VS2012.2
    # # }
    # cinstm git-credential-winstore
    # cinstm githubforwindows
    # cinstm Console2
    # cinstm sublimetext2
    # cinstm SublimeText2.PackageControl
    cinstm PsGet
    # cinstm dotpeek
    # cinstm googlechrome
    # # cinstm resharper
    # cinstm SourceCodePro
    # cinstm MesloLG.DZ
    # cinstm dejavu.fonts

    # Write-Host "Importing PsGet"
    # Import-Module "$env:programfiles\Common Files\Modules\PsGet\PsGet.psm1"
    # Write-Host "Installing Posh-Git"
    # Install-Module Posh-Git
    # Write-Host "Posh-Git installed!"

    # $sublimeDir = "$env:programfiles\Sublime Text 2"

    # # Need to make sure the appdata path exists, and if not create it.
    # $sublimeUserDir = "$env:APPDATA\Sublime Text 2"
    # if(!(Test-Path $sublimeUserDir))
    # {
    #     New-Item "$sublimeUserDir\Packages\User" -type Directory
    # }
    # & git clone "https://github.com/buymeasoda/soda-theme/" "$sublimeUserDir\Packages\Theme - Soda"
    # # Currently erroring here.
    # Copy-Item (Join-Path (Get-PackageRoot($MyInvocation)) 'sublime\*.tmTheme') -Force -Recurse "$sublimeUserDir\Packages\User"
    # Copy-Item (Join-Path (Get-PackageRoot($MyInvocation)) 'sublime\*.sublime-settings') -Force -Recurse "$sublimeUserDir\Packages\User"

    # $powerShellUserDir = "$($env:USERPROFILE)\Documents\WindowsPowerShell"
    # if(!(Test-Path $powerShellUserDir))
    # {
    #     Write-Host "Creating $powerShellUserDir..."
    #     New-Item "$powerShellUserDir" -type Directory -Force
    # }
    # Write-Host "Copying Microsoft.PowerShell_profile.ps1 to $powerShellUserDir"
    # Copy-Item (Join-Path (Get-PackageRoot($MyInvocation)) 'Microsoft.PowerShell_profile.ps1') -Force -Recurse "$powerShellUserDir"

    # Install-ChocolateyPinnedTaskBarItem "$sublimeDir\sublime_text.exe"
    # # Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Google\Chrome\Application\chrome.exe"
    # Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe"

    # Install-ChocolateyFileAssociation ".txt" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    # Install-ChocolateyFileAssociation ".ps1" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    # Install-ChocolateyFileAssociation ".cs" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    # Install-ChocolateyFileAssociation ".cshtml" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    # Install-ChocolateyFileAssociation ".csproj" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    # Install-ChocolateyFileAssociation ".js" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    # Install-ChocolateyFileAssociation ".css" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    # Install-ChocolateyFileAssociation ".less" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    # Install-ChocolateyFileAssociation ".config" "$env:programfiles\Sublime Text 2\sublime_text.exe"

    # if(!(where.exe git))
    # {
    #     #Why is git not on the PATH?

    #     $gitPath = 'C:\Program Files\git\bin'
    #     if(!(test-path $gitPath))
    #     {
    #         $gitPath = 'C:\Program Files (x86)\Git\bin'
    #     }

    #     if(test-path "$gitPath\git.exe")
    #     {
    #         $env:Path += ";$gitPath"
    #     }
    #     else
    #     {
    #         throw "could not find git, rest of setup not going to execute..."
    #         return;
    #     }
    # }

    # git config --global user.email kmcginnes@me.com
    # git config --global user.name 'Kris McGinnes'
    # git config --global color.status.changed "cyan normal bold" 
    # git config --global color.status.untracked "cyan normal bold"

    # # configure git diff and merge if p4merge was installed
    # if(where.exe p4merge) {
    #     git config --global merge.tool p4merge
    #     git config --global mergetool.p4merge.cmd 'p4merge.exe \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"'
    #     git config --global mergetool.prompt false

    #     git config --global diff.tool p4merge
    #     git config --global difftool.p4merge.cmd 'p4merge.exe \"$LOCAL\" \"$REMOTE\"'
    # }

    Write-ChocolateySuccess 'DevBox'
} catch {
  Write-ChocolateyFailure 'DevBox' $($_.Exception.Message)
  throw
}