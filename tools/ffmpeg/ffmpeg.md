- Info
    - ffmpeg -hide_banner -h encoder=hevc_nvenc
    - ffmpeg -hide_banner -h encoder=h264_nvenc


- Copy Right Audio Channel to Left Channel
    - ffmpeg -i "input.avi" -c:v copy -af "pan=stereo|FR=FR|FL=FR" "output.avi"
- Overwrite
    - ffmpeg -y
- Fixed bitrate 320kbps
    - ffmpeg -i {src.mp4} -vn -acodec libmp3lame -ac 2 -ab 320k -ar 48000 {dest.mp3}
- VBR
    - ffmpeg -i {src.mp4} -vn -acodec libmp3lame -ac 2 -qscale:a 4 -ar 48000 {dest.mp3}
- Extract audio no re-encode
    - ffmpeg -i input-video.avi -vn -acodec copy output-audio.m4a
Fade In, Fade Out (30 min audio) ffmpeg -i "static.mp3" -vn -filter_complex "afade=type=in:start_time=0:duration=2, afade=type=out:start_time=1798:duration=2" "static-fade.mp3"
- Analyze
    - ffprobe
- Replace audio
    - ffmpeg -i v.mp4 -i a.wav -c copy -map 0:v:0 -map 1:a:0 new.mp4
- Trim Video
    - ffmpeg -ss 00:00:02 -to 01:24:19 -i {src.mp4} -c copy {dest.mp4}
    - https://trac.ffmpeg.org/wiki/Seeking#Cuttingsmallsections
- Rotate Video
    - ffmpeg -i input.MP4 -c:a copy -c:v libx265 -x265-params lossless=1 -vf "transpose=2" rotated.mp4
        - PAY ATTENTION TO THE LIBX265 IT COULD BE LIBX264 BE CAREFUL
        - 0 = 90° counterclockwise and vertical flip (default)
        - 1 = 90° clockwise
        - 2 = 90° counterclockwise
        - 3 = 90° clockwise and vertical flip
        - VERY Slow, the other methods of just flipping the metadata doesn't allow for recombining
        - Flip
            - ffmpeg -i input_video_file_path -vf hflip output_video_file_path  # horizontal
            - ffmpeg -i input_video_file_path -vf vflip output_video_file_path  # vertical
- Concat Videos
    - (echo file '<file1>.mp4' & echo file '<file2>.mp4' )>list.txt
        - file.txt reads
            - file 'file1.mp4'
            - file 'file2.mp4'
        - ffmpeg -safe 0 -f concat -i list.txt -c copy output.mp4
    - ffmpeg -i 'part1.mov' -i 'part2.mov' -filter_complex "[0:v][0:a][1:v][1:a]concat=n=2:v=1:a=1" 'part3.mov'  # Filter complex
- Concat different resolutions:
    - For file in files:
        - Resize them ALL to the same
        - IF NECESSARY: Convert their video codec to the same
        - IF NECESSARY: Convert their audio codec to the same
    - Concat
- Concat and Flip and Speed Up etc
    - DOESN’T FKING WORK
    - ffmpeg -i   input1.mp4 -i input2.mp4 -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1 [v] [a]" -vsync 2 -map "[v]" -map "[a]"    output1.mp4  # concat
    - ffmpeg -i   outpu1.mp4 -filter_complex "[0:v]hflip,setpts=0.77*PTS;[0:a]atempo=1.3" output2.mp4  # flip + speed up
    - ffmpeg -i input1.mp4 -i input2.mp4 -filter_complex "[0:v][0:a][1:v][1:a]concat=n=2:v=1:a=1[v][a];[v]hflip,setpts=PTS/1.3;[a]atempo=1.3" output.mp4  # concat, flip + speedup
- Wav to FLAC
    - ffmpeg -i in.wav -af aformat=s32:176000 out.flac  # encodes to 32-bit 176 kHz
    - ffmpeg -i in.wav -af aformat=s16:44100 out.flac  # encodes to 16-bit 44.1 kHz
- Convert to MP3
    - ffmpeg -i input.wav -vn -ar 48000 -ac 2 -b:a 192k output.mp3
        - Ar: sample rate
        - Ac: audio channel count
        - b:a constant and bitrate
- Convert to MP4
    - keep sources same
        - ffmpeg -i input_filename.avi -c:v copy -c:a copy -y output_filename.mp4
    - keep audio same, video using vp9 at 100kbps
        - ffmpeg -i input_filename.avi -c:a copy -c:v vp9 -b:v 100K output_filename.mp4
    - using h264
        - ffmpeg -i input_filename.avi -c:v libx264 -preset slow -crf 22 -c:a copy output.mkv
        - https://trac.ffmpeg.org/wiki/Encode/H.264
- Resize / Change Framerate / Resolution
    - For filepath in filepaths:
        - ffmpeg -y -i "input.mov" -vf scale=3840:-2,setsar=1:1,fps=30 -c:v h264_nvenc -c:a copy "output.mov"
        - # https://superuser.com/a/1667740 - QUALITY FLAGS
            - '-rc', 'constqp', '-qp', '24', '-preset', 'p7', '-tune', 'hq', '-rc-lookahead', '4',
- Resize Slow, not sure why
    - resize, but slow preset for high quality
        - ffmpeg -i input_filename.avi -vf scale=1280:720 -preset slow -crf 18 output_filename.mp4
        - ffmpeg -i input_filename.avi -vf scale=480:360 -preset slow -crf 18 output_filename.mp4
    - resize, keep aspect ratio but fix either width/height
        - ffmpeg -i input_filename.avi -vf scale=320:-1 output_filename.mp4
    - Scale, resize to a ratio
        - ffmpeg -i input_filename.avi -vf "scale=iw/2:ih/2" output_filename.mp4
        - w/framerate
            - ffmpeg -i input_filename.avi -vf "scale=iw/4:ih/4,fps=30" output_filename.mp4
    - framerate
        - ffmpeg -i input_filename.avi -filter:v fps=fps=30 output_filename
    - using the crf to adjust visual fidelity
        - CRF scale is 0–51, where 0 is lossless (for 8 bit only, for 10 bit use -qp 0), 23 is the default, and 51 is worst quality possible. sane range is 17–28. Consider 17 or 18 to be visually lossless. range is exponential, +6 results in roughly half the bitrate / file size

- Speed Up / Slow Down
    - You can speed up audio independently with atempo, and video with setpts. https://trac.ffmpeg.org/wiki/How%20to%20speed%20up%20/%20slow%20down%20a%20video
    - 100.08% speed up (with h265 [hevc] cuda codec)
        ffmpeg -y -i <INPUT_FILEPATH> `
        -filter_complex "[0:v]setpts=PTS/1.0008[v];[0:a]atempo=1.0[a]" -map "[v]" -map "[a]" `
        -c:v hevc_nvenc `
        -rc constqp -qp 24 -preset p7 -tune hq -rc-lookahead 4 `
        <OUTPUT_FILEPATH>
    - 100.08% speed up (with h265 [hevc] cuda codec) [do it quicker for preview]
        ffmpeg -y -i <INPUT_FILEPATH> `
        -filter_complex "[0:v]setpts=PTS/1.0008[v];[0:a]atempo=1.0[a]" -map "[v]" -map "[a]" `
        -c:v hevc_nvenc `
        -preset p1 `
        <OUTPUT_FILEPATH>
    - 100.04 speed up (LOW QUALITY TO PREVIEW IT)

        ```powershell
        $start = get-date
        $inputFile = 'MMNT_20231117_210216793.MOV'
        $outputFile = 'baynk-2.mov'
        ffmpeg -y `
        -hwaccel_output_format cuda `
        -i $inputFile `
        -filter_complex "[0:v]setpts=PTS/1.0004[v];[0:a]atempo=1.0[a]" -map "[v]" -map "[a]" `
        -c:v hevc_nvenc `
        -preset p1 `
        -rc:v cbr -b:v 8M -bufsize:v 4M  `
        -rc-lookahead:v 32 `
        -bf:v 3 -b_ref_mode:v middle `
        $outputFile
        $end = get-date
        $elapsed = $end - $start
        Write-Host $elapsed
        ```

    - # scale to width 480
    https://stackoverflow.com/a/34404185
    $inp = "WIN_20250221_18_55_52_Pro.mp4"
    ffmpeg -y -i "$inp" -vf scale=480:-2,setsar=1:1 -c:v libx264 -c:a copy "$inp-shrink.mp4"


- Video to Photos / Extract Frames / Video to Frames
    - ffmpeg -i file.mpg -r 1/1 $filename%03d.bmp  # .bmp incurs no encoding cost
    - ffmpeg -i input.mp4 -filter:v fps=fps=1/60 ffmpeg_%0d.bmp  # includes fps


- Video to GIF Convert

    ```powershell
    ffmpeg -ss 30:19 -to 30:26 -i src-trim.mov `
        -vf "fps=10,scale=720:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" `
        -loop 0 output.gif
    ```

    This example will skip the first 30 seconds (-ss 30) of the input and create a 3 second output (-t 3).
    fps filter sets the frame rate. A rate of 10 frames per second is used in the example.
    scale filter will resize the output to 320 pixels wide and automatically determine the height while preserving the aspect ratio. The lanczos scaling algorithm is used in this example.
    palettegen and paletteuse filters will generate and use a custom palette generated from your input. These filters have many options, so refer to the links for a list of all available options and values. Also see the Advanced options section below.
    split filter will allow everything to be done in one command and avoids having to create a temporary PNG file of the palette.
    Control looping with -loop output option but the values are confusing. A value of 0 is infinite looping, -1 is no looping, and 1 will loop once meaning it will play twice. So a value of 10 will cause the GIF to play 11 times.

    - ffmpeg -i input.mp4 -vf "fps=10,scale=320:-1:flags=lanczos" -c:v pam \
        -f image2pipe - | \
        magick.exe convert -delay 10 - -loop 0 -layers optimize output.gif
    - magick.exe convert -delay 10 input.gif -loop 0 -layers optimize output.gif
    - Secondly, the -delay value in convert is in ticks (there are 100 ticks per second), not in frames per second. For example, with fps=12.5 = 100/12.5 = 8 = -delay 8

- Mute segments of video
    - ffmpeg -i in_video.mp4 -filter:a "volume=enable='between(t,34*60,35*60)':volume=0.1, volume=enable='between(t,37*60,40*60)':volume=0.1" -vcodec copy out_video.mp4
        - 0.1 volume between 34 to 35 minutes, 37 to 40 minutes
    - ffmpeg -i in.mp4 -vcodec copy -af "volume=enable='between(t,5,10)':volume=0, volume=enable='between(t,15,20)':volume=0" out.mp4
        - mute two sections: between 5-10s and 15-20s:

- Loop video to audio:
    - Pad with last frame
        - ffmpeg.exe -i "D:\video.m4s" -i "\audio.m4s" -c:v copy -c:a copy "D:\combined.mp4"
            - if (audio.length < video.length), then pad the audio with silent, so that audio.length === video.length
            - if (audio.length > video.length), then pad the video with the last frame of this video, so that audio.length === video.length
    - Stream in a loop piped to joining
        - ffmpeg  -stream_loop -1 -i 1.mp4 -c copy -v 0 -f nut - | ffmpeg -thread_queue_size 10K -i - -i 1.mp3 -c copy -map 0:v -map 1:a -shortest -y out.mp4
    - Stream loop no pipe
        - ffmpeg -stream_loop -1 -i video.mp4 -i audio.mp3 -shortest -map 0:v:0 -map 1:a:0 -y output.mp4


- Framerate
    - ffmpeg -i <input> -filter:v fps=fps=30 <output>

- Codecs
    - list codecs: ffmpeg -formats
    - get a file's codecs: ffprobe -i input_filename.avi -hide_banner
    - full help: ffmpeg -h full


- Crop / Make a Short
    - ratios for x, y, start x, start y: (short needs to be 9:16)
        - 3840 * 2160 - 16:9 | so the short needs to be x 1215 (2160 / 16 * 9), y 2160, X midpoint then is (3840 - 1215) / 2 so 1313
        - 1920 * 1080 - 16:9 | so the short needs to be x 607.5, y 1080, x midpoint then is (1920 - 607) / 2 so 656
    - ffplay -i $infile -vf "crop=X:Y:START_X:START_Y"
    - # preview things
        - ffplay -i $infile -vf "crop=1215:2160:1313:0"
    - ffmpeg -y -ss 32:22 -to 32:50 -i $infile -filter:v "crop=1215:2160:1313:0" $outfile
    - ffmpeg -y -ss 32:22 -to 32:50 -i $infile -filter:v "crop=607:1080:656:0" $outfile

- Generate Thumbnails
    ```powershell
    # thumbnail
    $bmps = @()
    for($i = 0; $i -lt 30; $i++) {
      ffmpeg -y -accurate_seek -ss $i -i "Puppet - NEW ALBUM ALMOST DONE.mov" -frames:v 1 "thumbnail-$i.bmp"
      $bmps += "thumbnail-$i.bmp"
    }
    magick mogrify -format jpg "thumbnail-*.bmp"
    Remove-Item $bmps
    ```


- Reverse Audio!
fmpeg -i "game\input.ogg" -af "areverse" "game\input (Reversed).ogg"


- Photo to Video Picture to Video Image to Video

```powershell
<#
https://stackoverflow.com/questions/24961127/how-to-create-a-video-from-images-with-ffmpeg
https://trac.ffmpeg.org/wiki/Slideshow
https://stackoverflow.com/questions/15792105/simulating-tv-noise
https://trac.ffmpeg.org/wiki/Map
#>

$noise_wav = "C:\Users\chris\OneDrive\Documents\Audacity\noise.wav"

$video_info = ffprobe -v error -select_streams v:0 -show_entries stream -of default=noprint_wrappers=1 "C:\Users\chris\Videos\dad-clock.mov"
$video = @{}
$video_info | ForEach-Object {
    $tokens = ($_ -split '=')
    $video[$tokens[0]] = $tokens[1]
}
$width = $video['width']
$height = $video['height']
$resolution = "$($width)x$($height)"
$pix_fmt = $video['pix_fmt']
$frame_rate = ($video['r_frame_rate'] -split '/')[0]
$codec = $video['codec_name']
if ($codec -eq "h264") {
    $codec = "h264_nvenc"
}

$audio_info = ffprobe -v error -select_streams a:0 -show_entries stream -of default=noprint_wrappers=1 "C:\Users\chris\Videos\dad-clock.mov"
$audio = @{}
$audio_info | ForEach-Object {
    $tokens = ($_ -split '=')
    $audio[$tokens[0]] = $tokens[1]
}


Set-Location "C:\Users\chris\OneDrive\_\Life\Family\Carl, Klaus\diagrams"
$images = Get-ChildItem "C:\Users\chris\OneDrive\_\Life\Family\Carl, Klaus\diagrams\2026-06-24-clock-bad"
$secs = 5
foreach ($image in $images) {
    # -hwaccel cuda -hwaccel_output_format cuda `
    ffmpeg `
        -loop 1 `
        -i "$($image.FullName)" `
        -i $noise_wav `
        -filter_complex "[0:v]scale=$width`:$height`:force_original_aspect_ratio=decrease,pad=$width`:$height`:(ow-iw)/2:(oh-ih)/2[v0]" `
        -map "[v0]" `
        -map "1:a" `
        -c:v $codec `
        -t $secs -r $frame_rate -pix_fmt $pix_fmt `
        -c:a aac `
        -b:a 192k -shortest `
        "$($image.FullName).mp4" -y
}
```
