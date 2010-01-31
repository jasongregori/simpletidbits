//
//  STMenuMultiTableViewCell.h
//  STMenuKit
//
//  Created by Jason Gregori on 1/17/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STMenuTableViewCell.h"

/*
 STMenuValueToStringTableViewCell
 --------------------------------
 
 This cell allows you to set different titles for different values if you can't
 just use the description.
 
 Use values and strings to tell what string to show for each value.
 
 Use defaultValue for the the value to show the user when value is not in values
 or value is nil. If defaultValue is nil, we use [super setValue:].
 
 */

@interface STMenuValueToStringTableViewCell : STMenuTableViewCell
{
    id          _defaultValue;
    id          _plist;
    NSArray     *_values;
    NSArray     *_strings;
}
// This is the value to show when value is not in values or is nil, optional.
@property (nonatomic, retain)   id      defaultValue;

// The plist can either be a dictionary OR a string that is the file name of  a
// plist that contains a dictionary. It must contain:
//  "values"    =>  Array of values that map to strings
//  "strings"   =>  Array of strings to show user for value
// We map these values to the titles and use the titles for the valueString.
// values and strings must have the same number of items.
@property (nonatomic, retain)   id      plist;

@end
