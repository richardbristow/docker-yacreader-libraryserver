#!/bin/sh

comicsDir="/comics/.yacreaderlibrary"
configDir="/config/.yacreaderlibrary"

if [ -d "$configDir" ]; then
  echo "${configDir} already exists"
else
  echo "making directory: ${configDir}"
  mkdir "$configDir"
fi

if [ -d "$comicsDir" ]; then
  if [ -L "$comicsDir" ]; then
    echo "symbolic link to "$configDir" found."cd /
    if [ "$(ls -A $comicsDir)" ]; then
      echo "$comicsDir is not empty. adding existing library to YACReaderLibraryServer"
      YACReaderLibraryServer add-library Comics /comics
    else
      echo "$comicsDir is empty. Creating library"
      YACReaderLibraryServer create-library Comics /comics
    fi
  else
    echo "existing .yacreaderlibrary directory found"
    echo "copying "$comicsDir" to "$configDir""
    cp -R "$comicsDir"/* "$configDir"
    currentTime=$(date +%s)
    echo "renaming old "$comicsDir" to "$configDir.$currentTime""
    mv "$comicsDir" "$comicsDir.$currentTime"
    echo "creating symbolic link to "$configDir""
    ln -s "$configDir" "$comicsDir"
    echo "adding existing library to YACReaderLibraryServer"
    YACReaderLibraryServer add-library Comics /comics
  fi
else
  echo "Creating library"
  ln -s "$configDir" "$comicsDir"
  YACReaderLibraryServer create-library Comics /comics
fi

mkdir /etc/periodic/10min
echo -e '#!/bin/sh\nYACReaderLibraryServer update-library /comics' >> /etc/periodic/10min/yaclibraryupdate
chmod +x /etc/periodic/10min/yaclibraryupdate
echo "*/10 * * * * run-parts /etc/periodic/10min" >> /etc/crontabs/root
crond -l 8

YACReaderLibraryServer --port 8080 start
