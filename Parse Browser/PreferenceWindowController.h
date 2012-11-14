//
//  PreferenceWindowController.h
//  Parse Browser
//
//  Created by Nick Sulik on 12-11-13.
//  Copyright (c) 2012 Nick Sulik. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferenceWindowController : NSWindowController

@property (strong) IBOutlet NSTextField *applicationIDField;
@property (strong) IBOutlet NSTextField *masterKeyField;
@property (strong) IBOutlet NSTextField *queryResultLimit;
@property (strong) IBOutlet NSButton *savePreferencesButton;
@property (strong) IBOutlet NSTextField *limitErrorText;


@end
