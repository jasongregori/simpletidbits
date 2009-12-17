//
//  STMenuNoItemsTableViewCell.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/16/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuNoItemsTableViewCell.h"


@implementation STMenuNoItemsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:reuseIdentifier])
    {
        // Initialization code
        self.textLabel.textAlignment    = UITextAlignmentCenter;
        self.textLabel.font             = [UIFont boldSystemFontOfSize:16];
        self.textLabel.textColor        = [UIColor grayColor];
        self.selectionStyle             = UITableViewCellSelectionStyleNone;
    }
    return self;
}


@end
