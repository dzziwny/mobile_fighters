#!/bin/zsh

# Directory to search for .dart files
SEARCH_DIR="."

# File to which the contents will be appended
OUTPUT_FILE="output_file.txt"

rm "$OUTPUT_FILE"

# Ensure the output file exists
touch "$OUTPUT_FILE"

echo "Listing all .dart files..."

# Loop over each .dart file and print its path
for file in ${SEARCH_DIR}/**/*.dart; do
    if [[ -f $file ]]; then
        echo "Found .dart file: $file"
        echo "" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        file_content=$(cat "$file")
        echo "" >> "$OUTPUT_FILE"
        echo "FILE: $(basename "$file")" >> "$OUTPUT_FILE"
        cat "$file" >> "$OUTPUT_FILE"
        echo "Copied."
    fi
done

echo "Listing complete."
