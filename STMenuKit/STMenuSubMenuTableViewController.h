//
//  STMenuSubMenuTableViewController.h
//  STMenuKit
//
//  Created by Jason Gregori on 12/19/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMenuBaseTableViewController.h"
#import "STMenuTableViewCell.h"

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
    NSNumber    *_dontStyleCell;
}
@property (nonatomic, retain)   id          subValue;
// BOOL, if YES, cell is not styled
@property (nonatomic, retain)   NSNumber    *dontStyleCell;

// This is called when value changes. The default is to set subValue to value.
// You may override it and set subValue to something else if you want.
- (void)valueDidChange;

// Called internally or call to force a save.
// The default is to 
- (void)save;

// shouldSave is called when the user taps save.
// If NO is returned, nothing happens.
// If YES is returned, save is called.
// If you want, you may override and do some work to subValue before setting
// self.value to it. Or you can throw up an alert and return NO. Or you can
// dismiss the subMenu and return to basically cancel instead of save.
// The default is to check if [self.value isEqual:self.subValue], if YES,
// dismiss the subMenu and return NO (effectively cancelling). If NO, return
// YES.
- (BOOL)shouldSave;

#pragma mark Private/Subclasse Methods
// Subclasses should use this to save. It will call `save` if necessary.
- (void)st_save;

// This is called on save. In it, you should convert subValue back to value.
// The default is to set self.value to self.subValue.
- (void)st_saveSubValue;

@end

@protocol STMenuSubMenuTableViewControllerDelegate <NSObject>

@optional
// This is called when the user taps the save button
// If you return YES, save is called.
// If you return NO, nothing happens.
// You may use this to validate the item: if the item is not valid show an alert
// and return NO.
// If you need to do something that will take a while (like save the item on the
// server), you may return NO and later call save yourself.
- (BOOL)subMenu:(STMenuSubMenuTableViewController *)subMenu
     shouldSave:(id)value;

@end

