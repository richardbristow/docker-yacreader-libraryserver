#!/bin/sh

comicsDir="/comics/.yacreaderlibrary"

if [ -d "$comicsDir" ]; then
  if [ "$(ls -A $comicsDir)" ]; then
    echo "$comicsDir is not empty. Adding existing library to YACReaderLibraryServer"
    YACReaderLibraryServer add-library Comics /comics
  else
    echo "$comicsDir is empty. Creating library"
    YACReaderLibraryServer create-library Comics /comics
  fi
else
  echo "$comicsDir not found. Creating library"
  YACReaderLibraryServer create-library Comics /comics
fi

mkdir /etc/periodic/10min
echo -e '#!/bin/sh\nYACReaderLibraryServer update-library /comics' >> /etc/periodic/10min/yaclibraryupdate
chmod +x /etc/periodic/10min/yaclibraryupdate
echo "*/10 * * * * run-parts /etc/periodic/10min" >> /etc/crontabs/root
crond -l 8

YACReaderLibraryServer --port 8080 start
