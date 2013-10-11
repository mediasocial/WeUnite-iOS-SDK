//
//  InAppBrowserVC.m
//  DonutFrenzyC2
//
//  Created by Anthony Gonsalves on 13/03/13.
//
//

#import "InAppBrowserVC.h"
#import "AppDelegate.h"

@interface InAppBrowserVC ()

@end

@implementation InAppBrowserVC

@synthesize mURLString;
@synthesize mTitleItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    mInAppWebView.delegate = nil;
    [mInAppWebView removeFromSuperview];
    //[mInAppWebView release];
    //[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    //[super viewWillAppear:animated];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.mURLString]];
    [mInAppWebView loadRequest:request];
    
    mTitleItem.text = @"WeUnite";
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doneItemPressed:(id)sender{

    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    [mLoadingActivity startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    [mLoadingActivity stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
        NSLog(@"didFailLoadWithError");
    [mLoadingActivity stopAnimating];
    //[UIAlertView showAlertMessage:@"No Internet"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString hasPrefix:@"https://itunes.apple.com/"]) {
        [[UIApplication sharedApplication]openURL:request.URL];
        return NO;
    }

    [mLoadingActivity startAnimating];
    
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
