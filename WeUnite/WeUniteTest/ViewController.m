//
//  ViewController.m
//  WeUniteTest
//
//  Created by Anthony Gonsalves on 23/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}



-(IBAction)createSessionButtonPressed:(id)sender{
    mWeUnite = [[WeUnite alloc] initWithAppKey:@"201506049871774" secretKey:@"ea4d531e2a62c19c97ffefd2017e71fd" andDelegate:self];
}

-(IBAction)getCommentButtonPressed:(id)sender{
   
    
//    [mWeUnite getCommentsForPassionID:kPassionId completionBlock:^(id JSON, NSError *error) {
//        NSLog(@"%@,%@",JSON,error);
//    }];
}

//WUSessionDelegate
- (void)wuLogin:(BOOL)success{
    NSString *successStatus = success?@"Success":@"Failure";
    NSLog(@"%@",successStatus);
}

- (void)wuDidLogout{
    NSLog(@"%@",@"logOut");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
