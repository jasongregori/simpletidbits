//
//  STMenuSwitchTableViewCell.m
//  STMenuKit
//
//  Created by Jason Gregori on 1/17/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STMenuSwitchTableViewCell.h"

@interface STMenuSwitchTableViewCell ()

@property (nonatomic, readonly) UISwitch    *toggle;

- (void)st_switchValueChanged;

@end


@implementation STMenuSwitchTableViewCell
@synthesize defaultValue = _defaultValue, trueValue = _trueValue,
            falseValue = _falseValue, toggle = _toggle;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _toggle     = [[UISwitch alloc] init];
        [_toggle addTarget:self
                    action:@selector(st_switchValueChanged)
          forControlEvents:UIControlEventValueChanged];
        self.editingAccessoryView   = _toggle;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)dealloc
{
    [_toggle release];
    
    [super dealloc];
}

- (void)st_switchValueChanged
{
    [self.delegate menuTableViewCell:self
                      didChangeValue:(self.toggle.on ?
                                      self.trueValue : self.falseValue)];
}

#pragma mark STMenuTableViewCell

- (void)setValue:(id)value
{
    if ([value isEqual:self.trueValue])
    {
        [self.toggle setOn:YES animated:!!self.window];
    }
    else if ([value isEqual:self.falseValue])
    {
        [self.toggle setOn:NO animated:!!self.window];
    }
    else
    {
        [self.toggle setOn:[self.defaultValue isEqual:self.trueValue]
                  animated:!!self.window];
    }
}

- (void)st_prepareForReuse
{
    self.defaultValue   = nil;
    self.trueValue      = [NSNumber numberWithBool:YES];
    self.falseValue     = [NSNumber numberWithBool:NO];
}

@end
