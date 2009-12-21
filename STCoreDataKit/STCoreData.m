//
//  STCoreData.m
//  STCoreDataKit
//
//  Created by Jason Gregori on 12/16/09.
//  Copyright 2009 Slingshot Labs. All rights reserved.
//

#import "STCoreData.h"

static NSManagedObjectContext		*st_mainManagedObjectContext	= nil;
static NSPersistentStoreCoordinator	*st_persistentStoreCoordinator	= nil;

@implementation STCoreData

// Has a retain count of 1, you must release it
+ (NSManagedObjectContext *)newManagedObjectContext
{
    if (!st_persistentStoreCoordinator)
    {
        // get documents directory
        NSArray		*paths
          = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                NSUserDomainMask, YES);
        NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0]:nil;
        if (!basePath)
        {
            return nil;
        }
        // store url
        NSURL *storeUrl = [NSURL fileURLWithPath:
                           [basePath stringByAppendingPathComponent:
                            @"STCoreDataDatabase.sqlite"]];
        
        // MOM
        // Get ALL models
        NSMutableArray	*allBundles		= [NSMutableArray array];
        [allBundles addObjectsFromArray:[NSBundle allBundles]];
        [allBundles addObjectsFromArray:[NSBundle allFrameworks]];
        NSManagedObjectModel	*mom	= [NSManagedObjectModel
                                           mergedModelFromBundles:allBundles];
        
        // coordinator
        NSError		*error		= nil;
        st_persistentStoreCoordinator	= [[NSPersistentStoreCoordinator alloc]
                                           initWithManagedObjectModel:mom];
        if (![st_persistentStoreCoordinator
              addPersistentStoreWithType:NSSQLiteStoreType
              configuration:nil
              URL:storeUrl
              options:nil
              error:&error])
        {
            // ERROR
            NSLog(@"STCoreData ERROR newMOC:\n"
                  @"ERROR: %@\n"
                  @"UserInfo: %@\n",
                  error,
                  [error userInfo]);
            
            [st_persistentStoreCoordinator release];
            st_persistentStoreCoordinator	= nil;
            return nil;
        }
    }
    
    // create moc
    NSManagedObjectContext	*moc	= [[NSManagedObjectContext alloc]
                                       init];
    [moc setPersistentStoreCoordinator:st_persistentStoreCoordinator];
    [moc setMergePolicy:NSOverwriteMergePolicy];
    
    return moc;
}

// Use this main MOC for everything on your main thread
// Any other mocs that are saved, are merged into the main MOC
+ (NSManagedObjectContext *)mainManagedObjectContext
{
    if (!st_mainManagedObjectContext)
    {
        st_mainManagedObjectContext	= [self newManagedObjectContext];

        // observe all mocs!
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:
         @selector
         (mergeSavedManagedObjectContextNotificationIntoMainManagedObjectContext:)
         name:NSManagedObjectContextDidSaveNotification
         object:nil];
    }
    return st_mainManagedObjectContext;
}

// If you use this to save, changes will be forced.
// Any errors will be logged.
+ (BOOL)saveManagedObjectContext:(NSManagedObjectContext *)moc;
{
    NSLog(@"Saving: %@", moc);
    
    NSError		*error		= nil;
    BOOL		didWork		= [moc save:&error];
    if (!didWork)
    {
        // Log Error
        NSLog(@"STCoreData ERROR save: Failed to Save.\n"
              @"ERROR: %@\n"
              @"UserInfo: %@\n",
              error,
              [error userInfo]);
        [moc rollback];
    }
    return didWork;
}

+ (void)mergeSavedManagedObjectContextNotificationIntoMainManagedObjectContext:
  (NSNotification *)notification
{
    if ([notification object] != [STCoreData mainManagedObjectContext])
    {
        [[STCoreData mainManagedObjectContext]
         mergeChangesFromContextDidSaveNotification:notification];
    }
}

@end
