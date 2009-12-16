//
//  STCoreData.h
//  STCoreDataKit
//
//  Created by Jason Gregori on 12/16/09.
//  Copyright 2009 Slingshot Labs. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface STCoreData : NSObject

// Has a retain count of 1, you must release it
+ (NSManagedObjectContext *)newManagedObjectContext;

// Use this main MOC for everything on your main thread
// Any other mocs that are saved, are merged into the main MOC
+ (NSManagedObjectContext *)mainManagedObjectContext;

// If you use this to save, moc will be rolled back on errors and
// all errors will be logged.
+ (BOOL)saveManagedObjectContext:(NSManagedObjectContext *)moc;

@end
