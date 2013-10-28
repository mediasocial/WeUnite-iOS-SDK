//
//  WUPinVC.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 12/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUSharePin.h"
#import "WUConstants.h"

#import "WUBoardServices.h"
#import "WUPostCommentCell.h"
#import "WUCommentCell.h"
#import "WUMainCell.h"
#import "TKImageCache.h"
#import "WUSharedCache.h"
#import "UIKit+Extensions.h"
#import "Foundation+Extensions.h"
#import "Base64.h"

#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "InAppBrowserVC.h"

static NSString *zCommentCellReuseIdentifier = @"WUCommentCell";
static NSString *zPostCellReuseIdentifier = @"WUPostCommentCell";

static NSString *zMainCellReuseIdentifier = @"WUMainCell";

static NSString *zMainCellReuseIdentifier1 = @"WUMainCell1";

@interface WUSharePin ()
{
    NSString* mPinTitle;
    NSString* mPinDescription;
    UIImage*  mPinImage;
    NSString* mPinImgUrl;
    
    int typeOfPostOperation;
    
    NSString *mPinID;
    NSString *mBoardID;
    NSArray *mPinComments;
    
    id<WUActionDelegate>pinDelegate;
}

@end



@implementation WUSharePin


@synthesize mTableView;

@synthesize mPinInfo;

@synthesize mOverlayView;

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
    [self registerTableCells];
    [self addNotifications];
    [self setUpImageCaching];
    
    [WUUtilities findCurrentLocation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [mImageCache removeAllObjects];
    mImageCache = nil;
    //[super dealloc];
}










-(void)addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)setUpImageCaching{
    mImageCache = [[TKImageCache alloc] initWithCacheDirectoryName:@"WUPin"];
    NSString *notificationName = [NSString stringWithFormat:@"self %@",self];
	mImageCache.notificationName = notificationName;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newImageRetrieved:) name:notificationName object:nil];
}

-(void)registerTableCells{
    
     
    [mTableView registerNib:[UINib nibWithNibName:[WUUtilities xibBundlefileName:@"WUCommentCell"] bundle:nil] forCellReuseIdentifier:zCommentCellReuseIdentifier];
    
    [mTableView registerNib:[UINib nibWithNibName:[WUUtilities xibBundlefileName:@"WUPostCommentCell"] bundle:nil] forCellReuseIdentifier:zPostCellReuseIdentifier];
}

-(IBAction)backItemPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark - TableView DataSource and Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return 1;
    }
    else if (section == 2){
        return mPinComments.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    else if (section == 1){
        return 5;
    }
    else if (section == 2){
        return 5;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 345;
    }
    else if (indexPath.section == 1){
        return 50;
    }
    else if (indexPath.section == 2){
        return 70;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WUPostCommentCell *cell = (WUPostCommentCell *)[mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell.mPostCommentTextField resignFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        
        
        NSString* identifier = (wuShareEntityType == 1) ? zMainCellReuseIdentifier : zMainCellReuseIdentifier1;
        
        WUMainCell *cell = (WUMainCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:[WUUtilities xibBundlefileName:@"WUMainCell"] owner:nil options:nil];
            
            cell = (wuShareEntityType == 1) ? (WUMainCell*) nibArray[0] : (WUMainCell*)nibArray[1];
            
            NSLog(@"wuShareEntityType %d",wuShareEntityType);
            
            if (wuShareEntityType == 1) {
                cell.mCellType = 1;
            }
            else{
                cell.mCellType = 2;
            }
            
        }
        

        id data_3 = self.mPinInfo[@"Data_3"];
        if ([data_3 isKindOfClass:[UIImage class]]) {
            cell.mWUMainImageView.image = (UIImage *)data_3;
        }
        else {
            NSString *thumbURLString = data_3;
            NSString *thumbFileName = [thumbURLString lastPathComponent];
            NSURL *thumbURL = [NSURL URLWithString:thumbURLString];
            UIImage* img = [mImageCache imageForKey:thumbFileName url: thumbURL queueIfNeeded:YES tag:100];
            if (img != nil) {
                cell.mWUMainImageView.image = img;                
            }

        }
        
        
        cell.mTableView = mTableView;
        cell.mSharePinController = self;
        if (self.mPinInfo[@"View_Count"] == nil) {
            cell.mViewCountLabel.text = @"Views: ";
        }else{
            cell.mViewCountLabel.text = [NSString stringWithFormat:@"Views: %@",self.mPinInfo[@"View_Count"]];
        }

        
        [cell.mShareBtn addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.mLikeBtn addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.mWeUniteWebBtn addTarget:self action:@selector(inAppBrowerPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [cell.mCellMainView.layer setCornerRadius:15.0];
        _mPinTitle.text = self.mPinInfo[@"Data_1"];
        cell.layer.borderColor = [UIColor grayColor].CGColor;
        cell.layer.borderWidth = 1.0f;
        return cell;
    }
    else if (indexPath.section ==1) {
        WUPostCommentCell *cell = (WUPostCommentCell *)[tableView dequeueReusableCellWithIdentifier:zPostCellReuseIdentifier];
        cell.mPostCommentTextField.delegate = self;
        return cell;
    }
    else if (indexPath.section == 2)
    {
        WUCommentCell *cell = (WUCommentCell *)[tableView dequeueReusableCellWithIdentifier:zCommentCellReuseIdentifier];
        NSString *eventTimeText = nil;

        NSDictionary *commentInfo = mPinComments[indexPath.row];
        NSString *thumbURLString = commentInfo[@"Member_Info"][@"Member_Pic"];
        NSString *thumbFileName = [thumbURLString lastPathComponent];
        NSURL *thumbURL = [NSURL URLWithString:thumbURLString];
       
        UIImage* img = [mImageCache imageForKey: thumbFileName url: thumbURL queueIfNeeded:YES tag:indexPath.row];
        cell.mProfileImageView.image = img;
        
        cell.mAuthorLabel.text = commentInfo[@"Member_Info"][@"Member_User_Name"];
        cell.mMessageLabel.text = commentInfo[@"Comment_Text"];
        eventTimeText = commentInfo[@"Comment_Created"];
        
        static NSDateFormatter *rawDateFormatter =  nil;
        if (rawDateFormatter == nil) {
            rawDateFormatter = [[NSDateFormatter alloc] init];
            [rawDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        }
        NSDate *rawDate = [rawDateFormatter dateFromString:eventTimeText];
        //NSLog(@"date : %@",date);
        NSDate *destinationDate = [rawDate dateFromUTCtoLocalTime];
        
        
        cell.mPostedTimeLabel.text = [destinationDate timeAgoFormat];
        
        cell.layer.borderColor = [UIColor grayColor].CGColor;
        cell.layer.borderWidth = 1.0f;
        
        return cell;

        

    }
    
    //cell.layer.borderColor = [UIColor grayColor].CGColor;
   // cell.layer.borderWidth = 1.0f;

 	return nil;
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //do your operations
    
    //send it to super class
    NSLog(@"share pin touches began is called.....");
    
    
}




-(void)pinImgCellTapped:(UITapGestureRecognizer*)tapRecognizer
{
    NSLog(@"pinImgCellTapped %d",tapRecognizer.state);

    if (tapRecognizer.state == UIGestureRecognizerStateBegan) {
        
    }
    else if (tapRecognizer.state == UIGestureRecognizerStateCancelled) {
        
    }
    
}




-(void)inAppBrowerPressed:(id)sender
{
    InAppBrowserVC *inAppBrowserVC = [[InAppBrowserVC alloc] initWithNibName:[WUUtilities xibBundlefileName:@"InAppBrowserVC"] bundle:nil];
    
    NSString* mPinUrl = self.mPinInfo[@"Pin_URL"];
    inAppBrowserVC.mURLString = mPinUrl;
    [self.navigationController pushFadeViewController:inAppBrowserVC];
}


-(void)likePin:(id)sender
{
    NSString *pinID = mPinID;
    WUBoardServices* boardServices = [WUBoardServices sharedWUBoardServices];
    [boardServices likePin:pinID likeStatus:YES completionBlock:^(id JSON, NSError *error) {
      
        if(error == nil){
            [UIAlertView showAlertMessage:@"Pin Liked!"];
        }
        [self animateOutOverlay];
    }];
    
}

-(void)share:(id)sender
{
   // [self animateOutOverlay];
    WUPostCommentCell *cell = (WUPostCommentCell *)[mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
      if([cell.mPostCommentTextField canBecomeFirstResponder]){
          [cell.mPostCommentTextField resignFirstResponder];
          [cell.mPostCommentTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0];
    }
    
}

-(void)animateInOverlay{
    self.mOverlayView.alpha = 0.0f;
    [self.view addSubview:self.mOverlayView];
    [UIView animateWithDuration:0.1 animations:^{
        self.mOverlayView.alpha = 0.80f;
    }];
}

-(void)animateOutOverlay{
    [UIView animateWithDuration:0.2f animations:^{
        self.mOverlayView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.mOverlayView removeFromSuperview];
    }];
}




#pragma mark - Public Interface Methods for sharing Pin


-(void) shareScrapPin:(NSDictionary*)pinParams WithDelegate:(id <WUActionDelegate>)delegate
{
    /*
     NSDictionary *infoDict = @{@"boardID":kSampleBoardId,
     @"image":[UIImage imageNamed:@"icon.png"],
     @"title": @"Demo",
     @"description":@"Desc"};
     */
    
    pinDelegate = delegate;
    
    if(pinParams[kKeyBoardLinkKey] == nil)
    {
        NSAssert(pinParams[kKeyBoardLinkKey], @"WeUnite Pin --> Scrap Board Link Key is mandatory");
        return;
    }
    
    if (pinParams[@"title"] == nil) {
        NSAssert(pinParams[@"title"], @"WeUnite Pin --> Title is mandatory");
        return;
    }
    
    if (pinParams[@"image"] == nil) {
        NSAssert(pinParams[@"image"], @"WeUnite Pin --> Image is mandatory");
        return;
    }
    
    
    
    //All Mandatory fields are present so now get values...
    if ([pinParams[@"image"] isKindOfClass:[UIImage class]]) {
        mPinImage = pinParams[@"image"];
        mScrapPinImgUrl = nil;
    }
    else{
        [self loadPinImageFromUrl:pinParams[@"image"]];
        mScrapPinImgUrl = pinParams[@"image"];
    }
    
    mBoardID = pinParams[kKeyBoardLinkKey];
    mPinTitle = pinParams[@"title"];
    mPinDescription = pinParams[@"description"] == nil ? @"" : pinParams[@"description"];
    wuShareEntityType = pinParams[@"shareType"] == nil ? 1 : [pinParams[@"shareType"] intValue];
    
    NSLog(@"mBoardId %@, mPinTitle %@, mPinDesc %@, share %d",mBoardID, mPinTitle, mPinDescription, wuShareEntityType);
    
    self.mPinInfo = [
                     @{@"Data_1": mPinTitle,
                       @"Data_2": mPinDescription,
                       @"Data_3": mPinImage,
                       @"Data_4": [NSNull null],
                       @"Data_5": @"image",
                       @"View_Count": @"1"
                       } mutableCopy];
    

    [mTableView reloadData];
    [self performSelectorInBackground:@selector(createScrapBoardPin) withObject:nil];
    
}





-(void) sharePin:(NSDictionary*)pinParams WithDelegate:(id <WUActionDelegate>)delegate
{
    /*
     NSDictionary *infoDict = @{@"boardID":kSampleBoardId,
     @"image":[UIImage imageNamed:@"icon.png"],
     @"title": @"Demo",
     @"description":@"Desc"};
     */
    
    pinDelegate = delegate;
    
    NSLog(@"pinParams[kKeyBoardLinkKey]  %@",pinParams[kKeyBoardLinkKey] );
    
    if(pinParams[kKeyBoardLinkKey] == nil)
    {
        NSAssert(pinParams[kKeyBoardLinkKey], @"WeUnite Pin --> Board Key is mandatory");
        return;
    }
    
    if (pinParams[@"title"] == nil) {
        NSAssert(pinParams[@"title"], @"WeUnite Pin --> Title is mandatory");
        return;
    }
    
    if (pinParams[@"image"] == nil) {
        NSAssert(pinParams[@"image"], @"WeUnite Pin --> Image is mandatory");
        return;
    }

    
    
    //All Mandatory fields are present so now get values...
    if ([pinParams[@"image"] isKindOfClass:[UIImage class]]) {
        mPinImage = pinParams[@"image"];
    }
    else{
        [self loadPinImageFromUrl:pinParams[@"image"]];
    }

    NSLog(@"mpin image is %@",mPinImage);
    
    mBoardID = pinParams[kKeyBoardLinkKey];
    mPinTitle = pinParams[@"title"];
    mPinDescription = pinParams[@"description"] == nil ? @"" : pinParams[@"description"];
    wuShareEntityType = pinParams[@"shareType"] == nil ? 1 : [pinParams[@"shareType"] intValue];
    
    
    
    self.mPinInfo = [
                     @{@"Data_1": mPinTitle,
                     @"Data_2": mPinDescription,
                     @"Data_3": mPinImage,
                     @"Data_4": [NSNull null],
                     @"Data_5": @"image",
                     @"View_Count": @"1"
                     } mutableCopy];
    
    
    NSLog(@"self.mPinInfo %@",self.mPinInfo);

    [mTableView reloadData];
    
    [self performSelectorInBackground:@selector(createBoardPin) withObject:nil];


}



//Share Pin with existing WeUnite Pin Id.
-(void) openPin:(NSDictionary*)params WithDelegate:(id <WUActionDelegate>)delegate
{
    pinDelegate = delegate;
    mPinID = params[@"pinKey"];
    wuShareEntityType = params[@"shareType"] == nil ? 1 : [params[@"shareType"] intValue];
    
    [self loadPinInfo:mPinID];
}




-(void) setMBoardID:(NSString *)mBoardKey WithDelegate:(id <WUActionDelegate>)delegate
{
    mBoardID = mBoardKey;
    pinDelegate = delegate;
}


#pragma mark - Load Pin image from Url

-(void) loadPinImageFromUrl:(NSString*)pinImgUrl
{
    //TODO -- Check right place for this check. It should show when user passes the url.
    if (pinImgUrl == nil || [pinImgUrl length] == 0) {
        [UIAlertView showAlertMessage:@"Image url is not valid. Please check again."];
        return;
    }
    
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:pinImgUrl.urlEncode]];
    mPinImage = [UIImage imageWithData:data];
    NSLog(@"mPinImage %@",mPinImage);
    NSLog(@"load pin image from url %@",pinImgUrl.urlEncode);
}



#pragma mark - Create Pin Method
-(void)createScrapBoardPin
{
    
    NSString *userToken = [WUSharedCache getUserToken];
    
    if (userToken == nil)
    {
        typeOfPostOperation = 2;
        [[WUSharedCache wuSharedCache] performSelectorOnMainThread:@selector(loginWeUnite:) withObject:self waitUntilDone:NO];
        return;
    }
    
    [Base64 initialize];
    
    
    NSDictionary* dict = nil;
  
    

    CLLocation* location = [[WUUtilities sharedWUUtilities] getUserLocation];
    NSString* latitude = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
    NSString* longitude = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];
    
    
    NSLog(@"mScrapPinImgUrl %@",mScrapPinImgUrl);
    if (mScrapPinImgUrl != nil || [mScrapPinImgUrl length] > 0) {
        
        NSString *imageExt = [mPinImgUrl.lastPathComponent.pathExtension lowercaseString];
        NSString *imageType = (imageExt != nil) ? [NSString stringWithFormat:@"image/%@",imageExt]: @"image/jpg";
        
       
        
        // Pass ImageURL to server
        dict = @{
                         @"Member_Token": userToken,
                         @"Title": mPinTitle,
                         @"Description": mPinDescription,
                         @"Image_Link": mScrapPinImgUrl,
                         @"Image_Type": imageType,
                         @"Longitude": latitude,
                         @"Latitude": longitude,
                         @"Image": @{
                                 @"Name": @"",
                                 @"Content": @"",
                                 @"Content_Type": @""
                                 }
                 };
        
        
    }
    else{
        
        // Pass Image object to server
        NSData* imgData = UIImageJPEGRepresentation(mPinImage, 0.7);
        NSString *pinImage64 = [Base64 encode:imgData];
        
        dict = @{
                 @"Member_Token": userToken,
                         @"Title": mPinTitle,
                         @"Description": mPinDescription,
                         @"Image_Link": pinImage64,
                         @"Image_Type": @"image/jpeg",
                         @"Longitude": latitude,
                         @"Latitude": longitude,
                         @"Image": @{
                                 @"Name": @"",
                                 @"Content": @"",
                                 @"Content_Type": @""
                                 }
                         
                 };
        
        
    }
    
    [SVProgressHUD showInView:self.view];
    
    WUBoardServices *boardServices = [WUBoardServices sharedWUBoardServices];
    [boardServices  createScrapPinForBoardID:mBoardID memberID:userToken  pinProperties:dict completionBlock:^(id JSON, NSError *error)
     {
        
         
         NSLog(@"createPinForBoardID %@ %@",JSON,error);
         
         if (error != nil) {
             //TOOD- Improve Message description as per error
             NSDictionary *errorInfo =[NSDictionary dictionaryWithObject:@"Sorry, There is problem in creating Pin."forKey:NSLocalizedDescriptionKey];
             
             NSError *outError = [NSError errorWithDomain:@"Pin Creation error" code:501 userInfo:errorInfo];
             
             
             NSDictionary* pinErrorResponse = @{kResponseActionKey:kActionNewPinKey,
                                                outError:kResponseErrorKey};
             [pinDelegate wuActionResponse:NO params:pinErrorResponse];
             
             return ;
         }
         
         NSDictionary *jsonInfo = (NSDictionary *)JSON;
         mPinID = jsonInfo[@"Data"][@"Board_Data_Id"];
         NSLog(@"mPinID %@",mPinID);
         
         NSDictionary* pinResponse = @{kResponseActionKey:kActionNewPinKey,
                                       @"pinKey":mPinID};
         
         [pinDelegate wuActionResponse:YES params:pinResponse];
         
         
         //Load PIN Info as it has high priority.
         [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(loadPinInfo:) userInfo:mPinID repeats:NO];
         
         
         [SVProgressHUD dismiss];
         
     }];
}






#pragma mark - Create Pin Method
-(void)createBoardPin
{
    
    NSString *userToken = [WUSharedCache getUserToken];
    
    if (userToken == nil)
    {
        
        typeOfPostOperation = 0;
        [[WUSharedCache wuSharedCache] performSelectorOnMainThread:@selector(loginWeUnite:) withObject:self waitUntilDone:NO];
        return;
    }
    
    [Base64 initialize];
    
    
    NSDictionary* dict = nil;
    
    //Set Image name
    NSTimeInterval interval = [[NSDate  date]timeIntervalSinceReferenceDate];
    
    
    if (mPinImgUrl != nil || [mPinImgUrl length] > 0) {
        
        NSString *fileName = [NSString stringWithFormat:@"image%lld.png",(long long)ceilf(interval)];
        
        // Pass ImageURL to server
        dict = @{
                 @"Data": @{
                         @"Member_Access_Token": userToken,
                         @"Title": mPinTitle,
                         @"Description_1": mPinDescription,
                         @"Description_2": @"desc2",
                         @"Image_Content": @{
                                 @"FileName": fileName,
                                 @"FileContent": mPinImgUrl,
                                 @"ContentType": @"image/png"
                                 }
                         }
                 };
        
        
    }
    else{
        
        NSString *fileName = [NSString stringWithFormat:@"image%lld.jpeg",(long long)ceilf(interval)];
        
        // Pass Image object to server
        NSData* imgData = UIImageJPEGRepresentation(mPinImage, 0.7);
        NSString *pinImage64 = [Base64 encode:imgData];
        
        dict = @{
                 @"Data": @{
                         @"Member_Access_Token": userToken,
                         @"Title": mPinTitle,
                         @"Description_1": mPinDescription,
                         @"Description_2": @"desc2",
                         @"Image_Content": @{
                                 @"FileName": fileName,
                                 @"FileContent": pinImage64,
                                 @"ContentType": @"image/jpeg"
                                 }
                         }
                 };
        
        
    }
    
    [SVProgressHUD showInView:self.view];
    
    
    WUBoardServices *boardServices = [WUBoardServices sharedWUBoardServices];
    NSLog(@"mBoardID %@",mBoardID);
    [boardServices  createPinForBoardID:mBoardID memberID:userToken  pinProperties:dict completionBlock:^(id JSON, NSError *error)
    {
       // NSLog(@"createPinForBoardID %@ %@",JSON,error);
        
        if (error != nil) {
            //TOOD- Improve Message description as per error
            NSDictionary *errorInfo =[NSDictionary dictionaryWithObject:@"Sorry, There is problem in creating Pin."forKey:NSLocalizedDescriptionKey];
            
            NSError *outError = [NSError errorWithDomain:@"Pin Creation error" code:501 userInfo:errorInfo];
            
            
            NSDictionary* pinErrorResponse = @{kResponseActionKey:kActionNewPinKey,
                                               outError:kResponseErrorKey};
            [pinDelegate wuActionResponse:NO params:pinErrorResponse];
            
            return ;
        }
        
        NSDictionary *jsonInfo = (NSDictionary *)JSON;
        mPinID = jsonInfo[@"Board"][@"Pin_Info"][@"Pin_Id"];
        NSLog(@"mPinID %@",mPinID);
        
        //Load PIN Info as it has high priority.

        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(loadPinInfo:) userInfo:mPinID repeats:NO];
        

        
        NSDictionary* pinResponse = @{kResponseActionKey:kActionNewPinKey,
                                      @"pinKey":mPinID};
        [pinDelegate wuActionResponse:YES params:pinResponse];
        
        
        
        [SVProgressHUD dismiss];
        
    }];
}







#pragma mark - Load Pin and Comments Methods

-(void)loadPinInfo:(NSString*)pinKey
{
    
    WUBoardServices *boardServices = [WUBoardServices sharedWUBoardServices];
    [boardServices getPinInfoForPinID:mPinID completionBlock:^(id JSON, NSError *error) {
        
        self.mPinInfo = JSON;
        NSLog(@"----------- mpininfo is %@",self.mPinInfo);
        [mTableView reloadData];
        
        //As Pin Info is loaded so now load Pin Comments
        [self loadPinComments];
    }];

    
}

-(void)loadPinComments{
    double delayInSeconds = 0.10;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        WUBoardServices *boardServices = [WUBoardServices sharedWUBoardServices];
        [boardServices getCommentsForPinID:mPinID completionBlock:^(id JSON, NSError *error)
         {
             if (error == nil) {
                 if ([JSON isKindOfClass:[NSDictionary class]])
                 {
                     mPinComments = [[NSArray alloc] initWithObjects:JSON, nil];
                 }
                 else{
                     mPinComments = JSON;
                 }
                 [mTableView reloadData];
             }
             
             
             [_mActivity stopAnimating];
             
             NSLog(@"comment Count %d",mPinComments.count);
         }];

    });
}








#pragma mark - Post comment on a Pin

-(void)postComment:(NSString *)comment
{
    NSString *memberID = [WUSharedCache getUserToken];

    if (memberID == nil) {
        
        typeOfPostOperation = 1;
        mPinDescription = comment;
        [[WUSharedCache wuSharedCache] performSelectorOnMainThread:@selector(loginWeUnite:) withObject:self waitUntilDone:NO];
        return;
    }
    
    WUBoardServices* services = [WUBoardServices sharedWUBoardServices];
    [services comment:comment pinId:mPinID ForMember:memberID completionBlock:^(id JSON, NSError *error) {
        
        
        
       // NSLog(@"Pin post comment response %@ and error %@",JSON,error);
        NSString *message = nil;
        
        if (error==nil)
        {
            message = @"Posting successfull";
            [self loadPinComments];
            
        }
        else {
            message = @"Posting failure";
        }
        [UIAlertView showAlertMessage:message];
    }];
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
        if (typeOfPostOperation == 0) {
            [self createBoardPin];
        }
        else if(typeOfPostOperation == 1){
            [self postComment:mPinDescription];
        }
        else if(typeOfPostOperation == 2){
            [self createScrapBoardPin];
        }

        return;
    }
    
    
    
    
}











#pragma mark - Keyboard handling methods for posting on passion

-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    
	CGRect containerFrame = mTableView.frame;
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    mTableView.height = containerFrame.size.height -keyboardBounds.size.height;
	[UIView commitAnimations];
    [self performSelector:@selector(adjustTableViewForPost) withObject:nil afterDelay:[duration doubleValue]];
}


-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	mTableView.height = self.view.height-44;
	
	// commit animations
	[UIView commitAnimations];
    mTableView.scrollEnabled = YES;
}






-(void)adjustTableViewForPost{
    
    [mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    mTableView.scrollEnabled = NO;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self postComment:textField.text];
    textField.text = @"";
    [textField resignFirstResponder];
    return YES;
}




#pragma mark - Image Cache Delegate Methods

- (void) newImageRetrieved:(NSNotification*)sender{
	NSDictionary *dict = [sender userInfo];
	NSInteger tag = [dict[@"tag"] intValue];
	NSArray *paths = [mTableView indexPathsForVisibleRows];
    
    if (tag == 100) {
        WUMainCell *mainCell = (WUMainCell *)[mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UIImage* img = dict[@"image"];
        mainCell.mWUMainImageView.image = img;
        return;
    }
    
	for(NSIndexPath *path in paths){
		NSInteger index = path.row;
		
		WUCommentCell *cell = (WUCommentCell*)[mTableView cellForRowAtIndexPath:path];
        if(cell.imageView.image == nil && tag == index && path.section == 2){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage* img = dict[@"image"];
                cell.mProfileImageView.image = img;
                [cell setNeedsLayout];
            });
		}
	}
}



- (void)viewDidUnload {
    [self setMPinTitle:nil];
    [self setMActivity:nil];
    [super viewDidUnload];
}
@end
