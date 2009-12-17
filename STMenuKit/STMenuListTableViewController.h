//
//  STMenuListTableViewController.h
//  STMenuKit
//
//  Created by Jason Gregori on 12/16/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "STMenuBaseTableViewController.h"

/*
 STMenuListTableViewController
 -----------------------------
 
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

@interface STMenuListTableViewController : STMenuBaseTableViewController
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
    id          _addMenu;
    id          _noItemsMessageCell;
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
@property (nonatomic, retain)   id          addMenu;    // (STMenuMaker Item)
@property (nonatomic, retain)   id          noItemsMessageCell; // (STMenuMaker)

- (void)setShowAddButton:(BOOL)show animated:(BOOL)animated;
- (void)setShowEditButton:(BOOL)show animated:(BOOL)animated;

// show add menu
- (void)addItem;

// push an item
- (void)showItem:(id)item;

// use this or override commitEditingStyle
- (void)deleteItem:(id)item;

// I need this because of the noItem section
- (NSUInteger)numberOfSections;

// Checks if there are any items, if there aren't any, shows the noItemsMessage
- (void)noItemsCheck;

#pragma mark Subclasses

@property (nonatomic, assign)   BOOL        st_showNoItemsMessage;

// override to use default cell, or override cellForRow, didSelectRow, and
// commitEditingStyle.
- (id)st_itemForIndexPath:(NSIndexPath *)indexPath;

@end
