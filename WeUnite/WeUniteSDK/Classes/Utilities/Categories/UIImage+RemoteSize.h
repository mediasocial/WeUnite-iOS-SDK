//
//  UIImage+RemoteSize.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 07/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^UIImageSizeRequestCompleted) (NSURL* imgURL, CGSize size);


typedef uint32_t dword;

@interface NSURL (RemoteSize)
@property (nonatomic, strong) NSMutableData* sizeRequestData;
@property (nonatomic, strong) NSString* sizeRequestType;
@property (nonatomic, copy) UIImageSizeRequestCompleted sizeRequestCompletion;
@end

@interface UIImage (RemoteSize)
+ (void) requestSizeFor: (NSURL*) imgURL completion: (UIImageSizeRequestCompleted) completion;

@end
