#!/usr/bin/env bash

# MEX VLC controller - build script for Linux

### START EDITING HERE

# path to MATLAB installation (this dir should contain a "bin" dir)
MATLAB=/usr/local/Matlab/R2014a

### STOP EDITING HERE

# change to directory that the script is in
cd `dirname $0`

# clear build files
rm vlc.mex*

# build
$MATLAB/bin/mex vlc.cpp vlcmex.cpp -g -lvlc

