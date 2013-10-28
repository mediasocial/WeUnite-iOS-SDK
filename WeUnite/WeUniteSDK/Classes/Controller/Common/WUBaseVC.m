//
//  WUBaseVC.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 25/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUBaseVC.h"
#import "UIKit+Extensions.h"
@interface WUBaseVC ()

@end

@implementation WUBaseVC
@synthesize mBaseView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)copyBasicPropertiesOfView:(UIView *)tView{
    //TODO: implement this
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    mBGImageView.image = [WUUtilities imageNamed:@"backgroundPlain.png"];
    mToolBarImageView.image = [WUUtilities imageNamed:@"toolbar.png"];
    [mBackButton setBackgroundImage:[WUUtilities imageNamed:@"backNav.png"] forState:UIControlStateNormal];
    
  //  CGRect frame = [[UIScreen mainScreen] applicationFrame];
    self.mBaseView = self.view;
    return;
    [self alignUI];
   /*
    UIView *baseView = [[UIView alloc] initWithFrame:frame];
    UIView *selfView = self.view;
    self.view = baseView;
    
    self.mBaseView = selfView;
    self.mBaseView.top = 20;
    [self.view addSubview:self.mBaseView];*/
}

-(void)alignUI
{
    __weak WUBaseVC *weakSelf = self;
    double delayInSeconds = 1/60.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        return ;
        CGRect frame = [[UIScreen mainScreen] applicationFrame];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {                      UIView *baseView = [[UIView alloc] initWithFrame:frame];
            UIView *selfView = weakSelf.view;
            
            weakSelf.view = baseView;
            for (UIView *view in selfView.subviews) {
                [view removeFromSuperview];
                [baseView addSubview:view];
            }

            weakSelf.mBaseView = baseView;
            weakSelf.mBaseView.top = 20;
            weakSelf.mBaseView.height = frame.size.height-20;
            [weakSelf.view addSubview:weakSelf.mBaseView];
            
         //   UIApplication *application = [UIApplication sharedApplication];
          //  application.statusBarStyle = UIStatusBarStyleLightContent;
            UIView *addStatusBar = [[UIView alloc] init];
            addStatusBar.frame = CGRectMake(0, 0, frame.size.width, 20);
            addStatusBar.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1]; //change this to match your navigation bar
            addStatusBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
            [weakSelf.view addSubview:addStatusBar];
        }else{
            weakSelf.mBaseView = weakSelf.view;
        }
    });
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
