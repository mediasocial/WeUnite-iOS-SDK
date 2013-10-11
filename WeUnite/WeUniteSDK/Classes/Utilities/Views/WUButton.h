//
//  WUButton.h
//  ControlDemo
//
//  Created by Anthony Gonsalves on 16/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WUButton : UIButton<UIActionSheetDelegate>{

}
+(instancetype)weUniteButtonWithParentController:(UIViewController *)parentController;
@end
