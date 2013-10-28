//
//  UIImage+Extensions.m
//  NE
//
//  Created by Anthony Gonslaves on 12/10/11.
//  Copyright 2011 Demansol. All rights reserved.
//

#import "UIKit+Extensions.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import "WUConstants.h"
#import "WUConfiguration.h"

#if __has_feature(objc_arc) && __clang_major__ >= 3
    #define ARC_ENABLED 1
#endif // __has_feature(objc_arc)


@implementation UIImage (Extensions)

- (UIImage*)resizedImageWithSize:(CGSize)size {
   /* UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGImageRef sourceImage = CGImageCreateCopy(self.CGImage);
    UIImage *newImage = [UIImage imageWithCGImage:sourceImage scale:0.0 orientation:self.imageOrientation];
    [newImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    CGImageRelease(sourceImage);
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;*/
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage *)scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
    CGFloat oldWidth = self.size.width;
    CGFloat oldHeight = self.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return [self resizedImageWithSize:newSize];
}

- (UIImage*)cropImageFromFrame:(CGRect)frame {
    CGRect destFrame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
    
    CGFloat scale = 1.0;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        scale = [[UIScreen mainScreen] scale];
    }
#endif
    
    CGRect sourceFrame = CGRectMake(frame.origin.x*scale, frame.origin.y*scale, frame.size.width*scale, frame.size.height*scale);
    
    UIGraphicsBeginImageContextWithOptions(destFrame.size, NO, 0.0);
    CGImageRef sourceImage = CGImageCreateWithImageInRect(self.CGImage, sourceFrame);
    UIImage *newImage = [UIImage imageWithCGImage:sourceImage scale:0.0 orientation:self.imageOrientation];
    [newImage drawInRect:destFrame];
    CGImageRelease(sourceImage);
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (NSArray*)createTilesWithRows:(int)rows columns:(int)columns spacing:(float)space{
	float imgSegWidth,imgSegHeight;
	
	imgSegWidth = self.size.width/rows;
	imgSegHeight = self.size.height/columns;
	
	NSMutableArray *tImages = [NSMutableArray arrayWithCapacity:0];
	for( int x=0; x<rows; x++ )
		for( int y=0; y<columns; y++ )
		{
			CGRect tileFrame =  CGRectMake((imgSegWidth+space)*x, (imgSegHeight+space)*y, 
										   imgSegWidth, imgSegHeight );
			UIImage *tileImage = [self cropImageFromFrame:tileFrame];
			[tImages addObject:tileImage];
		}
	
	return tImages;
}

-(UIImage *)applyColor:(UIColor *)color{
    return [self imageWithGradientStartColor:color endColor:color];
}

- (UIImage *)imageWithGradientStartColor:(UIColor *)color1 endColor:(UIColor *)color2 {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    //CGContextDrawImage(context, rect, img.CGImage);
    
    // Create gradient
    NSArray *colors = [NSArray arrayWithObjects:(id)color2.CGColor, (id)color1.CGColor, nil];
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, NULL);
    
    // Apply gradient
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0,0), CGPointMake(0, self.size.height), 0);
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(space);
    
    return gradientImage;
}
@end


@implementation UIView (extensions)

-(void)addRoundedEdgesWithCornerRadius:(float)radius {
    CALayer  *l = [self layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:radius];
}

-(void)addGradientWithColors:(NSArray *)colors{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = colors;
    self.layer.masksToBounds = YES;
    [self.layer insertSublayer:gradient atIndex:0];
}

-(UIImage *)snapShot{
	UIGraphicsBeginImageContext(self.frame.size);
	[self.layer renderInContext: UIGraphicsGetCurrentContext()];
	UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return retval;
}

- (UIImage *) renderWithSubframe:(CGRect)frame {
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextConcatCTM(c, CGAffineTransformMakeTranslation(-frame.origin.x, -frame.origin.y));
    [self.layer renderInContext:c];
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
    
}



-(void)removeAllSubviews
{
	for (UIView *tView in self.subviews) {
		[tView.layer removeAllAnimations];
        if([tView isKindOfClass:[UIImageView class]])
        {
            [(UIImageView *)tView setImage:nil];
        }
        
		[tView removeFromSuperview];
        //tView = nil;
       // NSLog(@"%@",tView);
    
	}
}

-(void)addToParentView:(UIView*)tParent
{
	[tParent addSubview:self];
}

- (UIView *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}

@end

@implementation UIView (FrameSetting)
///////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


@end

@implementation UIImage (Utility)
- (CGSize) aspectFitAndScaledImageSizeForWidth:(float)width height:(float)height{
    float frameWidth,frameHeight;
    float imgWidth,imgHeight;
    frameWidth = width;
    frameHeight = height;
    imgWidth = self.size.width;
    imgHeight = self.size.height;
    
    float originalAspectRatio = imgWidth / imgHeight;
    float maxAspectRatio = frameWidth / frameHeight;
    
    CGSize aspectImageSize = CGSizeMake(width, height);
    
    if (originalAspectRatio > maxAspectRatio) { // scale by width
        aspectImageSize.height = frameWidth * imgHeight / imgWidth;
        //newRect.origin.y += (maxRect.size.height - newRect.size.height)/2.0;
    } else {
        aspectImageSize.width = frameHeight * imgWidth / imgHeight;
        //newRect.origin.x += (maxRect.size.width - newRect.size.width)/2.0;
    }
    
    return aspectImageSize;
}
@end


@implementation UIImageView(Utility)
- (CGSize) aspectFitAndScaledImageSize {
    float frameWidth,frameHeight;
    float imgWidth,imgHeight;
    frameWidth = self.frame.size.width;
    frameHeight = self.frame.size.height;
    imgWidth = self.image.size.width;
    imgHeight = self.image.size.height;
    
    CGSize size = [self.image aspectFitAndScaledImageSizeForWidth:frameWidth height:frameHeight];
    return size;
}

@end




@implementation UIColor (Utility)
+ (UIColor *)colorForHex:(NSString *)hexColor {
	hexColor = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
                 ] uppercaseString];  
    
    // String should be 6 or 7 characters if it includes '#'  
    if ([hexColor length] < 6) 
		return [UIColor blackColor];  
    
    // strip # if it appears  
    if ([hexColor hasPrefix:@"#"]) 
		hexColor = [hexColor substringFromIndex:1];  
    
    // if the value isn't 6 characters at this point return 
    // the color black	
    if ([hexColor length] != 6) 
		return [UIColor blackColor];  
    
    // Separate into r, g, b substrings  
    NSRange range;  
    range.location = 0;  
    range.length = 2; 
    
    NSString *rString = [hexColor substringWithRange:range];  
    
    range.location = 2;  
    NSString *gString = [hexColor substringWithRange:range];  
    
    range.location = 4;  
    NSString *bString = [hexColor substringWithRange:range];  
    
    // Scan values  
    unsigned int r, g, b;  
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  
    [[NSScanner scannerWithString:gString] scanHexInt:&g];  
    [[NSScanner scannerWithString:bString] scanHexInt:&b];  
    
    return [self colorWithRed:((float) r / 255.0f)  
                        green:((float) g / 255.0f)  
                         blue:((float) b / 255.0f)  
                        alpha:1.0f];  
    
}

@end

@implementation UIScrollView (Utility)
- (CGRect)visibleRect{
    CGPoint contentOffset = self.contentOffset;
    CGSize frameSize = self.frame.size;
    CGRect visibleRect = CGRectMake(contentOffset.x, contentOffset.y, frameSize.width, frameSize.height);
    return visibleRect;
}
@end


@implementation UIAlertView(Utility)
+(UIAlertView *)showAlertMessage:(NSString *)tMessage
{
    
	UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:kWUAppName
													   message:tMessage
													  delegate:nil
											 cancelButtonTitle:@"OK"
											 otherButtonTitles:nil];
	[alertView show];
    
#ifndef ARC_ENABLED
    [alertView release];
#endif
    return alertView;
}

+(UIAlertView *)showFlashAlertMessage:(NSString *)tMessage
{
    
	UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:kWUAppName
													   message:tMessage
													  delegate:nil
											 cancelButtonTitle:nil
											 otherButtonTitles:nil];
	[alertView show];
    
#ifndef ARC_ENABLED
    [alertView release];
#endif
    [alertView performSelector:@selector(dismissWithClickedButtonIndex: animated:) withObject:nil afterDelay:1.0];
    return alertView;
}


@end

/*
 Copied and pasted from David Hamrick's blog:
 
 Source: http://www.davidhamrick.com/2011/12/31/Changing-the-UINavigationController-animation-style.html
 */

@implementation UINavigationController (Fade)

- (void)pushFadeViewController:(UIViewController *)viewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
	[self.view.layer addAnimation:transition forKey:nil];
    
	[self pushViewController:viewController animated:NO];
}

- (void)fadePopViewController
{
	CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
	[self.view.layer addAnimation:transition forKey:nil];
	[self popViewControllerAnimated:NO];
}

@end


