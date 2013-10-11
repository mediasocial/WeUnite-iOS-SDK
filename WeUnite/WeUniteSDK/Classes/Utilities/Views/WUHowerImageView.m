//
//  WUHowerImageView.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 03/10/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUHowerImageView.h"

@implementation WUHowerImageView
@synthesize mDegrees,mNormalRadius,mSqueezeRadius,mBoundingFrame;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) {
        float offset = mSqueezeRadius - mNormalRadius;
        self.mBoundingFrame = CGRectInset(self.frame, 1/offset,1/offset);
        //self.frame = self.mBoundingFrame;
    }
    else
        self.mBoundingFrame = self.frame;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
}

- (void) squeezeOut{
    float radian = 2 * 22/7 * (float)mDegrees/360;
    
   float height = mSqueezeRadius * sin(radian);
   float base   = mSqueezeRadius * cos(radian);
    
    CGPoint newCenter;
    
    newCenter.x =  self.mAnchorPoint.x + base;
    newCenter.y = self.mAnchorPoint.y + height;

    self.center = newCenter;
}

-(void)backToNormal{
    float radian = 2 * 22/7 * (float)mDegrees/360;
    
    float height = mNormalRadius * sin(radian);
    float base   = mNormalRadius * cos(radian);
    
    CGPoint newCenter;
    
    newCenter.x =  self.mAnchorPoint.x + base;
    newCenter.y = self.mAnchorPoint.y + height;
    
    self.center = newCenter;

}


@end
