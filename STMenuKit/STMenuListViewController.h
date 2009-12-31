//
//  STMenuListViewController.h
//  STMenuKit
//
//  Created by Jason Gregori on 12/16/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "STMenuBaseTableViewController.h"

// TODO: change newItem to createItem because newItem expects to be retained

/*
 STMenuListViewController
 ------------------------
 
 TableView list of data.
 
 * Selecting a row pushes itemMenu with that item.
 * If add button is tapped, nav modal is displayed with itemMenu in addMode
   with addTitle or addMenu is used if not nil.
 * On save,
    * If addMenu is not nil, itemMenu is pushed before addMenu disappears.
    * Scrolls to that row.
 * allowDeletion
    * If yes, allow editing of all cells. Allow swipe to delete.
    * If no, allow no editing of any cells.
    * Override all the editing table view delegate functions to change this.
 * No Items Message
    * EG: "No Messages"
 
 */

// TODO: Have a total count cell at the bottom, like in contacts

@interface STMenuListViewController : STMenuBaseTableViewController
{
  @protected
    NSNumber    *_rowHeight;
    BOOL        _showNoItemsMessage;
    NSNumber    *_noItemsRow;
    NSString    *_noItemsMessage;
    NSNumber    *_allowDeletion;
    UIBarButtonItem *_addButton;

    id          _itemMenu;
    id          _cell;
    NSString    *_addTitle;
    NSString    *_showTitle;
    id          _addMenu;
    id          _noItemsMessageCell;
    id          _newItem;
}
@property (nonatomic, retain)   NSNumber    *rowHeight; // float
@property (nonatomic, retain)   NSNumber    *noItemsRow;    // Message row
@property (nonatomic, copy)     NSString    *noItemsMessage;// Default: No Items
@property (nonatomic, retain)   NSNumber    *allowDeletion; // BOOL, Default: NO
@property (nonatomic, retain)   NSNumber    *showAddButton; // BOOL, Default: NO
@property (nonatomic, retain)   NSNumber    *showEditButton;// BOOL, Default: NO

@property (nonatomic, retain)   id          itemMenu;   // (STMenuMaker Item)
@property (nonatomic, retain)   id          cell;       // (STMenuMaker Item)
@property (nonatomic, copy)     NSString    *addTitle;  // itemMenu add title
@property (nonatomic, copy)     NSString    *showTitle; // itemMenu show title
@property (nonatomic, retain)   id          addMenu;    // (STMenuMaker Item)
@property (nonatomic, retain)   id          noItemsMessageCell; // (STMenuMaker)
@property (nonatomic, retain)   id          newItem;    // used for addItem

- (void)setShowAddButton:(BOOL)show animated:(BOOL)animated;
- (void)setShowEditButton:(BOOL)show animated:(BOOL)animated;

// show add menu. Trys to get a newItem from the delegate, if it can't it gets a
// copy of newItem. If addMenu exists, uses that menu. Otherwise uses itemMenu
// and sets title to addTitle. Then sets value of menu to newItem and displays
// it modally.
- (void)addItem;

// push an item
- (void)showItem:(id)item;

// use this or override commitEditingStyle
- (void)deleteItem:(id)item;

// I need this because of the noItem section
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

// Checks if there are any items, if there aren't any, shows the noItemsMessage
- (void)noItemsCheck;

#pragma mark Subclasses

@property (nonatomic, assign)   BOOL        st_showNoItemsMessage;

// override to use default cell, or override cellForRow, didSelectRow, and
// commitEditingStyle.
- (id)st_itemForIndexPath:(NSIndexPath *)indexPath;

// Returns a copy of newItem to be used as the item to be edited for adding.
// Override to provide something else.
- (id)st_copyOfNewItem;

@end


@protocol STMenuListViewControllerDelegate

  @optional
// Called when showItem: is called, you may use this to do something at the same
// time. Or if itemMenu is nil, you can push something else instead.
- (void)listMenu:(STMenuListViewController *)listMenu showingItem:(id)item;

// Called when addItem is called. If an item is returned, it is used as the 
// new Item for the user to edit. Otherwise st_copyOfNewItem is used.
- (id)listMenuNewItem:(STMenuListViewController *)listMenu;

@end
