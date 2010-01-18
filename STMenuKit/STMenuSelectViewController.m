//
//  STMenuSelectViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 1/17/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STMenuSelectViewController.h"

@interface STMenuSelectViewController ()

@property (nonatomic, assign)   NSUInteger  selectedRow;

- (void)st_resetSubValue;

@end

@implementation STMenuSelectViewController
@synthesize defaultValue = _defaultValue, values = _values, strings = _strings,
            selectedRow = _selectedRow;

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped])
    {
        self.selectedRow    = NSNotFound;
    }
    return self;
}

- (void)dealloc
{
    [_defaultValue release];
    [_values release];
    [_strings release];
    
    [super dealloc];
}

- (void)setStrings:(NSArray *)strings
{
    if (![_strings isEqual:strings])
    {
        [_strings release];
        _strings    = [strings retain];
        
        if ([self isViewLoaded])
        {
            [self.tableView reloadData];
            [self st_resetSubValue];
        }
    }
}

- (void)setValues:(NSArray *)values
{
    if (![_values isEqual:values])
    {
        [_values release];
        _values     = [values retain];
        
        if ([self isViewLoaded])
        {
            [self.tableView reloadData];
            [self st_resetSubValue];
        }
    }
}

- (void)st_resetSubValue
{
    // take checkmark away from old guy
    if (self.selectedRow != NSNotFound)
    {
        [[self.tableView cellForRowAtIndexPath:
          [NSIndexPath indexPathForRow:self.selectedRow inSection:0]]
         setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    self.selectedRow    = [self.values indexOfObject:self.subValue];
    
    if (self.selectedRow == NSNotFound)
    {
        self.selectedRow    = [self.values indexOfObject:self.defaultValue];
    }
    
    if (self.selectedRow != NSNotFound)
    {
        // set checkmark for new cell
        [[self.tableView cellForRowAtIndexPath:
          [NSIndexPath indexPathForRow:self.selectedRow inSection:0]]
         setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.strings count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    STMenuTableViewCell *cell   = [self st_cellWithCellData:nil
                                                        key:self.key];
    [cell setTitle:[self.strings objectAtIndex:indexPath.row]];
	
    // checkmark
    if (self.selectedRow == indexPath.row)
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
    self.subValue       = [self.values objectAtIndex:indexPath.row];
    
    // deselect row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark STMenuSubMenuTableViewController

- (void)setSubValue:(id)subValue
{
    [super setSubValue:subValue];
    
    if ([self isViewLoaded])
    {
        [self st_resetSubValue];
    }
}

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self st_resetSubValue];
}

@end
