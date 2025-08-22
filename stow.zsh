#!/bin/zsh

for dir in ./*/ ; do
  if [ -d "$dir" ]; then
    dirname=$(basename "$dir")
    echo "Processing $dirname..."
    stow "$dirname" -d . -t ~/ -v
  fi
done

echo "Done!"
