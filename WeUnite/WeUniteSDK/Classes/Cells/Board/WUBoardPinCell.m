//
//  WUBoardPinCell.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 07/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUBoardPinCell.h"
#import "WUConstants.h"

@implementation WUBoardPinCell
@synthesize mPinImageView,mAuthorImageView;
@synthesize mDescriptionLabel,mAuthorNameLabel,mAuthorDescLabel;

@synthesize mLikeButton, mCommentImgView;
@synthesize mLikesCountLabel, mCommentsCountLabel;

@synthesize mLikeImageView;

@synthesize mLongPressGestureRecognizer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    mPinImageView.image = nil;
    mLikeImageView = nil;
    mAuthorDescLabel = nil;
    [self removeGestureRecognizer:self.mLongPressGestureRecognizer];
    mLongPressGestureRecognizer = nil;
    wuCurrentFunc();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
