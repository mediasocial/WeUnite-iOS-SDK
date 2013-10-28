//
//  WUConfiguration.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 22/10/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <Foundation/Foundation.h>


////////Constant Variables
extern NSString *const kWUMainURL;
extern NSString *const kWUMainInitialURL;

extern NSString *const kWeUniteSiteURL;

extern NSString *const kWUAppName;
extern BOOL const kCodeTest;

extern NSString *const kSharePanelTouchType;
extern NSString *const kSharePanelBarType;

extern NSString *const kBoardPinScreen;




//////Define statements
#define wuCurrentFunc() NSLog(@"%s",__func__)