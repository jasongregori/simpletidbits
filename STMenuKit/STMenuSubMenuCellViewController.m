//
//  STMenuSubMenuSingleCellViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/19/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuSubMenuCellViewController.h"


@implementation STMenuSubMenuCellViewController
@synthesize cell = _cell;


- (id)initWithStyle:(UITableViewStyle)style
{
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:UITableViewStyleGrouped])
    {
        
    }
    return self;
}

- (void)dealloc
{
    [_cell release];
    
    [super dealloc];
}

- (void)reloadCell
{
    if ([self isViewLoaded])
    {
        STMenuTableViewCell *cell
          = (id)[self.tableView cellForRowAtIndexPath:
                 [NSIndexPath indexPathForRow:0 inSection:0]];
        [cell setValue:self.subValue];
    }
}

- (void)setCell:(id)cell
{
    if (_cell != cell)
    {
        [_cell release];
        _cell       = [cell retain];
        if ([self isViewLoaded])
        {
            [self.tableView reloadData];
        }
    }
}

#pragma mark STMenuSubMenuTableViewController

- (void)setSubValue:(id)value
{
    [super setSubValue:value];
    [self reloadCell];
}

#pragma mark STMenuProtocol

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // this has to be done here or the table deselects the row right after this
    // method (the first time the view loads)
    [self.tableView layoutIfNeeded];
    
    // make label first responder
    [self.tableView selectRowAtIndexPath:
     [NSIndexPath indexPathForRow:0 inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    STMenuTableViewCell *cell   = [self st_cellWithCellData:self.cell
                                                        key:self.key];
    cell.delegate   = self;
    [cell setValue:self.subValue];
	
    return cell;
}

#pragma mark Delegate Methods
#pragma mark STMenuTableViewCellDelegate

- (void)menuTableViewCell:(STMenuTableViewCell *)cell
           didChangeValue:(id)newValue
{
    // change our value to new value
    self.subValue   = newValue;
}

@end

