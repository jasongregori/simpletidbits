//
//  UIFontAdditions.m
//  SimpleTidbits
//
//  Created by Jason Gregori on 9/26/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "UIFontAdditions.h"


@implementation UIFont (SimpleTidbits)

+ (UIFont *)st_settingsTitleFont
{
    return [UIFont boldSystemFontOfSize:17];
}

+ (UIFont *)st_settingsDetailFont
{
    return [UIFont systemFontOfSize:17];
}

+ (UIFont *)st_contactsTitleFont
{
    return [UIFont boldSystemFontOfSize:15];
}

+ (UIFont *)st_contactsDetailFont
{
    return [UIFont boldSystemFontOfSize:17];
}

@end
