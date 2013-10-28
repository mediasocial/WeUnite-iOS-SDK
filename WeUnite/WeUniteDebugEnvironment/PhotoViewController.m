//
//  PhotoViewController.m
//  WeUnite
//
//  Created by Adeesh Jain on 16/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "PhotoViewController.h"
#import "WUConstants.h"
#import "UIKit+Extensions.h"
#import "AppDelegate.h"
#import "WUConfiguration.h"
#import "WUUtilities.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

@synthesize scrollView1;

CGFloat kScrollObjHeight;
CGFloat kScrollObjWidth	;
const NSUInteger kNumImages		= 15;

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
    
    kScrollObjHeight = [UIScreen mainScreen].bounds.size.height - 44.0;
    kScrollObjWidth	= self.view.frame.size.width;
    NSLog(@"height and width is %f, %f",kScrollObjHeight, kScrollObjWidth);
    // Do any additional setup after loading the view from its nib.
    
    [scrollView1 setBackgroundColor:[UIColor blackColor]];
	[scrollView1 setCanCancelContentTouches:NO];
	scrollView1.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView1.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
	scrollView1.scrollEnabled = YES;
	
	// pagingEnabled property default is NO, if set the scroller will stop or snap at each photo
	// if you want free-flowing scroll, don't set this property.
	scrollView1.pagingEnabled = YES;
	
	// load all the images from our bundle and add them to the scroll view
	NSUInteger i;
	for (i = 1; i <= kNumImages; i++)
	{
		NSString *imageName = [NSString stringWithFormat:@"image%d.jpg", i];
		UIImage *image = [WUUtilities imageNamed:imageName];
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScrollObjWidth, kScrollObjHeight)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [imageView setImage:image];
		imageView.tag = i;	// tag our images for later use when we place them in serial fashion
		
        [scrollView1 addSubview:imageView];
		imageView = nil;
        image = nil;
	}
	
	[self layoutScrollImages];	// now place the photos in serial layout within the scrollview
	
	// 2. setup the scrollview for one image and add it to the view controller
	//
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)layoutScrollImages
{
	UIImageView *view = nil;
	NSArray *subviews = [scrollView1 subviews];
    
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = 0;
	for (view in subviews)
	{
		if ([view isKindOfClass:[UIImageView class]] && view.tag > 0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;
			
			curXLoc += (kScrollObjWidth);
		}
	}
	
	// set the content size so it can be scrollable
	[scrollView1 setContentSize:CGSizeMake((kNumImages * kScrollObjWidth), kScrollObjHeight)];
}
- (IBAction)weUniteSharePressed:(id)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Board", @"Share on Scrap Board", nil];
    
    [sheet showInView:self.view];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index is %d",buttonIndex);
    
    if (buttonIndex == 0)
    {
        [self shareOnBoard:nil];
    }
    else if(buttonIndex == 1)
    {
        [self shareOnScrapBoard];
    }
}


- (void)shareOnBoard:(id)sender
{
    
    NSLog(@"current index is %d",(int)((int)(scrollView1.contentOffset.x)/(int)kScrollObjWidth));
    
    int imageIndex = (int)((int)(scrollView1.contentOffset.x)/(int)kScrollObjWidth);
    NSString* imgPinKey  = [NSString stringWithFormat:@"ImagePin_%d",imageIndex];
    NSString* imgPinId = [[NSUserDefaults standardUserDefaults] objectForKey:imgPinKey];
    NSString* imgTitle = [NSString stringWithFormat:@"Image %d",imageIndex+1];
    UIImageView* imgView = (UIImageView*)[scrollView1 viewWithTag:imageIndex+1];
    
    NSString* shareTypeScreen = (imageIndex % 2) == 0 ? kSharePanelTouchType : kSharePanelBarType;
    
    
    /**
     * To enable WeUnite share on any image, use the performAction method of framework with action Type as
     *  kActionNewPinKey. In Response, server will return PinId, save that and call the same performAction method 
     *  so that everyone can view/share/comment over it.
     */
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (imgPinId == nil) {
        
        NSDictionary *infoDict = @{kKeyBoardLinkKey:kTestBoardId,
                                   @"image":imgView.image,
                                   @"title": imgTitle,
                                   @"description":@"This is cool",
                                   @"shareType":shareTypeScreen};
        
        [appDel.mWeUnite performAction:kActionNewPinKey andParams:infoDict andDelegate:self];
    }
    else{
        
        NSDictionary *infoDict = @{@"pinKey":imgPinId, @"shareType":shareTypeScreen};
        [appDel.mWeUnite performAction:kActionOpenPinKey andParams:infoDict andDelegate:self];
    }
    

    
}


-(void) shareOnScrapBoard
{
    
    NSLog(@"share on scrap board is called...");
    
    
    NSLog(@"current index is %d",(int)((int)(scrollView1.contentOffset.x)/(int)kScrollObjWidth));
    
    int imageIndex = (int)((int)(scrollView1.contentOffset.x)/(int)kScrollObjWidth);
    NSString* imgPinKey  = [NSString stringWithFormat:@"Scrap_ImagePin_%d",imageIndex];
    NSString* imgPinId = [[NSUserDefaults standardUserDefaults] objectForKey:imgPinKey];
    NSString* imgTitle = [NSString stringWithFormat:@"Image %d",imageIndex+1];

    
    NSString* shareTypeScreen = (imageIndex % 2) == 0 ? kSharePanelTouchType : kSharePanelBarType;
   
    
    NSString* mPinImgUrl = @"http://a3.twimg.com/profile_images/66601193/cactus.jpg";
    if (imageIndex == 0) {
        mPinImgUrl = @"http://a3.twimg.com/profile_images/66601193/cactus.jpg";
    }
    else if(imageIndex == 1)
    {
        mPinImgUrl = @"https://s3.amazonaws.com/twitter_production/profile_images/425948730/DF-Star-Logo.png";
    }
    else if(imageIndex == 2)
    {
        mPinImgUrl = @"http://imgs.mi9.com/uploads/landscape/4717/free-the-seaside-landscape-of-maldives-wallpaper_422_84903.jpg";
    }
    else if(imageIndex == 3)
    {
        mPinImgUrl = @"http://pics4.city-data.com/cpicc/cfiles42848.jpg";
    }
    else if(imageIndex == 4)
    {
        mPinImgUrl = @"http://www.beautifullife.info/wp-content/uploads/2011/03/16/20.jpg";
    }
    else if(imageIndex == 5)
    {
        mPinImgUrl = @"http://images.coveralia.com/audio/a/Angels_And_Airwaves-We_Don_t_Need_To_Whisper-Interior_Trasera.jpg";
    }
    
    NSLog(@"imgPinId %d",imageIndex);
    /**
     * To enable WeUnite share on any image, use the performAction method of framework with action Type as
     *  kActionNewPinKey. In Response, server will return PinId, save that and call the same performAction method
     *  so that everyone can view/share/comment over it.
     */
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (imgPinId == nil) {
        
        NSDictionary *infoDict = @{kKeyBoardLinkKey:kTestScrapBoardLinkKey,
                                   @"image":mPinImgUrl,
                                   @"title": imgTitle,
                                   @"description":@"This is cool",
                                   @"shareType":shareTypeScreen};
        
        
        [appDel.mWeUnite performAction:kActionNewScrapPinKey andParams:infoDict andDelegate:self];
    }
    else
    {
        NSDictionary *infoDict = @{@"pinKey":imgPinId, @"shareType":shareTypeScreen};
        [appDel.mWeUnite performAction:kActionOpenPinKey andParams:infoDict andDelegate:self];
    }
    

    
}





- (IBAction)backPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}










- (void)wuActionResponse:(BOOL)isSuccess params:(NSDictionary*)params
{
    
    
    NSString* action = params[kResponseActionKey];
    NSLog(@"View Controller wuAction response is called ffor action %@",action);
    
    if (isSuccess == false) {
        
        if ([action isEqualToString:kActionInitAppKey]) {
            
            // Handle error if you want to handle it gracefully.
        }
        
        NSError* error = params[kResponseErrorKey];
        [UIAlertView showAlertMessage:[error localizedDescription]];
        return;
    }
    
    
    NSLog(@"params are %@",params);
    
    if ([action isEqualToString:kActionNewPinKey]) {
        
        int imageIndex = (int)((int)(scrollView1.contentOffset.x)/(int)kScrollObjWidth);
        NSString* pinId = params[@"pinKey"];
        NSString* imgPinKey  = [NSString stringWithFormat:@"ImagePin_%d",imageIndex];
        [[NSUserDefaults standardUserDefaults] setObject:pinId forKey:imgPinKey];
        
        [UIAlertView showAlertMessage:@"New Pin creation is Successful."];
        
        return;
    }
    
    else  if ([action isEqualToString:kActionNewScrapPinKey]) {
        
        int imageIndex = (int)((int)(scrollView1.contentOffset.x)/(int)kScrollObjWidth);
        NSString* pinId = params[@"pinKey"];
        NSString* imgPinKey  = [NSString stringWithFormat:@"Scrap_ImagePin_%d",imageIndex];
        [[NSUserDefaults standardUserDefaults] setObject:pinId forKey:imgPinKey];
        
        [UIAlertView showAlertMessage:@"New Pin creation is Successful."];
        
        return;
    }

    
    
}

@end
