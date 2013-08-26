//
//  WeUnite.h
//  WeUniteTest
//
//  Created by Anthony Gonsalves on 26/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WURequest.h"

/**
 *  Functions:
 *  Create Session, End Session
 *  Session Validation
 *  Login, Logout, Authorize.
 */
@interface WeUnite : NSObject{
}



/**
 *  Peforms request operation that are in WURequestType
 *
 *  @param requestType should be in WURequestType enum values
 *  @param delegate    the class which handles the callbacks of successSel and failSel
 *  @param successSel  selector which handles if the request is successful
 *  @param failSel     selector which handles if the request is failure
 */
+(void)startRequestOfType:(WURequestType)requestType delegate:(NSObject *)delegate
          successSelector:(SEL)successSel failSelector:(SEL)failSel;

@end
