//
//  WUMainCell.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 13/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUMainCell.h"

@implementation WUMainCell

@synthesize mCellType;

@synthesize mWUMainImageView;
@synthesize mShareBarView, mCellMainView;
@synthesize mShareBtn, mLikeBtn, mViewCountLabel, mWeUniteWebBtn;

@synthesize mSharePinController, mTableView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    NSLog(@"mCellType %d",mCellType);
    
    if (mCellType == 2) {
        return;
    }
   
    [UIView animateWithDuration:0.5 animations:^{
       [mShareBtn setAlpha:1.0];
       [mLikeBtn setAlpha:1.0];
       [mWeUniteWebBtn setAlpha:1.0];
        [mViewCountLabel setAlpha:1.0];
        
    } completion:^(BOOL finished) {
        [mTableView setScrollEnabled:FALSE];
    }];
    
    [super touchesBegan:touches withEvent:event];    
}




- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:[touch view]];
    
    
    
    
    if (CGRectContainsPoint(mShareBtn.frame, touchLocation))
    {
        [mShareBtn setImage:[WUUtilities imageNamed:@"Share_HL.png"] forState:UIControlStateNormal];
        [mLikeBtn setImage:[WUUtilities imageNamed:@"Like.png"] forState:UIControlStateNormal];
        [mWeUniteWebBtn setImage:[WUUtilities imageNamed:@"Link.png"] forState:UIControlStateNormal];

    }
    else if(CGRectContainsPoint(mLikeBtn.frame, touchLocation))
    {
        [mShareBtn setImage:[WUUtilities imageNamed:@"Share.png"] forState:UIControlStateNormal];
        [mLikeBtn setImage:[WUUtilities imageNamed:@"Like_HL.png"] forState:UIControlStateNormal];
        [mWeUniteWebBtn setImage:[WUUtilities imageNamed:@"Link.png"] forState:UIControlStateNormal];
        
    }
    else if(CGRectContainsPoint(mWeUniteWebBtn.frame, touchLocation))
    {
        [mShareBtn setImage:[WUUtilities imageNamed:@"Share.png"] forState:UIControlStateNormal];
        [mLikeBtn setImage:[WUUtilities imageNamed:@"Like.png"] forState:UIControlStateNormal];
        [mWeUniteWebBtn setImage:[WUUtilities imageNamed:@"Link_HL.png"] forState:UIControlStateNormal];
    }
    else{
        [mShareBtn setImage:[WUUtilities imageNamed:@"Share.png"] forState:UIControlStateNormal];
        [mLikeBtn setImage:[WUUtilities imageNamed:@"Like.png"] forState:UIControlStateNormal];
        [mWeUniteWebBtn setImage:[WUUtilities imageNamed:@"Link.png"] forState:UIControlStateNormal];
    }
}




- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (mCellType == 2) {
        return;
    }
    
    [mShareBtn setImage:[WUUtilities imageNamed:@"Share.png"] forState:UIControlStateNormal];
    [mLikeBtn setImage:[WUUtilities imageNamed:@"Like.png"] forState:UIControlStateNormal];
    [mWeUniteWebBtn setImage:[WUUtilities imageNamed:@"Link.png"] forState:UIControlStateNormal];
    
    
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:[touch view]];
    
    if (CGRectContainsPoint(mShareBtn.frame, touchLocation))
    {
        NSLog(@"share button is selected.");
        [self pinShareBtnPressed:mShareBtn];
       
    }
    else if(CGRectContainsPoint(mLikeBtn.frame, touchLocation))
    {
        NSLog(@"like button is selected.");
        [self pinLikeBtnPressed:mLikeBtn];
       
    }
    else if(CGRectContainsPoint(mWeUniteWebBtn.frame, touchLocation))
    {
        NSLog(@"web button is selected.");
        [self pinOpenWeUniteInAppBtnPressed:mWeUniteWebBtn];
       
    }
    
 
    [UIView animateWithDuration:0.5 animations:^{
        [mShareBtn setAlpha:0.0];
        [mLikeBtn setAlpha:0.0];
        [mWeUniteWebBtn setAlpha:0.0];
        [mViewCountLabel setAlpha:0.0];
    } completion:^(BOOL finished) {
       
        [mTableView setScrollEnabled:TRUE];
    }];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (mCellType == 2) {
        return;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [mShareBtn setAlpha:0.0];
        [mLikeBtn setAlpha:0.0];
        [mWeUniteWebBtn setAlpha:0.0];
        [mViewCountLabel setAlpha:0.0];
    } completion:^(BOOL finished) {
        [mTableView setScrollEnabled:TRUE];
    }];
}



- (IBAction)pinOpenWeUniteInAppBtnPressed:(id)sender {
    
    [(WUSharePin*)mSharePinController inAppBrowerPressed:sender];
}

- (IBAction)pinLikeBtnPressed:(id)sender {
    [(WUSharePin*)mSharePinController likePin:sender];
}

- (IBAction)pinShareBtnPressed:(id)sender {
    [(WUSharePin*)mSharePinController share:sender];
}
@end
