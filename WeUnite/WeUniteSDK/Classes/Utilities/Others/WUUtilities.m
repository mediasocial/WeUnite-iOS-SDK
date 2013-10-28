//
//  WUUtilities.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 16/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUUtilities.h"
#import "WUConstants.h"
#import "WUConfiguration.h"
#import "SynthesizeSingleton.h"
#import "iToast.h"

@implementation WUUtilities

SYNTHESIZE_SINGLETON_FOR_CLASS(WUUtilities);

static CLLocationManager* locationManager;

+(void)flashMessage:(NSString *)message{
    
    // iToastSettings *settings = [iToastSettings getSharedSettings];
    
    [[iToast makeText:message]show];
    
    
}

+(void)flashMessage:(NSString *)message ForDuration:(int)duration
{
    
    // iToastSettings *settings = [iToastSettings getSharedSettings];
    iToast* toast = [iToast makeText:message];
    [toast setDuration:duration];
    [toast show];
    
}


+(void) findCurrentLocation
{
    
    [self releaseLocationManager];
    
    locationManager =  [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    if ([CLLocationManager locationServicesEnabled]) {
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
    }
    
    [locationManager startUpdatingLocation];
}


+(void) releaseLocationManager{
    
    if (locationManager != nil) {
        
        [locationManager stopUpdatingLocation];
        locationManager = nil;
        
    }
    
}

-(void)locationManager:(CLLocationManager *)manager     didUpdateLocation:(CLLocation *)newLocation      fromLocation:(CLLocation *)oldLocation
{
    
    if (mCurrentLocation != nil) {
        mCurrentLocation = nil;
    }
    
    mCurrentLocation = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    
    [locationManager stopUpdatingLocation];
}



-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location :%@",error);
}


-(CLLocation*) getUserLocation
{
    return mCurrentLocation;
}


#pragma mark - Decode String methods

+(NSMutableString*) decodeForString:(NSString*)str
{
    NSMutableString* strBuf = [[NSMutableString alloc] initWithString:str];
    strBuf = [self decodeString:strBuf];
    return strBuf;
}


+(NSMutableString*) decodeString:(NSMutableString*)strBuf
{
    NSRange range ;
    
    
    range.length = [strBuf length];
    range.location = 0;
    [strBuf replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSCaseInsensitiveSearch range:range];
    
    range.length = [strBuf length];
    range.location = 0;
    [strBuf replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSCaseInsensitiveSearch range:range];
    
    range.length = [strBuf length];
    range.location = 0;
    [strBuf replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSCaseInsensitiveSearch range:range];
    
    range.length = [strBuf length];
    range.location = 0;
    [strBuf replaceOccurrencesOfString:@"&apos;" withString:@"'" options:NSCaseInsensitiveSearch range:range];
    
    range.length = [strBuf length];
    range.location = 0;
    [strBuf replaceOccurrencesOfString:@"&#39;" withString:@"'" options:NSCaseInsensitiveSearch range:range];
    
    range.length = [strBuf length];
    range.location = 0;
    [strBuf replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSCaseInsensitiveSearch range:range];
    
    return strBuf;
}

+(UIImage *)imageNamed:(NSString*)filename{
    
    if (kCodeTest == NO) {
        filename = [NSString stringWithFormat:@"WeUniteSDK.framework/Versions/A/Resources/%@",filename];
    }
    return [UIImage imageNamed:filename];
}

+(NSString *)xibBundlefileName:(NSString *)filename{
    if (kCodeTest == NO ) {
        filename = [NSString stringWithFormat:@"WeUniteSDK.framework/Versions/A/Resources/%@",filename];
    }
    return filename;
}
@end
