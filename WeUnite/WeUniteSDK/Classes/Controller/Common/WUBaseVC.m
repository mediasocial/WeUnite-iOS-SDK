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
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    
    
    
    UIView *baseView = [[UIView alloc] initWithFrame:frame];
    UIView *selfView = self.view;
    self.view = baseView;
    
    self.mBaseView = selfView;
    self.mBaseView.top = 20;
    [self.view addSubview:self.mBaseView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
