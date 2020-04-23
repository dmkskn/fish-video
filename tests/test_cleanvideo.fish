@mesg "$current_filename"


function setup
    source (pwd)/functions/cleanvideo.fish
end

function teardown
    set matches /tmp/log.?????
    command --quiet rm $matches
    set --erase tmp_log
end


@test "throws and error code 1 if `--input` was not set" (
    cleanvideo --output output.mkv &> /dev/null
) $status -eq 1


@test "throws and error if `--input` was not set" (
    set -g tmp_log (command mktemp /tmp/log.XXXXX)
    cleanvideo --output output.mkv &> $tmp_log
) (cat $tmp_log) = "Error: `input` was not set. See help."


@test "throws and error code 1 if `--output` was not set" (
    cleanvideo --input input.mkv &> /dev/null
) $status -eq 1


@test "throws and error if `--output` was not set" (
    set -g tmp_log (command mktemp /tmp/log.XXXXX)
    cleanvideo --input input.mkv &> $tmp_log
) (cat $tmp_log) = "Error: `output` was not set. See help."


@test "throws and error code 1 if ffmpeg was not found" (
    cleanvideo --input input.mkv --output output.mkv --ffmpeg /path/to/the/ffmpeg &> /dev/null
) $status -eq 1


@test "throws and error if ffmpeg was not found" (
    set -g tmp_log (command mktemp /tmp/log.XXXXX)
    cleanvideo --input input.mkv --output output.mkv --ffmpeg /path/to/the/ffmpeg &> $tmp_log
) (cat $tmp_log) = "ffmpeg is required (https://www.ffmpeg.org)."
