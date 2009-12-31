//
//  STMenuSectionController.h
//  STMenuKit
//
//  Created by Jason Gregori on 11/21/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STMenuFormattedTableViewController.h"
#import "STMenuTableViewCell.h"

/*
 A section controller's job is to control all the cell's in it's section.
 
 It must also push subMenus onto it's menu and deal with the returned subMenu.
 
 It may use it's menu property to observe values, push menus, or whatever.
 
 It is the section controller's job to observe value changes (using KVO) to
 update it's cells and it's submenus.
 
 Use menu to create cells.
 */

@interface STMenuFormattedSectionController : NSObject
<STMenuTableViewCellDelegate>
{
    STMenuFormattedTableViewController  *_menu;
    NSUInteger      _section;
    NSString        *_title;
}
// Not plist properties
@property (nonatomic, assign)   STMenuFormattedTableViewController  *menu;
@property (nonatomic, assign)   NSUInteger      section;
// Tells you if the section is in editing mode.
@property (nonatomic, getter=isEditing, readonly)   BOOL    editing;

// plist property
@property (nonatomic, copy)     NSString        *title;

// Menu
// Called when menu's value property has changed.
- (void)menuValueDidChange:(id)newValue;
// Menu calls this when subMenu saves
- (void)saveValue:(id)value forSubMenuKey:(NSString *)key;
// Menu calls this when subMenu cancels
- (void)cancelForSubMenuKey:(NSString *)key;

// Menu calls this when it is set to editing mode. Default does nothing.
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

// More a convenience then anything else. Default reloads section.
- (void)reloadSection:(BOOL)animated;

// Cells

// The next four methods will use the subclass methods to figure these out.
// Override the subclass methods OR these OR both.
// didSelect uses menu, key, value, and title 
- (void)didSelectRow:(NSUInteger)row;
// height uses class, title, and value
- (CGFloat)heightForRow:(NSUInteger)row;
// cell uses title, value, key, and row data. sets cell delegate to self.
- (STMenuTableViewCell *)cellForRow:(NSUInteger)row;
// uses row data
- (Class)classForRow:(NSUInteger)row;

// Default: 0
- (NSInteger)numberOfRows;

// Cell editing
// Default: YES
- (BOOL)shouldIndentWhileEditingRow:(NSUInteger)row;
// Default does nothing
- (void)commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                    forRow:(NSUInteger)row;
// Default: YES
- (BOOL)canEditRow:(NSUInteger)row;
// Default: UITableViewCellEditingStyleDelete
- (UITableViewCellEditingStyle)editingStyleForRow:(NSUInteger)row;

// Subclass these! OR height and cellForRow methods OR both
// Defaults: nil
- (NSString *)titleForRow:(NSUInteger)row;
- (id)valueForRow:(NSUInteger)row;
- (id)cellDataForRow:(NSUInteger)row;
- (NSString *)keyForRow:(NSUInteger)row;
- (id)menuDataForRow:(NSUInteger)row;

@end
