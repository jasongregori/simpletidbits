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

- (void)st_resetSubValue;

@end

@implementation STMenuSelectViewController
@synthesize defaultValue = _defaultValue, values = _values,
            sections = _sections, st_selectedRow = _selectedRow, rows = _rows;

- (id)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)dealloc
{
    [_defaultValue release];
    [_values release];
    [_sections release];
    [_rows release];
    [_selectedRow release];
    
    [super dealloc];
}

- (void)setSections:(NSArray *)sections
{
    if (![_sections isEqual:sections])
    {
        if (sections)
        {
            self.rows   = nil;
        }
        [_sections release];
        _sections    = [sections retain];
        
        if ([self isViewLoaded])
        {
            [self.tableView reloadData];
        }
    }
}

- (void)setRows:(NSArray *)rows
{
    if (![_rows isEqualToArray:rows])
    {
        if (rows)
        {
            self.sections   = nil;
        }
        [_rows release];
        _rows   = [rows retain];
        
        if ([self isViewLoaded])
        {
            [self.tableView reloadData];
        }
    }
}

- (void)st_resetSubValue
{
    // take checkmark away from old guy
    if (self.st_selectedRow)
    {
        [[self.tableView cellForRowAtIndexPath:self.st_selectedRow]
         setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    if (self.rows)
    {
        NSUInteger  row     = [self.values indexOfObject:self.subValue];
        if (row != NSNotFound)
        {
            self.st_selectedRow    = [NSIndexPath indexPathForRow:row
                                                     inSection:0];
        }
        else
        {
            self.st_selectedRow    = nil;
        }
    }
    else
    {
        NSUInteger  row;
        self.st_selectedRow        = nil;
        NSUInteger i, count = [self.sections count];
        for (i = 0; i < count; i++)
        {
            NSArray     *rows   = [self.values objectAtIndex:i];
            row         = [rows indexOfObject:self.subValue];
            if (row != NSNotFound)
            {
                self.st_selectedRow    = [NSIndexPath indexPathForRow:row
                                                         inSection:i];
                break;
            }
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
    if (self.rows)
    {
        return 1;
    }
    return [self.sections count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (self.rows)
    {
        return [self.rows count];
    }
    return [[self.sections objectAtIndex:section] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    STMenuTableViewCell *cell   = [self st_cellWithCellData:nil
                                                        key:self.key];
    id      title       = nil;
    if (self.rows)
    {
        title   = [self.rows objectAtIndex:indexPath.row];
    }
    else
    {
        title   = [[self.sections objectAtIndex:indexPath.section]
                   objectAtIndex:indexPath.row];
    }

    [cell setTitle:[title description]];
	
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
    if (self.rows)
    {
        self.subValue   = [self.values objectAtIndex:indexPath.row];
    }
    else
    {
        self.subValue   = [[self.values objectAtIndex:indexPath.section]
                           objectAtIndex:indexPath.row];
    }
    
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
