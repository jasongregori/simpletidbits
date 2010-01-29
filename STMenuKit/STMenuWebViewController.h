//
//  STMenuWebViewController.h
//  STMenuKit
//
//  Created by Jason Gregori on 1/28/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STMenuBaseViewController.h"


@interface STMenuWebViewController : STMenuBaseViewController
{
    NSString    *_html;
}
// html string
@property (nonatomic, copy)     NSString  *html;

@end
