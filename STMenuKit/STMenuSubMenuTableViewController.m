//
//  STMenuSubMenuTableViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/19/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuSubMenuTableViewController.h"

@interface STMenuSubMenuTableViewController ()

- (void)st_save;

@end


@implementation STMenuSubMenuTableViewController
@synthesize subValue = _subValue;

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
    }
    return self;
}

- (void)dealloc
{
    [_subValue release];
    
    [super dealloc];
}

- (void)st_save
{
    if ([self save])
    {
        self.parentMenuShouldSave   = YES;
        [self dismiss];
    }
}

- (void)valueDidChange
{
    self.subValue   = self.value;
}

- (BOOL)save
{
    if (![self.value isEqual:self.subValue])
    {
        // only save if the values are not equal
        self.value      = self.subValue;
        return YES;
    }
    [self dismiss];
    return NO;
}

#pragma mark STMenuProtocol

- (void)setValue:(id)value
{
    [super setValue:value];
    [self valueDidChange];
}

@end

