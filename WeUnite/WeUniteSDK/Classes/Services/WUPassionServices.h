//
//  WUPassionServices.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 16/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeUnite.h"

@interface WUPassionServices : NSObject
+(instancetype)sharedWUPassionServices;

-(void) getPassionInfoForID:(NSString *)passionID completionBlock:(WURequestCompletionBlock)completionBlock;





/**
 * Get all Boards under Passion
 * @param passionID ID of the passion.
 * @param completionBlock -- block which needs to be executred when operation is finished. ID of the passion.
 */
- (void) getAllBoardsUnderPassion:(NSString *)passionID completionBlock:(WURequestCompletionBlock)completionBlock;


/**
 * Get all posts under Passion
 * @param passionID ID of the passion.
 * @param completionBlock -- block which needs to be executred when operation is finished. ID of the passion.
 */
- (void)getPostsForPassionID:(NSString *)passionID completionBlock:(WURequestCompletionBlock)completionBlock;

- (void)getPostsForPassionID:(NSString *)passionID offset:(NSInteger)offset limit:(NSInteger)limit completionBlock:(WURequestCompletionBlock)completionBlock;


-(void)likePassionPostID:(NSString *)postID likeStatus:(BOOL)yesOrNo completionBlock:(WURequestCompletionBlock)completionBlock;
/**
 * Post a comment under Passion Pin
 * @param passionID ID of the passion.
 * @param completionBlock -- block which needs to be executred when operation is finished. ID of the passion.
 */
- (void)comment:(NSString *)commentText passionID:(NSString *)passionID ForMemberID:(NSString *)memberID completionBlock:(PassionPostCompletionBlock)completionBlock;

@end
