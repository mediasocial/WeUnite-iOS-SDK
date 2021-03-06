//
//  ViewController.h
//  WeUniteDebugEnvironment
//
//  Created by Anthony Gonsalves on 26/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUBaseVC.h"

#import "WeUnite.h"
@interface ViewController : WUBaseVC<WUActionDelegate>
{
    NSString* newPinKey;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mActivity;
@property (weak, nonatomic) IBOutlet UIButton *mCommentsBtn;
@property (weak, nonatomic) IBOutlet UIButton *mLoginBtn,*mCreateScrapBtn,*mViewScrapBtn;
@property (weak, nonatomic) IBOutlet UIButton *mBoardBtn,*mCreatePinBtn;
@property (weak, nonatomic) IBOutlet UIButton *mRegisterPushTokenBtn;


-(IBAction)createSessionButtonPressed:(id)sender;
-(IBAction)getCommentButtonPressed:(id)sender;
-(IBAction)boardButtonPressed:(id)sender;
-(IBAction)createPinButtonPressed:(id)sender;

-(IBAction) registerPushToken:(id)sender;


@end
