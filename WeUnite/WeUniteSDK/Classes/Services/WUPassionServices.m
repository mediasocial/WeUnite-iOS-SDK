//
//  WUPassionServices.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 16/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUPassionServices.h"
#import "SynthesizeSingleton.h"
#import "AFNetworking.h"
#import "WUSharedCache.h"
#import "WUConstants.h"
#import "WUUtilities.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Foundation+Extensions.h"
/**
 *  1st parameter is the pin ID
 *  Description - To get the info of the pinID
 */
static NSString* kWUURLSchemePassionAllBoards = @"passion/%@/board";

/**
 *  first parameter is the passion ID
 */
static NSString* kWUURLSchemePassionPost = @"/passion/%@/post";


static NSString* kWUURLSchemePassionInfo = @"/passion/%@";


static NSString* kWUURLSchemePassionPostLike = @"/post/%@/like";

@interface WUPassionServices() {
    AFHTTPClient *mAFHTTPClient;
}
@property (nonatomic, copy) WURequestCompletionBlock boardServiceResponseBlock;
@property (nonatomic, copy) WURequestCompletionBlock passionPostBlock;
@property (nonatomic, copy) WURequestCompletionBlock passionPostCompletionBlock;
@end


@implementation WUPassionServices

SYNTHESIZE_SINGLETON_FOR_CLASS(WUPassionServices)

-(void) getPassionInfoForID:(NSString *)passionID completionBlock:(WURequestCompletionBlock)completionBlock{
    self.boardServiceResponseBlock = completionBlock;
    WUSharedCache *sharedCache = [WUSharedCache wuSharedCache];
    WeUnite *weUnite = sharedCache.mWeUnite;

    NSString *urlScheme = [NSString stringWithFormat:kWUURLSchemePassionInfo,passionID];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kWUMainURL,urlScheme];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:weUnite.mAccessToken forHTTPHeaderField:@"service_token"];
    
    NSLog(@"request is %@",request);
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        id jsonResponse =  JSON;
        if (jsonResponse != nil) {
            
            if (self.boardServiceResponseBlock)
                self.boardServiceResponseBlock(jsonResponse ,nil);
            
        }
        
        else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
            
            if(self.boardServiceResponseBlock)
                self.boardServiceResponseBlock(nil,error);
        }
        
        self.boardServiceResponseBlock = nil;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure");
        if(self.boardServiceResponseBlock)
            self.boardServiceResponseBlock(JSON,error);
        
        self.boardServiceResponseBlock = nil;
    }];
    
    [operation start];

}

/**
 * Get all boards under Passion
 * @param passionID ID of the passion.
 * @param completionBlock -- block which needs to be executred when operation is finished. ID of the passion.
 */
- (void) getAllBoardsUnderPassion:(NSString *)passionID completionBlock:(WURequestCompletionBlock)completionBlock
{
    
    self.boardServiceResponseBlock = completionBlock;
    
    WUSharedCache *sharedCache = [WUSharedCache wuSharedCache];
    WeUnite *weUnite = sharedCache.mWeUnite;
    
    
    NSString *urlScheme = [NSString stringWithFormat:kWUURLSchemePassionAllBoards,passionID];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kWUMainURL,urlScheme];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:weUnite.mAccessToken forHTTPHeaderField:@"service_token"];
    
    NSLog(@"request is %@",request);
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        id jsonResponse =  JSON[@"Passion"][@"Boards"][@"Board_Info"];
        if (jsonResponse != nil) {
            
            if (self.boardServiceResponseBlock)
                self.boardServiceResponseBlock(jsonResponse ,nil);
            
        }
        
        else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
            
            if(self.boardServiceResponseBlock)
                self.boardServiceResponseBlock(nil,error);
        }
        self.boardServiceResponseBlock = nil;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure");
        if(self.boardServiceResponseBlock)
            self.boardServiceResponseBlock(JSON,error);
        self.boardServiceResponseBlock = nil;
    }];
    
    [operation start];
}





/**
 * Get all posts under Passion
 * @param passionID ID of the passion.
 * @param completionBlock -- block which needs to be executred when operation is finished. ID of the passion.
 */
- (void)getPostsForPassionID:(NSString *)passionID completionBlock:(WURequestCompletionBlock)completionBlock
{
    [self getPostsForPassionID:passionID offset:0 limit:15 completionBlock:completionBlock];
}

- (void)getPostsForPassionID:(NSString *)passionID offset:(NSInteger)offset limit:(NSInteger)limit completionBlock:(WURequestCompletionBlock)completionBlock{
    
    
    NSString* mAccessToken = [WUSharedCache getServiceToken];
    self.passionPostBlock = completionBlock;
    
    NSString *limitStr = [NSString stringWithFormat:@"%d",limit];
    NSString *offsetStr = [NSString stringWithFormat:@"%d",offset];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@passion/%@/post",kWUMainURL,kSamplePassionId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:limitStr forHTTPHeaderField:@"limit"];
    [request setValue:offsetStr forHTTPHeaderField:@"offset"];
    [request setValue:@"basic" forHTTPHeaderField:@"type"];
    [request setValue:mAccessToken forHTTPHeaderField:@"service_token"];
    
    NSLog(@"%@",request.allHTTPHeaderFields);
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //  NSLog(@"Success %@",JSON);
        
        NSDictionary *responseDict = nil;
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            responseDict = (NSDictionary *)JSON;
            NSMutableDictionary *responseMutableDict = [NSMutableDictionary dictionaryWithDictionary:responseDict];
            [responseMutableDict replaceNullWithValue:@""];
            responseDict = [NSDictionary dictionaryWithDictionary:responseMutableDict];
            if ([responseDict.allKeys containsObject:@"Posts"]) {
                NSArray *allComments = responseDict[@"Posts"][@"Posts"][@"Post"];
                NSLog(@"allCommens %@",allComments);
                self.passionPostBlock(allComments,nil);
                self.passionPostBlock = nil;
            }
        }
        else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
            
            if(self.passionPostBlock)
                self.passionPostBlock(nil,error);
            self.passionPostBlock = nil;
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure");
        if(self.passionPostBlock)
            self.passionPostBlock(JSON,error);
        
        self.passionPostBlock = nil;
    }];
    [operation start];

}



/**
 * Post a comment under Passion Pin
 * @param passionID ID of the passion.
 * @param completionBlock -- block which needs to be executred when operation is finished. ID of the passion.
 */
- (void)comment:(NSString *)commentText passionID:(NSString *)passionID ForMemberID:(NSString *)memberID completionBlock:(PassionPostCompletionBlock)completionBlock
{
    
    NSString* mAccessToken = [WUSharedCache getServiceToken];
    self.passionPostCompletionBlock = completionBlock;
    
    NSString *urlScheme = [NSString stringWithFormat:kWUURLSchemePassionPost,passionID];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kWUMainURL,urlScheme];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    
    if (commentText==nil) {
        commentText = @"";
    }
    CLLocation* location = [[WUUtilities sharedWUUtilities] getUserLocation];
    NSString* latitude = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
    NSString* longitude = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];

    NSDictionary *params = @{@"Data": @{    @"Member_Access_Token": memberID,
                                            @"Message": commentText,
                                            @"Photo_Url": @"",  
                                            @"Longitude":longitude,
                                            @"Latitude":latitude,
                                            }
                             };
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:nil parameters:params];
    [request setValue:mAccessToken forHTTPHeaderField:@"service_token"];
   
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"Success %@",JSON);
        NSDictionary *responseDict = nil;
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            responseDict = (NSDictionary *)JSON;
            NSMutableDictionary *responseMutableDict = [NSMutableDictionary dictionaryWithDictionary:responseDict];
            [responseMutableDict replaceNullWithValue:@""];
            responseDict = [NSDictionary dictionaryWithDictionary:responseMutableDict];
            self.passionPostCompletionBlock(JSON,nil);
            
        }
        else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:response.statusCode userInfo:nil];
            self.passionPostCompletionBlock(nil,error);
        }
        self.passionPostCompletionBlock = nil;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
    {
        NSLog(@"Failure");
        self.passionPostCompletionBlock(JSON,error);
        self.passionPostCompletionBlock = nil;
    }];
    [operation start];
    
}


-(void)likePassionPostID:(NSString *)postID likeStatus:(BOOL)yesOrNo completionBlock:(WURequestCompletionBlock)completionBlock{
    self.boardServiceResponseBlock = completionBlock;
    
    WeUnite *weUnite = [WUSharedCache wuSharedCache].mWeUnite;
    
    NSString *urlScheme = [NSString stringWithFormat:kWUURLSchemePassionPostLike,postID];
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
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *responseDict = nil;
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            responseDict = (NSDictionary *)JSON;
            NSMutableDictionary *responseMutableDict = [NSMutableDictionary dictionaryWithDictionary:responseDict];
            [responseMutableDict replaceNullWithValue:@""];
            responseDict = [NSDictionary dictionaryWithDictionary:responseMutableDict];
            self.boardServiceResponseBlock(JSON,nil);
            self.boardServiceResponseBlock = nil;
            return ;
        }
        else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:response.statusCode userInfo:nil];
            self.boardServiceResponseBlock(nil,error);
            self.boardServiceResponseBlock = nil;
            return;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure");
        self.boardServiceResponseBlock(JSON,error);
        self.boardServiceResponseBlock = nil;
    }];
    [operation start];
    

}

@end
