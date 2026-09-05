#!/usr/bin/env bash
# ===============================================
# syshealth.sh - System Health & Log Analysis Toolkit
# Lab 1 - Data Collector
# Author: Your Name
# Date: $(date +%Y-%m-%d)
# ===============================================

# --- Variables and quoting demonstration ---

# The shebang tells the system to run this script using Bash, while /usr/bin/env finds Bash using the user's PATH.

HOSTNAME=$(hostname)
# $(hostname) is command substitution, so Bash runs hostname first and assigns its output to HOSTNAME.
# Quotes are not needed in the assignment because Bash does not perform word splitting on assignment values.

CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')
# The format string controls how date displays the year, month, day, hour, minute, and second.


# IMPORTANT: Quoting demo (Python/Java students read this!)
# Without quotes → word-splitting bug (try it!)
# With double quotes → safe (Bash best practice)
echo "Hostname without quotes: $HOSTNAME" # works here but dangerous later
echo "Hostname with quotes: \"$HOSTNAME\"" # always do this

# Add a comment explaining the difference (required for marks):
cat << EOF
# COMMENT FOR GRADER:
# In Python/Java variables expand safely.
# In Bash, unquoted \$VAR splits on spaces/tabs/newlines.
# Always double-quote unless you deliberately want splitting.
EOF

# --- System metrics collection ---
# These commands use Linux utilities and pipelines to extract the system information needed for the report.

# -p requests only the human-readable uptime rather than the full uptime output.
UPTIME=$(uptime -p)

# tail removes the df header so only the root filesystem information is stored.
DISK_USAGE=$(df -h / | tail -1)

# awk selects the memory row and extracts the used and total memory fields.
MEMORY_USAGE=$(free -h | awk '/Mem:/ {print $3 "/" $2}')

# ps -e lists all processes and wc -l counts the resulting lines.
PROCESS_COUNT=$(ps -e | wc -l)

# --- Output handling ---
OUTPUT_FILE="${1:-}" # if $1 is given, use it; else print to screen
# $1 represents the first command-line argument, while ${1:-} safely gives an empty value when no argument is supplied.

print_report() {
    printf "========================================\n"
    printf "System Health Report - %s\n" "$CURRENT_DATE"
    printf "Hostname        : %s\n" "$HOSTNAME"
    printf "Uptime          : %s\n" "$UPTIME"
    printf "Disk /          : %s\n" "$DISK_USAGE"
    printf "Memory used     : %s\n" "$MEMORY_USAGE"
    printf "Total processes : %s\n" "$PROCESS_COUNT"
    printf "========================================\n"
}

if [ -n "$OUTPUT_FILE" ]; then
    print_report > "$OUTPUT_FILE"
    echo "Report written to $OUTPUT_FILE"
else
    print_report
fi

exit 0
