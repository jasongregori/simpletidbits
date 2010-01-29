//
//  STMenuWebViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 1/28/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STMenuWebViewController.h"


@implementation STMenuWebViewController
@synthesize html = _html;

- (void)dealloc
{
    [_html release];
    
    [super dealloc];
}

- (void)setHtml:(NSString *)html
{
    if (html != _html)
    {
        [_html release];
        _html   = [html copy];
        
        if ([self isViewLoaded])
        {
            [((UIWebView *)self.view) loadHTMLString:self.html baseURL:nil];
        }
    }
}

#pragma mark UIViewController

- (void)loadView
{
    UIWebView       *webView    = [[UIWebView alloc] init];
    if (self.html)
    {
        [webView loadHTMLString:self.html baseURL:nil];
    }
    self.view       = webView;
    [webView release];
}

@end
