//
//  WUExtraServices.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 07/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeUnite.h"



@interface WUExtraServices : NSObject
{

}

@property(nonatomic, copy) WURequestCompletionBlock responseBlock;

+(instancetype)sharedWUExtraServices;
+(BOOL)isConnectedToInternet;
-(void)registerForPushWithToken:(NSString *)deviceToken;

-(void) initApp:(NSString*)appKey SecretKey:(NSString*)secretKey completionBlock:(WURequestCompletionBlock)completionBlock;

@end
