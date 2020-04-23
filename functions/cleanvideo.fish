function cleanvideo -d "Leave only what you need in the video container"

    # By default it selects subtitles track 1 and audio track 1
    set -l subtitles_indexies 1
    set -l audio_indexies 1

    set -l FFMPEG_PATH (command -v ffmpeg)
    set -l loglevel "fatal"

    # If there is no fish-getopts, throw an error
    if not functions -q getopts
        echo "fish-getopts is required (https://github.com/jorgebucaran/fish-getopts)." >&2
        return 1
    end

    # Parse key value arguments
    getopts $argv | while read -l key value
        switch $key
            case i input
                set input $value
            case o output
                set output $value
            case a audio-indexies
                set audio_indexies $value
            case s subtitles-indexies
                set subtitles_indexies $value
            case F ffmpeg
                set FFMPEG_PATH $value
            case L loglevel
                set loglevel $value
            case h help
                echo "Keep in the video container only what you need."
                echo ""
                echo "Options:"
                echo ""
                echo "  -i --input                an input file path (required)"
                echo "  -o --output               an output file path (required)"
                echo "  -a --audio-indexies       audio track index in the file (default: 1)"
                echo "  -s --subtitles-indexies   subtitle track index in the file (default: 1)"
                echo "  -F --ffmpeg               path to the ffmpeg executable"
                echo "  -L --loglevel             ffmpeg loglevel (default: fatal)"
                echo ""
                echo "Example:"
                echo ""
                echo '  cleanvideo --input "input.mkv" --output "output.mkv" --audio-indexies 3 --subtitles-indexies 3,2'

                return
        end
    end

    # If there is no ffmpeg executable, throw an error
    if not test -e $FFMPEG_PATH
        echo "ffmpeg is required (https://www.ffmpeg.org)." >&2
        return 1
    end

    # If input path was not set, throw an error
    if not set -q input
        echo "Error: `input` was not set. See help." >&2
        return 1
    end

    # If output path was not set, throw an error
    if not set -q output
        echo "Error: `output` was not set. See help." >&2
        return 1
    end

    # Collect -map arguments with correct indexies (ffmprobe returns correct map index)

    set -l maps "-map" "0:0"

    for ai in (string split , $audio_indexies)
        set ai (math $ai - 1)
        set ai (ffprobe $input -hide_banner -loglevel panic -select_streams a:$ai -show_entries stream=index -of csv=s=x:p=0)
        set ai "0:$ai"
        set maps $maps "-map" $ai
    end

    for si in (string split , $subtitles_indexies)
        set si (math $si - 1)
        set si (ffprobe $input -hide_banner -loglevel panic -select_streams s:$si -show_entries stream=index -of csv=s=x:p=0)
        set si "0:$si"
        set maps $maps "-map" $si
    end

    $FFMPEG_PATH -hide_banner -loglevel $loglevel -i "$input" -c:a copy -c:v copy -c:s copy $maps -y "$output"
    return 0
end
