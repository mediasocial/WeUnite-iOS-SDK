//
//  MainPassionCell.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 30/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPassionCell : UITableViewCell{
    IBOutlet UIImageView *mPassionImageView;
}

@property(nonatomic,weak)NSObject *mCellDelegate;

@property(nonatomic,strong) IBOutlet UIImageView *mPassionImageView;

@property (weak, nonatomic) IBOutlet UIButton *mLikeBtn;

@end
