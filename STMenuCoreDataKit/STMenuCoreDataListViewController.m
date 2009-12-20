//
//  STMenuCoreDataListTableViewController.m
//  STMenuCoreDataKit
//
//  Created by Jason Gregori on 12/17/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuCoreDataListViewController.h"
#import <STCoreDataKit/STCoreDataKit.h>

@interface STMenuCoreDataListViewController ()

@property (nonatomic, retain)
  NSFetchedResultsController  *st_fetchedResultsController;

@end

@implementation STMenuCoreDataListViewController
@synthesize fetchInfo = _fetchInfo,
            st_fetchedResultsController = _fetchedResultsController;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)dealloc
{
    [_fetchInfo release];
    [_fetchedResultsController release];
    
    [super dealloc];
}

- (void)setFetchInfo:(NSDictionary *)fetchInfo
{
    if (fetchInfo != _fetchInfo)
    {
        [_fetchInfo release];
        _fetchInfo  = [fetchInfo retain];
        
        NSManagedObjectContext  *moc    = [STCoreData mainManagedObjectContext];
        
        NSFetchRequest  *fetchRequest   = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:
         [NSEntityDescription entityForName:[fetchInfo valueForKey:@"entity"]
                     inManagedObjectContext:moc]];
        if ([fetchInfo valueForKey:@"predicate"])
        {
            [fetchRequest setPredicate:
             [NSPredicate predicateWithFormat:
              [fetchInfo valueForKey:@"predicate"]]];
        }
        if ([fetchInfo valueForKey:@"sortDescriptors"])
        {
            NSMutableArray  *sorts  = [NSMutableArray array];
            for (NSDictionary *sort
                 in [fetchInfo valueForKey:@"sortDescriptors"])
            {
                NSSortDescriptor    *descriptor
                  = [[NSSortDescriptor alloc]
                     initWithKey:[sort valueForKey:@"key"]
                     ascending:[[sort valueForKey:@"ascending"] boolValue]
                     selector:
                         [sort valueForKey:@"selector"] ?
                         NSSelectorFromString([sort valueForKey:@"selector"]) :
                         @selector(compare:)];
                [sorts addObject:descriptor];
                [descriptor release];
            }
            [fetchRequest setSortDescriptors:sorts];
        }
        
        NSFetchedResultsController  *controller
          = [[NSFetchedResultsController alloc]
             initWithFetchRequest:fetchRequest
             managedObjectContext:moc
             sectionNameKeyPath:[fetchInfo valueForKey:@"sectionName"]
             cacheName:[fetchInfo valueForKey:@"cacheName"]];
        [fetchRequest release];
        controller.delegate     = self;
        self.st_fetchedResultsController    = controller;
        
        [controller performFetch:NULL];
        if ([self isViewLoaded])
        {
            [self.tableView reloadData];
        }
        [controller release];
        
        // see if we have any items
        [self noItemsCheck];
    }
}

#pragma mark STMenuListTableViewController

- (void)noItemsCheck
{
    [self setSt_showNoItemsMessage:([[self.st_fetchedResultsController
                                      fetchedObjects]
                                     count] == 0)];
}

- (id)st_itemForIndexPath:(NSIndexPath *)indexPath
{
    return [self.st_fetchedResultsController objectAtIndexPath:indexPath];
}

- (NSInteger)numberOfSections
{
    return [[self.st_fetchedResultsController sections] count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo
      = [[self.st_fetchedResultsController sections]
         objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)deleteItem:(id)item
{
    NSManagedObjectContext  *moc    = [STCoreData mainManagedObjectContext];
    [moc deleteObject:item];
    [STCoreData saveManagedObjectContext:moc];
}

#pragma mark Delegate Methods
#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if ([self isViewLoaded])
    {
        [self.tableView beginUpdates];
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    if (![self isViewLoaded])
    {
        return;
    }
    
    UITableViewRowAnimation rowAnimation    = (self.view.window ?
                                               UITableViewRowAnimationFade :
                                               UITableViewRowAnimationNone);
    
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView
             insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
             withRowAnimation:rowAnimation];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView
             deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
             withRowAnimation:rowAnimation];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (![self isViewLoaded])
    {
        return;
    }
    
    UITableView *tableView = self.tableView;
    
    UITableViewRowAnimation rowAnimation    = (self.view.window ?
                                               UITableViewRowAnimationFade :
                                               UITableViewRowAnimationNone);
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView
             insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
             withRowAnimation:rowAnimation];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView
             deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
             withRowAnimation:rowAnimation];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [((STMenuTableViewCell *)[tableView
                                      cellForRowAtIndexPath:indexPath])
             setValue:[self st_itemForIndexPath:indexPath]];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView
             deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
             withRowAnimation:rowAnimation];
            [tableView
             insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
             withRowAnimation:rowAnimation];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([self isViewLoaded])
    {
        [self.tableView endUpdates];
        [self.tableView deselectRowAtIndexPath:
         [self.tableView indexPathForSelectedRow]
                                      animated:NO];
        [self noItemsCheck];
    }
}

@end

