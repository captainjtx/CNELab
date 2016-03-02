@rem MEX VLC controller - build script for Windows

@rem change to directory that the script is in
cd /d %0\..

@rem clear build files
del vlc.mex*

@rem build
cd win
call "C:\Program Files (x86)\Intel\Composer XE 2015\bin\ipsxe-comp-vars.bat" intel64 vs2010
cl /LD window.c
cd ..
mex -outdir %CD% vlc.cpp vlcmex.cpp -g -I%CD%\win\include -L%CD%\win -lvlc -lwindow

