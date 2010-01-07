//
//  STMenuCoreDataListSectionController.m
//  STMenuCoreDataKit
//
//  Created by Jason Gregori on 12/30/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuCoreDataListSectionController.h"

@interface STMenuCoreDataListSectionController ()

@end


@implementation STMenuCoreDataListSectionController
@synthesize listKeyPath = _listKeyPath, managedObject = _managedObject;

- (void)dealloc
{
    self.managedObject  = nil;
    [_listKeyPath release];
    
    [super dealloc];
}

- (void)setManagedObject:(NSManagedObject *)managedObject
{
    NSAssert(!managedObject
             || [managedObject isKindOfClass:[NSManagedObject class]],
             @"Tried to set managedObject of CoreData List Section Controller "
             @"to an object which is not a managed object.");
    
    if (managedObject != _managedObject)
    {
        if (self.listKeyPath)
        {
            // stop observing old list
            [_managedObject removeObserver:self
                                forKeyPath:self.listKeyPath];
        }
        [_managedObject release];
        _managedObject  = [managedObject retain];
        if (self.listKeyPath)
        {
            // start observing the new list
            [_managedObject addObserver:self
                             forKeyPath:self.listKeyPath
                                options:(NSKeyValueObservingOptionNew
                                         | NSKeyValueObservingOptionOld)
                                context:NULL];
            self.list   = [_managedObject valueForKeyPath:self.listKeyPath];
        }
        else
        {
            self.list   = nil;
        }
    }
}

- (void)setListKeyPath:(NSString *)listKeyPath
{
    if (listKeyPath != _listKeyPath)
    {
        // need to stop observing the old key
        self.managedObject  = nil;
        [_listKeyPath release];
        _listKeyPath        = [listKeyPath copy];
        // start observing the new key
        self.managedObject  = self.menu.value;
    }
}

#pragma mark STMenuFormattedSectionController

- (void)menuValueDidChange:(id)newValue
{
    self.managedObject  = newValue;
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    switch ([[change valueForKey:NSKeyValueChangeKindKey] intValue])
    {
        case NSKeyValueChangeSetting:
        {
            // there is a new list, reset the list
            self.list   = [change valueForKey:NSKeyValueChangeNewKey];
            break;
        }
        case NSKeyValueChangeInsertion:
        case NSKeyValueChangeRemoval:
        case NSKeyValueChangeReplacement:
        {
            BOOL        viewLoaded  = [self.menu isViewLoaded];
            if (viewLoaded)
            {
                [self.menu.tableView beginUpdates];
            }
            // remove old objects
            for (id object in [change valueForKey:NSKeyValueChangeOldKey])
            {
                [self deleteItem:object];
            }
            // add new objects
            for (id object in [change valueForKey:NSKeyValueChangeNewKey])
            {
                [self addItem:object];
            }
            if (viewLoaded)
            {
                [self.menu.tableView endUpdates];
            }
            break;
        }
    }
}

@end