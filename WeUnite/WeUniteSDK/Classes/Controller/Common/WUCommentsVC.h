//
//  WUCommentsVC.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 02/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeUnite.h"
#import "WUBaseVC.h"
@class TKImageCache;

@interface WUCommentsVC : WUBaseVC<UITextFieldDelegate, WUActionDelegate,UIGestureRecognizerDelegate>{
   
    
    TKImageCache *mImageCache;
    
    NSMutableArray *mComments;
    NSDictionary *mPassionInfo;
    
    
    NSString* mCommentToBePosted;
}

@property(nonatomic,strong)NSMutableArray *mComments;

@property(nonatomic, strong) NSDictionary* mFullPinInfo,*mPassionInfo;

@property(nonatomic, strong) NSString* mCommentType;

@property (weak, nonatomic) IBOutlet UILabel *mScreenTitle;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
