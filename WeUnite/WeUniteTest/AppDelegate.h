//
//  AppDelegate.h
//  WeUniteTest
//
//  Created by Anthony Gonsalves on 23/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeUnite;
#define kKeyToken @"push_token"

#define kPassionId @"444"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    WeUnite *mWeUnite;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WeUnite *mWeUnite;

@property (strong, nonatomic) ViewController *viewController;

@end
