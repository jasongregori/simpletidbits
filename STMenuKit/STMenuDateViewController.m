//
//  STMenuDateViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 1/9/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STMenuDateViewController.h"


@implementation STMenuDateViewController
@synthesize mode = _mode, maximumDate = _maximumDate,
            minimumDate = _minimumDate, minuteInterval = _minuteInterval;

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped])
    {
        [super setCell:@"Date"];
    }
    return self;
}

// TODO: on set mode change cell to same mode.
// TODO: add date picker

- (void)dealloc
{
    [_mode release];
    [_maximumDate release];
    [_minimumDate release];
    [_minuteInterval release];
    
    [super dealloc];
}

- (void)setMode:(NSString *)mode
{
    if (![_mode isEqualToString:mode])
    {
        [_mode release];
        _mode       = [mode copy];
        
        // set cell mode
        [super setCell:
         [NSDictionary dictionaryWithObjectsAndKeys:
          @"Date", @"class",
          mode, @"mode",
          nil]];
        if ([self isViewLoaded])
        {
            [self.tableView reloadData];
        }
    }
}

#pragma mark STMenuSubMenuCellViewController

- (void)setCell:(id)cell
{
    // dont let user override cell
}

#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // center the cell (height - keyboard - cell height)/2 - cell header margin
    self.tableView.contentInset
    = UIEdgeInsetsMake((self.tableView.frame.size.height - 216 - 44)/2.0 - 10,
                       0, 0, 0);
}

@end

