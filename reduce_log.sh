#!/bin/bash

log_file="reset_script.log"
max_size=$((100*1024)) # 100 KB in bytes
lines_to_remove=$1

# Check if the log file exists
if [ ! -f "$log_file" ]; then
    echo "Log file $log_file not found."
    exit 1
fi

# Get the size of the log file
file_size=$(stat -c %s "$log_file")

# Check if the file size is greater than the max size
if [ "$file_size" -gt "$max_size" ]; then
    echo "Log file size is larger than 100 KB."

    # Remove the first lines_to_remove lines from the log file
    tail -n +$((lines_to_remove+1)) "$log_file" > "$log_file.tmp"
    mv "$log_file.tmp" "$log_file"
    exit 1
fi
