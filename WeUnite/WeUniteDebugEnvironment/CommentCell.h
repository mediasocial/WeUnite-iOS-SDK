//
//  CommentCell.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 28/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell{
    IBOutlet UILabel *mMessageLabel,*mAuthorLabel;
    IBOutlet UIImageView *mProfileImageView;
}
@property(nonatomic,strong) IBOutlet UILabel *mMessageLabel,*mAuthorLabel;
@property(nonatomic,strong) IBOutlet UIImageView *mProfileImageView;
@end
