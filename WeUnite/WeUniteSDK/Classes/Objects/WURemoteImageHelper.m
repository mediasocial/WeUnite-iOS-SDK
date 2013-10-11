//
//  WURemoteImageHelper.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 07/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WURemoteImageHelper.h"
#import "UIImage+RemoteSize.h"


@implementation WURemoteImageHelper
-(void)requestSizeOfImages:(NSArray *)allURLs withID:(NSString *)tID completionBlock:(ImageSizeFetchComplete)completion{
    mImageSizeInfo = [[NSMutableDictionary alloc] init];
    mImageSizeInfo[tID] = [[NSMutableDictionary alloc] init];
    NSDate *date = [NSDate date];
    NSArray *distintURLs = [allURLs valueForKeyPath:@"@distinctUnionOfObjects.self"];
    for (NSString *urlString in distintURLs) {
        //mImageSizeInfo[tID][urlString] = @"";
        [UIImage requestSizeFor:[NSURL URLWithString:urlString] completion:^(NSURL *imgURL, CGSize size) {
            mImageSizeInfo[tID][urlString] = [NSValue valueWithCGSize:size];
            
            /* NSSet *set1 = [NSSet setWithArray:[mImageSizeInfo[tID] allKeys]];
             NSSet *set2 = [NSSet setWithArray:distintURLs];*/
            
            if ([[mImageSizeInfo[tID] allKeys] count]==distintURLs.count) {
                NSLog(@"finihed in %f\n %@",[[NSDate date]timeIntervalSinceDate:date],mImageSizeInfo[tID]);
            }
        }];
    }
}

@end
