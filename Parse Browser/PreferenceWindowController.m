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

#pragma mark -
#pragma mark NSbutton Selectors

- (IBAction)savePreferences:(NSButton*)sender {
    NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
    NSNumber* limit = [formater numberFromString:[self.queryResultLimit stringValue]];
    
    if(limit) {
        if(limit >= [NSNumber numberWithInt:1] || limit <= [NSNumber numberWithInt:1000]){
            [self.limitErrorText setHidden:YES];
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:[self.applicationIDField stringValue] forKey:@"application-id"];
            [prefs setObject:[self.masterKeyField stringValue] forKey:@"master-key"];
            [prefs setObject:[self.queryResultLimit stringValue] forKey:@"query-result-limit"];
            
            [prefs synchronize];
        } else {
            [self.limitErrorText setHidden:NO];
        }
    } else {
        [self.limitErrorText setHidden:NO];
    }
}

#pragma mark -
#pragma mark NSTextField delegate

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
    NSNumber* limit = [formater numberFromString:[(NSTextField*)control stringValue]];
    
    if(limit) {
        if(limit >= [NSNumber numberWithInt:1] || limit <= [NSNumber numberWithInt:1000]){
            [self.savePreferencesButton setEnabled:YES];
        } else {
            [self.savePreferencesButton setEnabled:NO];
        }
    } else {
        [self.savePreferencesButton setEnabled:NO];
    }
    return true;
}



@end
