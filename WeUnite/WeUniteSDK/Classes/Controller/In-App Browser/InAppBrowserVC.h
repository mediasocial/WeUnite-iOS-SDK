//
//  InAppBrowserVC.h
//  DonutFrenzyC2
//
//  Created by Anthony Gonsalves on 13/03/13.
//
//

#import <UIKit/UIKit.h>

#import "WUBaseVC.h"

@interface InAppBrowserVC : WUBaseVC{

    IBOutlet UIWebView *mInAppWebView;
   IBOutlet UIBarButtonItem *mDoneBarButtonItem;

   IBOutlet UIActivityIndicatorView *mLoadingActivity;
}
@property(nonatomic,copy)  NSString *mURLString;
@property(nonatomic,strong)IBOutlet UILabel *mTitleItem;
-(IBAction)doneItemPressed:(id)sender;
@end
