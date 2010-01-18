//
//  STMenuSwitchTableViewCell.h
//  STMenuKit
//
//  Created by Jason Gregori on 1/17/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STMenuTableViewCell.h"


@interface STMenuSwitchTableViewCell : STMenuTableViewCell
{
    UISwitch    *_toggle;
    
    id          _defaultValue;
    id          _trueValue;
    id          _falseValue;
}
@property (nonatomic, retain)   id          defaultValue;
// Defaults to NSNumber BOOL YES
@property (nonatomic, retain)   id          trueValue;
// Defaults to NSNumber BOOL NO
@property (nonatomic, retain)   id          falseValue;

@end
