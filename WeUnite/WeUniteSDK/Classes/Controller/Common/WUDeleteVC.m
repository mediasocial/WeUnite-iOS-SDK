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
#import "WUConfiguration.h"

@interface WUDeleteVC ()

@end

@implementation WUDeleteVC
@synthesize mTableView;

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
    [self.mTableView registerNib:[UINib nibWithNibName:@"WeUniteSDK.framework/Versions/A/Resources/WUPostCommentCell" bundle:nil] forCellReuseIdentifier:@"WUPostCommentCell"];
    
    UITableViewCell *cell = [self.mTableView dequeueReusableCellWithIdentifier:@"WUPostCommentCell"];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:NULL];
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
