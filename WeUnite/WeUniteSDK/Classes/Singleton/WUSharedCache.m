//
//  WUSharedCache.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 02/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUSharedCache.h"
#import "SynthesizeSingleton.h"
#import "WUConstants.h"
#import "WUConfiguration.h"


//User Token
#define kKeyWeUniteUserToken @"weunite_user_token"

//Constants for storing application service token and user token....
#define kKeyServiceToken @"weunite_service_token"
#define kKeyServiceTokenExpirty @"weunite_service_token_expiry"




@implementation WUSharedCache
SYNTHESIZE_SINGLETON_FOR_CLASS(WUSharedCache);

@synthesize mWeUnite;
@synthesize mWUDialog;

+(instancetype)wuSharedCache{
    return [self sharedWUSharedCache];
}

+(NSString*)getUserToken{
    NSString *userToken = [[NSUserDefaults standardUserDefaults] valueForKey:kKeyWeUniteUserToken];
    return userToken;
}


+(void)setUserToken:(NSString *)userToken{
    [[NSUserDefaults standardUserDefaults] setObject:userToken forKey:kKeyWeUniteUserToken];
}



#pragma mark - Service Token
+(NSString*)getServiceToken
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kKeyServiceToken];
}

+(void)setServiceToken:(NSString*)serviceToken
{
    [[NSUserDefaults standardUserDefaults] setObject:serviceToken forKey:kKeyServiceToken];
}


#pragma mark - Service Token Expiry Time
+(id)getServiceTokenExpiry
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kKeyServiceTokenExpirty];
}

+(void)setServiceTokenExpiry:(NSDate*)serviceTokenExpiry
{
    [[NSUserDefaults standardUserDefaults] setObject:serviceTokenExpiry forKey:kKeyServiceTokenExpirty];
}



- (void)loginWeUnite:(id<WUActionDelegate>)delegate
{
    self.mWUDialog = nil;
    
    NSString *nibName = nil;
    if (kCodeTest==NO) {
        nibName = @"WeUniteSDK.framework/Versions/A/Resources/WUDialog";
    }
    else {
        nibName = @"WUDialog";
    }
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    [self.mWUDialog show:delegate];
}


@end
