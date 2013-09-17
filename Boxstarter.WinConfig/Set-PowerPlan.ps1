function Set-PowerPlan { 
<#
.SYNOPSIS
Sets Windows power plan to one of three settings (High performance, Balanced, Power saver)

.PARAMETER preferredPlan
Must be one of the following: "High performance", "Balanced", "Power saver"

.LINK
http://blogs.msdn.com/b/aaronsaikovski/archive/2011/04/21/setting-your-machine-power-plan-via-powershell.aspx

#>  
    param( 
        [Parameter(Mandatory=$true)][ValidateSet("High performance", "Balanced", "Power saver")][string]$preferredPlan 
    )
    Write-BoxstarterMessage "Setting Windows power plan to $preferredPlan" 
    $guid = (Get-WmiObject -Class win32_powerplan -Namespace root\cimv2\power -Filter "ElementName='$preferredPlan'").InstanceID.tostring() 
    $regex = [regex]"{(.*?)}$" 
    $newpowerVal = $regex.Match($guid).groups[1].value
    powercfg -S $newpowerVal
}