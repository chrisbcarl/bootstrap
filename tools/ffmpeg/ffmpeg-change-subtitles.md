TODO: switch to ffmpeg instead of mkvmerge
mkvmerge

```batch
mkdir output
for %%a in ("*.mkv") do mkvmerge.exe -o "output\%%~na.mkv" ^
--audio-tracks 1 ^
--subtitle-tracks 3 ^
--default-track 1 ^
--default-track 3 ^
--forced-track 1:0 ^
--forced-track 2:0 ^
--forced-track 3:1 ^
--forced-track 4:0 ^
"%%a"
```
