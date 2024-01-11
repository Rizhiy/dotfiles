filename="${1:-.env}"

if [ ! -f "$filename" ]; then
    echo "Missing ${filename} file!"
    exit 1
fi

echo "Reading .env file..."
while read -r LINE; do
    if [[ $LINE != '#'* ]] && [[ $LINE == *'='* ]]; then
        export "$LINE"
    fi
done < "$filename"
