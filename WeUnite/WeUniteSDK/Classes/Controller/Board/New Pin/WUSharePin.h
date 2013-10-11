//
//  WUPinVC.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 12/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeUnite.h"
#import "WUMainCell.h"
#import "WUBaseVC.h"
@class TKImageCache;







@interface WUSharePin : WUBaseVC<UITextFieldDelegate, WUActionDelegate>
{
   
    
    
    TKImageCache *mImageCache;

    NSDictionary *mPinInfo;
    
    IBOutlet UIView *mOverlayView;
    
    int wuShareEntityType;
}


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mActivity;


@property(nonatomic,strong) IBOutlet UITableView *mTableView;

@property(nonatomic,strong)NSDictionary *mPinInfo;

@property(nonatomic,strong)IBOutlet UIView *mOverlayView;

@property (weak, nonatomic) IBOutlet UILabel *mPinTitle;


/*
 Share a new Pin with WeUniteServer.
 
 Structure of WeUnite Pin Params is:
 @{
 @"boardId":kSampleBoardId,
 @"image":[UIImage imageNamed:@"icon.png"],
 @"image":@"http://www.weunite.com/icon.png",
 @"title": @"Demo",
 @"description":@"Desc"
 };
 
 */
-(void) sharePin:(NSDictionary*)pinParams WithDelegate:(id <WUActionDelegate>)delegate;



//Open Already Shared Pin with existing WeUnite PinKey.
-(void) openPin:(NSDictionary*)params WithDelegate:(id <WUActionDelegate>)delegate;

-(void)likePin:(id)sender;
-(void)share:(id)sender;
-(void)inAppBrowerPressed:(id)sender;


@end

