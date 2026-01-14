#!/usr/bin/env bash

# Script to add date headings to journal markdown files
# Usage: ./add-journal-dates.sh [directory]
# If no directory is provided, searches from current directory

set -euo pipefail

# Get the base directory (default to current directory)
BASE_DIR="${1:-.}"

# Find all journal .md files with date format YYYY-MM-DD.md
find "$BASE_DIR" -type f -path "*/journal/*.md" -name "[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].md" | while read -r file; do
    # Extract filename without path
    filename=$(basename "$file")
    
    # Extract date from filename (YYYY-MM-DD)
    date="${filename%.md}"
    
    # Convert date to readable format (e.g., "October 6, 2025")
    formatted_date=$(date -d "$date" "+%B %-d, %Y" 2>/dev/null || echo "$date")
    
    # Check if file is empty or doesn't start with a heading for this date
    if [ -s "$file" ]; then
        first_line=$(head -n 1 "$file")
        
        # Check if first line already has the date heading
        if [[ "$first_line" =~ ^#[[:space:]]+.*$date.* ]] || [[ "$first_line" =~ ^#[[:space:]]+$formatted_date ]]; then
            echo "Skipping $file (already has date heading)"
            continue
        fi
        
        # Add heading at the top of the file
        temp_file=$(mktemp)
        {
            echo "# $formatted_date"
            echo ""
            cat "$file"
        } > "$temp_file"
        mv "$temp_file" "$file"
        echo "Added date heading to $file"
    else
        # File is empty, just add the heading
        echo "# $formatted_date" > "$file"
        echo ""
        echo "Added date heading to empty file $file"
    fi
done

echo "Done!"
