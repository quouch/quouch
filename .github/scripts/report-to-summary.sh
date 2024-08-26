#!/bin/bash

# Define the directory path to be removed
dir_path="$(pwd)"

raw_report=$(cat coverage/report.md)

# Every path in the report has the following format:
# |/Users/{user}/github/quouch/app/models/plan.rb|0.0%|0|20|20|
# We need to remove the path until `quouch` to make it more readable
# Use sed to remove the directory path and overwrite the file

echo "$raw_report" | sed "s|$dir_path/||g" > coverage/report-pretty.md

cat coverage/report-pretty.md >> $GITHUB_STEP_SUMMARY


