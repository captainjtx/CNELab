# vlc-matlab
Thin, limited Matlab wrapper for libvlc to do fast video playback

# What is this?
I needed real time video playback, synchronized with other data visualization happening in Matlab at the same time. In all my experiments, Matlab _really sucks_ at real time video playback. Even opening the video file takes a prohibitively long time, and then you can only plod along drawing one... frame... at... a... time. Synchronously. Meanwhile, I noticed that VLC is available on nearly every platform and is _great_ at real-time video playback. I decided that rather than try to reinvent the wheel in Matlab, I should just try to glue on VLC's existing wheel. This wrapper does that.

# Where does it work?
The wrapper has been tested and works on at least these platforms:

- Linux (Ubuntu 12.04)
- Mac OS X (10.9.5)
- Windows 7, 8

Software dependencies are (obviously) Matlab and VLC:

- Matlab (tested on versions 2014a and 2014b)
- VLC (tested using versions 2.1.5 and 2.2.1)

# What can the wrapper do?
The functionality is very limited. You can get a handle to a VLC object. Armed with this handle, you can open a video file (which returns another handle to the media). A window is automatically created. With the media handle you can get basic information (frame rate and length), play and pause the media, seek to a specific point, or query the current position.

That's it! I wrapped the functions I needed and no more. Feature requests (or pull requests!) welcome if you need more features.

## Planned features

- Matlab facility for adaptively synchronizing a timer with the video
- (Windows) Depend on already-installed VLC instead of bundling DLLs

# Installation

Download the latest release from [here](https://github.com/durka/vlc-matlab/releases) and extract it somewhere. You'll want to add the extracted folder to your Matlab path.

## Linux

1. Install Matlab. Edit ```build_linux.sh``` (see comments there) to set the path to Matlab.
2. Install VLC with development headers (for example, on Debian/Ubuntu ```sudo apt-get install libvlc-dev```).
3. Run the build script: ```./build_linux.sh```.

## Mac
1. Install Matlab. Edit ```build_mac.sh``` (see comments there) to set the path to Matlab.
2. Install VLC. Edit ```build_mac.sh``` (see comments there) to set the path to VLC.
3. Run the build script: ```./build_mac.sh```.

## Windows
1. Install Matlab.
2. Run the build script: ```build_windows.bat```.

# Example

This Matlab example creates the VLC instance, loads a video file, plays it for a bit, then queries the frame count of where it stopped. The "cleanup" command closes the window and releases the handles.

    >> vlc_setup
    >> vh = vlc_wrapper('init')
    vh =
      6.9432e-310
    >> vp = vlc_wrapper('open', vh, 'movie.avi')
    vp =
      6.9432e-310
    >> vlc_wrapper('play', vp, 1.0) % change 1.0 to 0.5 for slow-mo
    >> vlc_wrapper('pause', vp)
    >> vlc_wrapper('frame', vp)
    ans =
      6678
    >> vlc_wrapper cleanup

Note that the handles are returned as numbers, but they are to be treated as opaque objects! There is some crash protection -- if you pass a nonexistent file path or an invalid handle, the wrapper will refuse to do anything instead of freezing Matlab (hopefully).

