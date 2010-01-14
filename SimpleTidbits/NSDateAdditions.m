//
//  NSDateAdditions.m
//  SimpleTidbits
//
//  Created by Jason Gregori on 9/26/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "NSDateAdditions.h"

static NSDateFormatter *stringDateFormatter = nil;
static NSDateFormatter *shortDateFormatter = nil;
static NSDateFormatter *longDateFormatter = nil;
static NSDateFormatter *timeDateFormatter = nil;

@implementation NSDate (SimpleTidbits)

- (NSString *)st_stringValue
{
    if (!stringDateFormatter)
    {
        stringDateFormatter = [[NSDateFormatter alloc] init];
        [stringDateFormatter setDateStyle:NSDateFormatterLongStyle];
        [stringDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    return [stringDateFormatter stringFromDate:self];
}

- (NSString *)st_shortDateStringValue
{
	if (!shortDateFormatter)
	{
		shortDateFormatter	= [[NSDateFormatter alloc] init];
		[shortDateFormatter setDateStyle:NSDateFormatterShortStyle];
		[shortDateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
	return [shortDateFormatter stringFromDate:self];
}

- (NSString *)st_longDateStringValue
{
	if (!longDateFormatter)
	{
		longDateFormatter	= [[NSDateFormatter alloc] init];
		[longDateFormatter setDateStyle:NSDateFormatterLongStyle];
		[longDateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
	return [longDateFormatter stringFromDate:self];
}

- (NSString *)st_timeStringValue
{
    if (!timeDateFormatter)
    {
        timeDateFormatter   = [[NSDateFormatter alloc] init];
        [timeDateFormatter setDateStyle:NSDateFormatterNoStyle];
        [timeDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    return [timeDateFormatter stringFromDate:self];
}


- (NSDate *)st_dateByRoundingToNearest:(NSUInteger)minutes
{
    if (minutes == 0)
    {
        return self;
    }
    
    NSDateComponents	*dateComponents
      = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit
                                                  | NSMonthCalendarUnit
                                                  | NSDayCalendarUnit
                                                  | NSHourCalendarUnit
                                                  | NSMinuteCalendarUnit)
                                        fromDate:self];
    // should we round up or down?
    NSUInteger  minutesModRounder   = [dateComponents minute] % minutes;
    NSUInteger  newMinutes          = ([dateComponents minute]
                                       - minutesModRounder);
    if (minutesModRounder > minutes/2)
    {
        // up is closer, round up
        newMinutes  += minutes;
    }
    [dateComponents setMinute:newMinutes];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

@end
