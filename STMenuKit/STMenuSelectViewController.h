//
//  STMenuSelectViewController.h
//  STMenuKit
//
//  Created by Jason Gregori on 1/17/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STMenuSubMenuTableViewController.h"

/*
 
 STMenuSelectViewController
 --------------------------
 
 This is a Multi Select Menu.
 
 */

@interface STMenuSelectViewController : STMenuSubMenuTableViewController
{
    NSUInteger  _selectedRow;
    
    id          _defaultValue;
    NSArray     *_values;
    NSArray     *_strings;
}
// This is the value to show when value is not in values or is nil, optional.
@property (nonatomic, retain)   id              defaultValue;
// We map these values to the titles and use the titles for the valueString.
@property (nonatomic, retain)   NSArray         *values;
@property (nonatomic, retain)   NSArray         *strings;

@end
