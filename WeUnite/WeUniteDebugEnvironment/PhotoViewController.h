//
//  PhotoViewController.h
//  WeUnite
//
//  Created by Adeesh Jain on 16/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeUnite.h"

@interface PhotoViewController : UIViewController <WUActionDelegate>


- (IBAction)weUniteSharePressed:(id)sender;
- (IBAction)backPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView1;

@end
