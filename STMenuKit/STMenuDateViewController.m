//
//  STMenuDateViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 1/9/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STMenuDateViewController.h"
#import <SimpleTidbits/SimpleTidbits.h>

@interface STMenuDateViewController ()
@property (nonatomic, retain)   UIDatePicker    *st_datePicker;
@property (nonatomic, retain)   UITableView     *st_tableView;

- (void)st_datePickerValueChanged;

@end

@implementation STMenuDateViewController
@synthesize mode = _mode, maximumDate = _maximumDate,
            minimumDate = _minimumDate, minuteInterval = _minuteInterval,
            st_datePicker = _datePicker, st_tableView = _tableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped])
    {
        [super setCell:@"Date"];
    }
    return self;
}

- (void)dealloc
{
    [_mode release];
    [_maximumDate release];
    [_minimumDate release];
    [_minuteInterval release];
    
    [_datePicker release];
    [_tableView release];
    
    [super dealloc];
}

- (void)st_datePickerValueChanged
{
    self.subValue   = self.st_datePicker.date;
}

- (void)setMode:(NSString *)mode
{
    if (![_mode isEqualToString:mode])
    {
        [_mode release];
        _mode       = [mode copy];
        
        // set cell mode
        [super setCell:
         [NSDictionary dictionaryWithObjectsAndKeys:
          @"Date", @"class",
          mode, @"mode",
          nil]];
        if ([self isViewLoaded])
        {
            [self.tableView reloadData];
        }
    }
}

#pragma mark STMenuSubMenuCellViewController

- (void)setCell:(id)cell
{
    // dont let user override cell
}

#pragma mark STMenuSubMenuTableViewController

- (void)setSubValue:(id)value
{
    if (!value)
    {
        value   = [[NSDate date] st_dateByRoundingToNearest:
                   [self.minuteInterval integerValue]];
    }
    
    [super setSubValue:value];
    if (![self.st_datePicker.date isEqualToDate:value])
    {
        [self.st_datePicker setDate:value animated:NO];
    }
}

#pragma mark UITableViewController

- (UITableView *)tableView
{
    // make sure view is loaded
    self.view;
    return self.st_tableView;
}

#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // make cell appear centered between top and date picker
    // center the cell (height - cell height)/2 - cell header margin
    self.tableView.contentInset
      = UIEdgeInsetsMake((self.tableView.frame.size.height - 44)/2.0 - 10,
                         0, 0, 0);
}

- (void)loadView
{
    UIView          *view       = [[UIView alloc]
                                   initWithFrame:CGRectMake(0, 0, 320, 480)];
    view.autoresizingMask       = (UIViewAutoresizingFlexibleHeight
                                   | UIViewAutoresizingFlexibleWidth);
    self.view   = view;
    [view release];

    UIDatePicker    *datePicker = [[UIDatePicker alloc]
                                   init];
    [datePicker addTarget:self
                   action:@selector(st_datePickerValueChanged)
         forControlEvents:UIControlEventValueChanged];
    datePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                   | UIViewAutoresizingFlexibleTopMargin);
    // set up date picker
    datePicker.minimumDate      = self.minimumDate;
    datePicker.maximumDate      = self.maximumDate;
    if (self.minuteInterval)
    {
        datePicker.minuteInterval   = [self.minuteInterval integerValue];
    }
    // datepicker mode
    NSString    *lowercaseMode  = [self.mode lowercaseString];
    if ([lowercaseMode isEqualToString:@"time"])
    {
        datePicker.datePickerMode   = UIDatePickerModeTime;
    }
    else if ([lowercaseMode isEqualToString:@"date"])
    {
        datePicker.datePickerMode   = UIDatePickerModeDate;
    }
    else
    {
        datePicker.datePickerMode   = UIDatePickerModeDateAndTime;
    }
    // size
    [datePicker sizeToFit];
    CGRect          frame       = datePicker.frame;
    frame.origin.y  = view.frame.size.height - frame.size.height;
    frame.size.width            = view.frame.size.width;
    datePicker.frame            = frame;
    // value
    datePicker.date = self.subValue;
    
    self.st_datePicker  = datePicker;
    [datePicker release];
    
    // table view
    UITableView     *tableView  = [[UITableView alloc]
                                   initWithFrame:
                                   CGRectMake(0, 0,
                                              view.frame.size.width,
                                              datePicker.frame.origin.y)
                                   style:UITableViewStyleGrouped];
    tableView.autoresizingMask  = (UIViewAutoresizingFlexibleWidth
                                   | UIViewAutoresizingFlexibleHeight);
    tableView.delegate          = self;
    tableView.dataSource        = self;
    self.st_tableView           = tableView;
    [tableView release];
    
    [view addSubview:self.st_tableView];
    [view addSubview:self.st_datePicker];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.st_datePicker  = nil;
    self.st_tableView   = nil;
}

@end

