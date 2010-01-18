//
//  STMenuSubMenuSingleCellViewController.h
//  STMenuKit
//
//  Created by Jason Gregori on 12/19/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMenuSubMenuTableViewController.h"
#import "STMenuTextFieldTableViewCell.h"

// TODO: add option for more than one cell

/*
 
 The SubMenuCellViewController is a subMenu that displays one cell. It may be
 subClassed to add more controls to it.
 
 */

@interface STMenuSubMenuCellViewController : STMenuSubMenuTableViewController
<STMenuTableViewCellDelegate>
{
    id          _cell;
}
@property (nonatomic, retain)   id          cell;

- (void)reloadCell;

@end
