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
 
 This is a Select Menu.
 
 It is simply a list of items that the user may choose from.
 
 plist
 -----
 { // dictionary
    "strings"   =>  array of strings (for 1 section of strings)
                    OR array of array of strings (for multiple sections)
                    We use these values for cell's titles.
    "values"    =>  array of values (for 1 section of strings)
                    OR array of array of values (for multiple sections)
                    (Must be the same number or values as strings)
 }
 
 TODO: Multi Select
 
 */

@interface STMenuSelectViewController : STMenuSubMenuTableViewController
{
  @protected
    NSIndexPath *_selectedRow;
    
    id          _defaultValue;
    NSNumber    *_saveOnSelect;
    NSArray     *_values;
    NSArray     *_strings;
}

// This is the value to show when value is not in values or is nil, optional.
@property (nonatomic, retain)   id              defaultValue;

// BOOL, if this is YES, the menu saves and dismisses on select.
@property (nonatomic, retain)   NSNumber        *saveOnSelect;

@end
