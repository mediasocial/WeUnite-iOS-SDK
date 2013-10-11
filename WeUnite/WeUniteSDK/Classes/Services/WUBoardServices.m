//
//  WUBoardServices.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 09/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUBoardServices.h"
#import "SynthesizeSingleton.h"
#import "AFNetworking.h"
#import "WUSharedCache.h"
#import "WUConstants.h"
#import "Base64.h"
#import <SystemConfiguration/SystemConfiguration.h>

#import "WUUtilities.h"
#import "WUExtraServices.h"
#import "UIKit+Extensions.h"
#import "Foundation+Extensions.h"
/**
 *  first parameter is the Board ID
 *  2nd parameter is the limit
 *  3rd parameter is the offset
 */
static NSString* kWUURLSchemeBoardPins = @"board/%@/pin?type=full&limit=%d&offset=%d";


/**
 *  first parameter is the Board ID
 */
static NSString* kWUURLSchemeBoardInfo = @"/board/%@/?type=regular";



/**
 *  first parameter is the Pin ID
 *  2nd parameter is the limit
 *  3rd parameter is the offset
 */
static NSString* kWUURLSchemePinComments = @"pin/%@/comment?limit=%d&offset=%d";

/**
 *  1st parameter is the Pin ID
 */
static NSString* kWUURLSchemePostPinComment = @"pin/%@/comment";

/**
 *  1st parameter is the Pin ID
 */
static NSString* kWUURLSchemeLikePin = @"pin/%@/like";

/**
 *  1st parameter is the Board ID
 */
static NSString* kWUURLSchemeNewPin = @"board/%@/pin";


/**
 *  1st parameter is the pin ID
 *  Description - To get the info of the pinID
 */
static NSString* kWUURLSchemePinInfo = @"pin/%@/view_count";


//TODO -  WURequestCompletionBlock boardServiceRB to all individual blocks
@interface WUBoardServices()
@property (nonatomic,copy) WURequestCompletionBlock boardServiceResponseBlock;
@property (nonatomic,copy) WURequestCompletionBlock boardInfoServiceResponseBlock;

@property (nonatomic,copy) WURequestCompletionBlock boardPinsResponseBlock;

@end

@implementation WUBoardServices
SYNTHESIZE_SINGLETON_FOR_CLASS(WUBoardServices);


#pragma mark - Fetch Comments For Pin

- (void)getCommentsForPinID:(NSString *)pinID completionBlock:(WURequestCompletionBlock)completionBlock
{
    WUSharedCache *sharedCache = [WUSharedCache wuSharedCache];
    WeUnite *weUnite = sharedCache.mWeUnite;

    if ([WUExtraServices isConnectedToInternet] == NO) {
        [UIAlertView showAlertMessage:@""];
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
        
        if(self.boardServiceResponseBlock)
            self.boardServiceResponseBlock(nil,error);
        
        self.boardServiceResponseBlock = nil;
        return;
    }
    
    self.boardServiceResponseBlock = completionBlock;
    
    
    
    

    NSString *urlScheme = [NSString stringWithFormat:kWUURLSchemePinComments,pinID,15,0];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kWUMainURL,urlScheme];
    

    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:weUnite.mAccessToken forHTTPHeaderField:@"service_token"];
    
    NSLog(@"request is %@",request);
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        id jsonResponse =  JSON[@"Pin"][@"Comments"][@"Comment"];
        
        NSLog(@"response dict is %@",jsonResponse);
        
        if (jsonResponse != nil) {
            if ([jsonResponse isKindOfClass:[NSArray class]]) {
                jsonResponse = [(NSArray*)jsonResponse arrayByReplacingNullWithValue:@""];
            }
            else if([jsonResponse isKindOfClass:[NSDictionary class]]){
                jsonResponse = [(NSDictionary*)jsonResponse dictionaryByReplacingNullWithValue:@""];
            }
            
            if (self.boardServiceResponseBlock)
                self.boardServiceResponseBlock(jsonResponse ,nil);
         
            self.boardServiceResponseBlock = nil;
        }
        
        else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
            
            if(self.boardServiceResponseBlock)
                self.boardServiceResponseBlock(nil,error);
            
            self.boardServiceResponseBlock = nil;
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure");
        if(self.boardServiceResponseBlock)
            self.boardServiceResponseBlock(JSON,error);
        
        self.boardInfoServiceResponseBlock = nil;
    }];
    [operation start];
}








#pragma mark - Post Comment On Pin

/**
 * Post Comment Over Board Pin
 *
 */
- (void)comment:(NSString *)commentText pinId:(NSString *)pinId ForMember:(NSString *)memberToken completionBlock:(WURequestCompletionBlock)completionBlock
{
    
    if (commentText==nil) {
        commentText = @"";
    }

    self.boardServiceResponseBlock = completionBlock;
    
    if ([WUExtraServices isConnectedToInternet] == NO) {
        [UIAlertView showAlertMessage:@""];
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
        
        if(self.boardServiceResponseBlock)
            self.boardServiceResponseBlock(nil,error);
        
        self.boardServiceResponseBlock = nil;
        return;
    }
    

    
    if ([WUExtraServices isConnectedToInternet] == NO) {
        [UIAlertView showAlertMessage:@""];
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
        
        if(self.boardServiceResponseBlock)
            self.boardServiceResponseBlock(nil,error);
        
        self.boardServiceResponseBlock = nil;
        return;
    }
    


    WeUnite *weUnite = [WUSharedCache wuSharedCache].mWeUnite;
    
    NSString *urlScheme = [NSString stringWithFormat:kWUURLSchemePostPinComment,pinId];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kWUMainURL,urlScheme];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    
    CLLocation* location = [[WUUtilities sharedWUUtilities] getUserLocation];
    NSString* latitude = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
    NSString* longitude = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];
    NSLog(@"lat %@, long %@",latitude, longitude);
   
    NSDictionary *params = @{@"Data": @{    @"Member_Access_Token": memberToken,
                                            @"Message": commentText,
                                            @"Photo_Url": @"",
                                            @"Longitude":longitude,
                                            @"Latitude":latitude,
                                        }
                             };
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:nil parameters:params];
    [request setValue:weUnite.mAccessToken forHTTPHeaderField:@"service_token"];
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
       // NSLog(@"Success %@",JSON);
        NSDictionary *responseDict = nil;
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            responseDict = [(NSDictionary *)JSON dictionaryByReplacingNullWithValue:@""];
            self.boardServiceResponseBlock(JSON,nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:response.statusCode userInfo:nil];
            self.boardServiceResponseBlock(nil,error);
        }
         self.boardServiceResponseBlock = nil;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure");
        self.boardServiceResponseBlock(JSON,error);
        self.boardServiceResponseBlock = nil;
    }];
    [operation start];
    
}


#pragma mark - Like Pin

/**
 * Like Pin
 *
 */
-(void)likePin:(NSString*)pinID likeStatus:(BOOL)yesOrNo completionBlock:(WURequestCompletionBlock)completionBlock{
    
    self.boardServiceResponseBlock = completionBlock;
    
    
    if ([WUExtraServices isConnectedToInternet] == NO) {
        [UIAlertView showAlertMessage:@""];
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
        
        if(self.boardServiceResponseBlock)
            self.boardServiceResponseBlock(nil,error);
        
        self.boardServiceResponseBlock = nil;
        return;
    }
    

    
    WeUnite *weUnite = [WUSharedCache wuSharedCache].mWeUnite;
    
    NSString *urlScheme = [NSString stringWithFormat:kWUURLSchemeLikePin,pinID];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kWUMainURL,urlScheme];
    NSString *memberToken = [WUSharedCache getUserToken];
    NSString *likeStatus = (yesOrNo)?@"1":@"0";
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    
    CLLocation* location = [[WUUtilities sharedWUUtilities] getUserLocation];
    NSString* latitude = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
    NSString* longitude = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];
    NSLog(@"lat %@, long %@",latitude, longitude);
    
    
    NSDictionary *params = @{@"Data": @{@"Member_Access_Token": memberToken,
                                        @"Like_Status": likeStatus,
                                        @"Longitude":longitude,
                                        @"Latitude":latitude,
                                        }
                             };
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:nil parameters:params];
    [request setValue:weUnite.mAccessToken forHTTPHeaderField:@"service_token"];
    __weak WURequestCompletionBlock block = self.boardServiceResponseBlock;
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
     
        NSDictionary *responseDict = nil;
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            responseDict = [(NSDictionary *)JSON dictionaryByReplacingNullWithValue:@""];
            block(responseDict,nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:response.statusCode userInfo:nil];
            block(nil,error);
        }
        self.boardServiceResponseBlock = nil;

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure");
        self.boardServiceResponseBlock(JSON,error);
        self.boardServiceResponseBlock = nil;
    }];
    [operation start];

}




#pragma mark - Create New Pin

/**
 * Create New Pin
 *
 */
- (void)createPinForBoardID:(NSString *)boardId memberID:(NSString *)memberID pinProperties:(NSDictionary*)pinProperties completionBlock:(WURequestCompletionBlock)completionBlock{
    
    self.boardServiceResponseBlock = completionBlock;
    
    if ([WUExtraServices isConnectedToInternet] == NO) {
        [UIAlertView showAlertMessage:@""];
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
        
        if(self.boardServiceResponseBlock)
            self.boardServiceResponseBlock(nil,error);
        
        self.boardServiceResponseBlock = nil;
        return;
    }

    WeUnite *weUnite = [WUSharedCache wuSharedCache].mWeUnite;
    
    NSString *urlScheme = [NSString stringWithFormat:kWUURLSchemeNewPin,boardId];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kWUMainURL,urlScheme];
    NSLog(@"create new pin url is %@",urlString);
   // NSLog(@"pinProperties %@",pinProperties);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    
    
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:nil parameters:pinProperties];
    [request setValue:weUnite.mAccessToken forHTTPHeaderField:@"service_token"];
    [request setValue:memberID forHTTPHeaderField:@"user_token"];
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"create Pin is Success %@",JSON);
        NSDictionary *responseDict = nil;
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            responseDict = [(NSDictionary *)JSON dictionaryByReplacingNullWithValue:@""];
            self.boardServiceResponseBlock(responseDict,nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:response.statusCode userInfo:nil];
            self.boardServiceResponseBlock(nil,error);
        }
        self.boardServiceResponseBlock = nil;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure");
        self.boardServiceResponseBlock(JSON,error);
        self.boardServiceResponseBlock = nil;
    }];
    [operation start];
    
}









- (void)getPinInfoForPinID:(NSString *)pinID completionBlock:(WURequestCompletionBlock)completionBlock{
  
    WUSharedCache *sharedCache = [WUSharedCache wuSharedCache];
    WeUnite *weUnite = sharedCache.mWeUnite;
    
    self.boardServiceResponseBlock = completionBlock;
    if ([WUExtraServices isConnectedToInternet] == NO) {
        [UIAlertView showAlertMessage:@""];
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
        
        if(self.boardServiceResponseBlock)
            self.boardServiceResponseBlock(nil,error);
        
        self.boardServiceResponseBlock = nil;
        return;
    }

    
    NSString *urlScheme = [NSString stringWithFormat:kWUURLSchemePinInfo,pinID];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kWUMainURL,urlScheme];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:weUnite.mAccessToken forHTTPHeaderField:@"service_token"];
    
    NSLog(@"request is %@",request);
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        id jsonResponse =  JSON[@"Pin"][@"Pin_Info"];
        if ([jsonResponse isKindOfClass:[NSArray class]]) {
            jsonResponse = [(NSArray*)jsonResponse arrayByReplacingNullWithValue:@""];
        }
        else if([jsonResponse isKindOfClass:[NSDictionary class]]){
            jsonResponse = [(NSDictionary*)jsonResponse dictionaryByReplacingNullWithValue:@""];
        }

        NSLog(@"response dict is %@",jsonResponse);
        if (jsonResponse != nil) {
            if (self.boardServiceResponseBlock)
                self.boardServiceResponseBlock(jsonResponse ,nil);
            self.boardServiceResponseBlock = nil;
        }
        
        else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
            if(self.boardServiceResponseBlock)
                self.boardServiceResponseBlock(nil,error);
            self.boardServiceResponseBlock = nil;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure");
        if(self.boardServiceResponseBlock)
            self.boardServiceResponseBlock(JSON,error);
        self.boardServiceResponseBlock = nil;
    }];
    [operation start];
}



-(void)getBoardInfoForBoardID:(NSString *)boardID completionBlock:(WURequestCompletionBlock)completionBlock
{
    
    NSString* mAccessToken = [WUSharedCache getServiceToken];
    self.boardInfoServiceResponseBlock = completionBlock;
    if ([WUExtraServices isConnectedToInternet] == NO) {
        [UIAlertView showAlertMessage:@""];
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
        
        if(self.boardServiceResponseBlock)
            self.boardServiceResponseBlock(nil,error);
        
        self.boardServiceResponseBlock = nil;
        return;
    }

     
    NSString *scheme = [NSString stringWithFormat:kWUURLSchemeBoardInfo,boardID];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kWUMainURL,scheme];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:mAccessToken forHTTPHeaderField:@"service_token"];
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
       // NSLog(@"Success %@",JSON);
        
        NSDictionary *responseDict = [(NSDictionary *)JSON valueForKey:@"Board"];
        if ([responseDict isKindOfClass:[NSDictionary class]]) {
            responseDict = [responseDict dictionaryByReplacingNullWithValue:@""];
            if (self.boardInfoServiceResponseBlock)
                self.boardInfoServiceResponseBlock(responseDict,nil);
            self.boardInfoServiceResponseBlock = nil;

        }
        
        else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
            
            if(self.boardInfoServiceResponseBlock)
                self.boardInfoServiceResponseBlock(nil,error);
            self.boardInfoServiceResponseBlock = nil;

        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure");
        if(self.boardInfoServiceResponseBlock)
            self.boardInfoServiceResponseBlock(JSON,error);
        self.boardInfoServiceResponseBlock = nil;

    }];
    [operation start];
    
}



- (void)getBoardPinsForBoardID:(NSString *)boardID offset:(NSInteger)offset limit:(NSInteger)limit completionBlock:(WURequestCompletionBlock)completionBlock
{
    
    NSString* mAccessToken = [WUSharedCache getServiceToken];
    NSLog(@"access token is %@",mAccessToken);
    
    self.boardPinsResponseBlock = completionBlock;
    
    if ([WUExtraServices isConnectedToInternet] == NO) {
        [UIAlertView showAlertMessage:@""];
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
        
        if(self.boardServiceResponseBlock)
            self.boardServiceResponseBlock(nil,error);
        
        self.boardServiceResponseBlock = nil;
        return;
    }
    
    NSString *urlScheme = [NSString stringWithFormat:kWUURLSchemeBoardPins,boardID,limit , offset];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kWUMainURL,urlScheme];
    NSLog(@"url string is %@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:mAccessToken forHTTPHeaderField:@"service_token"];
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        
        NSLog(@"response code is %d",response.statusCode);
       // NSLog(@"Success %@",JSON);
        
        NSDictionary *responseDict = [(NSDictionary *)JSON valueForKey:@"Board"];
        if ([responseDict isKindOfClass:[NSDictionary class]]) {
            responseDict = [responseDict dictionaryByReplacingNullWithValue:@""];
            if (self.boardPinsResponseBlock)
                self.boardPinsResponseBlock(JSON ,nil);
            self.boardPinsResponseBlock  = nil;
        }
        
        else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
            
            if(self.boardPinsResponseBlock)
                self.boardPinsResponseBlock(nil,error);
            self.boardPinsResponseBlock = nil;
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure");
        if(self.boardPinsResponseBlock)
            self.boardPinsResponseBlock(JSON,error);
        self.boardPinsResponseBlock = nil;
    }];
    [operation start];
}


@end
