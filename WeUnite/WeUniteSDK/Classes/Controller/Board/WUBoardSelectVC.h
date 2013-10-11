//
//  WUBoardSelectVC.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 16/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUBaseVC.h"


typedef void (^BoardSelectionCompletionBlock)(BOOL success, id boardID);

@interface WUBoardSelectVC : WUBaseVC
{
    IBOutlet UITableView *mTableView;
    NSString *mSelectedBoardID,*mPassionID,*mSelectedBoardName;
    
    int selectedRow;
}


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mAcitivty;

@property(nonatomic,strong)NSString *mSelectedBoardID,*mPassionID,*mSelectedBoardName;
@property (nonatomic, copy) BoardSelectionCompletionBlock completionBlock;
@end
