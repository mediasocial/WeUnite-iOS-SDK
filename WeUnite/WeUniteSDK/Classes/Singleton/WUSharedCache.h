//
//  WUSharedCache.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 02/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeUnite.h"

@interface WUSharedCache : NSObject{
    __weak WeUnite *mWeUnite;
}
@property (nonatomic,weak) WeUnite *mWeUnite;
+(instancetype)wuSharedCache;

+(NSString*)getUserToken;
+(void)setUserToken:(NSString *)token;


+(id)getServiceTokenExpiry;
+(void)setServiceTokenExpiry:(NSDate*)serviceTokenExpiry;

+(void)setServiceToken:(NSString*)serviceToken;
+(NSString*)getServiceToken;

@end
