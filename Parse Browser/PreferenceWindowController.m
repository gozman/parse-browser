//
//  PreferenceWindowController.m
//  Parse Browser
//
//  Created by Nick Sulik on 12-11-13.
//  Copyright (c) 2012 Nick Sulik. All rights reserved.
//

#import "PreferenceWindowController.h"

@interface PreferenceWindowController ()

@end

@implementation PreferenceWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if([prefs stringForKey:@"application-id"]) {
        [self applicationIDField].stringValue = [prefs stringForKey:@"application-id"];
    } else {
        [self applicationIDField].stringValue = @"";
    }
    
    if([prefs stringForKey:@"master-key"]) {
        [self masterKeyField].stringValue = [prefs stringForKey:@"master-key"];
    } else {
        [self masterKeyField].stringValue = @"";
    }
    
    [self queryResultLimit].stringValue = [prefs stringForKey:@"query-result-limit"];
    
}

- (IBAction)savePreferences:(NSButton*)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setObject:[self.applicationIDField stringValue] forKey:@"application-id"];
    [prefs setObject:[self.masterKeyField stringValue] forKey:@"master-key"];
    [prefs setObject:[self.queryResultLimit stringValue] forKey:@"query-result-limit"];
    
    [prefs synchronize];
}



@end
