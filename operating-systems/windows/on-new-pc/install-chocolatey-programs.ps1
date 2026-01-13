<#
Author:         Chris Carl
Email:          chrisbcarl@outlook.com
Date:           2025-11-25
Description:
    way to send this settings file to appdata just in case.
    Algo:
        copy bootstrap settings to user path
        read the bootstrap/settings.json by clearing out all of the comments
        read-replace-write any global-specific settings to the user path

Updates:
    2026-01-05 21:26 - install-chocolatey-programs - pretty big re-do of the system to support 'slim' and specific section installation
    2025-08-28 15:49 - install-chocolatey-programs - initial commit

#>

[CmdletBinding()]
param (
    [Parameter()][string[]]$Sections=@(),
    [Parameter()][switch]$Slim,
    [Parameter()][switch]$All,
    [Parameter()][switch]$Dry
)


if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Not admin!"
    exit 1
}


if (($Sections.Count -eq 0) -and (-Not $Slim) -and (-Not $All)) {
    Write-Warning "Provide at least one or all of the arguments!"
    exit 1
}


$Chocolatey = @{
    languages=@{
        slim=$true;
        postcmds=@();
        packages=@"
python2
python36
python38
python312
python310
nodejs dotnet
dotnet-9.0-runtime dotnet-8.0-runtime
wkhtmltopdf miktex rsvg-convert pandoc
"@;
    };
    databases = @{
        slim=$false;
        postcmds=@();
        packages=@"
sqlserver-odbcdriver sql-server-management-studio
sql-server-express
"@;
    };
    dev_env = @{
        slim=$true;
        postcmds=@();
        packages=@"
git git-lfs svn tortoisesvn sysinternals InnoSetup
mingw  # gets you gcc.exe, make, etc.
"@;
    };
    dev_services = @{
        slim=$false;
        postcmds=@(
            "if (-Not (Test-Path C:\ProgramData\mingw64\mingw64\bin\make.exe -ErrorAction SilentlyContinue)) { cmd /c mklink /h C:\ProgramData\mingw64\mingw64\bin\make.exe C:\ProgramData\mingw64\mingw64\bin\mingw32-make.exe } else { echo exists }"  # alias mingw make to make
        );
        packages=@"
nginx rabbitmq docker-desktop docker-cli
"@;
    };
    dev_editors = @{
        slim=$true;
        postcmds=@();
        packages=@"
vscode sublimetext3 notepadplusplus
visualstudio2022buildtools visualstudio2022community
"@;
    };
    utils = @{
        slim=$true;
        postcmds=@();
        packages=@"
7zip putty winscp everything rufus spacesniffer grepwin
"@;
    };
    cloud = @{
        slim=$true;
        postcmds=@();
        packages=@"
googledrive dropbox
"@;
    };
    web = @{
        slim=$true;
        postcmds=@();
        packages=@"
googlechrome firefox microsoft-edge opera
"@;
    };
    media = @{
        slim=$true;
        postcmds=@();
        packages=@"
k-litecodecpackmega
gimp imagemagick ghostscript audacity obs vlc qbittorrent ffmpeg screentogif
"@;
    };
    messaging = @{
        slim=$true;
        postcmds=@();
        packages=@"
discord zoom
"@;
    };
    networking = @{
        slim=$true;
        postcmds=@();
        packages=@"
nordvpn
"@;
    };
    security = @{
        slim=$false;
        postcmds=@();
        packages=@"
malwarebytes
"@;
    };
    overclocking = @{
        slim=$false;
        postcmds=@();
        packages=@"
intel-rst-driver intel-ipdt intel-xtu
# msiafterburner evga-precision-x1
"@;
    };
    benchmarks = @{
        slim=$true;
        postcmds=@();
        packages=@"
crystaldiskmark crystaldiskinfo cpu-z gpu-z hwinfo cinebench
"@;
    };
    gaming = @{
        slim=$false;
        postcmds=@();
        packages=@"
steam ea-app razer-synapse-4
"@;
    };
}


foreach ($Section in $Sections) {
    if ($null -eq $Chocolatey[$Section]) {
        Write-Warning "Section $Section does not exist!"
        exit 1
    }
}
Write-Host "Validated."


foreach ($item in $Chocolatey.GetEnumerator()) {
    $Name = $item.Key
    $Section = $item.Value
    $SectionSlim = $Section["slim"]
    if ($All -or ($Slim -and $SectionSlim) -or ($Sections.Contains($Name))) {
        $SectionPackages = $Section["packages"]

        $SectionPackages = $SectionPackages -replace "#.+",""
        $SectionPackages = $SectionPackages.TrimEnd()
        $SectionPackages = $SectionPackages -split "\s{1,}"
        Write-Host -ForegroundColor Green "    installing $Name - $SectionPackages..."

        $SectionPostCmds = $Section["postcmds"]

        foreach ($SectionPackage in $SectionPackages) {
            $cmd = "choco install $SectionPackage --yes"
            Write-Host -ForegroundColor Cyan "        $cmd"
            if (-Not $Dry) {
                choco install $SectionPackage --yes  # i'd rather see the whole stdout live
                if ($LASTEXITCODE -ne 0) {
                    Write-Warning "        Failed: '$Name' install $cmd, exit code: $LASTEXITCODE"
                    exit $LASTEXITCODE
                }
            }
        }

        $SectionPostCmds | ForEach-Object {
            Write-Host -ForegroundColor Cyan "        $_"
            if (-Not $Dry) {
                $cmd = "`$global:LASTEXITCODE = 0; $_; return `$LASTEXITCODE"
                $res = (Invoke-Expression $cmd)  # capture stdout
                Write-Host $res
                if ($LASTEXITCODE -ne 0) {
                    Write-Warning "        Failed: '$Name' postcmd $_, exit code: $LASTEXITCODE"
                    exit $LASTEXITCODE
                }
            }
        }
    } else {
        Write-Host "    skipping '$Name'"
    }
}