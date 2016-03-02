For unknown reasons, on OS X libvlc cannot create its own window. Therefore, I have included a tiny Objective C helper library that can create and destroy NSWindows containing a single view. The view is passed back to the vlc-matlab wrapper and used for drawing.

