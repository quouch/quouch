#!/bin/bash

# Define the directory path to be removed
dir_path="$(pwd)"

raw_report=$(cat coverage/report.md)

# Put the first 5 lines of the report into the file
echo "$raw_report" | head -n 5 > coverage/report-pretty.md

# Add the overall coverage percentage to the report from the .last_run.json file
last_run_lines=$(cat coverage/.last_run.json | jq -r '.result.line')
echo "Overall coverage: $last_run_lines%" >> coverage/report-pretty.md

# Remove first 5 lines of the report
raw_report=$(echo "$raw_report" | tail -n +6)

# Every path in the report has the following format:
# |/Users/{user}/github/quouch/app/models/plan.rb|0.0%|0|20|20|
# We need to remove the path until `quouch` to make it more readable
# Use sed to remove the directory path and overwrite the file
echo "$raw_report" | sed "s|$dir_path/||g" >> coverage/report-pretty.md

if [ -z "$GITHUB_STEP_SUMMARY" ]; then
  echo "GITHUB_STEP_SUMMARY is not set. Exiting..."
  exit 0
fi
cat coverage/report-pretty.md >> $GITHUB_STEP_SUMMARY


