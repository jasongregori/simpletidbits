//
//  STMenuListTableViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/16/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuListTableViewController.h"
#import "STMenuTableViewCell.h"

@interface STMenuListTableViewController ()

@property (nonatomic, retain)   UIBarButtonItem     *st_addButton;

@end

@implementation STMenuListTableViewController
@synthesize itemMenu = _itemMenu, addTitle = _addTitle, cell = _cell,
            allowDeletion = _allowDeletion, addMenu = _addMenu,
            st_addButton = _addButton, rowHeight = _rowHeight,
            st_showNoItemsMessage = _showNoItemsMessage,
            noItemsRow = _noItemsRow, noItemsMessage = _noItemsMessage,
            noItemsMessageCell = _noItemsMessageCell;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)dealloc
{
    [_rowHeight release];
    [_noItemsMessage release];
    [_itemMenu release];
    [_addTitle release];
    [_cell release];
    [_allowDeletion release];
    [_addMenu release];
    
    [super dealloc];
}


// show add menu
- (void)addItem
{
    
}

// push an item
- (void)showItem:(id)item
{
    
}

- (void)deleteItem:(id)item
{
    
}

- (NSUInteger)numberOfSections
{
    return 0;
}

- (void)noItemsCheck
{
    self.st_showNoItemsMessage  = ([self numberOfSections] == 0);
}

- (id)st_itemForIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark Properties

- (void)setShowAddButton:(NSNumber *)show
{
    [self setShowAddButton:[show boolValue] animated:NO];
}

- (NSNumber *)showAddButton
{
    return [NSNumber numberWithBool:(self.navigationItem.rightBarButtonItem
                                     == self.st_addButton)];
}

- (void)setShowAddButton:(BOOL)show animated:(BOOL)animated
{
    if (show)
    {
        if (!self.st_addButton)
        {
            self.st_addButton
              = [[[UIBarButtonItem alloc]
                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                  target:self
                  action:@selector(addItem)]
                 autorelease];
        }
        [self.navigationItem setRightBarButtonItem:self.st_addButton
                                          animated:animated];
    }
    else
    {
        if (self.navigationItem.rightBarButtonItem == self.st_addButton)
        {
            [self.navigationItem setRightBarButtonItem:nil animated:animated];
        }
        self.st_addButton   = nil;
    }
}

- (void)setShowEditButton:(NSNumber *)show
{
    [self setShowEditButton:[show boolValue] animated:NO];
}

- (NSNumber *)showEditButton
{
    return [NSNumber numberWithBool:(self.navigationItem.leftBarButtonItem
                                     == self.editButtonItem)];
}

- (void)setShowEditButton:(BOOL)show animated:(BOOL)animated
{
    if (show)
    {
        [self.navigationItem setLeftBarButtonItem:self.editButtonItem
                                         animated:animated];
    }
    else if (self.navigationItem.leftBarButtonItem == self.editButtonItem)
    {
        [self.navigationItem setLeftBarButtonItem:nil animated:animated];
    }
}

- (void)setRowHeight:(NSNumber *)rowHeight
{
    if (rowHeight != _rowHeight)
    {
        [_rowHeight release];
        _rowHeight  = [rowHeight retain];
    }
    if ([self isViewLoaded])
    {
        self.tableView.rowHeight    = [rowHeight floatValue];
    }
}

- (void)setSt_ShowNoItemsMessage:(BOOL)show
{
    if (show != _showNoItemsMessage)
    {
        _showNoItemsMessage = show;
        if ([self isViewLoaded])
        {
            // reload the no Item section
            [self.tableView reloadSections:
             [NSIndexSet indexSetWithIndex:[self numberOfSections]]
                          withRowAnimation:YES];
        }
    }
}

#pragma mark STMenuProtocol

- (void)setSt_schema:(id)schema
{
    [super setSt_schema:schema];
    
    NSAssert(!schema || [schema isKindOfClass:[NSDictionary class]],
             @"List Table plist must be a dictionary!");
    for (NSString *key in schema)
    {
        [self setValue:[schema valueForKey:key]
            forKeyPath:key];
    }
    
    [self noItemsCheck];
}

- (void)st_prepareForReuse
{
    [super st_prepareForReuse];
    
    self.noItemsMessageCell = @"NoItems";
    self.rowHeight      = [NSNumber numberWithInt:44];
    self.noItemsRow     = [NSNumber numberWithInt:3];
    self.noItemsMessage = @"No Items";
    self.allowDeletion  = nil;
    self.showAddButton  = nil;
    self.showEditButton = nil;
    self.itemMenu       = nil;
    self.cell           = nil;
    self.addTitle       = nil;
    self.addMenu        = nil;
}

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight        = [self.rowHeight floatValue];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // plus the noItems section
    return [self numberOfSections] + 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (self.st_showNoItemsMessage && section == [self numberOfSections])
    {
        // no items section
        return [self.noItemsRow integerValue];
    }
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [self numberOfSections])
    {
        // no items section
        if (indexPath.row + 1 < [self.noItemsRow integerValue])
        {
            // spacer cells
            STMenuTableViewCell     *cell
              = [self st_cellWithCellData:nil
                                      key:@"spacer"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        // no item message cell
        STMenuTableViewCell     *cell
          = [self st_cellWithCellData:self.noItemsMessageCell
                                  key:@"noItemsMessage"];
        [cell setTitle:self.noItemsMessage];
        return cell;
    }
    
    // actual cells
    
    // load cell
    STMenuTableViewCell *cell   = [self st_cellWithCellData:self.cell
                                                        key:@"list"];
    // set value
    [cell setValue:[self st_itemForIndexPath:indexPath]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // make sure its not the no items section
    if (indexPath.section < [self numberOfSections])
    {
        [self showItem:[self st_itemForIndexPath:indexPath]];
    }
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return [self.allowDeletion boolValue];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteItem:[self st_itemForIndexPath:indexPath]];
    }
}



@end

