//
//  STMenuListViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/16/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuListViewController.h"
#import "STMenuTableViewCell.h"

@interface STMenuListViewController ()

@property (nonatomic, retain)   UIBarButtonItem     *st_addButton;

@end

@implementation STMenuListViewController
@synthesize itemMenu = _itemMenu, addTitle = _addTitle, cell = _cell,
            allowDeletion = _allowDeletion, addMenu = _addMenu,
            st_addButton = _addButton, rowHeight = _rowHeight,
            st_showNoItemsMessage = _showNoItemsMessage,
            noItemsRow = _noItemsRow, noItemsMessage = _noItemsMessage,
            noItemsMessageCell = _noItemsMessageCell, newItem = _newItem,
            showTitle = _showTitle;

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
    [_newItem release];
    [_showTitle release];
    
    [super dealloc];
}

// Returns a copy of newItem to be used as the item to be edited for adding.
// Override to provide something else.
- (id)st_copyOfNewItem
{
    return [[self.newItem copy] autorelease];
}

// show add menu
- (void)addItem
{
    // Get new item
    id      newItem     = nil;
    
    // try delegate
    if ([self.delegate respondsToSelector:@selector(listMenuNewItem:)])
    {
        newItem     = [self.delegate listMenuNewItem:self];
    }
    
    // try self
    if (!newItem)
    {
        newItem     = [self st_copyOfNewItem];
    }
    
    if (!newItem)
    {
        // failure
        return;
    }
    
    // get add menu
    UIViewController <STMenuProtocol>   *addMenu    = nil;
    
    // try addMenu prop
    if (self.addMenu)
    {
        addMenu     = [self st_getMenuFromData:self.addMenu forKey:@"list"];
    }
    else
    {
        addMenu     = [self st_getMenuFromData:self.itemMenu forKey:@"list"];
        addMenu.title   = self.addTitle;
    }
    // set value
    addMenu.value   = newItem;
    // set to new mode
    addMenu.newMode = [NSNumber numberWithBool:YES];
    
    // display
    [self st_presentMenu:addMenu];
}

// push an item
- (void)showItem:(id)item
{
    if ([self.delegate respondsToSelector:@selector(listMenu:showingItem:)])
    {
        [self.delegate listMenu:self showingItem:item];
    }
    
    if (self.itemMenu)
    {
        UIViewController <STMenuProtocol> *subMenu
          = [self st_getMenuFromData:self.itemMenu forKey:@"list"];
        // we use the key list so that the properties of the menu are not reset
        // everytime
        
        subMenu.title   = self.showTitle;
        subMenu.value   = item;
        if (!self.addMenu)
        {
            // we might have set this on an add
            subMenu.newMode = [NSNumber numberWithBool:NO];
        }
        
        [self st_pushMenu:subMenu];
    }
}

- (void)deleteItem:(id)item
{
    
}

- (NSInteger)numberOfSections
{
    return 0;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
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

- (void)setSt_showNoItemsMessage:(BOOL)show
{
    if (show != _showNoItemsMessage)
    {
        _showNoItemsMessage = show;
        if ([self isViewLoaded])
        {
            // reload the no Item section
            [self.tableView reloadSections:
             [NSIndexSet indexSetWithIndex:[self numberOfSections]]
                          withRowAnimation:(self.view.window ?
                                            UITableViewRowAnimationFade :
                                            UITableViewRowAnimationNone)];
        }
        if (show)
        {
            // if we show the no items message, stop editing
            [self setEditing:NO animated:YES];
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
    self.showTitle      = nil;
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
    if (section == [self numberOfSections])
    {
        // no items section
        return self.st_showNoItemsMessage?[self.noItemsRow integerValue]:0;
    }
    return [self numberOfRowsInSection:section];
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
    if (indexPath.section == [self numberOfSections])
    {
        // no items section
        return NO;
    }
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


#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight        = [self.rowHeight floatValue];
}


@end

