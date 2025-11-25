#!/bin/bash
echo "Verifying Documentation Consistency..."
echo "========================================"
echo ""

total_api_pages=$(find ./api-reference -name "*.mdx" -type f | wc -l)
echo "Total API Reference Pages: $total_api_pages"

has_curl=$(find ./api-reference -name "*.mdx" -type f -exec grep -l '```bash' {} \; | wc -l)
echo "Pages with cURL: $has_curl"

has_python=$(find ./api-reference -name "*.mdx" -type f -exec grep -l '```python' {} \; | wc -l)
echo "Pages with Python: $has_python"

has_js=$(find ./api-reference -name "*.mdx" -type f -exec grep -l '```javascript' {} \; | wc -l)
echo "Pages with JavaScript: $has_js"

has_errors=$(find ./api-reference -name "*.mdx" -type f -exec grep -l 'Error - Unauthorized' {} \; | wc -l)
echo "Pages with Error Examples: $has_errors"

echo ""
echo "Consistency Check:"
if [ "$has_curl" -eq "$total_api_pages" ] && [ "$has_python" -eq "$total_api_pages" ] && [ "$has_js" -eq "$total_api_pages" ]; then
    echo "✅ ALL pages have cURL, Python, and JavaScript examples"
else
    echo "⚠️  Some pages missing examples:"
    echo "   Missing cURL: $((total_api_pages - has_curl))"
    echo "   Missing Python: $((total_api_pages - has_python))"
    echo "   Missing JavaScript: $((total_api_pages - has_js))"
fi

if [ "$has_errors" -eq "$total_api_pages" ]; then
    echo "✅ ALL pages have error response examples"
else
    echo "⚠️  Pages missing error examples: $((total_api_pages - has_errors))"
fi

echo ""
echo "========================================"
