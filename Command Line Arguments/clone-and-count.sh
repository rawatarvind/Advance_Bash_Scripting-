# Clone the repository passed as the first argument

git clone "$1"

# Count files in the cloned repo
find . -type -f | wc -l 

echo "Script name : $0"

echo "Number of arguments: $#"

echo "All arguments (\$@): $@"

