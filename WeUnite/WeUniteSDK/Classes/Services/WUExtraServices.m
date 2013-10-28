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
#import "AFHTTPClient.h"
#import "WUSharedCache.h"
#import "WUConstants.h"
#import "WUOpenUDID.h"
#import "WUUtilities.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Foundation+Extensions.h"
#import "UIKit+Extensions.h"
#import "WUConfiguration.h"

#import "WUDialog.h"

static NSString* kWUURLSchemeAuthorize = @"authentication/app_auth";


/**
 *  1st parameter is the Board ID
 */
static NSString* kWUURLSchemeRegisterPushNotification = @"pushnotification";


/**
 *  1st parameter is board link ID
 */
static NSString* kWUURLSchemeCreateScrapForBoardLink = @"scrap/%@/pin";

/**
 *  1st parameter is boardID
 *  2nd parameter is appId
 *  ---------->3rd parameter is type(Here it is Scrap, hardcoded)
 *  3th parameter is limit
 *  4th parameter is offset
 */
static NSString* kWUURLSchemeScrapPostsForBoardLink = @"category/%@?appId=%@&type=Scrap&limit=%d&offset=%d&sortBy=Created_Date";


@interface WUExtraServices (){
    
}
@property (nonatomic,weak)IBOutlet WUDialog *mWUDialog;
@end


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
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kWUMainURL,kWUURLSchemeAuthorize];
    NSLog(@"url string is %@",urlString);
    NSURL *url = [NSURL URLWithString:kWUMainURL];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.allowsInvalidSSLCertificate = YES;
    httpClient.defaultSSLPinningMode = AFSSLPinningModePublicKey;
    httpClient.parameterEncoding = AFJSONParameterEncoding;

    
    
    NSDictionary *params = @{@"Developer_Token": @{@"Application_Secret":secretKey ,@"Application_Key": appKey}};

    //[httpClient setValue:@"application/json" forKey:@"Content-Type"];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:kWUURLSchemeAuthorize parameters:params];
    
  
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    

    
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
    
    /*
    operation.shouldUseCredentialStorage = YES;
    [operation setWillSendRequestForAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge) {
        NSURL *mainURL = [NSURL URLWithString:kWUMainURL];
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
            if ([mainURL.host isEqualToString:challenge.protectionSpace.host])
                [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }];
    */
}


-(void)createScrapForBoardLinkID:(NSString *)boardLinkID
                 memberID:(NSString *)memberID
                imageURL:(NSString *)imageURLString
                title:(NSString *)title
        description:(NSString *)desc completionBlock:(WURequestCompletionBlock)completionBlock{
    
    self.responseBlock = completionBlock;
    
    NSString *urlScheme = [NSString stringWithFormat:kWUURLSchemeCreateScrapForBoardLink,boardLinkID];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kWUMainURL,urlScheme];
    WeUnite *weUnite = [[WUSharedCache wuSharedCache] mWeUnite];

    NSURL *url = [NSURL URLWithString:urlString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    
    if (boardLinkID.length == 0) {
        boardLinkID = @"";
            }
    if (imageURLString.length == 0){
        imageURLString = @"";
    }
    if (title.length == 0){
        title = @"";
    }
    if (desc.length == 0) {
        desc = @"";
    }
    if (memberID.length == 0) {
        memberID = @"";
    }
    
    CLLocation* location = [[WUUtilities sharedWUUtilities] getUserLocation];
    NSString* latitude = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
    NSString* longitude = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];
    
    NSString *imageExt = [imageURLString.lastPathComponent.pathExtension lowercaseString];
    NSString *imageType = [NSString stringWithFormat:@"image/%@",imageExt];
    
    
    NSDictionary *params = nil;
    params = @{
               @"Member_Token": memberID,
               @"Title": title,
               @"Description": desc,
               @"Image_Link": imageURLString,
               @"Image_Type": imageType,
               @"Longitude": latitude,
               @"Latitude": longitude,
               @"Image": @{
                       @"Name": @"",
                       @"Content": @"",
                       @"Content_Type": @""
                       }
               };
    
  
    NSLog(@"PostData %@",params);
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:nil parameters:params];
    [request setValue:weUnite.mAccessToken forHTTPHeaderField:@"service_token"];
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest*request, NSHTTPURLResponse *response, id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            NSDictionary *reponseDict = (NSDictionary *)JSON;
            int statusCode = [reponseDict[@"Data"][@"Status"] integerValue];
           
            if(statusCode != 1){
                NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:response.statusCode userInfo:nil];
                if (self.responseBlock != nil)
                    self.responseBlock(JSON,error);
            }
            else{
                if (self.responseBlock != nil)
                    self.responseBlock(JSON,nil);
            }
        }
        else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:response.statusCode userInfo:nil];
            if (self.responseBlock != nil)
                self.responseBlock(nil,error);
        }
        if (self.responseBlock != nil)
            self.responseBlock = nil;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure");
        if(self.responseBlock)
            self.responseBlock(nil, error);
        self.responseBlock = nil;
    }];
    
    [operation start];

    
}

+ (void)loginWeUnite:(id<WUActionDelegate>)delegate
{
    WUExtraServices *es = [self sharedWUExtraServices];
    es.mWUDialog = nil;
    
    NSString *nibName = nil;
    if (kCodeTest==NO) {
        nibName = @"WeUniteSDK.framework/Versions/A/Resources/WUDialog";
    }
    else {
        nibName = @"WUDialog";
    }
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    [nib instantiateWithOwner:es options:nil];
    [es.mWUDialog show:delegate];
}
@end
