#!/bin/sh

echo 'Unzip application'

tmp='/tmp/i-bog/'
if [ ! -d tmp ]; then
	mkdir -p tmp
fi

echo 'Unzipping to ...' ${tmp}
cp -rf build.zip ${tmp} 	
# unzip app build:
unzip ${tmp}build.zip .

