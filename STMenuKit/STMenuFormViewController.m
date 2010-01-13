//
//  STMenuFormViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/3/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuFormViewController.h"
#import "STMenuBasicSectionController.h"


@implementation STMenuFormViewController

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

- (NSString *)st_customCellPrefix
{
    return @"STMenuForm";
}

- (UITableViewCellStyle)st_defaultCellStyle
{
    return UITableViewCellStyleValue1;
}

- (void)st_initializeCell:(STMenuTableViewCell *)cell
{
    cell.editingAccessoryType   = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.editing    = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
}

@end
