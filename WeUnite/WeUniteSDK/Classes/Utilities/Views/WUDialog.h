//
//  WUDialog.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 03/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeUnite.h"

//TODO: Demo purpose only. To be modified once again.

@interface WUDialog : UIView{
    IBOutlet UIView *mContainerView;
    IBOutlet UIWebView *mWebView;
}



-(void)show :(id<WUActionDelegate>)delegate;


@end
