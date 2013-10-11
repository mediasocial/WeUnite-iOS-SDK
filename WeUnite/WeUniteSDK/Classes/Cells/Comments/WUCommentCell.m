//
//  WUCommentCell.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 02/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUCommentCell.h"

@implementation WUCommentCell
@synthesize mMessageLabel,mAuthorLabel,mProfileImageView,mPostedTimeLabel;
@synthesize mMessageWebview;
@synthesize mLikesLabel;

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

- (void)dealloc{
    self.mProfileImageView = nil;
    self.mMessageLabel = nil;
    self.mAuthorLabel = nil;
    self.mPostedTimeLabel = nil;
    self.mMessageWebview = nil;
    self.mLikesLabel = nil;
}

@end
