//
//  STRemoteSignUpViewController.h
//  STRemoteKit
//
//  Created by Jason Gregori on 1/20/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import <STMenuKit/STMenuKit.h>
#import "STRemoteSignUpControllerProtocol.h"

/*
 
 STRemoteSignUpViewController
 ----------------------------
 
 This is a default View Controller version of a Sign Up Controller.
 
 It is a sample Sign Up that you may use if you don't want to make one.
 
 STRemoteSignUpViewController is a modal controller so it must be modally shown
 or its parent must be modally shown. (It uses self.parentViewController
 dismissModalViewControllerAnimated: to dismiss itself).
 
 The default plist is in the bundle. Use it as a starting point or include
 the bundle in your project and set the plist to
 @"STRemoteKit.bundle/STRemoteSignUp.plist".
 
 */

@interface STRemoteSignUpViewController : STMenuFormViewController
<STRemoteSignUpControllerProtocol>
{
@protected
    id <STRemoteSignUpControllerDelegate> _delegate;
    BOOL            _cancelButtonHidden;
    
    UIBarButtonItem *_cancelButton;
}
// default cancel button showing
@property (nonatomic, assign)   BOOL    cancelButtonHidden;

- (void)setCancelButtonHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)cancel;
- (void)signUp;

@end
