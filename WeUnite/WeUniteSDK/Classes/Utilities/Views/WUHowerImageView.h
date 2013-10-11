//
//  WUHowerImageView.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 03/10/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WUHowerImageView : UIImageView
@property(nonatomic,assign)int mDegrees,mNormalRadius,mSqueezeRadius;
@property(nonatomic,assign)CGPoint mAnchorPoint;
@property(nonatomic,assign)CGRect mBoundingFrame;
- (void) squeezeOut;
- (void)backToNormal;
@end
