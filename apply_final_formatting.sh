#!/bin/bash
# Apply structured formatting to all pages with long descriptions

cd api-reference

echo "Applying structured formatting to all pages..."

# Function to check and reformat
reformat_if_needed() {
    local file=$1
    
    # Check if has long description and no Overview
    if grep -q "^description:.*[[:alnum:]]\{150,\}" "$file" 2>/dev/null && ! grep -q "## Overview" "$file" 2>/dev/null; then
        echo "  ✓ Reformatting $file"
        
        # Extract first sentence for short desc
        desc=$(grep "^description:" "$file" | sed 's/description: "//;s/"$//' | cut -d'.' -f1)
        
        # Add Overview section after path/query parameters if not exists
        if ! grep -q "## Overview" "$file"; then
            # Insert Overview before Request Body or RequestExample
            sed -i '' '/## Request Body/i\
## Overview\
\
Detailed endpoint documentation.\
\
' "$file"
        fi
    fi
}

# Process all MDX files
find . -name "*.mdx" -type f | while read file; do
    reformat_if_needed "$file"
done

echo ""
echo "✅ Formatting check complete"
