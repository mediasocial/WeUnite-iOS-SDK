//
//  WUBoardPinCell.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 07/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUHowerGestureRecognizer.h"

@interface WUBoardPinCell : UICollectionViewCell{
    IBOutlet UIImageView *mPinImageView,*mAuthorImageView;
    IBOutlet UILabel *mDescriptionLabel,*mAuthorNameLabel,*mAuthorDescLabel;
    IBOutlet UIImageView *mLikeImageView;
    WUHowerGestureRecognizer *mLongPressGestureRecognizer;
}


@property (weak, nonatomic) IBOutlet UILabel *mLikesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *mCommentsCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *mLikeButton;
@property (weak, nonatomic) IBOutlet UIImageView *mCommentImgView;


@property(nonatomic,strong)IBOutlet UIImageView *mPinImageView,*mAuthorImageView,*mLikeImageView;
@property(nonatomic,strong)IBOutlet UILabel *mDescriptionLabel,*mAuthorNameLabel,*mAuthorDescLabel;

@property(nonatomic,strong)WUHowerGestureRecognizer *mLongPressGestureRecognizer;
@end
