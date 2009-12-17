//
//  STMenuFormTableViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/3/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuFormTableViewController.h"
#import "STMenuFormTableViewCell.h"
#import "STMenuBasicSectionController.h"


@implementation STMenuFormTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped])
    {

    }
    return self;
}

#pragma mark STMenuFormattedTableViewController

- (Class)st_defaultSectionClass
{
    return [STMenuBasicSectionController class];
}

#pragma mark STMenuBaseTableViewController

- (Class)st_defaultCellClass
{
    return [STMenuFormTableViewCell class];
}

- (NSString *)st_customCellPrefix
{
    return @"STMenuForm";
}

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.editing    = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
}

@end
