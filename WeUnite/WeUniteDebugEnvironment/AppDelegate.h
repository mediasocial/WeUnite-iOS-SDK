//
//  AppDelegate.h
//  WeUniteDebugEnvironment
//
//  Created by Anthony Gonsalves on 26/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//


#import <WeUniteSDK/WeUniteSDK.h>

#define kKeyToken @"push_token"

#define kPassionId @"444"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    WeUnite *mWeUnite;
}

@property (strong, nonatomic) WeUnite *mWeUnite;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *viewController;

@end
