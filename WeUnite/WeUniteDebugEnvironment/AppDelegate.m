//
//  AppDelegate.m
//  WeUniteDebugEnvironment
//
//  Created by Anthony Gonsalves on 26/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "UIKit+Extensions.h"

@implementation AppDelegate
@synthesize mWeUnite;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setAppearanceSchemes];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    
    ViewController *tViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:tViewController];
    navCon.navigationBarHidden = YES;
    self.window.rootViewController = navCon;
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)setAppearanceSchemes{
   // [[UIToolbar appearance] setTintColor:[UIColor colorForHex:@"#EF6535"]];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}






#pragma mark -
#pragma mark Push Notification delegate methods start




- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	NSString *mDeviceToken = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
	
    NSLog(@"device token is %@",mDeviceToken);
    // [UIAlertView showAlertMessage:mDeviceToken];
    
	NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
	[ud setObject:mDeviceToken forKey:kKeyToken];
	[ud synchronize];
	
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    /*
     [UIAlertView showAlertMessage:@"Fail to register token for push notification."];
     */
}



- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)userInfo{
    [self application:application didReceiveRemoteNotification:userInfo.userInfo];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	NSLog(@"aps = %@",[userInfo valueForKey:@"aps"]);
    
    NSString *pushMessage = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    [UIAlertView showAlertMessage:pushMessage];
    
    
    
    
}





@end
