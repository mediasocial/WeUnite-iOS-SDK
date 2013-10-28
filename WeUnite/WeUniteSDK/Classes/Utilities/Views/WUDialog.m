//
//  WUDialog.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 03/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUDialog.h"
#import "WUUtilities.h"
#import "WUConstants.h"

#import "UIKit+Extensions.h"
#import "Foundation+Extensions.h"

#import "WUSharedCache.h"
#import "WUConfiguration.h"
#import <QuartzCore/QuartzCore.h>

@interface WUDialog(){
    IBOutlet UIActivityIndicatorView *mActivityView;
    IBOutlet UIButton *mCloseButton;
    id<WUActionDelegate> mWUDelegate;
}

@end

@implementation WUDialog


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



-(void)show :(id<WUActionDelegate>)delegate
{
    UIImage *closeImage = [WUUtilities imageNamed:@"close.png"];
    [mCloseButton setBackgroundImage:closeImage forState:UIControlStateNormal];
    mWUDelegate = delegate;
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    UIScreen *screen = [UIScreen mainScreen];
    self.center = window.center;
    self.frame =  screen.applicationFrame;
    [window addSubview:self];
    
    // self.transform = [self transformForOrientation];
    [self paint];
    [self loadWebView];
    
    [self launchDialogAnimation];
}




- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillHideNotification" object:nil];
}

-(void)launchDialogAnimation{
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

-(void)dismissDialogAnimation{
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


-(void)paint{
    self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6];
    mContainerView.layer.cornerRadius = 5.0f;
    mContainerView.layer.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8] CGColor];
}


-(void)loadWebView{
    WUSharedCache *sharedCache = [WUSharedCache wuSharedCache];
    WeUnite *weUnite = sharedCache.mWeUnite;
    
    NSString *placeholderString = @"%@?macaddr=121212&platform=iphone&appversion=v1.0&appkey=%@&secretkey=%@&accesstoken=%@" ;
    
    NSString *loginURLString = [NSString stringWithFormat:placeholderString,kWeUniteSiteURL, weUnite.mAppKey,weUnite.mAppSecretKey,weUnite.mAccessToken];
    
    NSLog(@" login url string is %@",loginURLString);
    
    
    [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loginURLString]]];
}


-(IBAction)closePressed:(id)sender {
    [self dismissDialogAnimation];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    if ([request.URL.absoluteString hasPrefix:@"weunitelogin://"]) {
        
        //NSLog(@"%@",request);
        NSString *userToken = nil, *userExpiryDate = nil;
        NSString *tokenNexpiryDate = [request.URL.absoluteString substringFromIndex:15];
        NSArray *components = [tokenNexpiryDate componentsSeparatedByString:@"&"];
        userToken = components[0];
        userExpiryDate = components[1];
        
        components = [userToken componentsSeparatedByString:@"="];
        userToken = components[1];
        
        NSLog(@"user token is %@",userToken);
        
        [WUSharedCache setUserToken:userToken];
       
        
        [self dismissDialogAnimation];
        

        if (mWUDelegate != nil && [mWUDelegate respondsToSelector:@selector(wuActionResponse:params:)]) {
            
            NSDictionary* dict = @{kResponseActionKey:kActionLoginKey};
            [mWUDelegate wuActionResponse:YES params:dict];
            dict = nil;
        }
        

        return NO;
    }
    
    return YES;
}




- (void)webViewDidStartLoad:(UIWebView *)webView{
    [mActivityView startAnimating];
}




- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [mActivityView stopAnimating];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [mActivityView stopAnimating];
    NSLog(@"didFailLoadWithError %@",error);
  //  [UIAlertView showAlertMessage:error.localizedDescription];
}




- (CGAffineTransform)transformForOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

- (void)deviceOrientationDidChange:(void*)object {
    self.transform = [self transformForOrientation];
}

- (void)dealloc
{
    [mWebView stopLoading];
    [self removeAllSubviews];
}
@end
