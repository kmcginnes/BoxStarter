Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Reclaim a ton of disk space from branches that have been built but aren't actively needed
# It's hard-coded with my code folder and MYAPP:\ so I can call it from anywhere, but
# it can be made more generic and simplified with James Tryand's walk function further down
Function Clean-All
{
    pushd Z:\Projects\
    Get-ChildItem -Directory | % {
        pushd $_
        Get-Item *.sln | % {
            Write-Host ("    Cleaning {0}" -f $_.ToString().Replace("Z:\Projects\", "")) -F Yellow
            &'msbuild' /t:Clean /nologo /v:m $_
        }
        popd
    }
    popd
    Write-Host ""
}

#Set environment variables for Visual Studio Command Prompt
$visualStudioPath = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio 12.0\VC"
$visualStudioVersion = "2013"
if(!(Test-Path $visualStudioPath)) {
    $visualStudioPath = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio 11.0\VC"
    $visualStudioVersion = "2012"
}
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

Set-Alias subl 'C:\Program Files\Sublime Text 2\sublime_text.exe'

# Launch explorer in current folder
Function e { ii . }
# Launch VS for sln(s) in current folder
Function VS { ii *.sln }

# Set up a simple prompt, adding the git prompt parts inside git repos
function prompt {
    $realLASTEXITCODE = $LASTEXITCODE
    
    $newline = [Environment]::NewLine

    $dt= "`n[{0:ddd, MMM d hh:mm:ss}] " -f (get-date)
    Write-Host $dt -NoNewline -ForegroundColor Cyan

    Write-Host($pwd) -nonewline -ForegroundColor Green

    $global:LASTEXITCODE = $realLASTEXITCODE
    return $newline + "--> "
}

Pop-Location
