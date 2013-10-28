//
//  WUBaseVC.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 25/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUUtilities.h"

@interface WUBaseVC : UIViewController{
    UIView *mBaseView;
    IBOutlet UIImageView *mBGImageView,*mToolBarImageView;
    IBOutlet UIButton *mBackButton;
}
@property (nonatomic,strong)UIView *mBaseView;
@end
