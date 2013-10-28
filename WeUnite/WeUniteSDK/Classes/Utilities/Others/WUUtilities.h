//
//  WUUtilities.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 16/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <UIKit/UIKit.h>

@interface WUUtilities : NSObject <CLLocationManagerDelegate>
{
    CLLocation* mCurrentLocation;
}

+(instancetype)sharedWUUtilities;


+(void)flashMessage:(NSString *)message;
+(void)flashMessage:(NSString *)message ForDuration:(int)duration;

+(void) findCurrentLocation;
+(void) releaseLocationManager;


-(CLLocation*) getUserLocation;

+(NSMutableString*) decodeForString:(NSString*)str;

+(NSMutableString*) decodeString:(NSMutableString*)strBuf;
+(UIImage *)imageNamed:(NSString*)filename;
+(NSString *)xibBundlefileName:(NSString *)filename;
@end
