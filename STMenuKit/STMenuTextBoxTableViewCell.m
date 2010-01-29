//
//  STMenuTextBoxTableViewCell.m
//  STMenuKit
//
//  Created by Jason Gregori on 1/28/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STMenuTextBoxTableViewCell.h"


@implementation STMenuTextBoxTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:reuseIdentifier])
    {
        self.textLabel.numberOfLines    = 0;
    }
    return self;
}

#pragma mark STMenuTableViewCell

+ (CGFloat)heightWithTitle:(NSString *)title value:(id)value
{
    return 23.0 + [title sizeWithFont:[UIFont boldSystemFontOfSize:17]
                  constrainedToSize:CGSizeMake(280, CGFLOAT_MAX)].height;
}

- (void)setValueString:(NSString *)string
{
    // so we don't accidentally override title   
}

@end
