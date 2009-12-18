//
//  STMenuCoreDataListTableViewController.h
//  STMenuCoreDataKit
//
//  Created by Jason Gregori on 12/17/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <STMenuKit/STMenuKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface STMenuCoreDataListTableViewController : STMenuListTableViewController
<NSFetchedResultsControllerDelegate>
{
  @protected
    NSDictionary    *_fetchInfo;
    NSFetchedResultsController  *_fetchedResultsController;
}
/*
 fetchInfo
 ---------
 entity (string)
 predicate (string)
 sortDescriptors (array of dictionaries)
    key (string)
    ascending (BOOL)
 sectionName (string)
 cacheName (string)
 */
@property (nonatomic, retain)   NSDictionary    *fetchInfo;

@end
