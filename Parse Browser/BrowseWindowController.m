//
//  BrowseWindowController.m
//  Parse Browser
//
//  Created by Nick Sulik on 12-10-31.
//  Copyright (c) 2012 Nick Sulik. All rights reserved.
//

#import "BrowseWindowController.h"
#import "ConstraintViewController.h"
#import "JSONKit.h"
#import "TextFieldCell.h"

@interface BrowseWindowController () {
    NSMutableArray* _constraintControllerArray;
    NSArray* _tableData;
    NSArray* _columns;
    NSString* _currentClass;
}

- (NSString*)getParamsFromBasicQuery;

@end

@implementation BrowseWindowController

#pragma mark Window methods

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        _constraintControllerArray = [[NSMutableArray alloc] init];
        _tableData = [[NSArray alloc] init];
        _columns = [[NSArray alloc] init];
        _currentClass = nil;
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    //Generate constraint form view
    ConstraintViewController* newConstraint = [[ConstraintViewController alloc] initWithNibName:@"ConstraintView" bundle:nil];
    CGRect constraintFrame = [newConstraint view].frame;
    constraintFrame.origin = CGPointMake(344, 54);
    [newConstraint view].frame = constraintFrame;
    
    newConstraint.addConstraintButton.title = @"Where";
    newConstraint.addConstraintButton.tag = _constraintControllerArray.count;
    [newConstraint.addConstraintButton setTarget:self];
    [newConstraint.addConstraintButton setAction:@selector(clickedWhere:)];
    
    newConstraint.removeConstraintButton.tag = _constraintControllerArray.count;
    [newConstraint.removeConstraintButton setTarget:self];
    [newConstraint.removeConstraintButton setAction:@selector(removeConstraint:)];
    
    NSMenuItem* boolItem = [newConstraint.columnType.menu itemAtIndex:BOOLEAN];
    boolItem.tag = _constraintControllerArray.count;
    [boolItem setTarget:self];
    [boolItem setAction:@selector(hidePointerType:)];
    
    NSMenuItem* numItem = [newConstraint.columnType.menu itemAtIndex:NUMBER];
    numItem.tag = _constraintControllerArray.count;
    [numItem setTarget:self];
    [numItem setAction:@selector(hidePointerType:)];
    
    NSMenuItem* ptrItem = [newConstraint.columnType.menu itemAtIndex:POINTER];
    ptrItem.tag = _constraintControllerArray.count;
    [ptrItem setTarget:self];
    [ptrItem setAction:@selector(showPointerType:)];
    
    NSMenuItem* strItem = [newConstraint.columnType.menu itemAtIndex:STRING];
    strItem.tag = _constraintControllerArray.count;
    [strItem setTarget:self];
    [strItem setAction:@selector(hidePointerType:)];
    
    [_constraintControllerArray addObject:newConstraint];
    
    [self.simpleQueryView addSubview:[newConstraint view]];
    [self appendStringToResponseConsole:@"\n"];
    
}

#pragma mark -
#pragma mark Button Selectors

-(IBAction)showPointerType:(NSMenuItem*)sender {
    
    ConstraintViewController* controller = [_constraintControllerArray objectAtIndex:[sender tag]];
    CGRect frame = [controller valueSection].frame;
    frame.origin = CGPointMake(frame.origin.x + 110, frame.origin.y);
    [controller valueSection].frame = frame;
    
    [[controller pointerClassName] setHidden:NO];
}

-(IBAction)hidePointerType:(NSMenuItem*)sender {
    ConstraintViewController* controller = [_constraintControllerArray objectAtIndex:[sender tag]];
    if(![controller pointerClassName].isHidden) {
        [[controller pointerClassName] setHidden:YES];
        
        CGRect frame = [controller valueSection].frame;
        frame.origin = CGPointMake(frame.origin.x - 110, frame.origin.y);
        [controller valueSection].frame = frame;
    }
}

- (IBAction)clickedWhere:(NSButton*)sender {
    [sender setBordered:NO];
    [sender setEnabled:NO];
    
    //controller
    ConstraintViewController* currentController = [_constraintControllerArray objectAtIndex:[sender tag]];
    
    //Show rest of the current constraint view
    [[currentController constraintFormView] setHidden:NO];
    
    //Remove the previous remove button
    if(_constraintControllerArray.count > 1) {
        ConstraintViewController* previousController = [_constraintControllerArray objectAtIndex:[sender tag] -1];
        [[previousController removeConstraintButton] setHidden:YES];
    }
    
    if(_constraintControllerArray.count < MAX_CONSTRAINTS) {
        //Generate new constraint view
        ConstraintViewController* newConstraint = [[ConstraintViewController alloc] initWithNibName:@"ConstraintView" bundle:nil];
        CGRect constraintFrame = [currentController view].frame;
        constraintFrame.origin = CGPointMake(constraintFrame.origin.x, constraintFrame.origin.y - 25);
        [newConstraint view].frame = constraintFrame;
        
        newConstraint.addConstraintButton.title = @"And";
        newConstraint.addConstraintButton.tag = _constraintControllerArray.count;
        [newConstraint.addConstraintButton setTarget:self];
        [newConstraint.addConstraintButton setAction:@selector(clickedWhere:)];
        
        newConstraint.removeConstraintButton.tag = _constraintControllerArray.count;
        [newConstraint.removeConstraintButton setTarget:self];
        [newConstraint.removeConstraintButton setAction:@selector(removeConstraint:)];
        
        NSMenuItem* boolItem = [newConstraint.columnType.menu itemAtIndex:BOOLEAN];
        boolItem.tag = _constraintControllerArray.count;
        [boolItem setTarget:self];
        [boolItem setAction:@selector(hidePointerType:)];
        
        NSMenuItem* numItem = [newConstraint.columnType.menu itemAtIndex:NUMBER];
        numItem.tag = _constraintControllerArray.count;
        [numItem setTarget:self];
        [numItem setAction:@selector(hidePointerType:)];
        
        NSMenuItem* ptrItem = [newConstraint.columnType.menu itemAtIndex:POINTER];
        ptrItem.tag = _constraintControllerArray.count;
        [ptrItem setTarget:self];
        [ptrItem setAction:@selector(showPointerType:)];
        
        NSMenuItem* strItem = [newConstraint.columnType.menu itemAtIndex:STRING];
        strItem.tag = _constraintControllerArray.count;
        [strItem setTarget:self];
        [strItem setAction:@selector(hidePointerType:)];
        
        [_constraintControllerArray addObject:newConstraint];
        
        //Add newly generated elements to view
        [self.simpleQueryView addSubview:[newConstraint view]];
    }
}

- (IBAction)removeConstraint:(NSButton*)sender {
    if([sender tag] > 0) {
        //Show previous constraint view delete button
        ConstraintViewController* previousConstraintConstroller = [_constraintControllerArray objectAtIndex:([sender tag] - 1)];
        [[previousConstraintConstroller removeConstraintButton] setHidden:NO];
    }
    
    //Hide the rest of the current constraint view and enable the add/where button
    ConstraintViewController* currentConstraintConstroller = [_constraintControllerArray objectAtIndex:([sender tag])];
    [[currentConstraintConstroller constraintFormView] setHidden:YES];
    [[currentConstraintConstroller addConstraintButton] setBordered:YES];
    [[currentConstraintConstroller addConstraintButton] setEnabled:YES];
    
    //Remove the next constraint view from the window and delete the entry in the constraint constroller array
    if([sender tag] < (MAX_CONSTRAINTS - 1)) {
        ConstraintViewController* nextConstraintConstroller = [_constraintControllerArray objectAtIndex:([sender tag] + 1)];
        [[nextConstraintConstroller view] removeFromSuperview];
        [_constraintControllerArray removeLastObject];
    }
    
}

- (IBAction)getData:(NSButton*)sender {
    BOOL issue = NO;
    
    if(![self constraintFormsFilled]) {
        [self appendStringToResponseConsole:@"Please fill in all the input or remove uneeded ones.\n"];
        issue = YES;
    }
    
    if(self.className.stringValue.length == 0) {
        [self appendStringToResponseConsole:@"Please fill in the class name to query.\n"];
        issue = YES;
    }
    
    if(!issue){
        [sender setEnabled:NO];
        [sender setTitle:@"Loading"];
        JSONDecoder* decoder = [[JSONDecoder alloc]
                                initWithParseOptions:JKParseOptionNone];
        _currentClass = [self.className stringValue];
        
        NSString* urlString = nil;
        
        if(_constraintControllerArray.count == 1) {
            urlString = [NSString stringWithFormat:@"https://api.parse.com/1/classes/%@",[self.className stringValue]];
        } else {
            urlString = [NSString stringWithFormat:@"https://api.parse.com/1/classes/%@?%@",[self.className stringValue],[self getParamsFromBasicQuery]];
        }
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [request addValue:@"9hrI0yl4JxdZuTSlAHXZxROtHRXbFd2QeBCaHCAY" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [request addValue:@"rz12fkyL9jEKfnByEcq2QQ0h2P6c95qTHJNaTZcv" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [request addValue:@"FBWK6u1JIvTsbVjojwm34SFqxmnsX52K7DgE04fZ" forHTTPHeaderField:@"X-Parse-Master-Key"];
        NSOperationQueue* queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                if([httpResponse statusCode] == 200) {
                    [self.dataTable beginUpdates];
                    [self.dataTable scrollRowToVisible:0];
                    [self clearTable];
                    _tableData = [[decoder objectWithData:data] objectForKey:@"results"];
                    if([_tableData count] > 0) {
                        NSMutableArray* columnNames = [[NSMutableArray alloc] init];
                        
                        NSMutableArray* columnTitles = [[NSMutableArray alloc] init];
                        for(int i = 0; i < _tableData.count; i++) {
                            NSArray* entryKeys = [[_tableData objectAtIndex:i] allKeys];
                            for(int j = 0; j < entryKeys.count; j++ ){
                                if(![columnNames containsObject: [entryKeys objectAtIndex:j]]) {
                                    [columnNames addObject:[entryKeys objectAtIndex:j]];
                                }
                            }
                        }
                        
                        for(int i = 0; i < columnNames.count;i++) {
                            NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:[columnNames objectAtIndex:i]];
                            [column setEditable:YES];
                            [[column headerCell] setStringValue:[columnNames objectAtIndex:i]];
                            
                            [columnTitles addObject:column];
                            [self.dataTable addTableColumn:column];
                        }
                        
                        _columns = [NSArray arrayWithArray:columnTitles];
                    }
                    
                    [self.dataTable endUpdates];
                    [self.dataTable reloadData];
                    
                    [sender setEnabled:YES];
                    [sender setTitle:@"Get Data"];
                    
                    if([_tableData count] == 0) {
                        [self appendStringToResponseConsole: @"No matches found. Check the query for mistakes.\n"];
                    } else {
                        [self appendStringToResponseConsole:[NSString stringWithFormat:@"Success! Displaying %ld results.\n", [_tableData count]]];
                    }
                } else {
                    [self appendStringToResponseConsole:[NSString stringWithFormat:@"Error: %ld - %@\n", [httpResponse statusCode], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
                    [sender setEnabled:YES];
                    [sender setTitle:@"Get Data"];
                }
            }
        }];
    }
}

#pragma mark -
#pragma mark NSTableView DataSource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return _tableData.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    //NSLog(@"row#: %ld; columnName:%@",row,[tableColumn identifier]);
    TextFieldCell *result = [tableView makeViewWithIdentifier:@"MyView" owner:self];
                
    if (result == nil) {
        result = [[TextFieldCell alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        result.identifier = @"MyView";
    }
    
    [result setColumnIdentifier:[tableColumn identifier]];
    [result setRowIndex:(int)row];
    
    id entry = [[_tableData objectAtIndex:row] objectForKey:[tableColumn identifier]];
    if([entry isKindOfClass:[NSDictionary class]]) {
        NSString* type = [entry objectForKey:@"__type"];
        if([type isEqualToString:@"Date"]) {
            result.stringValue = [entry objectForKey:@"iso"];
        }
        if([type isEqualToString:@"Pointer"]) {
            result.stringValue = [entry objectForKey:@"objectId"];
        }
        if([type isEqualToString:@"File"]) {
            result.stringValue = [entry objectForKey:@"url"];
        }
    } else {
        if(!entry) {
            result.stringValue = @"";
        } else {
            result.stringValue = entry;
        }
    }
    
    [result setSelectable:YES];
    
    if([[tableColumn identifier] isEqualToString:@"objectId"] ||[[tableColumn identifier] isEqualToString:@"createdAt"] || [[tableColumn identifier] isEqualToString:@"updatedAt"]) {
        [result setEditable:NO];
    } else {
        [result setEditable:YES];
    }
    
    result.delegate = self;
    result.tag = row;
                
    return result;
                
}

#pragma mark -
#pragma mark NSTextField delegate

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    int rowIndex = (int)[(TextFieldCell*)control rowIndex];
    NSString* columnIdentifier = [(TextFieldCell*)control columnIdentifier];
    NSString* objectId = [[_tableData objectAtIndex:(long)rowIndex ] objectForKey:@"objectId"];
    
    NSString* newString = [(TextFieldCell*)control stringValue];
    [self updateParseObject:objectId forColumn:columnIdentifier withString:newString];
    return true;
}

#pragma mark -
#pragma mark NSTableView Delegate methods
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 20;
}
     
#pragma mark -
#pragma mark Utilities

- (void)clearTable {
    while([[self.dataTable tableColumns] count] > 0) {
        [self.dataTable removeTableColumn:[[self.dataTable tableColumns] lastObject]];
    }
}

- (void)updateParseObject:(NSString*)objectId forColumn:(NSString*)columnName withString:(NSString*)text {
    NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
    
    NSString* urlString = [NSString stringWithFormat:@"https://api.parse.com/1/classes/%@/%@",_currentClass,objectId];
    NSString* body = nil;
    if([formater numberFromString:text]) {
        body = [NSString stringWithFormat:@"{\"%@\": %@}",columnName,text];
    } else if ([[text lowercaseString] isEqualToString:@"true"] ||[[text lowercaseString] isEqualToString:@"false"]) {
        body = [NSString stringWithFormat:@"{\"%@\": %@}",columnName,[text lowercaseString]];
    } else {
        body = [NSString stringWithFormat:@"{\"%@\": \"%@\"}",columnName,text];
    }
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:@"9hrI0yl4JxdZuTSlAHXZxROtHRXbFd2QeBCaHCAY" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request addValue:@"rz12fkyL9jEKfnByEcq2QQ0h2P6c95qTHJNaTZcv" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [request addValue:@"FBWK6u1JIvTsbVjojwm34SFqxmnsX52K7DgE04fZ" forHTTPHeaderField:@"X-Parse-Master-Key"];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if([httpResponse statusCode] == 200) {
                [self appendStringToResponseConsole:[NSString stringWithFormat:@"Successfully Updated: %@\n", objectId]];
            } else {
                [self appendStringToResponseConsole:[NSString stringWithFormat:@"Error: %ld - %@\n", [httpResponse statusCode], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
            }
        }
    }];
}

- (NSString*)getParamsFromBasicQuery {
    NSMutableString* paramString = [NSMutableString stringWithString:@"where={"];
    
    for(int i =0; i<_constraintControllerArray.count; i++) {
        ConstraintViewController* currentController = (ConstraintViewController*)[_constraintControllerArray objectAtIndex:i];
        if(![[currentController constraintFormView] isHidden]) {
            //Get form entries
            NSString* columnName = [[currentController columnName] stringValue];
            NSString* constraintVerb = [self getConstraintVerbFromPopUpButton:[currentController constraintType]];
            NSString* constraintValue = [[currentController constraintValue] stringValue];
            NSString* columnType = [self getColumnTypeFromPopUpButton:[currentController columnType]];
            NSString* columnClass = [[currentController pointerClassName] stringValue];
            
            //Construct JSON GET request
            if([constraintVerb isEqualToString:@"$exists"]) {
                [paramString appendString:[NSString stringWithFormat:@"\"%@\" : {\"%@\" :%@},",columnName,constraintVerb,[constraintValue lowercaseString]]];
            } else {
                if( [columnType isEqualToString:@"Number"]) {
                    if([constraintVerb isEqualToString:@"$e"]) {
                        [paramString appendString:[NSString stringWithFormat:@"\"%@\" : %@,",columnName,constraintValue]];
                    } else {
                        [paramString appendString:[NSString stringWithFormat:@"\"%@\" : {\"%@\" : %@},",columnName,constraintVerb,constraintValue]];
                    }
                } else if( [columnType isEqualToString:@"Boolean"]) {
                    if([constraintVerb isEqualToString:@"$e"]) {
                        [paramString appendString:[NSString stringWithFormat:@"\"%@\" :%@,",columnName,[constraintValue lowercaseString]]];
                    } else {
                        [paramString appendString:[NSString stringWithFormat:@"\"%@\" : {\"%@\" :%@},",columnName,constraintVerb,[constraintValue lowercaseString]]];
                    }
                } else  if([columnType isEqualToString:@"Pointer"]) {
                    if([constraintVerb isEqualToString:@"$e"]) {
                        [paramString appendString:[NSString stringWithFormat:@"\"%@\" : {\"__type\":\"Pointer\",\"className\":\"%@\",\"objectId\":\"%@\"},",columnName,columnClass,constraintValue]];
                    } else {
                        [paramString appendString:[NSString stringWithFormat:@"\"%@\" : {\"%@\" : {\"__type\":\"Pointer\",\"className\":\"%@\",\"objectId\":\"%@\"}},",columnName,constraintVerb,columnClass,constraintValue]];
                    }
                } else  if([columnType isEqualToString:@"String"]) {
                    if([constraintVerb isEqualToString:@"$e"]) {
                        [paramString appendString:[NSString stringWithFormat:@"\"%@\" : \"%@\",",columnName,constraintValue]];
                    } else {
                        [paramString appendString:[NSString stringWithFormat:@"\"%@\" : {\"%@\" : \"%@\"},",columnName,constraintVerb,constraintValue]];
                    }
                }
            }
        }
    }
    
    paramString = [NSMutableString stringWithString:[paramString substringToIndex:[paramString length] -1]];
    [paramString appendString:@"}"];
    
    return [paramString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

- (BOOL) constraintFormsFilled {
    for(int i=0; i<_constraintControllerArray.count-1; i++) {
        NSString* columnName = [[(ConstraintViewController*)[_constraintControllerArray objectAtIndex:i] columnName] stringValue];
        NSString* constraintValue = [[(ConstraintViewController*)[_constraintControllerArray objectAtIndex:i] constraintValue] stringValue];
        if(columnName.length == 0 || constraintValue.length == 0) {
            return false;
        }
    }
    
    return true;
}

- (NSString*) getConstraintVerbFromPopUpButton: (NSPopUpButton*)button {
    switch ([button indexOfSelectedItem]) {
        case LT:
            return @"$lt";
            break;
            
        case LTE:
            return @"$lte";
            break;
            
        case GT:
            return @"$gt";
            break;
            
        case GTE:
            return @"$gte";
            break;
            
        case E:
            return @"$e";
            break;
            
        case NE:
            return @"$ne";
            break;
            
        case EXISTS:
            return @"$exists";
            break;
            
        default:
            return nil;
            break;
    }
}

- (NSString*) getColumnTypeFromPopUpButton: (NSPopUpButton*)button {
    switch ([button indexOfSelectedItem]) {
        case BOOLEAN:
            return @"Boolean";
            break;
            
        case NUMBER:
            return @"Number";
            break;
            
        case POINTER:
            return @"Pointer";
            break;
            
        case STRING:
            return @"String";
            break;
            
        default:
            return nil;
            break;
    }
}


- (void) appendStringToResponseConsole: (NSString*)text {
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:text];
    NSTextStorage *storage = [self.responseConsoleTextView textStorage];
    
    [storage beginEditing];
    [storage appendAttributedString:string];
    [storage endEditing];
}

@end
