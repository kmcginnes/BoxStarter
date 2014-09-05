Disable-UAC
Update-ExecutionPolicy Unrestricted
 
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions -EnableShowFullPathInTitleBar
Set-StartScreenOptions -EnableBootToDesktop -EnableDesktopBackgroundOnStart -EnableShowStartOnActiveScreen -EnableShowAppsViewOnStartScreen -EnableSearchEverywhereInAppsView -EnableListDesktopAppsFirst
Set-TaskbarOptions -Lock -Dock Left
 
Write-BoxstarterMessage "Setting Windows power plan to $preferredPlan" 
$guid = (Get-WmiObject -Class win32_powerplan -Namespace root\cimv2\power -Filter "ElementName='High performance'").InstanceID.tostring() 
$regex = [regex]"{(.*?)}$" 
$newpowerVal = $regex.Match($guid).groups[1].value
powercfg -S $newpowerVal
 
Write-BoxstarterMessage "Setting Standby Timeout to Never"
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0
 
Write-BoxstarterMessage "Setting Monitor Timeout to Never"
powercfg -change -monitor-timeout-ac 0
powercfg -change -monitor-timeout-dc 0
 
Write-BoxstarterMessage "Setting Disk Timeout to Never"
powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 0
 
Write-BoxstarterMessage "Turning off Windows Hibernation"
powercfg -h off
 
Write-BoxstarterMessage "Setting time zone to Central Standard Time"
& C:\Windows\system32\tzutil /s "Central Standard Time"

cinst 7zip
cinst SublimeText3
cinst SublimeText3.PackageControl
cinst sublimetext3-contextmenu
cinst googlechrome
cinst SourceCodePro
cinst wizmouse
cinst githubforwindows
cinst NuGet.CommandLine
cinst msbuild.communitytasks
cinst wpfinspector
cinst console2
cinst wincommandpaste
# cinst Office365HomePremium

cinst hst
hst add buildserver1 10.1.12.110

# Memory disk apps

cinst imdisk

# freefilesync install is not working right now
# cinst autoit #required by freefilesync
# cinst freefilesync 
 
# This should be a search for CasPol.exe and then loop over all results
& C:\Windows\Microsoft.Net\Framework64\v4.0.30319\CasPol.exe -pp off -m -ag 1.2 -url file:///Z:/Projects/* FullTrust
& C:\Windows\Microsoft.Net\Framework\v4.0.30319\CasPol.exe -pp off -m -ag 1.2 -url file:///Z:/Projects/* FullTrust


# Visual Studio 2013

cinst VisualStudio2013Ultimate -InstallArguments "/Features:'Blend WebTools Win8SDK SQL WindowsPhone80 SilverLight_Developer_Kit'"
cinst VSColorOutput
cinst resharper
cinst ncrunch2.vs2013
cinst editorconfig.vs
Install-ChocolateyVsixPackage "HideMainMenu" http://visualstudiogallery.msdn.microsoft.com/bdbcffca-32a6-4034-8e89-c31b86ad4813/file/18183/2/HideMenu.vsix
Install-ChocolateyVsixPackage "SqlCeToolbox" http://visualstudiogallery.msdn.microsoft.com/0e313dfd-be80-4afb-b5e9-6e74d369f7a1/file/29445/68/SqlCeToolbox.vsix
