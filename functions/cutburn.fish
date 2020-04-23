function cutburn -d "Cut video and burn subtitles into it"

    # By default it selects subtitles track 1 and audio track 1
    set -l subtitles_index 1
    set -l audio_index 1
    set -l font_size "24px"

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
            case f from
                set from $value
            case t to
                set to $value
            case a audio-index
                set audio_index $value
            case s subtitles-index
                set subtitles_index $value
            case x font-size
                set font_size $value
            case F ffmpeg
                set FFMPEG_PATH $value
            case l loglevel
                set loglevel $value
            case h help
                echo "Cut video and burn subtitles into it."
                echo ""
                echo "Options:"
                echo ""
                echo "  -i --input             an input file path (required)"
                echo "  -o --output            an output file path (required)"
                echo "  -f --from              start timestamp (required)"
                echo "  -t --to                end timestamp (required)"
                echo "  -a --audio-index       audio track index in the file (default: 1)"
                echo "  -s --subtitles-index   subtitle track index in the file (default: 1)"
                echo "  -x --font-size         Font size (default: 24px)"
                echo "  -F --ffmpeg            path to the ffmpeg executable"
                echo "  -L --loglevel          ffmpeg loglevel (default: fatal)"
                echo ""
                echo "Example:"
                echo ""
                echo '  cutburn --input "input.mkv" --output "output.mp4" --from "00:39:46" --to "00:39:51" --audio-index 3 --subtitles-index 3'

                return
        end
    end

    # If there is no ffmpeg executable, throw an error
    if not test -e $FFMPEG_PATH
        echo "ffmpeg is required (https://www.ffmpeg.org)." >&2
        return 1
    end

    if not set -q input
        echo "Error: `input` was not set. See help." >&2
        return 1
    end

    if not set -q output
        echo "Error: `output` was not set. See help." >&2
        return 1
    end

    if not set -q from
        echo "Error: `from` was not set. See help." >&2
        return 1
    end

    if not set -q to
        echo "Error: `to` was not set. See help." >&2
        return 1
    end

    set audio_index (math $audio_index - 1)
    set subtitles_index (math $subtitles_index - 1)

    set subtitles_filter_args "-vf" "subtitles=$input:si=$subtitles_index:force_style='FontSize=$font_size,PrimaryColour=&H00FFFF&'"
    set maps "-map" "0:0" "-map" "0:a:$audio_index"

    ffmpeg -hide_banner -loglevel $loglevel -ss $from -to $to -copyts -i "$input" $subtitles_filter_args $maps -ss $from -to $to -y $output
    return 0
end


