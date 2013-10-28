//
//  WUHowerGestureRecognizer.h
//  Hower
//
//  Created by Anthony Gonsalves on 01/10/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>


@interface WUHowerGestureRecognizer : UILongPressGestureRecognizer{
   // NSObject* mSelectorDelegate;
}
@property (nonatomic) CFTimeInterval minimumPressDuration;
@property(nonatomic,strong)UIView *mMainView;
@property (nonatomic,weak)NSObject* mSelectorDelegate;
@end
