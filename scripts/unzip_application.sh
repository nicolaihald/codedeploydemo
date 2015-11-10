#!/bin/sh

echo 'Unzip application'

tmp='/tmp/i-bog/'
if [ ! -d tmp ]; then
	mkdir -p tmp
fi

echo 'Copying zip-file to: ' ${tmp}
cp -rf build.zip ${tmp} 

	
# unzip app build:
zipfile=${tmp}build.zip
echo 'Unzipping to: '
unzip ${zipfile} -d '/usr/share/nginx/html/i-bog/'

