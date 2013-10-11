//
//  WUHowerGestureRecognizer.m
//  Hower
//
//  Created by Anthony Gonsalves on 01/10/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUHowerGestureRecognizer.h"
#import "WUHowerImageView.h"

CGRect CGRectChangeCenter(CGRect rect, CGFloat dx, CGFloat dy){
    rect = CGRectOffset(rect,dx-rect.size.width*0.5f,dy-rect.size.height*0.5f);
    return rect;
}

@interface WUHowerGestureRecognizer(){
    CGPoint _anchorPoint;
    UIImageView *mAnchorImageView,*mFirstImageView,*mSecondImageView,*mThirdImageView;
    NSArray *mButtonImageViews;
}
@property(nonatomic,assign)CGPoint anchorPoint;
@property (nonatomic, retain) NSTimer *pressTimer;
@property (nonatomic) BOOL didLongPress;

- (void)reset;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@implementation WUHowerGestureRecognizer
@synthesize mSelectorDelegate;
- (id)init {
    if (self = [super init]) {
        self.minimumPressDuration = 0.5;
        
        UIImageView *likeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Like.png"]];
        UIImageView *linkImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Link.png"]];
        UIImageView *shareImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Share.png"]];
        
       mButtonImageViews = @[likeImageView,linkImageView,shareImageView];
    }
    return self;
}

- (id)initWithTarget:(id)target action:(SEL)action {
    if (self = [super initWithTarget:target action:action]) {
        self.minimumPressDuration = 0.5;
        WUHowerImageView *likeImageView = [[WUHowerImageView alloc]initWithImage:[UIImage imageNamed:@"Like.png"]];
        likeImageView.highlightedImage = [UIImage imageNamed:@"Like_HL.png"];
        WUHowerImageView *linkImageView = [[WUHowerImageView alloc]initWithImage:[UIImage imageNamed:@"Link.png"]];
        linkImageView.highlightedImage = [UIImage imageNamed:@"Link_HL.png"];
        WUHowerImageView *shareImageView = [[WUHowerImageView alloc]initWithImage:[UIImage imageNamed:@"Share.png"]];
        shareImageView.highlightedImage = [UIImage imageNamed:@"Share_HL.png"];
        
        mButtonImageViews = @[likeImageView,linkImageView,shareImageView];
        self.mMainView = [[UIView alloc]init];
        self.mMainView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
        
    }
    return self;
}

- (void)reset {
    [super reset];
    
    self.anchorPoint = CGPointZero;
    self.didLongPress = NO;
    if (self.pressTimer) {
        [self.pressTimer invalidate];
    }
    self.pressTimer = nil;

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if ([touches count] != 1 || [[touches anyObject] tapCount] > 1) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGPoint touchPoint = [[touches anyObject] locationInView:window];
    self.anchorPoint = touchPoint;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.minimumPressDuration
                                                      target:self selector:@selector(longPressed:)
                                                    userInfo:nil repeats:NO];
    self.pressTimer = timer;
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    NSLog(@"touches Moved");
    
    if (self.didLongPress == NO) {
        [self.pressTimer invalidate];
        self.pressTimer = nil;
        self.state = UIGestureRecognizerStateFailed;
    }
    else{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        CGPoint touchPoint = [[touches anyObject] locationInView:window];

        [self animateMenuItemAtPoint:touchPoint];
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
    [self checkForSelectionAtPoint:[[touches anyObject] locationInView:self.view]];
    [self animateOutHower];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.pressTimer) {
        [self.pressTimer invalidate];
    }
    self.pressTimer = nil;
    self.state = UIGestureRecognizerStateFailed;
}


-(void)setUpMenuItemsAtAnchorPoint{
    // Convert the co-ordinates of the view into the window co-ordinate space
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    float radius = 100.0f;
    
    float height,base;
    CGPoint startPoint;
    int degs[3] = {-1,-1,-1};
    
    CGRect sampleFrame = CGRectMake(0, 0, 50, 50);
    for (int deg = 245; deg <= 1200; deg+=40) {
        
        float radian = 2 * 22/7 * (float)deg/360;
        
        height = radius * sin(radian);
        base   = radius * cos(radian);
        
        startPoint.x = self.anchorPoint.x + base;
        startPoint.y = self.anchorPoint.y + height;
        
        NSLog(@"sampleCenter deg %d %@",deg,NSStringFromCGPoint(startPoint));
        
        CGRect frame = CGRectChangeCenter(sampleFrame, startPoint.x, startPoint.y);
        if(CGRectContainsRect(window.frame, frame)){
            BOOL allDone = NO;
            for (int i = 0; i < 3; i++) {
                if (degs[i] == -1) {
                    degs[i] = deg;
                    if (i == 2) {
                        allDone = YES;
                    }
                    break;
                }
            }
            if (allDone) {
                break;
            }
        }
        else {
            for (int i = 0; i < 3; i++) {
                degs[i] = -1;
            }
        }
        
    }
    
 //   return;
    
    if (degs[2]==-1) {
        return;
    }
    

    [window addSubview:self.mMainView];
    self.mMainView.frame = window.frame;
    for (int i = 0; i < 3; i++) {
        float radian = 2 * 22/7 * (float)degs[i]/360;
        
        height = radius * sin(radian);
        base   = radius * cos(radian);
        
        startPoint.x = self.anchorPoint.x + base;
        startPoint.y = self.anchorPoint.y + height;
        
        NSLog(@"sampleCenter deg %d %@",degs[i],NSStringFromCGPoint(startPoint));
        
        CGRect frame = CGRectChangeCenter(sampleFrame, startPoint.x, startPoint.y);
        WUHowerImageView *imageView = mButtonImageViews[i];
        imageView.frame = frame;
        imageView.mDegrees = degs[i];
        imageView.mNormalRadius = radius;
        imageView.mSqueezeRadius = radius + 20;
        imageView.mAnchorPoint = self.anchorPoint;
        imageView.mBoundingFrame = frame;
        [self.mMainView addSubview:imageView];
    }
    NSLog(@"%d %d %d",degs[0],degs[1],degs[2]);
  //  [window addSubview:nil];
}

- (void)longPressed:(NSTimer*)theTimer {
    if (theTimer == self.pressTimer) {
        self.state = UIGestureRecognizerStateBegan;
        self.didLongPress = YES;
        [theTimer invalidate];
        self.pressTimer = nil;
        [self setUpMenuItemsAtAnchorPoint];
        [self animateInHower];
    }
}


- (void)animateInHower{
    [UIView animateWithDuration:0.4 animations:^{
        self.mMainView.alpha = 1.0f;
    }];
    for (UIImageView *imageView in mButtonImageViews) {
        imageView.alpha = 0.0f;
        [UIView animateWithDuration:0.50 animations:^{
            imageView.alpha = 1.0f;
        } completion:^(BOOL finished) {
        }];

    }
}

-(void)animateOutHower{
    [UIView animateWithDuration:0.50 animations:^{
        self.mMainView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.mMainView removeFromSuperview];
    }];
    for (UIImageView *imageView in mButtonImageViews) {
        [UIView animateWithDuration:0.50 animations:^{
            imageView.alpha = 0.0f;
           
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
        }];
    }
}

-(void)animateMenuItemAtPoint:(CGPoint)point{
    CGPoint touchPoint = point;
    for (WUHowerImageView *imageView in mButtonImageViews) {
        if (CGRectContainsPoint(imageView.mBoundingFrame, touchPoint)) {
            
            if (imageView.isHighlighted==NO){
                imageView.highlighted = YES;
                [UIView animateWithDuration:0.5 animations:^{
                    imageView.alpha = 0.5f;
                    [imageView squeezeOut];
                }];
            }
        }
        else{
            if (imageView.isHighlighted){
                imageView.highlighted = NO;
                [UIView animateWithDuration:0.5 animations:^{
                    imageView.alpha =1.0f;
                    [imageView backToNormal];
                }];
            }
        }
    }
}

-(void)checkForSelectionAtPoint:(CGPoint)point{
    for (int i = 0; i < mButtonImageViews.count; i++) {
        UIImageView *imageView = mButtonImageViews[i];
        if (CGRectContainsPoint(imageView.frame, point)) {
            switch (i) {
                case 0:
                    [self likeItemSelected];
                    break;
                case 1:
                    [self linkItemSelected];
                    break;
                case 2:
                 default:
                    [self shareItemSelected];
                    break;
                }
        }
    }
}

-(void)likeItemSelected{

}

-(void)linkItemSelected{

}

-(void)shareItemSelected{

}

@end
