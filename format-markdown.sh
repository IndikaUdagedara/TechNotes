#!/bin/bash
# Markdown formatting script using prettier
# Usage: ./format-markdown.sh [file.md|directory|all]

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if prettier is available
if ! command -v npx &> /dev/null; then
    echo -e "${RED}Error: npx not found. Please install Node.js${NC}"
    exit 1
fi

format_file() {
    local file="$1"
    echo -e "${YELLOW}Formatting:${NC} $file"
    
    # Remove empty bullet points (lines with just '-' or '- ')
    sed -i '/^-[[:space:]]*$/d' "$file"
    
    # Remove trailing empty bullets at different indent levels
    sed -i '/^[[:space:]]*-[[:space:]]*$/d' "$file"
    
    # Format with prettier
    npx prettier --write --prose-wrap always --print-width 80 "$file"
    
    echo -e "${GREEN}✓ Done${NC}"
}

format_directory() {
    local dir="$1"
    echo -e "${YELLOW}Formatting all markdown files in:${NC} $dir"
    find "$dir" -name "*.md" -type f | while read -r file; do
        format_file "$file"
    done
}

# Main script logic
if [ $# -eq 0 ]; then
    echo "Usage: $0 [file.md|directory|all]"
    echo ""
    echo "Examples:"
    echo "  $0 pages/VSCode.md          # Format single file"
    echo "  $0 pages/                   # Format all .md in directory"
    echo "  $0 all                      # Format all .md in workspace"
    exit 1
fi

case "$1" in
    all)
        echo -e "${YELLOW}Formatting all markdown files in workspace...${NC}"
        format_directory "."
        ;;
    *.md)
        if [ -f "$1" ]; then
            format_file "$1"
        else
            echo -e "${RED}Error: File not found: $1${NC}"
            exit 1
        fi
        ;;
    *)
        if [ -d "$1" ]; then
            format_directory "$1"
        else
            echo -e "${RED}Error: Not a valid file or directory: $1${NC}"
            exit 1
        fi
        ;;
esac

echo -e "${GREEN}All done!${NC}"
