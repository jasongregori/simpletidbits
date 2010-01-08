//
//  STMenuCoreDataListSectionController.h
//  STMenuCoreDataKit
//
//  Created by Jason Gregori on 12/30/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STMenuKit/STMenuKit.h>
#import <CoreData/CoreData.h>

/*
 
 STMenuCoreDataListSectionController
 -----------------------------------
 
 List Section Controller that lists a to-many relationship of a core data item.
 
 •  The value must be a core data item.
 •  The listKey is the key to the to-many relationship to show.
 •  blankItem must be an Entity Description Name of the item to add when the
    user hits add. This is used to create a new item.
 
 */

@interface STMenuCoreDataListSectionController : STMenuListSectionController
{
  @protected
    NSString        *_listKeyPath;
    NSManagedObject *_managedObject;
    NSNumber        *_onlyRemoveItemsOnDelete;
}
// The managed object that we are getting the list from. If in a menu, the value
// is automatically set to the menu's value. Otherwise you may set this value.
@property (nonatomic, retain)   NSManagedObject *managedObject;
// The keypath to use on the object to get a list of objects. It is also used to
// observe changes to that list.
@property (nonatomic, copy)     NSString        *listKeyPath;
// BOOL, default: NO
// If YES, we only remove the item from the managedObject on delete.
// If NO, we also delete the item from it's moc.
// This is useful if your items are used in more then one place.
@property (nonatomic, retain)   NSNumber        *onlyRemoveItemsOnDelete;

@end
