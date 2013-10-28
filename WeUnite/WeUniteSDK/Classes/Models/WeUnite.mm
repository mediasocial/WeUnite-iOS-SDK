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
#import "WUDeleteVC.h"








/**
 *  first parameter is the Board ID
 *  2nd parameter is the limit
 *  3rd parameter is the offset
 */
static NSString* kWUURLSchemeBoardPins = @"board/%@/pin?type=full&limit=%d&offset=%d";


@interface WeUnite(){
   
}




@end
//TODO: Important Track Ownership cycles
//TODO: assigning the self.blockname = nil after dispatch;

@implementation WeUnite

@synthesize mAccessToken,mExpirationDate;
@synthesize mAppKey,mAppSecretKey;




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




- (BOOL)isSessionValid {
    return (self.mAccessToken != nil && self.mExpirationDate != nil
            && NSOrderedDescending == [self.mExpirationDate compare:[NSDate date]]);
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
    
    if ([action isEqualToString:kActionNewScrapPinKey]) {
        
        NSString *nibName = [WUUtilities xibBundlefileName:@"WUSharePin"];
        WUSharePin* sharePin = [[WUSharePin alloc] initWithNibName:nibName bundle:nil];
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:sharePin];
        navCon.navigationBarHidden = YES;
        
        [(UIViewController*)delegate presentViewController:navCon animated:YES completion:^{
            //Present the new MVC
            [sharePin shareScrapPin:params WithDelegate:delegate];            
        }];
        

        
        return;
    }
    else if ([action isEqualToString:kActionNewPinKey]) {
        
        NSString *nibName = [WUUtilities xibBundlefileName:@"WUSharePin"];
        WUSharePin* sharePin = [[WUSharePin alloc] initWithNibName:nibName bundle:nil];
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:sharePin];
        navCon.navigationBarHidden = YES;
        
        
        
        [(UIViewController*)delegate presentViewController:navCon animated:YES completion:^{
            //Present the new MVC
           [sharePin sharePin:params WithDelegate:delegate];
        }];
        
        
        
        return;
    }
    else if([action isEqualToString:kActionOpenPinKey]){
       
        NSString *nibName = [WUUtilities xibBundlefileName:@"WUSharePin"];;
        WUSharePin* sharePin = [[WUSharePin alloc] initWithNibName:nibName bundle:nil];
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:sharePin];
        navCon.navigationBarHidden = YES;
        
        [sharePin openPin:params WithDelegate:delegate];
        
        [(UIViewController*)delegate presentViewController:navCon animated:YES completion:NULL];
        return;
    }
    else if([action isEqualToString:kActionOpenPassionPosts])
    {
        NSString *nibName =  [WUUtilities xibBundlefileName:@"WUCommentsVC"];

        WUCommentsVC *commentsVC = [[WUCommentsVC alloc] initWithNibName:nibName bundle:nil];
        commentsVC.mPassionLinkKey = params[kKeyPassionLinkKey];
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:commentsVC];
        navCon.navigationBarHidden = YES;
        [(UIViewController*)delegate presentViewController:navCon animated:YES completion:^{
        }];
    }
    
    else if([action isEqualToString:kActionOpenBoardKey])
    {
        NSString *nibName = [WUUtilities xibBundlefileName:@"WUBoardVC"];
        NSLog(@"nib name is %@",nibName);
        
        WUBoardVC *boardVC = [[WUBoardVC alloc] initWithNibName:nibName bundle:nil];
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:boardVC];
        navCon.navigationBarHidden = YES;
        boardVC.mBoardInfo = params;
        boardVC.mBoardID = params[kKeyBoardLinkKey];
        [(UIViewController*)delegate presentViewController:navCon animated:YES completion:^{
        }];
    }
    
    //Handle Other Actions/.................
}




@end
