//
//  Constants.h
//  Parse Browser
//
//  Created by Nick Sulik on 12-11-01.
//  Copyright (c) 2012 Nick Sulik. All rights reserved.
//

//Constants for Broswer View (BrowserWindowController)
extern int const AND_BUTTON_TAG_OFFSET;
extern int const X_BUTTON_TAG_OFFSET;
extern int const TYPE_DROPDOWN_TAG_OFFSET;
extern int const MAX_CONSTRAINTS;

typedef enum {
    WHERE_TYPE,
    AND_TYPE
} ConstraintType;

typedef enum {
    LT,
    LTE,
    GT,
    GTE,
    E,
    NE,
    EXISTS
} ConstraintVerb;

typedef enum {
    BOOLEAN,
    NUMBER,
    POINTER,
    STRING
} ColumnType;