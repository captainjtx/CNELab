BioSigPlot v0.1.1 beta - Matlab tools to plot multichannel signals

This is more an alpha version. The compatibility with future release is not Warranted

 MAIN FEATURES:
    - Scrolling through the time and through the channels
    - Auto Time Scrolling
    - Viewing multiple datasets of the same duration simultaneously on 
      various modes (Alternated Superimpose, ...)
    - Possibility to set Montage and preprocess of data
    - (On 32bit Matlab Version) Viewing video synchroneously with signals
    - Plot and Browsing events marker
    - Grahpics and Command line controls
    
Future Features :
    - Reading directly from the file avoiding to load the entire recording into memory
    - Online AFOP Filtering
    - Better EEGLAB Integration by enabling to plot multidataset
    - Add Menu to set Colors, Montage
    - Add the commands to Open and Control the Video Window from command line
    - Add the commands to Open and Closed Config and Event Window from command line
    - Enabling to select Time period and channels
    - Time Frequency image of a channel (eg O1 and use it navigate through time)
    - Fourrier Spectra on selection of a channel and a time period
    - On Vertical Mode, give the possibility to change the Axis Height ratio Eg. Dataset EEG Big , Dataset ECG Small
    - Do a demo for the synchronisation of 2 datasets. winlength different
    - Make inherence classes for all biomedical signal where this class may be applied
    - Possibility to Change the channel Y-offset (or limits)
    - Show scale and give the possibility to get/set the scale ether by spacing or by Y/pixels 
    - Possibility of a more precise Y Grid
    - Possibility to Add several video files with various offset
    - CardioTocoMeter analysis
    - Create a Front Axes to Speed up the Measurer
    - Help/licence section
    - All the preprocessing (filtering montage spacing and else) can be done only 1 specific data set
    - chan2display et time2display par bouttons
    
Not sure Features Or very farer:
    - Enable the user to set a Process Function to do any processing directly without waiting to process the entire recording
    - QRS detection
    - Online Viewing and processing.
    - Possibility to print selected periods.
    - More than 9 Dataset (e.g. usefull for ERPs) (If more than 9, use arrow to change)
    
That it is not Supposed to do :
 - Any process on the entire recordings or it will be an other class
 - Have a File>Open or save menu