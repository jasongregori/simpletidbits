//
//  STMenuIntercomController.h
//  STMenuKit
//
//  Created by Jason Gregori on 12/18/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STMenuProtocol.h"

/*
 STMenuIntercomController
 ------------------------
 
 The STMenuIntercomController's, or the intercom for short, job is to allow
 communication between menus and their delegates.
 
 Most of the time, you shoudn't need delegates in MenuKit (that's kind of the
 whole point), but sometimes you need a bit more customization.
 
 Menus
 -----
 
 When you set the menuKey on a menu, it registers with the intercom. You may
 then ask the intercom for the menu that uses that key and it will be returned
 to you if it exists. Always ask the intercom for menus, never save a menu. The
 menu using a specific key may change, especially if a memory warning happens.
 It is important to remember this fact. It is best not to rely on menu states
 unless you know a menu will not stop using a key. If you must, use
 the intercom's notifications to help.
 
 Delegates
 ---------
 
 When you set the delegateKey on a menu, the menu will ask the intercom for a
 delegate with that key if it ever needs to call it's delegate. You must
 register with the intercom for the menu to call you.
 
 Important
 ---------
 
 You may only register one menu or delegate for a key. Never use the same key
 for two different menus or delegates! The issue is that one may "steal" the key
 from the other resulting in both thinking they have the key but only one
 actually having it.
 
 The intercom does not retain menus or delegates, you must unregister them when
 their keys change or when they are dealloced.
 */

#pragma mark Notifications
// userInfo: {key:}
extern NSString *const STMenuIntercomControllerDidRegisterMenuNotification;
extern NSString *const STMenuIntercomControllerWillUnregisterMenuNotification;
extern NSString *const STMenuIntercomControllerDidRegisterDelegateNotification;
extern NSString *const
  STMenuIntercomControllerWillUnregisterDelegateNotification;

@interface STMenuIntercomController : NSObject
{
    NSMutableDictionary *_menus;
    NSMutableDictionary *_delegates;
}

+ (STMenuIntercomController *)sharedIntercom;

- (void)registerMenu:(id <STMenuProtocol>)menu forKey:(NSString *)key;
- (void)unregisterMenu:(id <STMenuProtocol>)menu forKey:(NSString *)key;
- (id <STMenuProtocol>)menuForKey:(NSString *)key;

- (void)registerDelegate:(id)delegate forKey:(NSString *)key;
- (void)unregisterDelegate:(id)delegate forKey:(NSString *)key;
- (id)delegateForKey:(NSString *)key;

@end
