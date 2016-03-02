#!/usr/bin/env bash

# MEX VLC controller - build script for Linux

### START EDITING HERE

# path to MATLAB app package
MATLAB=/Applications/MATLAB_R2015b.app

# path to VLC app package
VLC=/Applications/VLC.app

### STOP EDITING HERE

# change to directory that the script is in
cd `dirname $0`

# clear build files
rm vlc.mex*

# build XCode
cd osx/MexWindowHelper
xcodebuild clean
xcodebuild build
cd ../..

# hack to work around VLC bug
echo "#define _VLC_ \"$VLC\"" >apple_workaround.h

# build MEX
$MATLAB/bin/mex vlc.cpp vlcmex.cpp -g -lvlc -lMexWindowHelper -I$VLC/Contents/MacOS/include -L$VLC/Contents/MacOS/lib -Losx/MexWindowHelper/build/Release
install_name_tool -change @loader_path/lib/libvlc.5.dylib $VLC/Contents/MacOS/lib/libvlc.5.dylib vlc.mexmaci64
install_name_tool -change /usr/local/lib/libMexWindowHelper.dylib $PWD/osx/MexWindowHelper/build/Release/libMexWindowHelper.dylib vlc.mexmaci64
