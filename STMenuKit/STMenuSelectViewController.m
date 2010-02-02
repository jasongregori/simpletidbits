//
//  STMenuSelectViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 1/17/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STMenuSelectViewController.h"

@interface STMenuSelectViewController ()

@property (nonatomic, retain)   NSIndexPath *st_selectedRow;
@property (nonatomic, retain)   NSArray     *st_strings;
@property (nonatomic, retain)   NSArray     *st_values;

- (void)st_resetSubValue;

@end

@implementation STMenuSelectViewController
@synthesize defaultValue = _defaultValue, st_values = _values,
            st_strings = _strings, st_selectedRow = _selectedRow,
            saveOnSelect = _saveOnSelect;

- (id)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)dealloc
{
    [_defaultValue release];
    [_values release];
    [_strings release];
    [_selectedRow release];
    [_saveOnSelect release];
    
    [super dealloc];
}

- (void)st_resetSubValue
{
    // take checkmark away from old guy
    if (self.st_selectedRow)
    {
        [[self.tableView cellForRowAtIndexPath:self.st_selectedRow]
         setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    NSUInteger  row;
    self.st_selectedRow        = nil;
    NSUInteger section, count = [self.st_values count];
    for (section = 0; section < count; section++)
    {
        NSArray     *rows   = [self.st_values objectAtIndex:section];
        row         = [rows indexOfObject:self.subValue];
        if (row != NSNotFound)
        {
            self.st_selectedRow    = [NSIndexPath indexPathForRow:row
                                                        inSection:section];
            break;
        }
    }
    
    if (self.st_selectedRow)
    {
        // set checkmark for new cell
        [[self.tableView cellForRowAtIndexPath:self.st_selectedRow]
         setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.st_strings count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[self.st_strings objectAtIndex:section] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    STMenuTableViewCell *cell   = [self st_cellWithCellData:nil
                                                        key:self.key];

    [cell setTitle:
     [[[self.st_strings objectAtIndex:indexPath.section]
       objectAtIndex:indexPath.row] description]];
	
    // checkmark
    if ([self.st_selectedRow isEqual:indexPath])
    {
        cell.accessoryType  = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set sub value (setting it will also checkmark the cell)
    self.subValue   = [[self.st_values objectAtIndex:indexPath.section]
                       objectAtIndex:indexPath.row];
    
    // deselect row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.saveOnSelect boolValue])
    {
        [self st_save];
    }
}

#pragma mark STMenuSubMenuTableViewController

- (void)setSubValue:(id)subValue
{
    if (![self.subValue isEqual:subValue])
    {
        [super setSubValue:subValue];
        
        if ([self isViewLoaded])
        {
            [self st_resetSubValue];
        }
    }
}

#pragma mark STMenuProtocol

- (void)st_prepareForReuse
{
    [super st_prepareForReuse];
    
    self.saveOnSelect   = nil;
}

- (void)setSt_schema:(id)schema
{
    if (schema)
    {
        NSAssert([schema isKindOfClass:[NSDictionary class]],
                 @"Section Menu plist must be a dictionary!");

        NSArray     *strings    = [schema valueForKey:@"strings"];
        NSArray     *values     = [schema valueForKey:@"values"];
        
        NSAssert([strings isKindOfClass:[NSArray class]],
                 @"Select Menu plist must have an array value for the "
                 @"\"strings\" key");
        NSAssert([values isKindOfClass:[NSArray class]],
                 @"Select Menu plist must have an array value for the \"values\" "
                 @"key");
        
        // check if this is a one section select menu or multi section
        BOOL        multiSection    = YES;
        for (id object in strings)
        {
            if (![object isKindOfClass:[NSArray class]])
            {
                multiSection  = NO;
                break;
            }
        }
        
        if (!multiSection)
        {
            strings     = [NSArray arrayWithObject:strings];
            values      = [NSArray arrayWithObject:values];
        }
        
        // make sure these have the same number of sections/rows
        NSAssert([strings count] == [values count],
                 @"Select Menu plist strings and values must have the same "
                 @"number of sections.");
        NSUInteger i, count = [strings count];
        for (i = 0; i < count; i++)
        {
            NSAssert([[strings objectAtIndex:i] count] ==
                     [[values objectAtIndex:i] count],
                     @"Select Menu plist strings and values sections do not "
                     @"all have the same number of rows."); 
        }
        
        self.st_strings = strings;
        self.st_values  = values;
    }
    else
    {
        self.st_strings = nil;
        self.st_values  = nil;
    }

    if ([self isViewLoaded])
    {
        [self.tableView reloadData];
    }
}

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self st_resetSubValue];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.contentOffset    = CGPointMake(0,0);
}

@end
