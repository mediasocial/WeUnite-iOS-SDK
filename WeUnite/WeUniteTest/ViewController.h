//
//  ViewController.h
//  WeUniteTest
//
//  Created by Anthony Gonsalves on 23/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WeUniteSDK/WeUniteSDK.h>

@interface ViewController : UIViewController<WUSessionDelegate>
{
    WeUnite *mWeUnite;
}
-(IBAction)createSessionButtonPressed:(id)sender;
-(IBAction)getCommentButtonPressed:(id)sender;

@end
