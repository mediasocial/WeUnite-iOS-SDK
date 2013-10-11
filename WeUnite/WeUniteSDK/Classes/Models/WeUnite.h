//
//  WeUnite.h
//  WeUniteSDK
//
//  Created by Anthony Gonsalves on 26/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WURequest.h"


@protocol WUActionDelegate;

/*TODO: At end Check whether Block name PassionCommentsFetchCompletionBlock,
 PassionPostCompletionBlock can be replaced by RequestCompleted name
 */

typedef void (^PassionCommentsFetchCompletionBlock)(id JSON, NSError *error);

typedef void (^PassionPostCompletionBlock)(id JSON, NSError *error);




//typedef void (^BoardInfoRequestCompletionBlock)(id JSON, NSError *error);

typedef void (^PinCommentsRequestCompletionBlock)(id JSON, NSError *error); //Name Change if possible

typedef void (^BoardPinsRequestCompletionBlock)(id JSON, NSError *error);


typedef void (^WURequestCompletionBlock)(id JSON, NSError *error);


//typedef void ();

/**
 *  Functions:
 *  Create Session, End Session
 *  Session Validation
 *  Login, Logout, Authorize.
 */
@interface WeUnite : NSObject{
    NSString* mAccessToken;
    NSDate* mExpirationDate;
    
    NSString *mAppKey, *mAppSecretKey;
    
}


@property(nonatomic, strong) NSString* mAccessToken,*mAppKey, *mAppSecretKey;
@property(nonatomic, strong) NSDate* mExpirationDate;


/**
 *  This method initializes the WeUnite Object with appkey and secret key
 *  and creates a session with the server getting the access token and session
 *  expiry date
 *
 *  @param appKey    App key
 *  @param secretKey App Secret
 *  @param delegate  delegate which is implementing WUSessionDelegate methods
 *
 *  @return WeUnite Object
 */
- (id)initWithAppKey:(NSString *)appKey secretKey:(NSString *)secretKey WithDelegate:(id<WUActionDelegate>)delegate;



/**
 *  Presents the Dialog Box for login
 */
- (void)loginWeUnite:(id<WUActionDelegate>)delegate;




/**
 *  This method check whether the session is valid or not
 *
 *  @return is session valid or not.
 */
- (BOOL)isSessionValid;



/**
 *  This method presents the BoardController to view Board/Comments/Pin
 *
 *  @param parentController ParentController from which the modal controller is
 *  been presented
 */
- (void)presentModalBoardPinsControllerFromParentController:(UIViewController *)parentController;

/**
 *  This  method gets the Board Pin/Comments on the board ID
 *
 *  @param boardID  ID of the Board.
 *  @param completionBlock gives the callbacks of result of requests to
 *  owner.
 */
- (void)getCommentsForPinID:(NSString *)pinID completionBlock:(PinCommentsRequestCompletionBlock)completionBlock;


/**
 *  Creates a pin for board ID
 *
 *  @param boardId         boardID
 *  @param pinProperties   the whole postData
 *  @param completionBlock gives the callbacks of result of requests to
 *  owner.
 */
- (void)createPinForBoardID:(NSString *)boardId memberID:(NSString *)memberID  pinProperties:(NSDictionary*)pinProperties completionBlock:(WURequestCompletionBlock)completionBlock;

/**
 *  Register for push with post notification
 *
 *  @param deviceToken deviceToken
 */
- (void)registerForPushWithToken:(NSString *)deviceToken;




- (void)getPinInfoForPinID:(NSString *)pinID completionBlock:(WURequestCompletionBlock)completionBlock;



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
- (void) performAction:(NSString *)action andParams:(NSDictionary *)params  andDelegate:(id <WUActionDelegate>)delegate;


@end



/**
 * Your application should implement this delegate to receive status of Actiion performed by WeUnite Framework.
 */
@protocol WUActionDelegate <NSObject>
@optional

/**
 * Called when the Action is performed by SDK and results is ready to handover to developer. And params is the detail results given back to developer.
 
 * @param params -- 
                If isSuccess = false then format is:
                    @{@"error":error, @"action":action};
                
                If isSuccess = true then format is:
                @{@"action":action, @"other parmas":@""....};
 */
- (void)wuActionResponse:(BOOL)isSuccess params:(NSDictionary*)params;



@end

