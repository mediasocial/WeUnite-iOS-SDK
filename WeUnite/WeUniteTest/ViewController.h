//
//  ViewController.h
//  WeUniteTest
//
//  Created by Anthony Gonsalves on 23/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WeUniteSDK/WeUniteSDK.h>

@interface ViewController : UIViewController<WUActionDelegate>
{
    WeUnite *mWeUnite;
    WUButton *wuButton;
    NSString *newPinKey;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mActivity;
@property (weak, nonatomic) IBOutlet UIButton *mCommentsBtn;
@property (weak, nonatomic) IBOutlet UIButton *mLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *mBoardBtn,*mCreatePinBtn;
@property (weak, nonatomic) IBOutlet UIButton *mRegisterPushTokenBtn;


-(IBAction)createSessionButtonPressed:(id)sender;
-(IBAction)getCommentButtonPressed:(id)sender;
-(IBAction)loginRegisterWeUnite:(id)sender;
-(IBAction)boardButtonPressed:(id)sender;
-(IBAction)createPinButtonPressed:(id)sender;

-(IBAction) registerPushToken:(id)sender;

@end
