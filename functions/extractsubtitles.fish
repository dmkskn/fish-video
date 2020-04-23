function extractsubtitles -d "Extract subtitles from video file"

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
            case s subtitles-index
                set subtitles_index $value
            case F ffmpeg
                set FFMPEG_PATH $value
            case L loglevel
                set loglevel $value
            case h help
                echo "Extract subtitles from video file"
                echo ""
                echo "Options:"
                echo ""
                echo "  -i --input             an input file path (required)"
                echo "  -o --output            an output file path (required)"
                echo "  -s --subtitles-index   subtitles track index to extract"
                echo "  -F --ffmpeg            path to the ffmpeg executable"
                echo "  -L --loglevel          ffmpeg loglevel (default: fatal)"
                echo ""
                echo "Example:"
                echo ""
                echo '  extractsubtitles --input "input.mkv" --output "output.srt" --subtitles-index 1'
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

    if not set -q subtitles_index
        echo "Error: `subtitles-index` was not set. See help." >&2
        return 1
    end

    set subtitles_index (math $subtitles_index - 1)

    set args "-vn" -an -map "0:s:$subtitles_index" "-y"

    ffmpeg -hide_banner -loglevel fatal -i $input $args $output
    return 0
end
