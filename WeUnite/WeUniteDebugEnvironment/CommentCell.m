//
//  CommentCell.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 28/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell
@synthesize mMessageLabel,mAuthorLabel,mProfileImageView;

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

@end
