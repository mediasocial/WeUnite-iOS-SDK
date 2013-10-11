//
//  WUPinCommentsVc.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 09/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUBaseVC.h"
@class TKImageCache;

@interface WUPinCommentsVC : WUBaseVC{
    NSString *mPinID;
    IBOutlet UITableView *mTableView;
    TKImageCache *mImageCache;
  
}

@property (nonatomic, strong) NSArray* mComments;
@property (nonatomic,strong)NSString *mPinID;

@end
