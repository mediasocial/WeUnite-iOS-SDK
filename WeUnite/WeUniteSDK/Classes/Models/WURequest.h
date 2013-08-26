//
//  WURequest.h
//  WeUniteTest
//
//  Created by Anthony Gonsalves on 23/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  Types of Requests the WURequest Class handles
 *
 *  WURequestTypeRegistration: Registers/authenticates the application with We Unite
 *
 */
typedef NS_ENUM(NSInteger, WURequestType){
    WURequestTypeRegistration = 1
};


/**
 *  WURequest handles the basic types of requests. Registration etc. 
 */
@interface WURequest : NSObject

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
