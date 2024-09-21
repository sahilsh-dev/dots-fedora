#/bin/bash
 
if [ -f "$1" ]; then
  filename=$(realpath "$1")
  /usr/bin/convert "$filename" -channel RGB -negate "$filename"
  /usr/bin/notify-send "Inverted image $filename"
else 
  echo "No file path" >&2
fi
