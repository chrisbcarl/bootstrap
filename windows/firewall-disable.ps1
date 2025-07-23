[CmdletBinding()]
param (
    [Parameter()][Int[]]$PortsExclude=@(
        32400  # Plex Media Server
    ),
    [Parameter()][switch]$Dry
)


function isadmin {
    # https://ss64.com/ps/syntax-elevate.html
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
If (-NOT (isadmin)) {
    # Relaunch as an elevated process:
    Start-Process powershell.exe "-noprofile", "-executionpolicy", "bypass", "-File", ('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
    exit
}


# get port ranges
$port_midpoints = @(0)
foreach ($port_exclude in $PortsExclude) {
    $port_midpoints += @(($port_exclude - 1), ($port_exclude + 1))
}
$port_midpoints += 65535


# get commands
Write-Host "Generating cmds..."
$profiles = @()
$cmds = @()
for ($i = 0; $i -lt $port_midpoints.Count; $i+=2) {
    $lo = $port_midpoints[$i]
    $hi = $port_midpoints[$i + 1]
    $cmds += @(
        "New-NetFirewallRule -DisplayName 'TempBlockInTCP-$i' -Profile 'Any' -Direction Inbound -Action Block -Protocol TCP -LocalPort '$lo-$hi'",
        "New-NetFirewallRule -DisplayName 'TempBlockInUDP-$i' -Profile 'Any' -Direction Inbound -Action Block -Protocol UDP -LocalPort '$lo-$hi'",
        "New-NetFirewallRule -DisplayName 'TempBlockOutTCP-$i' -Profile 'Any' -Direction Outbound -Action Block -Protocol TCP -LocalPort '$lo-$hi'",
        "New-NetFirewallRule -DisplayName 'TempBlockOutUDP-$i' -Profile 'Any' -Direction Outbound -Action Block -Protocol UDP -LocalPort '$lo-$hi'",
        "Set-NetFirewallRule -DisplayName 'TempBlockInTCP-$i' -Enabled True",
        "Set-NetFirewallRule -DisplayName 'TempBlockInUDP-$i' -Enabled True",
        "Set-NetFirewallRule -DisplayName 'TempBlockOutTCP-$i' -Enabled True",
        "Set-NetFirewallRule -DisplayName 'TempBlockOutUDP-$i' -Enabled True"
    )
    $profiles += @(
        "TempBlockInTCP-$i",
        "TempBlockInUDP-$i",
        "TempBlockOutTCP-$i",
        "TempBlockOutUDP-$i"
    )
}
foreach ($cmd in $cmds) {
    Write-Host -ForegroundColor Cyan $cmd
    if (-Not $Dry) {
        Invoke-Expression $cmd
    }
}


# wait for ctrl + c
# https://stackoverflow.com/a/70441768
Write-Warning "WARING: waiting for ctrl + c..."
[console]::TreatControlCAsInput = $true
try {
    while ($true){
        if ([Console]::KeyAvailable){
            $readkey = [Console]::ReadKey($true)
            if ($readkey.Modifiers -eq "Control" -and $readkey.Key -eq "C"){
                Write-Host -ForegroundColor Green "ctrl + c detected..."
                break
            } else {
                Start-Sleep -Seconds 1
            }
        }
    }
}
catch {
    Write-Host -ForegroundColor Green "ctrl + c or some other exception detected..."
}


# undo things
Write-Warning "WARING: undoing firewall rules..."
$cmds = $profiles | ForEach-Object {"Remove-NetFirewallRule -DisplayName '$_'"}
foreach ($cmd in $cmds) {
    Write-Host -ForegroundColor Cyan $cmd
    if (-Not $Dry) {
        Invoke-Expression $cmd
    }
}


Write-Host -ForegroundColor Green "Done!"


# New-NetFirewallRule -DisplayName "Allow Inbound Telnet" -Direction Inbound -Program %SystemRoot%\System32\tlntsvr.exe -RemoteAddress LocalSubnet -Action Allow
# New-NetFirewallRule -DisplayName "Block Outbound Telnet" -Direction Outbound -Program %SystemRoot%\System32\tlntsvr.exe -Protocol TCP -LocalPort 23 -Action Block -PolicyStore domain.contoso.com\gpo_name
# New-NetFirewallRule -DisplayName 'Custom Inbound' -Profile @('Domain', 'Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort 11000-12000
# Set-NetFirewallRule -DisplayGroup "Windows Firewall Remote Management" -Enabled True
# Remove-NetFirewallRule -DisplayName "Allow Web 80"

# 32400

# New-NetFirewallRule -DisplayName 'PlexOnly-Inbound-1' -Profile "Any" -Direction Inbound -Action Block -Protocol TCP -LocalPort "0-32399"
# New-NetFirewallRule -DisplayName 'PlexOnly-Inbound-2' -Profile "Any" -Direction Inbound -Action Block -Protocol TCP -LocalPort "32401-65535"
# New-NetFirewallRule -DisplayName 'PlexOnly-Outbound-1' -Profile "Any" -Direction Outbound -Action Block -Protocol TCP -LocalPort "0-32399"
# New-NetFirewallRule -DisplayName 'PlexOnly-Outbound-2' -Profile "Any" -Direction Outbound -Action Block -Protocol TCP -LocalPort "32401-65535"

# Set-NetFirewallRule -DisplayName 'PlexOnly-Inbound-1' -Enabled False
# Set-NetFirewallRule -DisplayName 'PlexOnly-Inbound-2' -Enabled False
# Set-NetFirewallRule -DisplayName 'PlexOnly-Outbound-1' -Enabled False
# Set-NetFirewallRule -DisplayName 'PlexOnly-Outbound-2' -Enabled False

# # Set-NetFirewallRule -DisplayName 'BranchCache Hosted Cache Server(HTTP-Out)' -Enabled False

# 32400

# $netpath = [IO.Path]::GetFullPath($(Resolve-Path -Path '~').ToString() + '/desktop/netstat')
# New-Item -ItemType Directory -Path $netpath -ErrorAction SilentlyContinue

#   78 Set-NetFirewallRule -DisplayGroup 'BranchCache Hosted Cache Server(HTTP-Out)' -Enabled False
#   79 Set-NetFirewallRule -DisplayName 'BranchCache Hosted Cache Server(HTTP-Out)' -Enabled False
#   88 (Get-Content C:\Windows\System32\LogFiles\Firewall\pfirewall-private.log)
#   80 (Get-Content C:\Windows\System32\LogFiles\Firewall\pfirewall-private.log) -notmatch "127.0.0.1" | findstr " 80 "
#   81 (Get-Content C:\Windows\System32\LogFiles\Firewall\pfirewall-private.log) -notmatch "127.0.0.1" | findstr " 443 "
#   89 (Get-Content C:\Windows\System32\LogFiles\Firewall\pfirewall-private.log) -notmatch "127.0.0.1" | findstr " 32400 "
