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
 This class does only two things: it creates a cancel button that dismisses
 itself and it creates a save button that sets parentMenuShouldSave to YES and
 dismisses itself.
 */

@interface STMenuSubMenuTableViewController : STMenuBaseTableViewController

- (void)save;

@end
