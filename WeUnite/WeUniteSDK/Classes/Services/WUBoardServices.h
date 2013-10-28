//
//  WUBoardServices.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 09/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeUnite.h"



@interface WUBoardServices : NSObject
{
}

+(instancetype)sharedWUBoardServices;


/**
 *  This  method gets the Pin Comments on the pin ID
 *
 *  @param boardID  ID of the Board.
 *  @param completionBlock gives the callbacks of result of requests to
 *  owner.
 */
- (void)getCommentsForPinID:(NSString *)pinID completionBlock:(WURequestCompletionBlock)completionBlock;


/**
 *  This  method post a comment on the Pin
 *
 *  @param pinId --  Id of the Pin.
 *  @param completionBlock gives the callbacks of result of requests to
 *  owner.
 */
- (void)comment:(NSString *)commentText pinId:(NSString *)pinId ForMember:(NSString *)memberToken completionBlock:(WURequestCompletionBlock)completionBlock;



/**
 *  This  method likes Pin
 *
 *  @param pinId --  Id of the Pin.
 *  @param yesOrNo  like = True or like = false
 *  @param completionBlock gives the callbacks of result of requests to
 *  owner.
 */
-(void)likePin:(NSString*)pinID likeStatus:(BOOL)yesOrNo completionBlock:(WURequestCompletionBlock)completionBlock;


/**
 *  Creates a pin for board ID
 *
 *  @param boardId         boardID
 *  @param memberToken     memberToken
 *  @param pinProperties   the whole postData
 *  @param completionBlock gives the callbacks of result of requests to
 *  owner.
 */
- (void)createPinForBoardID:(NSString *)boardId memberID:(NSString *)memberID  pinProperties:(NSDictionary*)pinProperties completionBlock:(WURequestCompletionBlock)completionBlock;


/**
 *  Creates a pin for Scrap board ID
 *
 *  @param boardId         ScrapboardID
 *  @param memberToken     memberToken
 *  @param pinProperties   the whole postData
 *  @param completionBlock gives the callbacks of result of requests to
 *  owner.
 */
- (void)createScrapPinForBoardID:(NSString *)boardId memberID:(NSString *)memberID pinProperties:(NSDictionary*)pinProperties completionBlock:(WURequestCompletionBlock)completionBlock;


/**
 *  Gets pin information for board ID
 *
 *  @param pinID         Unique id of Pin 
 *  @param completionBlock gives the callbacks of result of requests to
 *  owner.
 */
- (void)getPinInfoForPinID:(NSString *)pinID completionBlock:(WURequestCompletionBlock)completionBlock;


/**
 *  Gets Board Info corresponding to board ID
 *
 *  @param boardId         boardID
 *  @param completionBlock gives the callbacks of result of requests to
 *  owner.
 */
-(void)getBoardInfoForBoardID:(NSString *)boardID completionBlock:(WURequestCompletionBlock)completionBlock;



/**
 *  Gets pin information for board ID on chunk basis
 *
 *  @param pinID         Unique id of Pin
 *  @param completionBlock gives the callbacks of result of requests to
 *  owner.
 */
- (void)getBoardPinsForBoardID:(NSString *)boardID offset:(NSInteger)offset limit:(NSInteger)limit completionBlock:(WURequestCompletionBlock)completionBlock;

@end
