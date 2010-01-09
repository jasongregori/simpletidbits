//
//  STMenuSubMenuTableViewController.h
//  STMenuKit
//
//  Created by Jason Gregori on 12/19/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMenuBaseTableViewController.h"

/*
 STMenuSubMenuTableViewController
 --------------------------------

 The SubMenu, as the name implies, is for creating subMenus for other menus.
 
 This menu provides a cancel button that dismisses itself and a save button that
 calls save, then sets parentMenuShouldSave to YES and dismisses itself.
 
 SubClasses should use subValue to store their value instead of the value
 property. This is because the subClass may be passed a value that contains the
 value to be edited instead of just the value to be edited (although this is
 not the responsibility of the subClass, but of whoever needs it). For example,
 I have a CoreData object that is mostly just a date and my date subMenu gets
 this object set as the value (not its date value). I can subClass the date
 subMenu and set its subValue to my object's date value.
 
 */

@interface STMenuSubMenuTableViewController : STMenuBaseTableViewController
{
    id          _subValue;
}
@property (nonatomic, retain)   id          subValue;

// This is called when value changes. The default is to set subValue to value.
// You may override it and set subValue to something else if you want.
- (void)valueDidChange;

// Save is called right before we dismiss the menu.
// If NO is returned, the save is cancelled.
// The default is to set self.value to self.subValue and return YES.
// If you want, you may override and do some work to subValue. Or you can throw
// up an alert and return NO.
- (BOOL)save;

@end
