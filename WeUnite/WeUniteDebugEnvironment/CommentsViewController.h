//
//  CommentsViewController.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 27/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKImageCache.h"
#import "HPGrowingTextView.h"

@interface CommentsViewController : UIViewController{
    IBOutlet UITableView *mTableView;
    NSArray *mComments;
    NSDictionary *mSelectedCommentInfo;
    TKImageCache *mImageCache;
    
    HPGrowingTextView *mHPGrowingTextView;
    UIView *mContainerView;
}
@property(nonatomic,strong)NSArray *mComments;

-(IBAction)backItemPressed:(id)sender;

@end
