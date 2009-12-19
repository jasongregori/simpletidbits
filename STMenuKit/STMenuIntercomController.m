//
//  STMenuIntercomController.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/18/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuIntercomController.h"

#pragma mark Notifications
NSString *const STMenuIntercomControllerDidRegisterMenuNotification
  = @"STMenuIntercomControllerDidRegisterMenuNotification";
NSString *const STMenuIntercomControllerWillUnregisterMenuNotification
  = @"STMenuIntercomControllerWillUnregisterMenuNotification";
NSString *const STMenuIntercomControllerDidRegisterDelegateNotification
  = @"STMenuIntercomControllerDidRegisterDelegateNotification";
NSString *const STMenuIntercomControllerWillUnregisterDelegateNotification
  = @"STMenuIntercomControllerWillUnregisterDelegateNotification";

static STMenuIntercomController *st_sharedIntercom = nil;

@interface STMenuIntercomController ()

@property (nonatomic, retain) NSMutableDictionary   *st_menus;
@property (nonatomic, retain) NSMutableDictionary   *st_delegates;

@end

@implementation STMenuIntercomController
@synthesize st_menus = _menus, st_delegates = _delegates;

+ (STMenuIntercomController *)sharedIntercom
{
    if (!st_sharedIntercom)
    {
        st_sharedIntercom   = [[STMenuIntercomController alloc] init];
    }
    return st_sharedIntercom;
}

- (id)init
{
    if (st_sharedIntercom)
    {
        // there can only be one!
        [self release];
        self = st_sharedIntercom;
    }
    else if (self = [super init])
    {
        // special dictionaries that do not retain the values
        _menus  = (id)CFDictionaryCreateMutable
                      (NULL,
                       0,
                       &kCFCopyStringDictionaryKeyCallBacks,
                       NULL);
        _delegates  = (id)CFDictionaryCreateMutable
                          (NULL,
                           0,
                           &kCFCopyStringDictionaryKeyCallBacks,
                           NULL);
    }
    return self;
}

- (void)dealloc
{
    [_menus release];
    [_delegates release];
    
    [super dealloc];
}

- (void)registerMenu:(id <STMenuProtocol>)menu forKey:(NSString *)key
{
    if (!key)
    {
        return;
    }
    [self.st_menus setValue:menu forKey:key];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:STMenuIntercomControllerDidRegisterMenuNotification
     object:self
     userInfo:[NSDictionary dictionaryWithObject:key forKey:@"key"]];
}
- (void)unregisterMenu:(id <STMenuProtocol>)menu forKey:(NSString *)key
{
    if (!key)
    {
        return;
    }
    if ([self.st_menus valueForKey:key] == menu)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:
           STMenuIntercomControllerWillUnregisterMenuNotification
         object:self
         userInfo:[NSDictionary dictionaryWithObject:key forKey:@"key"]];
        [self.st_menus removeObjectForKey:key];
    }
}
- (id <STMenuProtocol>)menuForKey:(NSString *)key
{
    if (!key)
    {
        return nil;
    }
    return [self.st_menus valueForKey:key];
}

- (void)registerDelegate:(id)delegate forKey:(NSString *)key
{
    if (!key)
    {
        return;
    }
    [self.st_delegates setValue:delegate forKey:key];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:
       STMenuIntercomControllerDidRegisterDelegateNotification
     object:self
     userInfo:[NSDictionary dictionaryWithObject:key forKey:@"key"]];
}

- (void)unregisterDelegate:(id)delegate forKey:(NSString *)key
{
    if (!key)
    {
        return;
    }
    if ([self.st_delegates valueForKey:key] == delegate)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:
           STMenuIntercomControllerWillUnregisterDelegateNotification
         object:self
         userInfo:[NSDictionary dictionaryWithObject:key forKey:@"key"]];
        [self.st_delegates removeObjectForKey:key];
    }
}

- (id)delegateForKey:(NSString *)key
{
    if (!key)
    {
        return nil;
    }
    return [self.st_delegates valueForKey:key];
}

@end
