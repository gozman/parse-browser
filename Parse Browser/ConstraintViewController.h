//
//  ConstraintViewController.h
//  Parse Browser
//
//  Created by Nick Sulik on 12-10-31.
//  Copyright (c) 2012 Nick Sulik. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ConstraintViewController : NSViewController

@property (strong) IBOutlet NSTextField *columnName;
@property (strong) IBOutlet NSTextField *constraintValue;
@property (strong) IBOutlet NSPopUpButton *constraintType;
@property (strong) IBOutlet NSButton *removeConstraintButton;
@property (strong) IBOutlet NSButton *addConstraintButton;
@property (strong) IBOutlet NSView *constraintFormView;
@property (strong) IBOutlet NSPopUpButton *columnType;
@property (strong) IBOutlet NSTextField *pointerClassName;
@property (strong) IBOutlet NSView *valueSection;

@end
