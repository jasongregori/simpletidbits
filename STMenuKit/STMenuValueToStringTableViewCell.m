//
//  STMenuMultiTableViewCell.m
//  STMenuKit
//
//  Created by Jason Gregori on 1/17/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STMenuValueToStringTableViewCell.h"

@interface STMenuValueToStringTableViewCell ()

@property (nonatomic, retain)   NSArray         *st_values;
@property (nonatomic, retain)   NSArray         *st_strings;

@end


@implementation STMenuValueToStringTableViewCell
@synthesize defaultValue = _defaultValue, st_values = _values,
            st_strings = _strings, plist = _plist;

- (void)dealloc
{
    [_defaultValue release];
    [_plist release];
    [_values release];
    [_strings release];
    
    [super dealloc];
}

#pragma mark STMenuTableViewCell

- (void)setPlist:(id)plist
{
    if ([plist isEqual:_plist])
    {
        return;
    }
    
    if (!plist)
    {
        self.st_values  = nil;
        self.st_strings = nil;
    }
    else if ([plist isKindOfClass:[NSString class]])
    {
        // plist is file, load it
        
        NSData  *plistData  = [NSData dataWithContentsOfFile:
                               [[[NSBundle mainBundle] bundlePath]
                                stringByAppendingPathComponent:plist]];
        NSString    *error;
        NSDictionary    *dictionary
          = [NSPropertyListSerialization
             propertyListFromData:plistData
             mutabilityOption:NSPropertyListImmutable
             format:NULL
             errorDescription:&error];
        
        if (![dictionary isKindOfClass:[NSDictionary class]])
        {
            error   = @"Plist is not a dictionary";
        }
        
        if (error)
        {
            [NSException raise:@"STMenuValueToStringTableViewCell Bad Plist"
                        format:
             @"Error loading plist with plist name from \"%@\". Error:\n%@",
             plist,
             error];
            [error release];
        }
        
        self.st_values  = [dictionary valueForKey:@"values"];
        self.st_strings = [dictionary valueForKey:@"strings"];        
    }
    else if ([plist isKindOfClass:[NSDictionary class]])
    {
        // plist is dictionary
        
        self.st_values  = [plist valueForKey:@"values"];
        self.st_strings = [plist valueForKey:@"strings"];
    }
    else
    {
        // bad type
        
        [NSException raise:@"STMenuValueToStringTableViewCell Bad Plist"
                    format:@"plist was not a string or dictionary"];
    }
 
    if ([self.st_values count] != [self.st_strings count])
    {
        // check that counts are the same
        
        [NSException
         raise:@"STMenuValueToStringTableViewCell Bad Plist"
         format:@"values and strings do not have the same number of items."];
    }
    
    // save
    [_plist release];
    _plist      = [plist retain];
}

- (void)setValue:(id)value
{
    if (value && self.st_values)
    {
        NSUInteger  i   = [self.st_values indexOfObject:value];
        if (i != NSNotFound)
        {
            [self setValueString:[self.st_strings objectAtIndex:i]];
            return;
        }
    }
    if (self.defaultValue && self.st_values)
    {
        NSUInteger  i   = [self.st_values indexOfObject:self.defaultValue];
        if (i != NSNotFound)
        {
            [self setValueString:[self.st_strings objectAtIndex:i]];
            return;
        }
    }
    [self setValueString:nil];
}

- (void)st_prepareForReuse
{
    [super st_prepareForReuse];
    
    self.defaultValue   = nil;
}

@end
