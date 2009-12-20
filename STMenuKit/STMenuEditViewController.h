//
//  STMenuEditViewController.h
//  STMenuKit
//
//  Created by Jason Gregori on 12/1/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuFormattedTableViewController.h"

/*
 
 STMenuEditViewController
 ========================

 An edit table view. Cells are not selectable unless table is in edit mode.
 Cells should load a subMenu to edit the item.
 Right bar button item is edit button.
 These are designed to be like the phone/contacts app.
  
 plist
 -----
 This controller creates a table from a plist using the following format:
 
 [ // table
    {
        // default section controller is the "basic"
        "title"     => section header name
        "rows"      =>
        [
            { // cell
                "title" => title for cell and menu
                "key"   => key for cell, menu, and value
                "defaultValue" => default value

                "cell"  => (STMenuMaker Item) class prefix:"STMenu"
                            suffix:"TableViewCell", secondary prefix:"",
                            suffix:"TableViewCell", default class
                            STMenuTableViewCell.

                "menu"  => (STMenuMaker Item) class prefix:"STMenu",
                            suffix:"ViewController", no default class.
            }
        ]
    }
 ]
 
 */

@interface STMenuEditViewController : STMenuFormattedTableViewController
{
  @protected
    BOOL            _inDeleteMode;
    NSNumber        *_showDeleteButton;
    NSString        *_deleteMessage;
}

// BOOL
// If set to yes, shows a delete button when editing.
// Uses tableFooterView, so if you use this you can't use that. Default: NO
@property (nonatomic, retain)   NSNumber    *showDeleteButton;
// Text to show on delete button. Default: "Delete"
@property (nonatomic, retain)   NSString    *deleteMessage;

// Saves item, does not call delegate method editMenu:shouldSaveItem:.
// Default simply stops editing.
- (void)saveItem;
// Delete item, does not call delegate method editMenu:shouldDeleteItem:.
// Default dismisses menu and sets value to nil;
- (void)deleteItem;

// If editing, stops editing, else, dismisses menu
- (void)done;

#pragma mark Subclasses

// This is called instead of setEditing:animated: because sometimes we block
// changing it. Do any edit changes in here instead of setEditing:animated:.
- (void)st_setEditing:(BOOL)editing animated:(BOOL)animated;

@end

@protocol STMenuEditViewControllerDelegate <NSObject>

@optional
// This is called when the user taps the done button
// If you return YES, saveItem is called.
// If you return NO, nothing happens and the user stays in edit mode.
// The user may not exit edit mode unless you return YES or later call saveItem.
// You may use this to validate the item: if the item is not valid show an alert
// and return NO.
// If you need to do something that will take a while (like save the item on the
// server), you may return NO and later call saveItem yourself.
- (BOOL)editMenu:(STMenuEditViewController *)editMenu
  shouldSaveItem:(id)item;

// This is called when the user taps the delete button
// If you return YES, deleteItem is called.
// If you return NO, nothing happens.
// If you need to do something that will take a while (like delete the item on
// the server), you may return NO and later call deleteItem yourself.
- (BOOL)editMenu:(STMenuEditViewController *)editMenu
shouldDeleteItem:(id)item;

@end

