%%
vh=vlc_wrapper('init');
vp=vlc_wrapper('open',vh,'../../behv.avi');
vlc_wrapper('play',vp,1.0)
%%
vlc_wrapper cleanup