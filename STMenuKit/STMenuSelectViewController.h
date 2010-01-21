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
 
 It is simply a list of items that the user may choose from.
 
 TODO: Multi Select
 
 */

@interface STMenuSelectViewController : STMenuSubMenuTableViewController
{
  @protected
    NSIndexPath *_selectedRow;
    
    id          _defaultValue;
    NSArray     *_values;
    NSArray     *_sections;
    NSArray     *_rows;
}

// This is the value to show when value is not in values or is nil, optional.
@property (nonatomic, retain)   id              defaultValue;

// These are the sections to show the user. It must be an array of arrays. Each
// sub array is a section and each sub array item is a row. The items of each
// sub array will be shown to the user as options. We call description on each
// item before setting it to the cell's title.
@property (nonatomic, retain)   NSArray         *sections;
// OR, you may use this if you only have one section
@property (nonatomic, retain)   NSArray         *rows;

// We map these values to the options. values must contain the same number of
// elements as you have options. If you use sections, values must be an array
// of arrays.
@property (nonatomic, retain)   NSArray         *values;

@end
