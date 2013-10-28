//
//  WUSharedCache.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 02/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeUnite.h"
#import "WUDialog.h"

@interface WUSharedCache : NSObject{
    __weak WeUnite *mWeUnite;
}

@property (nonatomic,weak) WeUnite *mWeUnite;
@property (nonatomic,weak)IBOutlet WUDialog *mWUDialog;

+(instancetype)wuSharedCache;

+(NSString*)getUserToken;
+(void)setUserToken:(NSString *)token;


+(id)getServiceTokenExpiry;
+(void)setServiceTokenExpiry:(NSDate*)serviceTokenExpiry;

+(void)setServiceToken:(NSString*)serviceToken;
+(NSString*)getServiceToken;

- (void)loginWeUnite:(id<WUActionDelegate>)delegate;

@end
