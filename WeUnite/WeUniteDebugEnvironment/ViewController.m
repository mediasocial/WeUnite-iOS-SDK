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
#import "WUExtraServices.h"

#import "WeUniteDebugEnvironment-Prefix.pch"

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
    
    
    /**
     * Add WeUnite Share Button in your application.
     */
    wuButton = [WUButton weUniteButtonWithParentController:self forPassionLinkKey:kPassionId];
    wuButton.frame = CGRectMake(250, 10, 50, 70);
    [wuButton setEnabled:FALSE];
    [self.mBaseView addSubview:wuButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)createSessionButtonPressed:(id)sender
{
 
    [_mActivity startAnimating];
    
    
    
    /*
     * To initialize the WeUnite Framework object, call the Framework Init method with Applicaiton Key and Applicaiton Secret Key in AppDelegate didFinishLaunching Method.
     */
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDel.mWeUnite = [[WeUnite alloc] initWithAppKey:@"76676973906775907677" secretKey:@"d3646ea467ed4bc284481c2d6d8f5adb" WithDelegate:self];

}

-(IBAction)getCommentButtonPressed:(id)sender{
    
    
    /**
     * To fetch your favorite Passion Posts and enable socializing, call the framework performAction method
     * and pass action as kActionOpenPassionPosts, constant defined in the WUConstant.h.
     */
   
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary* dict = @{kKeyPassionLinkKey:kTestPassionId};
    [appDel.mWeUnite performAction:kActionOpenPassionPosts andParams:dict andDelegate:self];
    
    
}

-(IBAction) registerPushToken:(id)sender
{

    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyToken];
    if (deviceToken == nil) {
        deviceToken = @"deviceToken";
    }

    
    /**
     * To register your device for Push Service, call the framework registerForPushWithToken method
     * and pass push token of your device.
     */
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.mWeUnite registerForPushWithToken:deviceToken];
}

-(IBAction)boardButtonPressed:(id)sender
{
    
    
    /**
     * To fetch your favorite Board Comments Posts and enable socializing, call the framework performAction method
     * and pass Board Link Key which is generated over Developer Portal.
     */
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary* dict = @{kKeyBoardLinkKey:kTestBoardId};
    [appDel.mWeUnite performAction:kActionOpenBoardKey andParams:dict andDelegate:self];
    
    
    
        NSLog(@"dict is %@",dict);
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
        self.mCreateScrapBtn.enabled = YES;
        self.mViewScrapBtn.enabled = YES;
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
