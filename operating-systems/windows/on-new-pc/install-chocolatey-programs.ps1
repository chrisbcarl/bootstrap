if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Not admin!"
    exit 1
}


# languages
choco install python2 --yes
choco install python36 --yes
choco install python38 --yes
choco install python312 --yes
choco install python310 --yes
choco install nodejs dotnet --yes
choco install dotnet-9.0-runtime dotnet-8.0-runtime --yes
# databases
choco install sqlserver-odbcdriver sql-server-management-studio --yes
choco install sql-server-express --yes
# dev ops
choco install git git-lfs svn tortoisesvn sysinternals nginx rabbitmq docker-desktop docker-cli InnoSetup --yes
# dev tools
choco install vscode sublimetext3 notepadplusplus --yes
choco install visualstudio2022buildtools visualstudio2022community --yes
choco install mingw --yes  # gets you gcc.exe, etc.
# utils - dope programs to have
choco install 7zip putty winscp everything rufus spacesniffer grepwin --yes
# cloud
choco install googledrive dropbox --yes
# web browsers
choco install googlechrome firefox microsoft-edge opera --yes
# media
choco install k-litecodecpackmega --yes
choco install gimp imagemagick audacity obs vlc qbittorrent ffmpeg --yes
# messaging
choco install discord zoom --yes
# networking
choco install nordvpn --yes
# security
choco install malwarebytes --yes
# overclocking
# choco install intel-rst-driver intel-ipdt intel-xtu --yes
choco install msiafterburner evga-precision-x1 razer-synapse-3 --yes
# benchmarks
choco install crystaldiskmark crystaldiskinfo cpu-z gpu-z hwinfo cinebench --yes
# gaming
choco install steam ea-app --yes
