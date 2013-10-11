//
//  WUExtraServices.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 07/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUExtraServices.h"
#import "SynthesizeSingleton.h"
#import "AFNetworking.h"
#import "WUSharedCache.h"
#import "WUConstants.h"
#import "WUOpenUDID.h"
#import <SystemConfiguration/SystemConfiguration.h>



static NSString* kWUURLSchemeAuthorize = @"authentication/app_auth";


/**
 *  1st parameter is the Board ID
 */
static NSString* kWUURLSchemeRegisterPushNotification = @"pushnotification";




@implementation WUExtraServices
static AFHTTPClient *zAFHTTPClient = nil;
@synthesize responseBlock;

SYNTHESIZE_SINGLETON_FOR_CLASS(WUExtraServices);

+(void)initialize{
    if (zAFHTTPClient == nil) {
        NSString *urlString = @"http://www.google.com/";
        zAFHTTPClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    }
}

+(BOOL)isConnectedToInternet{
    if (zAFHTTPClient.networkReachabilityStatus == AFNetworkReachabilityStatusUnknown          ||
        zAFHTTPClient.networkReachabilityStatus     == 0) {
        return NO;
    }
    return YES;
}


-(void)registerForPushWithToken:(NSString *)deviceToken
{
    WeUnite *weUnite = [WUSharedCache wuSharedCache].mWeUnite;
    
    NSString *urlScheme = [NSString stringWithString:kWUURLSchemeRegisterPushNotification];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kWUMainURL,urlScheme];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    NSString *deviceID = [WUOpenUDID value];
    
    NSDictionary *params = @{ @"Apple_Device_Token":@{
                                      @"Device_Id":deviceID,
                                      @"Device_Token": deviceToken }
                              };
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:nil parameters:params];
    [request setValue:weUnite.mAccessToken forHTTPHeaderField:@"service_token"];
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
     //   NSLog(@"Success %@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    //    NSLog(@"Failure");
    }];
    [operation start];
}



/**
 * Initialize the applicaiton key and gets service token from server.
 */

-(void) initApp:(NSString*)appKey SecretKey:(NSString*)secretKey
                    completionBlock:(WURequestCompletionBlock)completionBlock
{
    
    self.responseBlock = completionBlock;
    
    
    NSURL *url = [NSURL URLWithString:kWUMainURL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    
    NSDictionary *params = @{@"Developer_Token": @{@"Application_Secret":secretKey ,@"Application_Key": appKey}};
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:kWUURLSchemeAuthorize parameters:params];
    
    NSLog(@"reqeust si %@",request);
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest*request, NSHTTPURLResponse *response, id JSON) {
        
    //    NSLog(@"Success ");
        
        NSDictionary *responseDict = (NSDictionary *)JSON;
        NSDictionary *tokenInfo = responseDict[@"Application_Token"];
        
        self.responseBlock(tokenInfo, nil);
        
        self.responseBlock = nil;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure");
        self.responseBlock(nil, error);
        self.responseBlock = nil;
    }];
    
    [operation start];
    
}

@end
