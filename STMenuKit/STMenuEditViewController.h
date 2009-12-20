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

// use this to complete a save that you have stopped by returning NO to
// editMenu:shouldSaveItem:
- (void)save;
// use this to stop editing that you have prevented from ending earlier by
// returning NO to editMenu:shouldSaveItem:
- (void)stopEditing;

@end

@protocol STMenuEditViewControllerDelegate <NSObject>

@optional
// If you return YES, the item is saved. If you return NO, the item is not
// saved. At a later date, you may tell it to save.
- (BOOL)editMenu:(STMenuEditViewController *)editMenu
  shouldSaveItem:(id)item;

@end

