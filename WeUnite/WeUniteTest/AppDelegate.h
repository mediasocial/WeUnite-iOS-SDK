//
//  AppDelegate.h
//  WeUniteTest
//
//  Created by Anthony Gonsalves on 23/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WeUniteSDK/WeUniteSDK.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    WeUnite *mWeUnite;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
