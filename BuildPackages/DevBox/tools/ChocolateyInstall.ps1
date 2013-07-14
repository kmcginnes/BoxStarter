try {
    Install-WindowsUpdate -AcceptEula
    Update-ExecutionPolicy Unrestricted
    Set-ExplorerOptions -showHidenFilesFoldersDrives -showFileExtensions
    & powercfg.exe -h off # Turn off Hibernation

    # cinstm VisualStudio2012Ultimate
    # if((Get-Item "$($Boxstarter.programFiles86)\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe").VersionInfo.ProductVersion -lt "11.0.60115.1") {
    #     if(Test-PendingReboot){Invoke-Reboot}
    #     cinstm Dogtail.VS2012.2
    # }
    cinstm fiddler4
    # cinstm mssqlserver2012express
    # cinstm git-credential-winstore
    cinstm githubforwindows
    cinstm ConsoleZ
    cinstm sublimetext2
    cinstm SublimeText2.PackageControl
    # cinstm SublimeText2.PowershellAlias
    # cinstm poshgit
    # cinstm dotpeek
    # cinstm googlechrome
    # cinstm Paint.net
    # cinstm windirstat
    # cinstm resharper
    cinstm SourceCodePro
    cinstm MesloLG.DZ
    cinstm dejavu.font
    
    cinst git_reflow -source ruby

    # cinst IIS-WebServerRole -source windowsfeatures
    # cinst IIS-HttpCompressionDynamic -source windowsfeatures
    # cinst IIS-ManagementScriptingTools -source windowsfeatures
    # cinst IIS-WindowsAuthentication -source windowsfeatures

    $sublimeDir = "$env:programfiles\Sublime Text 2"
    $sublimeUserDir = "$env:APPDATA\Roaming\Sublime Text 2"

    & git clone "https://github.com/buymeasoda/soda-theme/" "$sublimeUserDir\Theme - Soda"

    copy-item (Join-Path (Get-PackageRoot($MyInvocation)) 'sublime\*.tmTheme') -Force -Recurse "$sublimeUserDir\Packages\User"
    copy-item (Join-Path (Get-PackageRoot($MyInvocation)) 'sublime\*.sublime-settings') -Force -Recurse "$sublimeUserDir\Packages\User"

    Install-ChocolateyPinnedTaskBarItem "$sublimeDir\sublime_text.exe"
    Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Google\Chrome\Application\chrome.exe"
    Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe"

    Install-ChocolateyFileAssociation ".txt" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".ps1" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".cs" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".cshtml" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".csproj" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".js" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".css" "$env:programfiles\Sublime Text 2\sublime_text.exe"
    Install-ChocolateyFileAssociation ".less" "$env:programfiles\Sublime Text 2\sublime_text.exe"

    # if(!(Test-Path("$sublimeDir\data")){mkdir "$sublimeDir\data"}
    # copy-item (Join-Path (Get-PackageRoot($MyInvocation)) 'sublime\*') -Force -Recurse "$sublimeDir\data"
    # move-item "$sublimeDir\data\Pristine Packages\*" -Force "$sublimeDir\Pristine Packages"
    # copy-item (Join-Path (Get-PackageRoot($MyInvocation)) 'console.xml') -Force $env:appdata\console\console.xml

    # Install-ChocolateyVsixPackage xunit http://visualstudiogallery.msdn.microsoft.com/463c5987-f82b-46c8-a97e-b1cde42b9099/file/66837/1/xunit.runner.visualstudio.vsix
    # Install-ChocolateyVsixPackage autowrocktestable http://visualstudiogallery.msdn.microsoft.com/ea3a37c9-1c76-4628-803e-b10a109e7943/file/73131/1/AutoWrockTestable.vsix
    # Install-ChocolateyVsixPackage vscommands http://visualstudiogallery.msdn.microsoft.com/a83505c6-77b3-44a6-b53b-73d77cba84c8/file/74740/18/SquaredInfinity.VSCommands.VS11.vsix

    Write-ChocolateySuccess 'DevBox'
} catch {
  Write-ChocolateyFailure 'DevBox' $($_.Exception.Message)
  throw
}
