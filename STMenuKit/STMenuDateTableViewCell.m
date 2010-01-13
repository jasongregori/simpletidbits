//
//  STMenuDateTableViewCell.m
//  STMenuKit
//
//  Created by Jason Gregori on 1/9/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STMenuDateTableViewCell.h"
#import <SimpleTidbits/SimpleTidbits.h>

@implementation STMenuDateTableViewCell
@synthesize mode = _mode;

//- (id)initWithStyle:(UITableViewCellStyle)style
//    reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self = [super initWithStyle:style
//                    reuseIdentifier:reuseIdentifier])
//    {
//        self.editingAccessoryType
//        = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    return self;
//}

- (void)setTitle:(NSString *)title
{
    
}

- (void)setValue:(id)value
{
    NSAssert(!value || [value isKindOfClass:[NSDate class]],
             @"Set value of Date Cell to non date.");
    
    NSString    *lowercaseMode  = [self.mode lowercaseString];
    NSString    *text   = nil;
    if ([lowercaseMode isEqualToString:@"time"])
    {
        text    = [value st_timeStringValue];
    }
    else if ([lowercaseMode isEqualToString:@"date"])
    {
        text    = [value st_longDateStringValue];
    }
    else
    {
        text    = [value st_stringValue];
    }

    self.textLabel.text = text;
}

@end
