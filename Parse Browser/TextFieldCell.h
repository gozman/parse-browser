//
//  TextFieldCell.h
//  Parse Browser
//
//  Created by Nick Sulik on 12-11-09.
//  Copyright (c) 2012 Nick Sulik. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TextFieldCell : NSTextField

- (id)initWithFrame:(NSRect)frame columnIdentifier:(NSString*)columnIdentifier rowIndex:(int)rowIndex;

- (void) setRowIndex:(int)rowIndex;
- (void) setColumnIdentifier:(NSString*)columnIdentifier;

- (int) rowIndex;
- (NSString*) columnIdentifier;
@end
