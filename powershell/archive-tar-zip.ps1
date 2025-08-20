
function Invoke-ZipProblemFolders {
    <#
    Zips folders that contain any files with the extensions given
    ex) $path = folder, $Extensions = png,jpg
        folder
            file.txt
            subfolder
                file.txt
                png.jpg
                subsubfolder
                    png.jpg
        -->
        folder
            file.txt
            subfolder.zip

    Does not use Compress-Archive, rather "system.io.compression.filesystem", also optionally gz instead

    temp_dir
    folders = Get folders with problems
    for src in src_folders
        parent = src.parent
        temp_src = copy src temp
        zip = zip(temp_scr)
        del src
        copy zip parent
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][String]$Path,
        [Parameter(Mandatory=$true)][String[]]$Extensions,
        [Parameter()][Switch]$Tar
    )

    Add-Type -assembly "system.io.compression.filesystem"
    $StartTime = $(Get-Date)

    $Temporary = New-TemporaryDirectory
    Write-Host $Temporary
    if ($PSBoundParameters['Verbose']) {
        Write-Host "created temporary path $($Temporary.FullName)"
    }
    $Folders = Find-FoldersContainingExtensionProgress -Path $Path -Extensions $Extensions
    $UncompressedSize = 0
    $CompressedSize = 0
    $Length = $Folders.Length
    $I = 0

    $PercentComplete = 0
    $UncompressedSizeMb = [System.Math]::Round($UncompressedSize / 1MB, 2)
    $CompressedSizeMb = [System.Math]::Round($CompressedSize / 1MB, 2)
    $CompressionRatio = 0

    foreach ($Folder in $Folders) {
        # identify src, mid, dest
        $Folder_Item = Get-Item (Resolve-Path -LiteralPath $Folder)
        $Src = Get-FileFullName -PathObject $Folder_Item
        $Src_Parent = Split-Path -Path $Folder
        $Src_Name = Get-FileName -PathObject $Folder_Item
        $Dest_Folder = [IO.Path]::GetFullPath("$Src_Parent/$Src_Name")
        $Mid = [IO.Path]::GetFullPath("$($Temporary.FullName)/$Src_Name")
        if ($PSBoundParameters['Verbose']) {
            Write-Host "    $Src"
        }

        # offload to local and zip it
        if ($PSBoundParameters['Verbose']) {
            Write-Host "        Copying $Src to $Mid"
        }
        Copy-Item -Path $Src -Destination $Mid -Recurse -Force

        if ($Tar) {
            # where folder is inside Temp, and you only wnat the contents of folder...
            # tar czpvf backup.tar.gz -C C:\Temp\folder *

            $Mid_Zip = "$Mid.tar.gz"
            $Dest_Zip = [IO.Path]::GetFullPath("$Dest_Folder/$Src_Name.tar.gz")
            if ($PSBoundParameters['Verbose']) {
                Write-Host "        gZipping $Mid to $Mid_Zip"
            }
            $(tar -czpf $Mid_Zip -C $Mid *) | Out-Null

        } else {
            # $Compression_Command = "Compress-Archive -Path '$Mid\*.*' -DestinationPath '$Mid_Zip'"
            # Invoke-Expression $Compression_Command

            $Mid_Zip = "$Mid.zip"
            $Dest_Zip = [IO.Path]::GetFullPath("$Dest_Folder/$Src_Name.zip")
            if ($PSBoundParameters['Verbose']) {
                Write-Host "        Zipping $Mid to $Mid_Zip"
            }
            [io.compression.zipfile]::CreateFromDirectory($Mid, $Mid_Zip)
        }

        # get size info before resolving
        $Mid_Item = Get-Item $Mid
        $Mid_Zip_Item = Get-Item $Mid_Zip
        $UncompressedSize += Get-PathObjectSize -PathObject $Mid_Item
        $CompressedSize += Get-PathObjectSize -PathObject $Mid_Zip_Item

        # Finalize dest
        if ($PSBoundParameters['Verbose']) {
            Write-Host "        Removing $Src"
        }
        Remove-Item -Path $Src -Recurse -Force
        Remove-Item -Path $Mid -Recurse -Force
        New-Item -ItemType Directory $Dest_Folder -ErrorAction SilentlyContinue | Out-Null
        if ($PSBoundParameters['Verbose']) {
            Write-Host "        Moving $Mid_Zip -> $Dest_Zip"
        }
        Move-Item -Path $Mid_Zip -Destination $Dest_Zip -Force

        $I += 1
        $PercentComplete = $I / $Length * 100
        $UncompressedSizeMb = [System.Math]::Round($UncompressedSize / 1MB, 2)
        $CompressedSizeMb = [System.Math]::Round($CompressedSize / 1MB, 2)
        if ($UncompressedSize -gt 0) {
            $CompressionRatio = [System.Math]::Round(($UncompressedSize - $CompressedSize) / $UncompressedSize * 100, 2)
        } else {
            $CompressionRatio = 0
        }
        $ElapsedTime = $(Get-Date) - $StartTime
        $TotalTime = "{0:dd\:hh\:mm\:ss}" -f ([timespan]::fromseconds( $ElapsedTime.TotalSeconds ))
        $Predicted = "{0:dd\:hh\:mm\:ss}" -f ([timespan]::fromseconds( $ElapsedTime.TotalSeconds / $I * ($Length - $I) ))  # \,fff
        $Status = "$PercentComplete% ($I/$Length) Uncompressed: $UncompressedSizeMb mb; Compressed: $CompressedSizeMb mb; Compression: $CompressionRatio; Elapsed: $TotalTime; ETA: $Predicted"
        if ($PSBoundParameters['Verbose']) {
            Write-Host "$Status"
        } else {
            Write-Progress -Activity "Zipped '$Folder'" -Status $Status -PercentComplete $PercentComplete
        }
    }
    Remove-Item -Path $Temporary -Recurse -Force
    Write-Output "$Status"
}



# $Extensions = Find-ExtensionsProgress -Path "~/src"
# $Extensions.GetEnumerator() | ForEach-Object {Write-Output "$($_.Key): $($_.Value)"}
# Write-Output $Extensions

# Invoke-ZipProblemFolders -Path "~/src" -Tar -Extensions .txt,.log  # -Verbose

Invoke-ZipProblemFolders -Path "~/src" -Tar -Extensions .txt,.log,.txt  # -Verbose

# Invoke-ZipProblemFolders -Path "~/src" -Extensions .log  # -Verbose
# $Folders = Find-FoldersContainingExtensionProgress -Path "~/src" -Extensions .log -Verbose
# Write-Output $Folders
