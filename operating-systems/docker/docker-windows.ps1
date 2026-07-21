# https://hub.docker.com/r/dockurr/windows
# https://github.com/dockur/windows
# https://computingforgeeks.com/how-to-run-windows-on-docker-with-docker-compose/

# NOTE: works as is, change VERSION=10 for win10
# docker run -it --rm --name windows -e "VERSION=11" -p 8006:8006 --device=/dev/kvm --device=/dev/net/tun --cap-add NET_ADMIN -v "${PWD:-.}/windows:/storage" --stop-timeout 120 docker.io/dockurr/windows
# http://127.0.0.1:8006/ QEMU VNC

# If you want a fully containerized thing
# windows 10 on

$cwd = Get-Location
$isodir = [IO.Path]::GetFullPath("/temp/dockurr/iso/")
New-Item -ItemType Directory -Path $isodir -ErrorAction SilentlyContinue
Set-Location $isodir

$isos = @(
    'https://archive.org/download/Windows-10-22H2-July-2024-64-bit-DVD-English/en-us_windows_10_business_editions_version_22h2_updated_july_2024_x64_dvd_c004521a.iso',
    'https://archive.org/download/Win11_24H2_English_x64/Win11_24H2_English_x64.iso'
)
$jobs = @()
$isos.foreach({
    $url = $_
    $tokens = ($url -split '/')
    $filename = $($tokens[$tokens.Count - 1])
    Write-Host "downloading $url"
    $jobs += @(Start-BitsTransfer -Source $url -Destination $filename -Asynchronous)
    # wget -UseBasicParsing  # slow, buffers to mem before disk
})
# async are jobs, so wait on them.
Get-BitsTransfer
$Activity = "Downloading"
# Transferring->Transferred
while ($jobs | Where-Object { $_.JobState -eq "Transferring" }) {
    $total_bytes = ($jobs | Select-Object -ExpandProperty BytesTotal | Measure-Object -Sum).Sum
    $elapsed_bytes = ($jobs | Select-Object -ExpandProperty BytesTransferred | Measure-Object -Sum).Sum

    $PercentComplete = $elapsed_bytes / $total_bytes * 100
    $Status = "$($jobs.Count) Files @ $PercentComplete%"
    Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete
    Start-Sleep 1
}
Get-BitsTransfer | Complete-BitsTransfer

# for some reason they're hidden???
Get-ChildItem -Path $isodir -Force -Recurse | ForEach-Object {
    Set-ItemProperty -Path $_.FullName -Name Attributes -Value Normal
}

Set-Location $cwd

$docker_compose_yaml = @"
services:
    windows:
      image: dockurr/windows
      container_name: windows
      environment:
          VERSION: "10"
          DISK_SIZE: "128G"
          RAM_SIZE: "32G"
          CPU_CORES: "8"
          USERNAME: "Docker"
          PASSWORD: "admin"
      devices:
          - /dev/kvm
          - /dev/net/tun
      cap_add:
          - NET_ADMIN
      ports:
          - 8006:8006
          - 3389:3389/tcp
          - 3389:3389/udp
      volumes:
          - C:/temp/dockurr/w10/storage:/storage
          - C:/temp/dockurr/w10/shared:/shared
          - C:/temp/dockurr/iso/en-us_windows_10_business_editions_version_22h2_updated_july_2024_x64_dvd_c004521a.iso:/boot.iso
      networks:
          vlan:
              ipv4_address: 192.168.0.100
      restart: always
      stop_grace_period: 2m

networks:
    vlan:
        external: true
"@

# vlan is the name of the network
docker network create -d macvlan `
    --subnet=192.168.0.0/24 `
    --gateway=192.168.0.1 `
    --ip-range=192.168.0.100/28 `
    -o parent=eth0 `
    vlan

$compose_file = 'operating-systems\docker/docker-compose-windows.yaml'
$compose_file = "$PSScriptRoot/docker-compose-windows.yaml"

Set-Content -Path $compose_file -Value $docker_compose_yaml

docker compose -f $compose_file up -d  # start detached
# http://127.0.0.1:8006/ QEMU VNC

docker compose -f $compose_file logs -f  # log

docker compose -f $compose_file down
