//
//  ViewController.m
//  WeUniteTest
//
//  Created by Anthony Gonsalves on 23/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "ViewController.h"
#import <WeUniteSDK/WeUniteSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

-(void)registerSuccess:(id)JSON{
    NSLog(@"%@",JSON);
}

-(void)registerFailure:(id)JSON{
    NSLog(@"%@",JSON);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createSession:(id)sender
{
    [WURequest startRequestOfType:WURequestTypeRegistration delegate:self successSelector:@selector(registerSuccess:) failSelector:@selector(registerFailure:)];
}
@end
