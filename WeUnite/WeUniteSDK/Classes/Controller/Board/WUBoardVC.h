//
//  WUBoardVC.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 04/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WUBaseVC;
#import "EGORefreshTableHeaderView.h"

@class TKImageCache;


@interface WUBoardVC : WUBaseVC<UITextFieldDelegate,EGORefreshTableHeaderDelegate,UIActionSheetDelegate>{
    TKImageCache *mProfilePicImageCache,*mPinImageCache;
    NSArray *mComments;
    NSMutableArray *mPins;
    NSDictionary *mBoardInfo;
    
    IBOutlet UIView *mBoardInfoView,*mPinsInfoView;
    //IBOutlet UICollectionView *mBoardPinCollectionView;
    NSString *mBoardID;
    
    BOOL mIsLoading;
    EGORefreshTableHeaderView *egoPullView;
    
    NSDictionary *mSelectedPinInfo;
}
@property(nonatomic,strong) NSString *mBoardID; 

@property(nonatomic,strong)NSArray *mComments;
@property(nonatomic,strong) NSMutableArray *mPins;
@property(nonatomic,strong)NSDictionary *mBoardInfo;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mActivity;
@property (weak, nonatomic)IBOutlet UICollectionView *mBoardPinCollectionView;
-(IBAction)backItemPressed:(id)sender;

- (IBAction)createNewPinPressed:(id)sender;




@end
