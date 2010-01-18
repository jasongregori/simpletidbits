//
//  STMenuMultiTableViewCell.m
//  STMenuKit
//
//  Created by Jason Gregori on 1/17/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STMenuValueToStringTableViewCell.h"


@implementation STMenuValueToStringTableViewCell
@synthesize defaultValue = _defaultValue, values = _values, strings = _strings;

#pragma mark STMenuTableViewCell

- (void)setValue:(id)value
{
    if (value && self.values)
    {
        NSUInteger  i   = [self.values indexOfObject:value];
        if (i != NSNotFound)
        {
            [self setValueString:[self.strings objectAtIndex:i]];
            return;
        }
    }
    if (self.defaultValue && self.values)
    {
        NSUInteger  i   = [self.values indexOfObject:self.defaultValue];
        if (i != NSNotFound)
        {
            [self setValueString:[self.strings objectAtIndex:i]];
            return;
        }
    }
    [self setValueString:nil];
}

- (void)st_prepareForReuse
{
    [super st_prepareForReuse];
    
    self.defaultValue   = nil;
    self.values         = nil;
    self.strings        = nil;
}

@end
