#ifndef _VLC_MEX_H_
#define _VLC_MEX_H_

#include <mex.h>
#include <vlc/vlc.h>
#include <string>
#include <vector>
#include <list>
#include <map>
#include <algorithm>
#include <sys/stat.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
using std::vector;
using std::string;
using std::list;
using std::map;
using std::find;

typedef list<libvlc_instance_t*> instance_list;
typedef list<libvlc_media_player_t*> player_list;

#ifdef __APPLE__
#define OWN_WINDOW
typedef void NSWindow;
typedef void NSView;
extern "C" {
    NSView* create_window(NSWindow**, float, float, float, float, char*);
    void close_window(NSWindow*);
}
typedef map<libvlc_media_player_t*, NSWindow*> window_list;
#endif
#ifdef _WIN32
#define OWN_WINDOW
typedef void* HWND;
typedef map<libvlc_media_player_t*, HWND> window_list;
extern "C" {
	HWND create_window(int, int, int, int, const char*);
	void close_window(HWND);
}
#endif

bool check_args(int nrhs, int n);
bool check_args(int nrhs, int m, int n);

string arr2str(const mxArray *arr);

void* unpack_pointer_INTERNAL(const mxArray *arr);
#define unpack_pointer(T,arr) ((T*)unpack_pointer_INTERNAL(arr))
void pack_pointer_INTERNAL(mxArray **arr, void *p);
#define pack_pointer(arr,p) pack_pointer_INTERNAL(&(arr), (void*)(p))
void pack_number_INTERNAL(mxArray **arr, double d);
void pack_number_INTERNAL(mxArray **arr, vector<double> vd);
#define pack_number(arr,d) pack_number_INTERNAL(&(arr), d)

#endif // _VLC_MEX_H_

