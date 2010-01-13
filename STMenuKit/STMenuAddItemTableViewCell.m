//
//  STMenuAddItemTableViewCell.m
//  STMenuKit
//
//  Created by Jason Gregori on 1/12/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STMenuAddItemTableViewCell.h"


@implementation STMenuAddItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:reuseIdentifier])
    {
        // Initialization code
        self.textLabel.font             = [UIFont boldSystemFontOfSize:12];
        self.textLabel.textColor        = [UIColor colorWithRed:0.32
                                                          green:0.4
                                                           blue:0.57
                                                          alpha:1];
    }
    return self;
}

@end
