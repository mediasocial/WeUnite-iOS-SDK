//
//  WURemoteImageHelper.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 07/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ImageSizeFetchComplete)(NSDictionary *allImagesSizeInfo);
@interface WURemoteImageHelper : NSObject{
    NSMutableDictionary *mImageSizeInfo;
}

-(void)requestSizeOfImages:(NSArray *)allURLs withID:(NSString *)tID completionBlock:(ImageSizeFetchComplete)completion;
@end
