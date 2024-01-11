sourced=0
if [ -n "$ZSH_VERSION" ]; then
  case $ZSH_EVAL_CONTEXT in *:file) sourced=1;; esac
elif [ -n "$KSH_VERSION" ]; then
  [ "$(cd -- "$(dirname -- "$0")" && pwd -P)/$(basename -- "$0")" != "$(cd -- "$(dirname -- "${.sh.file}")" && pwd -P)/$(basename -- "${.sh.file}")" ] && sourced=1
elif [ -n "$BASH_VERSION" ]; then
  (return 0 2>/dev/null) && sourced=1
else # All other shells: examine $0 for known shell binary filenames.
     # Detects `sh` and `dash`; add additional shell filenames as needed.
  case ${0##*/} in sh|-sh|dash|-dash) sourced=1;; esac
fi

if [ $sourced -eq 0 ]; then
    echo "This script has to be sourced to work properly!"
    exit 1
fi

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
