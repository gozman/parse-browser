//
//  AppDelegate.m
//  Parse Browser
//
//  Created by Nick Sulik on 12-10-30.
//  Copyright (c) 2012 Nick Sulik. All rights reserved.
//

#import "AppDelegate.h"
#import "BrowseWindowController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if (mainWindowController == NULL)
		mainWindowController = [[BrowseWindowController alloc] initWithWindowNibName:@"BrowseWindowController"];
	
	[mainWindowController showWindow:self];
}

@end
