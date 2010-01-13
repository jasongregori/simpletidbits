//
//  STMenuDateViewController.h
//  STMenuKit
//
//  Created by Jason Gregori on 1/9/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMenuSubMenuCellViewController.h"

/*
 
 Date SubMenu
 
 Shows one cell in a table that is the date and a datePicker.
 
 */

@interface STMenuDateViewController : STMenuSubMenuCellViewController
{
    NSString        *_mode;
    NSDate          *_maximumDate;
    NSDate          *_minimumDate;
    NSNumber        *_minuteInterval;
}
// Possible values: time, date, dateAndTime
@property (nonatomic, copy)     NSString    *mode;

@property (nonatomic, retain)   NSDate      *maximumDate;
@property (nonatomic, retain)   NSDate      *minimumDate;
@property (nonatomic, retain)   NSNumber    *minuteInterval;

@end
