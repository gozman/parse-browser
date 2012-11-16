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
    
    if(!browserWindowArray) {
        browserWindowArray = [[NSMutableArray alloc] init];
    }
    
    if (browserWindowArray.count == 0){
		[browserWindowArray addObject:[[BrowseWindowController alloc] initWithWindowNibName:@"BrowseWindowController"]];
    }
	
	[[browserWindowArray objectAtIndex:0] showWindow:self];
    
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

#pragma mark -
#pragma mark Main Menu button actions

- (IBAction)launchPreferences:(id)sender {
    if (preferenceWindowController == NULL){
		preferenceWindowController = [[PreferenceWindowController alloc] initWithWindowNibName:@"PreferenceWindowController"];
    }
	
	[preferenceWindowController showWindow:self];
    
}

- (IBAction)launchNewBrowserWindow:(id)sender {
    [browserWindowArray addObject:[[BrowseWindowController alloc] initWithWindowNibName:@"BrowseWindowController"]];
	
	[[browserWindowArray lastObject] showWindow:self];
    
}

#pragma mark -
#pragma mark Utilities

- (NSMutableArray*)getBrowserArray {
    return browserWindowArray;
}

@end
