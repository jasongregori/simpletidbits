//
//  STMenuSubMenuTableViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/19/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuSubMenuTableViewController.h"


@implementation STMenuSubMenuTableViewController

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
              action:@selector(save)]
             autorelease];
    }
    return self;
}

- (void)save
{
    self.parentMenuShouldSave   = YES;
    [self dismiss];
}

@end

