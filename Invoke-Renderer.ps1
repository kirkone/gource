[CmdletBinding()]
Param (
    [Parameter(Mandatory = $True, Position = 1)]    
    [string]
    $Project,

    [Parameter(Mandatory = $True, Position = 2)]
    [ValidateSet(25,30,60)]     
    [int]
    $FPS = 60

)

# I have no idea how to do this without CMD because the Pipe does not work in PowerShell as in CMD
& cmd.exe /C "gource\gource.exe --load-config `"Projects\$Project\config.txt`" --path `"Projects\$Project\Logs\combined.txt`" --user-image-dir `"Projects\$Project\Avatars`" --output-framerate $FPS --output-ppm-stream - | ffmpeg\ffmpeg.exe -y -r $FPS -f image2pipe -vcodec ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -crf 1 -threads 0 -bf 0 `"$Project.mp4`""
