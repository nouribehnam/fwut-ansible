#!/bin/bash

home=$(realpath ~)
id_files=""

if [ -f "$home/.id_files" ]; then
    id_files=$(cat "$home/.id_files")
else
    echo "No id files found at $home/.id_files"
fi

for f in $id_files; do
   if [ -r "$f" ]; then
      if ! [ -r "$f.pub" ]; then
         ssh-keygen -y -f "$f" > "$f.pub"
      fi

      c=$(cat "$f.pub" | cut -d ' ' -f 3)
      
      ssh-add -T "$f" &> /dev/null
      if [ $? -ne 0 ]; then
         echo "Adding $f ($c) ..."
         ssh-add $f
      else
         echo "$f ($c) already added..."
      fi
   else
      echo "File $f not exists!"
   fi
done