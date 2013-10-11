//
//  WUCommentCell.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 02/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WUCommentCell : UITableViewCell{
}



@property (weak, nonatomic) IBOutlet UIWebView *mMessageWebview;

@property(nonatomic,strong) IBOutlet UILabel *mMessageLabel,*mAuthorLabel,*mPostedTimeLabel;
@property(nonatomic,strong) IBOutlet UIImageView *mProfileImageView;

@property(nonatomic,weak) IBOutlet UILabel *mLikesLabel;
@end
