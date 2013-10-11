//
//  WUPinCommentsVC.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 09/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUPinCommentsVC.h"
#import "WUSharedCache.h"
#import "TKImageCache.h"

@interface WUPinCommentsVC ()
{
}
@end

@implementation WUPinCommentsVC

@synthesize mPinID;
@synthesize mComments;

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
    // Do any additional setup after loading the view from its nib.
    
}

-(void)setUpImageCaching{
    mImageCache = [[TKImageCache alloc] initWithCacheDirectoryName:@"WUPinCommentImages"];
    NSString *notificationName = [NSString stringWithFormat:@"self %@",self];
	mImageCache.notificationName = notificationName;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newImageRetrieved:) name:notificationName object:nil];
}


-(void)loadComments{
    WeUnite *weUnite = [[WUSharedCache wuSharedCache]mWeUnite];
    [weUnite getCommentsForPinID:self.mPinID completionBlock:^(id JSON, NSError *error) {
        if(error == nil){
            mComments = (NSArray *)JSON;
            [mTableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
