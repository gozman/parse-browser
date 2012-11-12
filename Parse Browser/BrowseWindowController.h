//
//  BrowseWindowController.h
//  Parse Browser
//
//  Created by Nick Sulik on 12-10-31.
//  Copyright (c) 2012 Nick Sulik. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BrowseWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>

@property (strong) IBOutlet NSView *simpleQueryView;
@property (strong) IBOutlet NSTextField *className;
@property (strong) IBOutlet NSTableView *dataTable;
@property (strong) IBOutlet NSTextView *responseConsoleTextView;

@end
