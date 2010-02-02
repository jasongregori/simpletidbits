//
//  STMenuSubMenuTableViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/19/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuSubMenuTableViewController.h"

@interface STMenuSubMenuTableViewController ()

@end


@implementation STMenuSubMenuTableViewController
@synthesize subValue = _subValue;
@synthesize dontStyleCell   = _dontStyleCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style])
    {
        self.navigationItem.leftBarButtonItem
          = [[[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
              target:self
              action:@selector(dismiss)]
             autorelease];
        self.navigationItem.rightBarButtonItem
          = [[[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemSave
              target:self
              action:@selector(st_save)]
             autorelease];
        self.hidesBottomBarWhenPushed   = YES;
    }
    return self;
}

- (void)dealloc
{
    [_subValue release];
    [_dontStyleCell release];
    
    [super dealloc];
}

- (void)st_save
{
    if ([self shouldSave])
    {
        if ([self.delegate respondsToSelector:@selector(subMenu:shouldSave:)])
        {
            if (![self.delegate subMenu:self shouldSave:self.subValue])
            {
                return;
            }
        }
        [self save];
    }
}

- (BOOL)shouldSave
{
    if (![self.value isEqual:self.subValue])
    {
        // only save if the values are not equal
        return YES;
    }
    [self dismiss];
    return NO;
}

- (void)save
{
    [self st_saveSubValue];
    self.parentMenuShouldSave   = YES;
    [self dismiss];
}

- (void)valueDidChange
{
    self.subValue   = self.value;
}

- (void)st_saveSubValue
{
    self.value      = self.subValue;
}

#pragma mark STMenuBaseTableViewController

- (void)st_initializeCell:(STMenuTableViewCell *)cell
{
    if (![self.dontStyleCell boolValue])
    {
        // make cell look like an editing cell
        cell.textLabel.textColor    = [UIColor colorWithRed:0.22
                                                      green:0.33
                                                       blue:0.53
                                                      alpha:1];
        cell.textLabel.font         = [UIFont systemFontOfSize:17];
    }
}

#pragma mark STMenuProtocol

- (void)setValue:(id)value
{
    [super setValue:value];
    [self valueDidChange];
}

@end

