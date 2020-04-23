@mesg "$current_filename"


function setup
    source (pwd)/functions/extractsubtitles.fish
end

function teardown
    set matches /tmp/log.?????
    command --quiet rm $matches
    set --erase tmp_log
end



@test "throws and error code 1 if `--input` was not set" (
    extractsubtitles --output output.mkv &> /dev/null
) $status -eq 1


@test "throws and error if `--input` was not set" (
    set -g tmp_log (command mktemp /tmp/log.XXXXX)
    extractsubtitles --output output.mkv &> $tmp_log
) (cat $tmp_log) = "Error: `input` was not set. See help."


@test "throws and error code 1 if `--output` was not set" (
    extractsubtitles --input input.mkv &> /dev/null
) $status -eq 1


@test "throws and error if `--output` was not set" (
    set -g tmp_log (command mktemp /tmp/log.XXXXX)
    extractsubtitles --input input.mkv &> $tmp_log
) (cat $tmp_log) = "Error: `output` was not set. See help."


@test "throws and error code 1 if `--subtitles-index` was not set" (
    extractsubtitles --input input.mkv --output output.mkv &> /dev/null
) $status -eq 1


@test "throws and error if `--subtitles-index` was not set" (
    set -g tmp_log (command mktemp /tmp/log.XXXXX)
    extractsubtitles --input input.mkv --output output.mkv &> $tmp_log
) (cat $tmp_log) = "Error: `subtitles-index` was not set. See help."


@test "throws and error code 1 if ffmpeg was not found" (
    extractsubtitles --input input.mkv --output output.mkv --ffmpeg /path/to/the/ffmpeg &> /dev/null
) $status -eq 1


@test "throws and error if ffmpeg was not found" (
    set -g tmp_log (command mktemp /tmp/log.XXXXX)
    extractsubtitles --input input.mkv --output output.mkv --ffmpeg /path/to/the/ffmpeg &> $tmp_log
) (cat $tmp_log) = "ffmpeg is required (https://www.ffmpeg.org)."
