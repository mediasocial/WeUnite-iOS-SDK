//
//  MainPassionCell.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 30/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "MainPassionCell.h"
#import "WUConstants.h"
#import "WUConfiguration.h"

@implementation MainPassionCell
@synthesize mCellDelegate;
@synthesize mPassionImageView;

@synthesize mLikeBtn;

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

- (void)dealloc
{
    mPassionImageView.image = nil;
    wuCurrentFunc();
}

@end
