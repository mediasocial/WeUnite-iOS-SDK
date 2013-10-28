//
//  WUPinCreateVC.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 11/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUPinCreateVC.h"
#import "WUConstants.h"
#import "WUSharedCache.h"
#import "Base64.h"
#import "WeUnite.h"
#import "WUBoardSelectVC.h"
#import "UIKit+Extensions.h"
#import <QuartzCore/QuartzCore.h>

#import "SVProgressHUD.h"
#import "WUUtilities.h"
#import "WUBoardServices.h"

@interface WUPinCreateVC ()
@end

@implementation WUPinCreateVC
@synthesize mBoardID,mBoardName;

@synthesize mPassionLinkKey;
@synthesize mPinImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.mCreatePinBtn setBackgroundImage:[WUUtilities imageNamed:@"Pin.png"] forState:UIControlStateNormal];
    
    [WUUtilities findCurrentLocation];
    
    [mPinImageView.layer setCornerRadius:5.0];
    [_mTextView.layer setCornerRadius:5.0];
    // Do any additional setup after loading the view from its nib.
    
    mSelectBoardButton.hidden = YES;

    if (self.mBoardID == nil) {
        mSelectBoardButton.hidden = NO;
    }

}

-(void) viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}

-(void) setPinImage:(UIImage*)img
{
    [mPinImageView setImage:img];
    [mPinImageView.layer setCornerRadius:10.0];
    
    [_mAddPhotoBtn setTitle:@"" forState:UIControlStateNormal];
    [_mAddPhotoBtn setAlpha:0.1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
    // Dispose of any resources that can be recreated.
}

-(IBAction)selectBoardID:(id)sender
{
    
    WUBoardSelectVC *boardVC = [[WUBoardSelectVC alloc] initWithNibName:[WUUtilities xibBundlefileName:@"WUBoardSelectVC"] bundle:nil];
    boardVC.mPassionID = mPassionLinkKey;
    
    __weak WUBoardSelectVC *weakBoard = boardVC;
    boardVC.completionBlock = ^(BOOL success,NSString *selectedID){
        NSLog(@"%@",weakBoard.mSelectedBoardID);
        self.mBoardID = weakBoard.mSelectedBoardID;
        NSString *boardText = [NSString stringWithFormat:@"Selected Board: %@",weakBoard.mSelectedBoardName];
        
        [mSelectBoardButton setTitle:boardText forState:UIControlStateNormal];
        [mSelectBoardButton setTitle:boardText forState:UIControlStateHighlighted];
        [mSelectBoardButton setTitle:boardText forState:UIControlStateSelected];
        
    };
    [self.navigationController pushViewController:boardVC animated:YES];
}

-(IBAction)backItemPressed:(id)sender{
    
    if([self.navigationController.viewControllers[0] isEqual:self]){
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}



-(IBAction)addPhotoPressed:(id)sender{
    [self bringActionSheetForChoosingPicture];
}

-(IBAction)createPinItemPressed:(id)sender
{
    NSString *userToken = [WUSharedCache getUserToken];
    
    if (userToken == nil) {
        [[WUSharedCache wuSharedCache] loginWeUnite:self];
        return;
    }

    if (self.mBoardID == nil) {
        [UIAlertView showAlertMessage:@"Please select Board"];
        return;
    }
    
    if (mPinTitleField.text.length == 0) {
        [UIAlertView showAlertMessage:@"Please add Title"];
        return;
    }
    
    if (mDescTitleField.text.length == 0) {
        [UIAlertView showAlertMessage:@"Please add Description"];
        return;
    }
    
    if (mPinImageView.image == nil) {
        [UIAlertView showAlertMessage:@"Please select some image to add on your pin"];
        return;
    }
    [Base64 initialize];
    NSData* pinImgData = UIImageJPEGRepresentation(mPinImageView.image, 0.7);
  //  NSData* pinImgData = [NSData dataWithContentsOfFile:@"/Users/aneeshkumar/Desktop/test.png"];
    NSString *pinImage64 = [Base64 encode:pinImgData];
    
    NSTimeInterval interval = [[NSDate  date] timeIntervalSinceReferenceDate];
    NSString *fileName = [NSString stringWithFormat:@"image%lld.png",(long long)ceilf(interval)];
    
    
    CLLocation* location = [[WUUtilities sharedWUUtilities] getUserLocation];
    NSString* latitude = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
    NSString* longitude = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];
    NSLog(@"lat %@, long %@",latitude, longitude);
    
    NSString *pinDesc = mDescTitleField.text;
    if (mDescTitleField.text.length==0) {
        pinDesc = @" ";
    }
    
    NSDictionary *dict = @{
        @"Data": @{
            @"Member_Access_Token": userToken,
            @"Title": mPinTitleField.text,
            @"Description_1": pinDesc,
            @"Longitude":latitude,
            @"Latitude":longitude,
            @"Image_Content": @{
                @"FileName": fileName,
                @"FileContent": pinImage64,
                @"ContentType": @"image/jpeg",
            }
        }
    };
    
    NSLog(@"dict is %@",dict);
    
    [_mActivity startAnimating];
    [_mCreatePinBtn setHidden:YES];
    
    [SVProgressHUD showInView:self.view];
    

    WUBoardServices *boardServices = [WUBoardServices sharedWUBoardServices];
    [boardServices createPinForBoardID:self.mBoardID memberID:userToken  pinProperties:dict completionBlock:^(id JSON, NSError *error) {
        
        NSLog(@"JSON %@  error %@",JSON,error);
        if(error == nil){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Pin created successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            alert.tag = 101;
            [alert show];
        }
        else{
            [UIAlertView showAlertMessage:@"Sorry, There is problem in creating pin."];
        }
        
        
        [SVProgressHUD dismiss];
        [_mActivity stopAnimating];
        [_mCreatePinBtn setHidden:NO];
        
    }];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        [mPinImageView setImage:nil];
        [_mAddPhotoBtn setAlpha:1.0];
        [_mAddPhotoBtn setTitle:@"Add Photo" forState:UIControlStateNormal];
        [mPinTitleField setText:@""];
        [mDescTitleField setText:@""];
    }
}


#pragma mark - Image Picker Controller delegate methods

-(void)bringActionSheetForChoosingPicture{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Select Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Album", nil];
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Camera"]) {
        [self presentPickerWithType:UIImagePickerControllerSourceTypeCamera];
    }
    else if ([buttonTitle isEqualToString:@"Photo Album"]) {
        [self presentPickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

-(void)presentPickerWithType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    //[_mAddPhotoBtn setBackgroundImage:chosenImage forState:UIControlStateNormal];
    mPinImageView.image = chosenImage;
    [mPinImageView.layer setCornerRadius:10.0];
    
    [_mAddPhotoBtn setTitle:@"" forState:UIControlStateNormal];
    [_mAddPhotoBtn setAlpha:0.1];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)viewDidUnload {
    [self setMAddPhotoBtn:nil];
    [self setMTextView:nil];
    [self setMActivity:nil];
    [self setMCreatePinBtn:nil];
    [super viewDidUnload];
}



#pragma mark - TEXT Field Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == mPinTitleField) {
        [mDescTitleField becomeFirstResponder];
    }
    else
    {
     [mDescTitleField resignFirstResponder];
    }
    
    
   // [textField resignFirstResponder];
    return YES;
}





#pragma mark - WUAction Delegate Methods

- (void)wuActionResponse:(BOOL)isSuccess params:(NSDictionary*)params
{
    NSString* actionKey = params[kResponseActionKey];
    
    if (isSuccess == false) {
        NSError* error = params[@"error"];
        [UIAlertView showAlertMessage:[error localizedDescription]];
        return;
    }
    
    
    
    if ([actionKey isEqualToString:kActionLoginKey])
    {
        //Login is successful
        [self createPinItemPressed:nil];
        return;
    }
    
    
    
    
}



@end
