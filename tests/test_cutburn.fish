@mesg "$current_filename"


function setup
    source (pwd)/functions/cutburn.fish
end

function teardown
    set matches /tmp/log.?????
    command --quiet rm $matches
    set --erase tmp_log
end


@test "throws and error code 1 if `--input` was not set" (
    cutburn --output output.mkv &> /dev/null
) $status -eq 1


@test "throws and error if `--input` was not set" (
    set -g tmp_log (command mktemp /tmp/log.XXXXX)
    cutburn --output output.mkv &> $tmp_log
) (cat $tmp_log) = "Error: `input` was not set. See help."


@test "throws and error code 1 if `--output` was not set" (
    cutburn --input input.mkv &> /dev/null
) $status -eq 1


@test "throws and error if `--output` was not set" (
    set -g tmp_log (command mktemp /tmp/log.XXXXX)
    cutburn --input input.mkv &> $tmp_log
) (cat $tmp_log) = "Error: `output` was not set. See help."


@test "throws and error code 1 if `--from` was not set" (
    cutburn --input input.mkv --output output.mkv &> /dev/null
) $status -eq 1


@test "throws and error if `--from` was not set" (
    set -g tmp_log (command mktemp /tmp/log.XXXXX)
    cutburn --input input.mkv --output output.mkv &> $tmp_log
) (cat $tmp_log) = "Error: `from` was not set. See help."


@test "throws and error code 1 if `--to` was not set" (
    cutburn --input input.mkv --output output.mkv --from "00:39:46" &> /dev/null
) $status -eq 1


@test "throws and error if `--to` was not set" (
    set -g tmp_log (command mktemp /tmp/log.XXXXX)
    cutburn --input input.mkv --output output.mkv --from "00:39:46" &> $tmp_log
) (cat $tmp_log) = "Error: `to` was not set. See help."


@test "throws and error code 1 if ffmpeg was not found" (
    cutburn --input input.mkv --output output.mkv --from "00:39:46" --to "00:39:51" --ffmpeg /path/to/the/ffmpeg &> /dev/null
) $status -eq 1


@test "throws and error if ffmpeg was not found" (
    set -g tmp_log (command mktemp /tmp/log.XXXXX)
    cutburn --input input.mkv --output output.mkv --from "00:39:46" --to "00:39:51" --ffmpeg /path/to/the/ffmpeg &> $tmp_log
) (cat $tmp_log) = "ffmpeg is required (https://www.ffmpeg.org)."
