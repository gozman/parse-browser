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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    if (mainWindowController == NULL){
		mainWindowController = [[BrowseWindowController alloc] initWithWindowNibName:@"BrowseWindowController"];
    }
	
	[mainWindowController showWindow:self];
    
    //Check for the user preferences have been set
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if(![prefs stringForKey:@"query-result-limit"]) {
        [prefs setObject:[NSNumber numberWithInt:400] forKey:@"query-result-limit"];
    }
    
    if(![prefs stringForKey:@"application-id"] || ![prefs stringForKey:@"master-key"]) {
        if (preferenceWindowController == NULL){
            preferenceWindowController = [[PreferenceWindowController alloc] initWithWindowNibName:@"PreferenceWindowController"];
        }
        
        [preferenceWindowController showWindow:self];
    }
}

-(IBAction)launchPreferences:(id)sender {
    if (preferenceWindowController == NULL){
		preferenceWindowController = [[PreferenceWindowController alloc] initWithWindowNibName:@"PreferenceWindowController"];
    }
	
	[preferenceWindowController showWindow:self];
    
}

@end
