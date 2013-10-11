//
//  WUPinCreateVC.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 11/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeUnite.h"
#import "WUBaseVC.h"


@interface WUPinCreateVC : WUBaseVC<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, WUActionDelegate>
{
    IBOutlet UITextField *mPinTitleField, *mDescTitleField;

    NSString *mBoardID,*mBoardName;
    IBOutlet UIButton *mSelectBoardButton;
}

@property (weak, nonatomic)     IBOutlet UIImageView *mPinImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mActivity;
@property (weak, nonatomic) IBOutlet UIButton *mCreatePinBtn;

@property (weak, nonatomic) IBOutlet UITextView *mTextView;

@property(nonatomic, strong) NSString *mBoardID,*mBoardName;

@property (weak, nonatomic) IBOutlet UIButton *mAddPhotoBtn;

-(IBAction)backItemPressed:(id)sender;

-(IBAction)createPinItemPressed:(id)sender;

-(void) setPinImage:(UIImage*)img;

@end
