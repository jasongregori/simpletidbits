//
//  NSDateAdditions.h
//  SimpleTidbits
//
//  Created by Jason Gregori on 9/26/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (SimpleTidbits)

// Uses NSDateFormattor
// Example: "November 23, 1937 3:30pm"
- (NSString *)st_stringValue;
// Example: “11/23/37”
- (NSString *)st_shortDateStringValue;
// Example: “November 23, 1937”
- (NSString *)st_longDateStringValue;
// Example: “3:30pm”
- (NSString *)st_timeStringValue;

- (NSDate *)st_dateByRoundingToNearest:(NSUInteger)minutes;

@end
