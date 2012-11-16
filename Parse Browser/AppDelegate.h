//
//  AppDelegate.h
//  Parse Browser
//
//  Created by Nick Sulik on 12-10-30.
//  Copyright (c) 2012 Nick Sulik. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BrowseWindowController.h"
#import "PreferenceWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSMutableArray* browserWindowArray;
    BrowseWindowController* mainWindowController;
    PreferenceWindowController* preferenceWindowController;
}

- (NSMutableArray*)getBrowserArray;

@end
