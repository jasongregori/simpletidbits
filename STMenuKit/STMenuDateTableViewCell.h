//
//  STMenuDateTableViewCell.h
//  STMenuKit
//
//  Created by Jason Gregori on 1/9/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STMenuTableViewCell.h"

@interface STMenuDateTableViewCell : STMenuTableViewCell
{
    NSString    *_mode;
}
// Possible values: time, date, dateAndTime. Defaults to dateAndTime.
@property (nonatomic, copy)   NSString    *mode;

@end
