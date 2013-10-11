//
//  WUDeleteVC.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 27/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUDeleteVC.h"
#import "UIKit+Extensions.h"
#import "WUConstants.h"

@interface WUDeleteVC ()

@end

@implementation WUDeleteVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    for (UIImageView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.image = nil;
        }
    }
    [self.view removeAllSubviews];
    wuCurrentFunc();
}

@end
