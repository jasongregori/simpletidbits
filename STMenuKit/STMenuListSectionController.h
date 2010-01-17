//
//  STMenuListSectionController.h
//  STMenuKit
//
//  Created by Jason Gregori on 12/28/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STMenuFormattedSectionController.h"
#import <UIKit/UIKit.h>

@interface STMenuListSectionController : STMenuFormattedSectionController
{
  @protected
    NSMutableArray  *_list;
    NSArray         *_sortDescriptors;
    id              _itemMenu;
    NSString        *_itemTitle;
    NSString        *_key;
    id              _cell;
    NSString        *_addTitle;
    id              _addCell;
    id              _blankItem;
    NSNumber        *_maxItems;
    NSNumber        *_editable;
    
    BOOL            _showingAddCell;
    id              _currentlyShowingItem;
}

// The list of items to show the user. May be an array or a set. A mutable array
// will be made from your list. Returns an array.
@property (nonatomic, copy)     id          list;
// Used to keep your list sorted. If nil, list is not sorted and new items are
// appended to the bottom of the list. Returns an array of actual sort
// descriptors.
// Format (array of dictionaries):
// "key" -> (string)
// "ascending" -> (NSNumber: BOOL)
// "selector" -> (string, optional)
@property (nonatomic, retain)   NSArray     *sortDescriptors;

// The menuMaker Menu to display for items.
@property (nonatomic, retain)   id          itemMenu;
// Title for item Menu
@property (nonatomic, copy)     NSString    *itemTitle;
// The key is used for subMenus and cells.
@property (nonatomic, copy)     NSString    *key;
// The menuMaker cell for each item.
@property (nonatomic, retain)   id          cell;
// Text to show on add Cell
@property (nonatomic, copy)     NSString    *addTitle;
// A custom add cell, defaults to AddItem cell
@property (nonatomic, retain)   id          addCell;
// A blank item. When the user adds an item, this is used.
// When we need to use this value we try to make a mutable copy first, if we
// can't do that, we try a regular copy, if we can't do that we return the
// original.
@property (nonatomic, retain)   id          blankItem;
// This will not prevent more items from appearing, but it will stop showing
// the add button if there are this many items. A nil value means unlimited.
// 0 means you can't add items. Default: nil.
@property (nonatomic, retain)   NSNumber    *maxItems;
// BOOL, if YES, users may delete items and add new ones. Default: NO.
@property (nonatomic, retain)   NSNumber    *editable;

// Pushes menu with this item. If the item is not in the list and it is saved,
// it is added to the list. This is called when a user taps an item's row and
// when the add row is tapped.
- (void)showItem:(id)item;

// Returns whether a row is in the list or out of it. Used to determine if we
// are tapping an item or the add button.
- (BOOL)isInList:(NSUInteger)row;

// Returns nil if item is not in list
- (NSIndexPath *)indexPathForItem:(id)item;
// Returns nil if addCell is not showing
- (NSIndexPath *)indexPathForAddCell;

#pragma mark Edit Item Methods

// You may override these

// Responsible for giving a new item for the list. The item will be given to the
// sub menu and if the user saves, it will be added to the list.
// Default: We try to make a copy of blankItem. If we can't do that, we return
// the original.
- (id)createItem;

// Responsible for adding the item to the actual list and adding it to the
// table. Called when a subMenu that was pushed with a new item returns. 
// Default: If item is already in the list, sort and move cell in table to new
// spot. Otherwise, item is added into list, the list is sorted, and a new row
// is added to the table for new index of the item.
- (void)addItem:(id)item;
// TODO: addItems

// Responsible for replacing an item in the list and making any necessary
// changes to the table. Called when a subMenu saves.
// Default: If item1 is nil or item1 == item2, calls addItem. Otherwise, calls
// deleteItem on item1 and addItem on item2.
- (void)replaceItem:(id)item1 withItem:(id)item2;

// Responsible for deleting the item from the list and from the table.
// Called when the user deletes the item's row.
// Default: Finds item in the list, if found, removes it and removes row from
// table.
- (void)deleteItem:(id)item;
// TODO: deleteItems

#pragma mark Private
// Mutable version of the list, use this for everything
@property (nonatomic, readonly) NSMutableArray  *st_list;

- (void)st_checkIfWeShouldShowAddCell:(BOOL)animated;

@end

