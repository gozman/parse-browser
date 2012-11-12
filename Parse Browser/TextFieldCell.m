//
//  TextFieldCell.m
//  Parse Browser
//
//  Created by Nick Sulik on 12-11-09.
//  Copyright (c) 2012 Nick Sulik. All rights reserved.
//

#import "TextFieldCell.h"

@interface TextFieldCell () {
    NSString* _columnIdentifier;
    int _rowIndex;
}

@end

@implementation TextFieldCell

- (id)initWithFrame:(NSRect)frame columnIdentifier:(NSString*)columnIdentifier rowIndex:(int)rowIndex
{
    self = [super initWithFrame:frame];
    if (self) {
        _columnIdentifier = columnIdentifier;
        _rowIndex = rowIndex;
    }
    
    return self;
}

- (void) setRowIndex:(int)rowIndex {
    _rowIndex = rowIndex;
}

- (void) setColumnIdentifier:(NSString*)columnIdentifier {
    _columnIdentifier = columnIdentifier;
}

- (int) rowIndex {
    return _rowIndex;
}

- (NSString*) columnIdentifier {
    return _columnIdentifier;
}

@end
