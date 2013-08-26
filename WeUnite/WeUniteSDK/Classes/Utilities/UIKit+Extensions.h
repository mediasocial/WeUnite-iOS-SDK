//
//  UIImage+Extensions.h
//  NE
//
//  Created by Anthony Gonslaves on 12/10/11.
//  Copyright 2011 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage(Extensions)

- (UIImage*)resizedImageWithSize:(CGSize)size;
- (UIImage*)cropImageFromFrame:(CGRect)frame;
- (NSArray*)createTilesWithRows:(int)rows columns:(int)columns spacing:(float)space;

//////http://stackoverflow.com/questions/8098130/how-can-i-tint-a-uiimage-with-gradient
- (UIImage *)imageWithGradientStartColor:(UIColor *)color1 endColor:(UIColor *)color2;
-(UIImage *)applyColor:(UIColor *)color;
@end


@interface UIView(extensions)
-(void)addGradientWithColors:(NSArray *)colors;
-(void)addRoundedEdgesWithCornerRadius:(float)radius;
-(UIImage *)snapShot;
- (UIImage *) renderWithSubframe:(CGRect)frame;
-(void)removeAllSubviews;
-(void)addToParentView:(UIView*)tParent;
- (UIView *)findFirstResponder;
@end

@interface UIView (FrameSetting)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;



@end


@interface UIImageView (Utility)
- (CGSize) aspectFitAndScaledImageSize;
@end

@interface UIImage (Utility)
- (CGSize) aspectFitAndScaledImageSizeForWidth:(float)width height:(float)height;
@end


@interface UIColor (Utility)
+ (UIColor *)colorForHex:(NSString *)hexColor;
@end

@interface UIScrollView (Utility)
- (CGRect)visibleRect;
@end

@interface UIAlertView (Utility)
+(UIAlertView *)showAlertMessage:(NSString *)tMessage;
+(UIAlertView *)showFlashAlertMessage:(NSString *)tMessage;
@end


/*
 Copied and pasted from David Hamrick's blog:
 
 Source: http://www.davidhamrick.com/2011/12/31/Changing-the-UINavigationController-animation-style.html
 */

@interface UINavigationController (Fade)

- (void)pushFadeViewController:(UIViewController *)viewController;
- (void)fadePopViewController;

@end
