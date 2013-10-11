//
//  WeUnite.m
//  WeUniteTest
//
//  Created by Anthony Gonsalves on 26/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WeUnite.h"
#import "WUConstants.h"
#import "WURequest.h"
#import "AFNetworking.h"
#import "WUCommentsVC.h"
#import "WUSharedCache.h"
#import "WUDialog.h"
#import "WUBoardVC.h"
#import "UIKit+Extensions.h"

#import "WUSharePin.h"

#import "WUExtraServices.h"
#import "WUBoardServices.h"









/**
 *  first parameter is the Board ID
 *  2nd parameter is the limit
 *  3rd parameter is the offset
 */
static NSString* kWUURLSchemeBoardPins = @"board/%@/pin?type=full&limit=%d&offset=%d";


@interface WeUnite(){
    IBOutlet __weak WUDialog *mWUDialog;
}
@property (nonatomic,copy)PassionCommentsFetchCompletionBlock passionCommentsFetchCompletionBlock;
@property (nonatomic,copy)PassionPostCompletionBlock passionPostCompletionBlock;
@property (nonatomic,copy)PinCommentsRequestCompletionBlock pinCommentsRequestCompletionBlock;
@property (nonatomic,copy)BoardPinsRequestCompletionBlock boardPinsRequestCompletionBlock;


@property (nonatomic,weak)IBOutlet WUDialog *mWUDialog;
@end
//TODO: Important Track Ownership cycles
//TODO: assigning the self.blockname = nil after dispatch;

@implementation WeUnite

@synthesize mAccessToken,mExpirationDate;
@synthesize mAppKey,mAppSecretKey;

@synthesize mWUDialog;


- (id)initWithAppKey:(NSString *)appKey secretKey:(NSString *)secretKey WithDelegate:(id<WUActionDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        
        self.mAppKey = appKey;   self.mAppSecretKey = secretKey;
        
        [[WUExtraServices sharedWUExtraServices] initApp:appKey SecretKey:secretKey completionBlock:^(id JSON, NSError *error) {
           
            NSLog(@"JSON %@ and error %@",JSON, error);
            
            if (error != nil) {
                NSDictionary* dict = @{kResponseErrorKey:error, kResponseActionKey:kActionInitAppKey};
                [delegate wuActionResponse:NO params:dict];
                dict = nil;
                
                return ;
            }
            
            
            if (JSON != nil)
            {
                NSTimeInterval seconds = (NSTimeInterval)[((NSString *)JSON[@"Expires_In"]) doubleValue];
                self.mExpirationDate = [NSDate  dateWithTimeIntervalSince1970:seconds];
                self.mAccessToken = JSON[@"Token"];
                
                [WUSharedCache setServiceToken:self.mAccessToken];
                [WUSharedCache setServiceTokenExpiry:self.mExpirationDate];

                NSDictionary* dict = @{kResponseActionKey:kActionInitAppKey};
                [delegate wuActionResponse:YES params:dict];
                dict = nil;
            }
            
        }];

        WUSharedCache *wuSharedCache = [WUSharedCache wuSharedCache];
        wuSharedCache.mWeUnite = self;
        
    }
    return self;
}


- (void)loginWeUnite:(id<WUActionDelegate>)delegate
{
    self.mWUDialog = nil;
    UINib *nib = [UINib nibWithNibName:@"WUDialog" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    [self.mWUDialog show:delegate];
}


- (BOOL)isSessionValid {
    return (self.mAccessToken != nil && self.mExpirationDate != nil
            && NSOrderedDescending == [self.mExpirationDate compare:[NSDate date]]);
}








- (void)presentModalBoardPinsControllerFromParentController:(UIViewController *)parentController{
    WUBoardVC *boardVC = [[WUBoardVC alloc] initWithNibName:@"WUBoardVC" bundle:nil];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:boardVC];
    navCon.edgesForExtendedLayout = UIRectEdgeNone;
    navCon.navigationBarHidden = YES;
    [parentController presentViewController:navCon animated:YES completion:^{
    }];
}

- (void)getCommentsForPinID:(NSString *)pinID completionBlock:(PinCommentsRequestCompletionBlock)completionBlock{
    WUBoardServices *boardServices = [WUBoardServices sharedWUBoardServices];
    [boardServices getCommentsForPinID:pinID completionBlock:completionBlock];
}

/**
 *  Creates a pin for board ID
 *
 *  @param boardId         boardID
 *  @param memberToken     memberToken
 *  @param pinProperties   the whole postData
 *  @param completionBlock gives the callbacks of result of requests to
 *  owner.
 */
- (void)createPinForBoardID:(NSString *)boardId memberID:(NSString *)memberID  pinProperties:(NSDictionary*)pinProperties completionBlock:(WURequestCompletionBlock)completionBlock
{
    WUBoardServices *boardServices = [WUBoardServices sharedWUBoardServices];
    [boardServices createPinForBoardID:boardId memberID:memberID  pinProperties:pinProperties completionBlock:completionBlock];

}


- (void)registerForPushWithToken:(NSString *)deviceToken{
    [[WUExtraServices sharedWUExtraServices] registerForPushWithToken:deviceToken];
}


#pragma mark - Show WeUnite Screen Methods

/**
 * Generate a UI dialog for the request action with the provided parameters.
 *
 * @param action
 *            String representation of the desired method:
 e.g.
 @"sharePin", @"passion", @"board", @"login"...
 * @param parameters
 *            key-value string parameters
 * @param delegate
 *            Callback interface to notify the calling application when the
 *            dialog has completed.
 */
- (void) performAction:(NSString *)action andParams:(NSDictionary *)params  andDelegate:(id <WUActionDelegate>)delegate
{
    
    if ([action isEqualToString:kActionNewPinKey]) {
        
        WUSharePin* sharePin = [[WUSharePin alloc] initWithNibName:@"WUSharePin" bundle:nil];
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:sharePin];
        navCon.navigationBarHidden = YES;
        
        [sharePin sharePin:params WithDelegate:delegate];
        
        [(UIViewController*)delegate presentViewController:navCon animated:YES completion:NULL];
        return;
    }
    else if([action isEqualToString:kActionOpenPinKey]){
        
        WUSharePin* sharePin = [[WUSharePin alloc] initWithNibName:@"WUSharePin" bundle:nil];
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:sharePin];
        navCon.navigationBarHidden = YES;
        
        [sharePin openPin:params WithDelegate:delegate];
        
        [(UIViewController*)delegate presentViewController:navCon animated:YES completion:NULL];
        return;
    }
    else if([action isEqualToString:kActionOpenCommentsKey])
    {
        WUCommentsVC *commentsVC = [[WUCommentsVC alloc] initWithNibName:@"WUCommentsVC" bundle:nil];
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:commentsVC];
        navCon.navigationBarHidden = YES;
        [(UIViewController*)delegate presentViewController:navCon animated:YES completion:^{
        }];
    }
    
    //Handle Other Actions/.................
    
    
    
    
}


- (void)getPinInfoForPinID:(NSString *)pinID completionBlock:(WURequestCompletionBlock)completionBlock{
     WUBoardServices *boardServices = [WUBoardServices sharedWUBoardServices];
    [boardServices getPinInfoForPinID:pinID completionBlock:completionBlock];
}
@end
