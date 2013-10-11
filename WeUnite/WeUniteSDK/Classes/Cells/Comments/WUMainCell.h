//
//  WUMainCell.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 13/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUSharePin.h"





@interface WUMainCell : UITableViewCell
{
}

@property int mCellType;

@property (weak, nonatomic) IBOutlet UIView *mShareBarView;
@property (weak, nonatomic) IBOutlet UIButton *mShareBtn;
@property (weak, nonatomic) IBOutlet UIButton *mWeUniteWebBtn;
@property (weak, nonatomic) IBOutlet UIButton *mLikeBtn;
@property (weak, nonatomic) IBOutlet UILabel *mViewCountLabel;

@property (weak, nonatomic) IBOutlet UIView *mCellMainView;

@property(nonatomic,strong)IBOutlet UIImageView *mWUMainImageView;


@property(nonatomic,strong) UITableView *mTableView;
@property(nonatomic, strong) UIViewController *mSharePinController;

- (IBAction)pinOpenWeUniteInAppBtnPressed:(id)sender;
- (IBAction)pinLikeBtnPressed:(id)sender;
- (IBAction)pinShareBtnPressed:(id)sender;



@end
