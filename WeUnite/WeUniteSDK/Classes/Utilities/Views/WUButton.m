//
//  WUButton.m
//  ControlDemo
//
//  Created by Anthony Gonsalves on 16/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUButton.h"
#import "WeUnite.h"

#import "WUPinCreateVC.h"
#import "InAppBrowserVC.h"

@interface WUButton(){

}
@property (nonatomic,weak)UIViewController *parentController;
@end


@implementation WUButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+(instancetype)weUniteButtonWithParentController:(UIViewController *)parentController{
    WUButton *button = [self buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"wuFist.png"];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:button action:@selector(presentActionSheet) forControlEvents:UIControlEventTouchUpInside];
    button.parentController = parentController;
    return button;
}

-(void)presentActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"WeUnite" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Go to WeUnite",@"Create Pin",nil];
    
    [actionSheet showInView:self.parentController.view];
}


// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if (actionSheet.tag == 101) {
        
        if ([title isEqualToString:@"Camera"]) {
            [self presentPickerWithType:UIImagePickerControllerSourceTypeCamera];
        }
        else if ([title isEqualToString:@"Photo Album"]) {
            [self presentPickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        
        return;
    }
    
    
    if ([title isEqualToString:@"Go to WeUnite"]) {
        [self gotoWeUnite];
    }
    else if ([title isEqualToString:@"Create Pin"]) {
        [self createPin];
    }
}


- (void)createPin{
    
    [self bringActionSheetForChoosingPicture];
}

- (void)gotoWeUnite{
    InAppBrowserVC *browserVC = [[InAppBrowserVC alloc] initWithNibName:@"InAppBrowserVC" bundle:nil];
    browserVC.mURLString = @"https://dev.weunite.com/";
    [self.parentController presentViewController:browserVC animated:YES
                                      completion:NULL];
}
















-(void)bringActionSheetForChoosingPicture{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Select Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Album", nil];
    
    actionSheet.tag = 101;
    
    [actionSheet showInView:self.parentController.view];
}



-(void)presentPickerWithType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    picker.sourceType = sourceType;
    [self.parentController presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self performSelector:@selector(loadCreatePin:) withObject:chosenImage afterDelay:1.0];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void) loadCreatePin:(UIImage*)img
{
    WUPinCreateVC *pinCreateVC = [[WUPinCreateVC alloc] initWithNibName:@"WUPinCreateVC" bundle:nil];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:pinCreateVC];
    navVC.navigationBarHidden = YES;
    [self.parentController presentViewController:navVC animated:YES completion:NULL];
    NSLog(@"%@",pinCreateVC.view);
    [pinCreateVC setPinImage:img];
}

@end
