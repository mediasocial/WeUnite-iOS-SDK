//
//  WURequest.m
//  WeUniteTest
//
//  Created by Anthony Gonsalves on 23/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "AFNetworking.h"
#import "WURequest.h"
#import "WeUnite.h"
#import "WUConstants.h"

@implementation WURequest

- (id)initWithDelegate:(id)delegate 
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(void)startRequestOfType:(WURequestType)requestType delegate:(NSObject *)delegate
          successSelector:(SEL)successSel failSelector:(SEL)failSel{
   /*
    if (requestType == WURequestTypeRegistration) {
        NSURL *url = [NSURL URLWithString:@"http://weuniteapiv1.cloudapp.net/v1/authentication/auth/"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        httpClient.parameterEncoding = AFJSONParameterEncoding;
        NSDictionary *params = @{@"Developer_Token": @{@"Application_Secret": kWUAppSecretKey ,@"Application_Key": kWUAppPublicKey}};
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:params];
        AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"Success");
            
            if ([delegate respondsToSelector:successSel]) {
                [delegate performSelector:successSel withObject:JSON];
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"Failure");
            
            if ([delegate respondsToSelector:failSel]) {
                [delegate performSelector:failSel withObject:JSON];
            }
        }];
        [operation start];
    }
    */
}

@end
