function Disable-LockScreen
{
<#
.SYNOPSIS
Turns off the lock screen in Windows 8 and above that only makes sense on tablets

.LINK
http://boxstarter.codeplex.com

#>
    $key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization'
    Set-ItemProperty $key NoLockScreen 1
}
