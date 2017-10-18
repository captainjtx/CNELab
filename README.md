# CNELab
A Matlab software for Clinical Neural Engineering Laboratory.


Getting started with CNELab
------------

Getting started with CNELab is fairly easy. It only takes a few minutes to complete this tutorial step by step.

Preparations
------------

We recommend using the latest Matlab release version, currently R2016a. However, most features of CNELab should be backward compatible up to R2014a. However, starting R2014b, Matlab updated on its graphic system. CNELab experienced a major performance drop (especially in plotting speed) in R2014b and R2015a. Thus, it is not recommended to use R2014b, R2015a or any version before R2014a.

CNELab depends on several basic toolboxes of Matlab. Most of time they come with your license.

- Signal Processing Toolbox.
- Statistics and Machine Learning Toolbox.
- Wavelet Toolbox.
- Computer Vision System Toolbox

You can type `ver` in the Matlab command window to verify the installed toolboxes.

Install CNELab
------------

If do not have CNELab yet, please refer to our download page. Once you download the zip file, unzip it and put it anywhere you prefer.

Change your current Matlab path to the root folder of CNELab, where you can see files such as cnelab.m and setup.m.

Run setup.m by typing it in command window:

> setup

If you receive no error message, congratulations !

More on setup.m
------------

Although `setup` automatically removes existed CNELab from Matlab Path, it is always a good practice to manually delete the previously installed CNELab folder.

`setup` will check if your java JVM version used in Matlab is greater than in 1 . 7 . * . Most of time you should not worry about it as Matlab shipped its version with specific JVM after R2013b. Type `version -java` to verify yourself.

`setup` tries to recompile c++ mexfunctions in CNELab to your system environment. However, our release already contains precompiled mexfunctions that can be immediately used in 64-bit of MacOS/Windows computer. Only if it is a unix or 32-bit system should you be careful. If you received a mex compile error, you would have to check your c++ compiler on Maltab and manually compile them. Type `mex -setup c++` to verify yourself.

Start with demo
------------

The best way to learn CNELab is to use it:

> cnelab

Open $CNELAB_ROOT/demo/demo.cds to explore yourself.

Enjoy !
