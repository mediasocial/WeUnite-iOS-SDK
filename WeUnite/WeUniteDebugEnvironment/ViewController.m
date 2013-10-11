//
//  ViewController.m
//  WeUniteDebugEnvironment
//
//  Created by Anthony Gonsalves on 26/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "ViewController.h"
#import "CommentsViewController.h"
#import "WUCommentsVC.h"
#import "WURequest.h"
#import "AppDelegate.h"

#import "PhotoViewController.h"
#import "WUConstants.h"
#import "UIKit+Extensions.h"
#import "WUButton.h"
#import "WUDeleteVC.h"

@interface ViewController ()

@end

@implementation ViewController

WUButton *wuButton = nil;

- (void)viewDidLoad
{
    NSLog(@"%@",self.view);
    [super viewDidLoad];
   	// Do any additional setup after loading the view, typically from a nib.
    //[WURequest startRequestOfType:WURequestTypeRegistration delegate:self successSelector:@selector(registerSuccess:) failSelector:@selector(registerFailure:)];
    
    
    //NSDate *date = [NSDate dateWithTimeIntervalSince1970:1382779689];
    
   /* UIView *view  = [[UIView alloc] initWithFrame:self.view.bounds];
    UIView *view1 = self.view;
    
    self.view = view;
    view1.top = 20;
    [self.view addSubview:view1];
    */
    wuButton = [WUButton weUniteButtonWithParentController:self];
    wuButton.frame = CGRectMake(250, 10, 50, 70);
    [wuButton setEnabled:FALSE];
    [self.mBaseView addSubview:wuButton];

    
    
    
    NSLog(@"%@",self.view.superview);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)createSessionButtonPressed:(id)sender
{
 
    [_mActivity startAnimating];
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDel.mWeUnite = [[WeUnite alloc] initWithAppKey:@"201506049871774" secretKey:@"ea4d531e2a62c19c97ffefd2017e71fd" WithDelegate:self];

}

-(IBAction)getCommentButtonPressed:(id)sender{
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.mWeUnite performAction:kActionOpenCommentsKey andParams:nil andDelegate:self];

    
    
}


-(IBAction)loginRegisterWeUnite:(id)sender{
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.mWeUnite loginWeUnite:self];
}

-(IBAction) registerPushToken:(id)sender
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyToken];
    if (deviceToken == nil) {
        deviceToken = @"deviceToken";
    }
    [appDel.mWeUnite registerForPushWithToken:deviceToken];
}

-(IBAction)boardButtonPressed:(id)sender{
     AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.mWeUnite presentModalBoardPinsControllerFromParentController:self];
}








-(IBAction)createPinButtonPressed:(id)sender
{
    PhotoViewController* photos = [[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushFadeViewController:photos];
    return;
    
       
    
    //   [self.facebook dialog:@"feed" andParams:params  andDelegate:self];
    

}



#pragma mark - Action Deleagte method is called.

- (void)wuActionResponse:(BOOL)isSuccess params:(NSDictionary*)params
{
    NSString* action = params[kResponseActionKey];
    NSLog(@"View Controller wuAction response is called ffor action %@",action);
    
    if (isSuccess == false) {
        
        if ([action isEqualToString:kActionInitAppKey]) {
            
            // Handle error if you want to handle it gracefully.
        }
        
        NSError* error = params[kResponseErrorKey];
        [UIAlertView showAlertMessage:[error localizedDescription]];
        return;
    }
    
    
    if ([action isEqualToString:kActionInitAppKey]) {
     
        [_mCommentsBtn setEnabled:YES];
        [_mLoginBtn setEnabled:YES];
        [_mBoardBtn setEnabled:YES];
        [wuButton setEnabled:YES];
        self.mCreatePinBtn.enabled = YES;
        [_mRegisterPushTokenBtn setEnabled:YES];
        [_mActivity stopAnimating];
      
        return;
    }
    
    
    if ([action isEqualToString:kActionLoginKey]) {
        [UIAlertView showAlertMessage:@"Login Successful."];
        return;
    }
    
    if ([action isEqualToString:kActionNewPinKey]) {
        [UIAlertView showAlertMessage:@"New Pin creation is Successful."];
        
        
        newPinKey = params[@"pinKey"];
        NSLog(@"pin Key is %@",newPinKey);
        
        return;
    }
    
}
@end
