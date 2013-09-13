try {
    Install-WindowsUpdate -AcceptEula
    Update-ExecutionPolicy Unrestricted
    Set-ExplorerOptions -showHidenFilesFoldersDrives -showFileExtensions
    
    write-BoxstarterMessage "Turning off Windows Hibernation"
    & powercfg.exe -h off
    & $env:windir\system32\tzutil /s "Central Standard Time"

    # cinstm VisualStudio2012Ultimate
    # if((Get-Item "$($Boxstarter.programFiles86)\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe").VersionInfo.ProductVersion -lt "11.0.60115.1") {
    #     if(Test-PendingReboot){Invoke-Reboot}
    #     cinstm Dogtail.VS2012.2
    # }
    cinstm 7zip
    cinstm fiddler4
    cinstm git-credential-winstore
    cinstm githubforwindows
    cinstm Console2
    cinstm sublimetext2
    cinstm SublimeText2.PackageControl
    # cinstm dotpeek
    cinstm googlechrome
    cinstm windirstat
    # cinstm resharper
    cinstm SourceCodePro
    cinstm PsGet

    # cinst IIS-WebServerRole -source windowsfeatures
    # cinst IIS-HttpCompressionDynamic -source windowsfeatures
    # cinst IIS-ManagementScriptingTools -source windowsfeatures
    # cinst IIS-WindowsAuthentication -source windowsfeatures

    $env:Path = "$env:Path;${env:ProgramFiles(x86)}\Git\cmd"

    $sublimeDir = "$env:programfiles\Sublime Text 2"
    $sublimePackagesDir = "$env:APPDATA\Sublime Text 2\Packages"

    if(!(Test-Path "$sublimePackagesDir\Theme - Soda")) {
        write-BoxstarterMessage "Cloning the Sublime Text theme Soda"
        & git clone "https://github.com/buymeasoda/soda-theme/" "$sublimePackagesDir\Theme - Soda"
    }

    write-BoxstarterMessage "Copying personal Sublime Text settings"
    New-Item -ItemType Directory -Path "$sublimePackagesDir\User" -Force
    copy-item (Join-Path (Get-PackageRoot($MyInvocation)) 'configs\sublime\*') -Force -Recurse "$sublimePackagesDir\User"

    write-BoxstarterMessage "Copying personal global gitignore and gitconfig"
    copy-item (Join-Path (Get-PackageRoot($MyInvocation)) 'configs\local.gitignore_global') -Force -Recurse "$env:userprofile\.gitignore_global"
    copy-item (Join-Path (Get-PackageRoot($MyInvocation)) 'configs\local.gitconfig') -Force -Recurse "$env:userprofile\.gitconfig"

    write-BoxstarterMessage "Installing PoshGit and PowerShell settings..."
    $documentsDir = [environment]::getfolderpath("mydocuments")
    New-Item -ItemType Directory -Path "c:\tools\poshgit" -Force
    & git clone "https://github.com/dahlbyk/posh-git.git" "c:\tools\poshgit"
    New-Item -ItemType Directory -Path "$documentsDir\WindowsPowerShell" -Force
    copy-item (Join-Path (Get-PackageRoot($MyInvocation)) 'configs\Microsoft.PowerShell_profile.ps1') -Force -Recurse "$documentsDir\WindowsPowerShell"

    $console2Dir = Join-Path "$env:ChocolateyInstall\lib" (Get-ChildItem "$env:ChocolateyInstall\lib" | ?{$_.name -match "^console2\.\d+"})
    write-BoxstarterMessage "Copying personal Console2 settings to $console2Dir\bin..."
    copy-item (Join-Path (Get-PackageRoot($MyInvocation)) 'configs\console.xml') -Force -Recurse "$console2Dir\bin"

    write-BoxstarterMessage "Setting up pinned task bar items"
    Install-ChocolateyPinnedTaskBarItem "$sublimeDir\sublime_text.exe"
    Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Google\Chrome\Application\chrome.exe"
    # Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe"

    Install-ChocolateyFileAssociation ".txt" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".log" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".config" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".xml" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".ps1" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".cs" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".cshtml" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".csproj" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".js" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".css" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".less" "$env:programfiles\Sublime Text 2\sublime_text.exe"

    Write-ChocolateySuccess 'DevBox'
} catch {
  Write-ChocolateyFailure 'DevBox' $($_.Exception.Message)
  throw
}