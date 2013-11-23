try {
    Disable-UAC
    Update-ExecutionPolicy Unrestricted

    Set-ExplorerOptions -showHidenFilesFoldersDrives -showFileExtensions -bootToDesktop -hideTouchKeyboard

    Write-BoxstarterMessage "Turning off the lock screen"
    $key = 'HKLM:\Software\Policies\Microsoft\Windows\Personalization'
    if(!(Test-Path $key))
    {
        New-Item -Path $key -Force | Out-Null
        New-ItemProperty -Path $key -Name NoLockScreen -Value 1 -Type DWord | Out-Null
    }
    else
    {
        Set-ItemProperty $key NoLockScreen 1 -Type DWord
    }
    
    Set-PowerPlan "High performance"
    Write-BoxstarterMessage "Setting Standby Timeout to Never"
    & powercfg.exe -change -standby-timeout-ac 0
    & powercfg.exe -change -standby-timeout-dc 0
    Write-BoxstarterMessage "Setting Monitor Timeout to Never"
    & powercfg.exe -change -monitor-timeout-ac 0
    & powercfg.exe -change -monitor-timeout-dc 0
    Write-BoxstarterMessage "Setting Disk Timeout to Never"
    & powercfg.exe -change -disk-timeout-ac 0
    & powercfg.exe -change -disk-timeout-dc 0
    Write-BoxstarterMessage "Turning off Windows Hibernation"
    & powercfg.exe -h off
    Write-BoxstarterMessage "Setting time zone to Central Standard Time"
    & $env:windir\system32\tzutil /s "Central Standard Time"
    Write-BoxstarterMessage "Stopping touch keyboard service"
    & net stop TabletInputService # untested

    cinst 7zip
    cinst fiddler4
    cinst githubforwindows
    cinst Console2
    cinst sublimetext2
    cinst SublimeText2.PackageControl
    cinst googlechrome
    cinst SourceCodePro
    cinst wizmouse

    cinst IIS-WebServerRole -source windowsfeatures
    cinst IIS-HttpCompressionDynamic -source windowsfeatures
    cinst IIS-ManagementScriptingTools -source windowsfeatures
    cinst IIS-WindowsAuthentication -source windowsfeatures

    $env:Path = "$env:Path;${env:ProgramFiles(x86)}\Git\cmd"

    $sublimeDir = "$env:programfiles\Sublime Text 2"
    $sublimePackagesDir = "$env:APPDATA\Sublime Text 2\Packages"

    if(!(Test-Path "$sublimePackagesDir\Theme - Soda")) {
        Write-BoxstarterMessage "Cloning the Sublime Text theme Soda"
        New-Item -ItemType Directory -Path "$sublimePackagesDir\Theme - Soda" -Force | Out-Null
        & git clone "https://github.com/buymeasoda/soda-theme/" "$sublimePackagesDir\Theme - Soda"
    }

    Write-BoxstarterMessage "Copying personal Sublime Text settings"
    New-Item -ItemType Directory -Path "$sublimePackagesDir\User" -Force | Out-Null
    Copy-Item (Join-Path (Get-PackageRoot($MyInvocation)) 'configs\sublime\*') -Force -Recurse "$sublimePackagesDir\User"

    Write-BoxstarterMessage "Copying personal global gitignore and gitconfig"
    Copy-Item (Join-Path (Get-PackageRoot($MyInvocation)) 'configs\local.gitignore_global') -Force -Recurse "$env:userprofile\.gitignore_global"
    Copy-Item (Join-Path (Get-PackageRoot($MyInvocation)) 'configs\local.gitconfig') -Force -Recurse "$env:userprofile\.gitconfig"

    Write-BoxstarterMessage "Installing PowerShell settings..."
    $documentsDir = [environment]::getfolderpath("mydocuments")
    New-Item -ItemType Directory -Path "$documentsDir\WindowsPowerShell" -Force | Out-Null
    Copy-Item (Join-Path (Get-PackageRoot($MyInvocation)) 'configs\Microsoft.PowerShell_profile.ps1') -Force -Recurse "$documentsDir\WindowsPowerShell"

    $console2Dir = Join-Path "$env:ChocolateyInstall\lib" (Get-ChildItem "$env:ChocolateyInstall\lib" | ?{$_.name -match "^console2\.\d+"})
    Write-BoxstarterMessage "Copying personal Console2 settings to $console2Dir\bin..."
    Copy-Item (Join-Path (Get-PackageRoot($MyInvocation)) 'configs\console.xml') -Force -Recurse "$console2Dir\bin"

    Write-BoxstarterMessage "Setting up pinned task bar items"
    Install-ChocolateyPinnedTaskBarItem "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\devenv.exe"
    Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Google\Chrome\Application\chrome.exe"
    Install-ChocolateyPinnedTaskBarItem "$console2Dir\bin\Console.exe"
    Install-ChocolateyPinnedTaskBarItem "$sublimeDir\sublime_text.exe"

    Install-ChocolateyFileAssociation ".txt" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".log" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".config" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".xml" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".ps1" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".psm" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".cs" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".cshtml" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".csproj" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".rb" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".js" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".css" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".less" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".pl" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".sh" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".java" "$env:programfiles\Sublime Text 2\sublime_text.exe"

    Install-WindowsUpdate -AcceptEula

    # $password = Read-AuthenticatedPassword
    # Set-SecureAutoLogon -Username $env:username -Password $password

    Write-ChocolateySuccess 'DevBox'
} catch {
  Write-ChocolateyFailure 'DevBox' $($_.Exception.Message)
  throw
}
