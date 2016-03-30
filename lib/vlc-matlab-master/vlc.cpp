#include "vlcmex.h"

enum Verb { INIT, RELEASE, OPEN, CLOSE, FRAME, PLAY, PAUSE, INFO, CLEANUP } verbs;

static void cleanup();

libvlc_instance_t* init();
void release(libvlc_instance_t*);
libvlc_media_player_t* open(libvlc_instance_t*, string);
void close(libvlc_media_player_t*);
double frame(libvlc_media_player_t*);
double frame(libvlc_media_player_t*, double);
void play(libvlc_media_player_t*, float);
void pause(libvlc_media_player_t*);
vector<double> info(libvlc_media_player_t*);

static instance_list instances;
static player_list players;
#ifdef OWN_WINDOW
static window_list windows;
#endif

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if (!check_args(nrhs, 1, 3)) return;
    
    mexAtExit(cleanup);

    Verb verb = (Verb)(int)(mxGetPr(prhs[0])[0]);
    switch (verb) {
        case INIT:
            if (!check_args(nrhs, 1)) return;
            pack_pointer(plhs[0], init());
            break;
        case RELEASE:
            if (!check_args(nrhs, 2)) return;
            release(unpack_pointer(libvlc_instance_t, prhs[1]));
            break;
        case OPEN:
            if (!check_args(nrhs, 3)) return;
            pack_pointer(plhs[0], open(unpack_pointer(libvlc_instance_t, prhs[1]), arr2str(prhs[2])));
            break;
        case CLOSE:
            if (!check_args(nrhs, 2)) return;
            close(unpack_pointer(libvlc_media_player_t, prhs[1]));
            break;
        case FRAME:
            if (!check_args(nrhs, 2, 3)) return;
            switch (nrhs) {
                case 2:
                    pack_number(plhs[0], frame(unpack_pointer(libvlc_media_player_t, prhs[1])));
                    break;
                case 3:
                    pack_number(plhs[0], frame(unpack_pointer(libvlc_media_player_t, prhs[1]), mxGetPr(prhs[2])[0]));
                    break;
            }
            break;
        case PLAY:
            if (!check_args(nrhs, 3)) return;
            play(unpack_pointer(libvlc_media_player_t, prhs[1]), mxGetPr(prhs[2])[0]);
            break;
        case PAUSE:
            if (!check_args(nrhs, 2)) return;
            pause(unpack_pointer(libvlc_media_player_t, prhs[1]));
            break;
        case INFO:
            if (!check_args(nrhs, 2)) return;
            pack_number(plhs[0], info(unpack_pointer(libvlc_media_player_t, prhs[1])));
            break;
        case CLEANUP:
            if (!check_args(nrhs, 1)) return;
            cleanup();
            break;
        default:
            mexErrMsgIdAndTxt("VLC:badVerb", "Unsupported operation");
            break;
    }
}

static void cleanup()
{
    for (player_list::iterator i = players.begin(); i != players.end(); ++i)
    {
        if (libvlc_media_player_is_playing(*i)) {
            libvlc_media_player_stop(*i);
        }
        libvlc_media_player_release(*i);
    }
    players.clear();

    for (instance_list::iterator i = instances.begin(); i != instances.end(); ++i)
    {
        libvlc_release(*i);
    }
    instances.clear();
    
#ifdef OWN_WINDOW
    for (window_list::iterator i = windows.begin(); i != windows.end(); ++i)
    {
        close_window(i->second);
    }
#endif
}

libvlc_instance_t* init()
{
#ifdef __APPLE__
#include "apple_workaround.h"
    setenv("VLC_PLUGIN_PATH", _VLC_ "/Contents/MacOS/plugins", 1);
#endif
    libvlc_instance_t *vlc = libvlc_new(0, NULL);
    instances.push_back(vlc);
    
    if (vlc == NULL) {
        mexWarnMsgIdAndTxt("VLC:init:nullPointer", "VLC instance is NULL");
    }

    return vlc;
}

void release(libvlc_instance_t *vlc)
{
    instance_list::iterator iter = find(instances.begin(), instances.end(), vlc);
    if (iter == instances.end()) {
        mexErrMsgIdAndTxt("VLC:release:invalidHandle", "Not a VLC instance");
        return;
    }

    instances.erase(iter);
    libvlc_release(vlc);
}

libvlc_media_player_t* open(libvlc_instance_t *vlc, string filename)
{
    instance_list::iterator iter = find(instances.begin(), instances.end(), vlc);
    if (iter == instances.end()) {
        mexErrMsgIdAndTxt("VLC:open:invalidHandle", "Not a VLC instance");
        return NULL;
    }

    struct stat statbuf;
    if (stat(filename.c_str(), &statbuf) == -1) {
        mexErrMsgIdAndTxt("VLC:open:badFile", "Could not stat video file: %s", strerror(errno));
        return NULL;
    }
    
    libvlc_media_t *media = libvlc_media_new_path(vlc, filename.c_str());
    libvlc_media_player_t *player = libvlc_media_player_new_from_media(media);
    if (!media || !player) {
        mexErrMsgIdAndTxt("VLC:open:errorOpening", "Could not open video file");
        return NULL;
    }
    
    players.push_back(player);
    
    libvlc_media_parse(media);
    char *title = libvlc_media_get_meta(media, libvlc_meta_Title);
    
#ifdef __APPLE__
    // get size
    libvlc_media_track_t **tracks;
    int count = libvlc_media_tracks_get(media, &tracks);
    int w = 720, h = 480;
    for (int i = 0; i < count; ++i) {
        if (tracks[i]->i_type == libvlc_track_video) {
            w = tracks[i]->video->i_width > w
                    ? tracks[i]->video->i_width
                    : w;
            h = tracks[i]->video->i_height > h
                    ? tracks[i]->video->i_height
                    : h;
        }
    }
    libvlc_media_tracks_release(tracks, count);
#endif
#ifdef __APPLE__    
    NSWindow *win;
    NSView *view = create_window(&win, 100, 100, w, h, title);
    windows[player] = win;
    
    libvlc_media_player_set_nsobject(player, view);
#endif
#ifdef _WIN32
	windows[player] = create_window(100, 100, 720, 480, title);
	libvlc_media_player_set_hwnd(player, windows[player]);
#endif
    
    libvlc_media_player_play(player);
    while (!libvlc_media_player_is_playing(player));
    libvlc_media_player_pause(player);
    
    libvlc_media_release(media);
    return player;
}

void close(libvlc_media_player_t *player)
{
    
    player_list::iterator iter = find(players.begin(), players.end(), player);
    if (iter == players.end()) {
        mexErrMsgIdAndTxt("VLC:close:invalidHandle", "Not a VLC media player instance");
        return;
    }
    
#ifdef OWN_WINDOW
    window_list::iterator witer = windows.find(player);
    if (witer != windows.end()) {
        close_window(witer->second);
        windows.erase(witer);
    }
#endif

    players.erase(iter);
    libvlc_media_player_release(player);
}

double frame(libvlc_media_player_t *player, double ms)
{
    if (find(players.begin(), players.end(), player) != players.end()) {
        libvlc_media_player_set_time(player, ms);
        return libvlc_media_player_get_time(player);
    }
    return -1;
}

double frame(libvlc_media_player_t *player)
{
    if (find(players.begin(), players.end(), player) != players.end()) {
        return libvlc_media_player_get_time(player);
    }
    return -1;
}

void play(libvlc_media_player_t *player, float rate)
{
    if (find(players.begin(), players.end(), player) != players.end())
    {
        libvlc_media_player_set_rate(player, rate);
        libvlc_media_player_play(player);
    }
}

void pause(libvlc_media_player_t *player)
{
    if (find(players.begin(), players.end(), player) != players.end())
        libvlc_media_player_pause(player);
}

vector<double> info(libvlc_media_player_t *player)
{
    vector<double> v;
    if (find(players.begin(), players.end(), player) != players.end()) {
        v.push_back(libvlc_media_player_get_fps(player));
        
        v.push_back(libvlc_media_get_duration(libvlc_media_player_get_media(player)));
    }
    return v;
}

