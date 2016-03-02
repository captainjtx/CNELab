//
//  MexWindowHelper.h
//  MexWindowHelper
//
//  Created by Alex Burka on 1/28/15.
//  Copyright (c) 2015 Alex Burka. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AppKit;

@interface MexWindowHelper : NSObject

NSView *create_window(NSWindow **pwin, float x, float y, float w, float h, char *title);
void close_window(NSWindow *win);

@end
