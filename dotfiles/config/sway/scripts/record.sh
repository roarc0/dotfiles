#!/bin/bash
# Sway WM screen + audio recorder
# Usage: ./record -d [display] -a [audio_device] -o [project_output_name]
#
# Displays can be listed with `swaymsg -t get_outputs`.
# Audio devices can be listed with `arecord -l`.
# Probably best not to put spaces in the "-o" argument, sorry...
#
# Dependencies: ffmpeg, alsamixer
#
# Example: ./record.sh eDP-1 hw:0,0 my_recording
#
# Note: If this file is sorely out of date, it's either no longer relevant,
# and/or I decided to push changes here: https://github.com/Spirotot/dotFiles

# Define some variables we're going to use...
DISP="LVDS-1"
AUDIO=""
OUTPUT="rec"
SCREEN_CMD=""
AUDIO_CMD=""
SCREEN_PID=""
AUDIO_PID=""
START=""
RATE="60"

# Set a trap for Ctrl+C (SIGINT) so that we can forward the
# Ctrl+C to the `swaygrab` and `arecord` subprocesses.
# Inspired by: https://stackoverflow.com/questions/8993655/can-a-bash-script-run-simultaneous-commands-then-wait-for-them-to-complete
trap killandconvert SIGINT

# `killandconvert()` kills the `swaygrab` and `arecord` subprocesses
# when Ctrl+C is pressed, and then proceeds to fix up the length
# discrepencies, and create the final output MKV.
killandconvert() {
    # Forward the SIGINT to `swagrab` and `arecord` so they can shut
    # themselves down properly.
    kill -2 $SCREEN_PID
    kill -2 $AUDIO_PID

    # Wait for them to exit...
    wait $AUDIO_PID
    wait $SCREEN_PID

    # Get the lengths:
    #     * https://forum.videolan.org/viewtopic.php?t=56438
    #     * https://stackoverflow.com/questions/20323640/ffmpeg-deocde-without-producing-output-file
    # Convert the lengths with awk: https://askubuntu.com/questions/407743/convert-time-stamp-to-seconds-in-bash
    SCREEN_LENGTH=`ffmpeg -i ${OUTPUT}_orig.mkv -f null /dev/null 2>&1 | \
                   grep Duration | awk '{print $2}' | tr -d "," | \
                   awk -F: '{print ($1 * 3600) + ($2 * 60) + $3}'`

    if [ "$START" = "" ]; then
        AUDIO_LENGTH=`ffmpeg -i ${OUTPUT}_orig.wav -f null /dev/null 2>&1 | \
                      grep Duration | awk '{print $2}' | tr -d "," | \
                      awk -F: '{print ($1 * 3600) + ($2 * 60) + $3}'`
    else
        # https://unix.stackexchange.com/questions/53841/how-to-use-a-timer-in-bash
        AUDIO_LENGTH=$((SECONDS - START))
    fi

    # Calculate the multiplier used to sync the video to the audio.
    # https://stackoverflow.com/questions/12722095/how-do-i-use-floating-point-division-in-bash
    MULTIPLIER=`bc -l <<< "scale=8; $AUDIO_LENGTH/$SCREEN_LENGTH"`

    # "Sync" the video to the audio by stretching it.
    # https://trac.ffmpeg.org/wiki/How%20to%20speed%20up%20/%20slow%20down%20a%20video
    `ffmpeg -i ${OUTPUT}_orig.mkv -filter:v "setpts=${MULTIPLIER}*PTS" \
    -preset ultrafast ${OUTPUT}_tmp.mkv`

    if [ "$START" = "" ]; then
        # Combine the video and audio streams into one output file.
        `ffmpeg -i ${OUTPUT}_tmp.mkv -i ${OUTPUT}_orig.wav \
         -c:v copy -c:a aac ${OUTPUT}.mkv`
    else
        # If there is no audio stream, then just rename the video stream
        # as the final outout file.
        mv ${OUTPUT}_tmp.mkv ${OUTPUT}.mkv
    fi

    # Cleanup
    rm -f ${OUTPUT}_orig.mkv
    rm -f ${OUTPUT}_tmp.mkv
    rm -f ${OUTPUT}_orig.wav
}

# Parse the command line options...
# http://abhipandey.com/2016/03/getopt-vs-getopts/
while getopts d:a:o: FLAG; do
    case $FLAG in
        d)
            DISP=$OPTARG
            ;;
        a)
            AUDIO=$OPTARG
            ;;
        o)
            OUTPUT=$OPTARG
            ;;
    esac
done

# Check the user's options to make sure they're somewhat sane.
if [ "$OUTPUT" = "" ]; then
    echo "No output specified."
    exit 1
fi

if [ "$DISP" = "" ]; then
    echo "No display specified."
    exit 1
else
    # Build the command used for screen recording.
    SCREEN_CMD="swaygrab -c -R $RATE -o $DISP ${OUTPUT}_orig.mkv"
fi

if [ "$AUDIO" = "" ]; then
    echo "Proceeding without audio recording."
else
    # Build the command used for audio recording.
    AUDIO_CMD="arecord -f cd -D $AUDIO ${OUTPUT}_orig.wav"
fi

# Start the screen recorder...
$SCREEN_CMD &
# ... and save the PID so we can kill it gracefully later.
SCREEN_PID=$!

if [ ! "$AUDIO_CMD" = "" ]; then
    # Start the audio recorder...
    $AUDIO_CMD &
    # ... and save the PID so we can kill it gracefully later.
    AUDIO_PID=$!
else
    # Unless we're not going to record audio, in which case we'll
    # simply use a timer to figure out how much we need to stretch
    # the video...
    # https://unix.stackexchange.com/questions/53841/how-to-use-a-timer-in-bash
    START=$SECONDS
fi

# Just hang out until the user presses Ctrl+C
wait
