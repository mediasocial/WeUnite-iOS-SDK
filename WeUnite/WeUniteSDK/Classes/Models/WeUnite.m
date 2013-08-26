//
//  WeUnite.m
//  WeUniteTest
//
//  Created by Anthony Gonsalves on 26/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WeUnite.h"
#import "WURequest.h"

@implementation WeUnite



+(void)startRequestOfType:(WURequestType)requestType delegate:(NSObject *)delegate
          successSelector:(SEL)successSel failSelector:(SEL)failSel{
    [WURequest startRequestOfType:requestType delegate:delegate successSelector:successSel failSelector:failSel];
}


@end
