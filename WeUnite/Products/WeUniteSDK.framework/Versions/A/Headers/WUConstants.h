//
//  WUConstants.h
//  WeUniteTest
//
//  Created by Anthony Gonsalves on 23/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

/**
 * All the neccessary constants are declared here
 * 
 */

#define kWUAppName @"WeUnite"

////TODO: Structure properly

#define kWUMainURL /*@"https://api.weunite.com/v1/"*/ @"http://weunitetestapi.cloudapp.net/v1/"

#define wuCurrentFunc() NSLog(@"%s",__func__)

#define BOARD_PIN_SCREEN @"BOARD_PIN"


#define kSampleBoardId @"1373" //@"1097"
#define kSamplePassionId @"444"



//Action Keys
#define kActionInitAppKey @"initApp"
#define kActionLoginKey @"login"
#define kActionNewPinKey @"newPin"
#define kActionOpenPinKey @"openPin"
#define kActionOpenCommentsKey @"comments"


//Delegate Response Dictionary Keys
#define kResponseErrorKey @"error"
#define kResponseActionKey @"action"