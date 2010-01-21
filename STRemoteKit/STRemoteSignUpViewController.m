//
//  STRemoteSignUpViewController.m
//  STRemoteKit
//
//  Created by Jason Gregori on 1/20/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STRemoteSignUpViewController.h"

@interface STRemoteSignUpViewController ()
@property (nonatomic, retain)   UIBarButtonItem *st_cancelButton;

@end

@implementation STRemoteSignUpViewController
@synthesize delegate = _delegate, st_cancelButton = _cancelButton,
            cancelButtonHidden = _cancelButtonHidden;

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style])
    {
        // set default value
        self.value      = [NSMutableDictionary dictionary];
                
        // set default options
        self.cancelButtonHidden = NO;
        
        // sign up button
        self.navigationItem.rightBarButtonItem
          = [[[UIBarButtonItem alloc]
              initWithTitle:@"Sign Up"
              style:UIBarButtonItemStyleDone
              target:self
              action:@selector(signUp)]
             autorelease];
    }
    return self;
}

- (void)dealloc
{
    [_cancelButton release];
    
    [super dealloc];
}

// Automatically calls delegate for each of these.
- (void)signUp
{
    [self.tableView
     deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
     animated:YES];
    [self.delegate remoteSignUpControllerTrySignUp:self];
}

// Calls `hide` as well
- (void)cancel
{
    [self.delegate remoteSignUpControllerCancel:self];
}

#pragma mark Properties

- (void)setCancelButtonHidden:(BOOL)hidden
{
    [self setCancelButtonHidden:hidden animated:NO];
}

- (void)setCancelButtonHidden:(BOOL)hidden animated:(BOOL)animated
{
    _cancelButtonHidden = hidden;
    if (!_cancelButtonHidden && !self.st_cancelButton)
    {
        // if we should show the cancel button, but it does not exist
        UIBarButtonItem *button = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:
                                   UIBarButtonSystemItemCancel
                                   target:self
                                   action:@selector(cancel)];
        self.st_cancelButton   = button;
        [button release];
        [self.navigationItem setLeftBarButtonItem:self.st_cancelButton
                                         animated:animated];
    }
    else if (_cancelButtonHidden && self.st_cancelButton)
    {
        // if the cancel button should hide and it exists
        [self.navigationItem setLeftBarButtonItem:nil
                                         animated:animated];
        self.st_cancelButton   = nil;
    }
}

#pragma mark STRemoteLoginControllerProtocol

- (void)dismiss
{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)setLoading:(BOOL)loading
{
    [super setLoading:loading];
}

- (BOOL)loading
{
    return [super loading];
}

@end
