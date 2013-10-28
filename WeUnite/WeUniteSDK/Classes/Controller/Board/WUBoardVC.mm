//
//  WUBoardVC.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 04/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WUBaseVC.h"
/////Extensions
#import "Foundation+Extensions.h"
#import "UIKit+Extensions.h"

/////ViewControllers
#import "WUBoardVC.h"
#import "WUCommentsVC.h"
#import "WUPinCreateVC.h"
#import "WUCommentsVC.h"

/////Cells
#import "WUBoardPinCell.h"
#import "CommentCell.h"
#import "MainPassionCell.h"
#import "WUPostCommentCell.h"
#import "WUCommentCell.h"

////Others
#import "TKImageCache.h"
#import "WUSharedCache.h"
#import "StackedGridLayout.h"
#import "WUConstants.h"
#import "EGORefreshTableHeaderView.h"

#import "WUUtilities.h"
#import "WUBoardServices.h"
#import "EXTScope.h"

#import "WUHowerGestureRecognizer.h"

#import "WUSharedCache.h"
#import "WUDeleteVC.h"
#import "WUConfiguration.h"

#import "InAppBrowserVC.h"

@interface WUBoardVC ()
{
    NSMutableDictionary *mImageSizeInfo;
}
@end

@implementation WUBoardVC
@synthesize mComments,mPins,mBoardInfo;
@synthesize mBoardParams, mBoardID;
@synthesize mActivity,mBoardPinCollectionView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.mBoardInfo = nil;
    self.mPins = nil;
    self.mComments = nil;
    mProfilePicImageCache = nil;
    mPinImageCache = nil;
    mSelectedPinInfo = nil;
    self.mBoardPinCollectionView = nil;
    egoPullView = nil;
    NSLog(@"%s",__func__);
   // [self.view removeAllSubviews];
    //[super dealloc];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [mCreatePinButton setBackgroundImage:[WUUtilities imageNamed:@"Plus.png"] forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view from its nib.
    //self.mBoardID = mBoardParams[kKeyBoardLinkKey];
    
    self.mPins = [NSMutableArray arrayWithCapacity:0];
    
  //  [WUUtilities findCurrentLocation];
    
    [self setUpImageCaching];
    [self loadNextPins];
    [self addPullToRefresh];
    [self registerCells];
    [self addGestures];
    
  /*
    NSArray *allURLs = @[
                         @"http://myntra.myntassets.com/images/banners/1378461781-Madura1_HPB_mini.jpg",
                         @"http://myntra.myntassets.com/images/banners/1378386289-pepe_SubBanner_mini.jpg",
                         @"http://myntra.myntassets.com/images/banners/1378463977-trend_jeans_HPB_2_mini.jpg",
                         @"http://i.imgur.com/RDh3i.png"];
*/
   // [self startDownloading:allURLs forID:@"a" completionBlock:NULL];
    
    
    
    self.mBoardPinCollectionView.collectionViewLayout = [[StackedGridLayout alloc] init];
    //[self segmentItemPressed:nil];
}

#pragma mark - IBAction button handling

-(IBAction)backItemPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)createNewPinPressed:(id)sender {
    
    WUPinCreateVC *pinCreate = [[WUPinCreateVC alloc] initWithNibName:[WUUtilities xibBundlefileName:@"WUPinCreateVC"] bundle:nil];
    pinCreate.mBoardID = self.mBoardID;
    [self.navigationController pushViewController:pinCreate
                                         animated:YES];
}

-(void)addPullToRefresh{
    egoPullView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.mBoardPinCollectionView.bounds.size.height, self.mBoardPinCollectionView.frame.size.width, self.mBoardPinCollectionView.bounds.size.height)];
    
    //NSLog(@"view is %@",view);
    egoPullView.delegate = self;
    [self.mBoardPinCollectionView addSubview:egoPullView];
}


-(void)setUpImageCaching{
    mProfilePicImageCache = [[TKImageCache alloc] initWithCacheDirectoryName:@"Board/ProfilePics"];
    [mProfilePicImageCache setImageSize:CGSizeMake(150, 200)];
    NSString *notificationName = [NSString stringWithFormat:@"self Profile %@",self];
	mProfilePicImageCache.notificationName = notificationName;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileImageRetrieved:) name:notificationName object:nil];
    
    mPinImageCache = [[TKImageCache alloc] initWithCacheDirectoryName:@"Board/PinPics"];
    notificationName = [NSString stringWithFormat:@"self Pin %@",self];
    [mPinImageCache setImageSize:CGSizeMake(150, 200)];
	mPinImageCache.notificationName = notificationName;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pinImageRetrieved:) name:notificationName object:nil];
}

-(void)profileImageRetrieved:(NSNotification*)sender{
    /*
	NSDictionary *dict = [sender userInfo];
	//NSInteger tag = [dict[@"tag"] intValue];
	NSArray *paths = [mTableView indexPathsForVisibleRows];
	for(NSIndexPath *path in paths){
        if ([path section] == 0 && path.row == 0) {
            MainPassionCell *cell = (MainPassionCell *)[mTableView cellForRowAtIndexPath:path];
            UIImage* img = dict[@"image"];
            cell.mPassionImageView.image = img;
            [cell setNeedsLayout];
        }
    }
     */
}

-(void)pinImageRetrieved:(NSNotification*)sender{
	NSDictionary *dict = [sender userInfo];
	NSInteger tag = [dict[@"tag"] intValue];
	NSArray *paths = [self.mBoardPinCollectionView indexPathsForVisibleItems];
	for(NSIndexPath *path in paths){
        if (path.row == tag) {
            WUBoardPinCell *pinCell = (WUBoardPinCell *)[self.mBoardPinCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
            pinCell.mPinImageView.image = dict[@"image"];
            [pinCell setNeedsLayout];
            break;
        }
    }
}




-(void)registerCells{
    ////Board Cells
    [self.mBoardPinCollectionView registerNib:[UINib nibWithNibName:[WUUtilities xibBundlefileName:@"WUBoardPinCell"] bundle:nil] forCellWithReuseIdentifier:@"WUBoardPinCell"];
}

-(void)addGestures
{
    WUHowerGestureRecognizer *gr = [[WUHowerGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(howerGesture:)];
    gr.minimumPressDuration = 0.25f;
    [self.mBoardPinCollectionView addGestureRecognizer:gr];
}

//////////////////
#pragma mark plain delegate


#pragma mark 2 Column Grid Implementation
- (NSInteger)collectionView:(UICollectionView*)cv
                     layout:(UICollectionViewLayout*)cvl
   numberOfColumnsInSection:(NSInteger)section
{
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)cv
                        layout:(UICollectionViewLayout*)cvl
   itemInsetsForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.0f, 5.0f, 10.0f, 5.0f);
}

- (CGSize)collectionView:(UICollectionView*)cv layout:(UICollectionViewLayout*)cvl
    sizeForItemWithWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    //CGSize retval = CGSizeMake(150, 200);
    NSDictionary *pinInfo = self.mPins[indexPath.row];
    float totalHeight = 0;
    
    totalHeight+= [self getPinImageSize].height;
    totalHeight+=2;
    
    NSString *descText = pinInfo[@"Data_2"];
    if (![descText isKindOfClass:[NSNull class]]) {
        totalHeight+= [self getDescriptionTextSizeForText:descText].height;
    }
    
    totalHeight+=2;
    
    NSString *otherText  = [NSString stringWithFormat:@"Likes:10  Comments:10"];
    CGSize otherTextSize = [self getDescriptionTextSizeForText:otherText];
    totalHeight += otherTextSize.height + 14.0;
    
    return CGSizeMake(150,totalHeight);
}



-(NSInteger)collectionView:(UICollectionView*)cv numberOfItemsInSection:(NSInteger)section {
    
    return self.mPins.count;
}



- (UICollectionViewCell*)collectionView:(UICollectionView*)cv cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    WUBoardPinCell *cell = (WUBoardPinCell*)[cv dequeueReusableCellWithReuseIdentifier:@"WUBoardPinCell" forIndexPath:indexPath];
    
    if(indexPath.row == self.mPins.count-1){
        [self loadNextPins];
    }
    
    
    if (cell.mLikeButton.allTargets.count==0) {
       // cell.mLongPressGestureRecognizer = [[WUHowerGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPressedWithGestureRegonizer:)];
        //[cell addGestureRecognizer:cell.mLongPressGestureRecognizer];
        [cell.mLikeButton addTarget:self action:@selector(likePinItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSLog(@"index path row is %d and row is %@",indexPath.row, self.mPins[indexPath.row]);
    
    NSDictionary *pinInfo = self.mPins[indexPath.row];
    
    NSLog(@"pin info is %@",pinInfo);
    
    NSString *imageURLString = pinInfo[@"Data_3"];
    cell.mPinImageView.image = [mPinImageCache imageForKey:imageURLString.lastPathComponent url:[NSURL URLWithString:imageURLString] queueIfNeeded:YES tag:indexPath.row];

    if (cell.mPinImageView.image == nil) {
        float colorVal = (arc4random() / (float)0x7fffffff );
        cell.mPinImageView.backgroundColor = [UIColor colorWithRed:colorVal green:colorVal blue:colorVal alpha:1.0f];
    }
    
    float frameY = 0;
    CGSize imageSize = [self getPinImageSize];
    cell.mPinImageView.size = imageSize;
    
    
    
    frameY += imageSize.height;
    frameY += 2;
    
    NSString *descText = pinInfo[@"Data_2"];
    CGSize descSize = CGSizeZero;
    if (![descText isKindOfClass:[NSNull class]]) {
        descSize = [self getDescriptionTextSizeForText:descText];
        cell.mDescriptionLabel.text = descText;
    }
    
    cell.mDescriptionLabel.top = frameY;
    cell.mDescriptionLabel.height = descSize.height;
    
    frameY = cell.mDescriptionLabel.bottom;
    frameY += 2;
    
    NSString *likeCount = pinInfo[@"Like_Count"];
    NSString *commentCount = pinInfo[@"Comment_Count"];
    
    
    cell.mLikeImageView.image = [WUUtilities imageNamed:@"Like.png"];
    cell.mCommentImgView.image = [WUUtilities imageNamed:@"Chat.png"];
    cell.mLikesCountLabel.text = likeCount;
    cell.mCommentsCountLabel.text = commentCount;
    
    
    cell.mLikesCountLabel.top = frameY;
    cell.mLikeImageView.top = frameY;
    cell.mCommentsCountLabel.top = frameY;
    cell.mLikeButton.top = frameY;
    cell.mCommentImgView.top = frameY;
    
    [cell addRoundedEdgesWithCornerRadius:5];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSDictionary *pinInfo = self.mPins[indexPath.row];
    NSLog(@"pin info is %@",pinInfo);
    
    NSString* boardId = pinInfo[@"Board_Id"];
    NSString* pinId = pinInfo[@"Pin_Id"];
    NSString* pinType = pinInfo[@"Data_5"];
    NSString* pinImgVideo = pinInfo[@"Data_3"];

    
    NSLog(@"boardId %@, pinId %@, pinImgVideo %@, pinType %@",boardId, pinId, pinImgVideo, pinType);
    
   
    

    WUCommentsVC* pinVC = [[WUCommentsVC alloc] initWithNibName:[WUUtilities xibBundlefileName:@"WUCommentsVC"] bundle:nil];
    pinVC.mPassionLinkKey = boardId;
    pinVC.mFullPinInfo = pinInfo;
    pinVC.mCommentType = kBoardPinScreen;
    [self.navigationController pushViewController:pinVC animated:YES];
    
}





#pragma mark CollectionCellSizeComponent getters

-(CGSize)getPinImageSize{
    return CGSizeMake(150, 140);
}

-(CGSize)getDescriptionTextSizeForText:(NSString *)text{
    if ([text isKindOfClass:[NSNull class]]) {
        return CGSizeZero;
    }
    
    
    static UILabel *label =  nil;
    if(!label){
        label = [[UILabel alloc]init];
        label.numberOfLines = 2;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.font = [UIFont systemFontOfSize:12];
    }
    label.width = 150;
    label.text = text;
    [label sizeToFit];
    
    return label.size;
}

-(CGSize)getOtherInfoTextSizeForText:(NSString *)text{
    static UILabel *label =  nil;
    if(!label){
        label = [[UILabel alloc]init];
        label.numberOfLines = 1;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.font = [UIFont systemFontOfSize:12];
    }
    label.width = 150;
    label.text = text;
    [label sizeToFit];
    
    return label.size;
}

#pragma mark - Lazy Loading
-(void)showEgoRefreshView{

}

-(void)hideEgoRefreshView{
    mIsLoading = NO;
    [egoPullView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mBoardPinCollectionView];
}

-(void)reloadPin:(NSDictionary *)pinInfo{
    
    mIsLoading = YES;
    [self.mActivity startAnimating];
    
    int index = [self.mPins indexOfObject:pinInfo];
    
    if (index == NSNotFound) {
        return;
    }
    
    NSLog(@"index is %d",index);
    
    WUBoardServices* services = [WUBoardServices sharedWUBoardServices];
    
    @weakify(self);
    [services getBoardPinsForBoardID:self.mBoardID offset:index limit:1 completionBlock:^(id JSON, NSError *error) {
        @strongify(self);
        
        [self hideEgoRefreshView];
        
        
        if (error == nil) {
            NSDictionary *allInfo = (NSDictionary *)JSON;
            NSDictionary *refreshedItem = allInfo[@"Board"][@"Item"];
            
            if (refreshedItem != nil && [refreshedItem isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"replacng object is %@",self.mPins[index]);
                
                [self.mPins replaceObjectAtIndex:index withObject:refreshedItem];
                NSLog(@"replacng object is %@",self.mPins[index]);
                
                [self.mBoardPinCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
            }
            [self.mActivity stopAnimating];
        }
    }];
}

-(void)loadNextPins
{
    mIsLoading = YES;
    [self.mActivity startAnimating];
    
    WUBoardServices* services = [WUBoardServices sharedWUBoardServices];
    
    @weakify(self);
   [services getBoardPinsForBoardID:self.mBoardID offset:self.mPins.count limit:15 completionBlock:^(id JSON, NSError *error) {
       @strongify(self);
     
        [self hideEgoRefreshView];

       
        if (error == nil) {
            NSDictionary *allInfo = (NSDictionary *)JSON;
            NSArray *newItems = allInfo[@"Board"][@"Item"];
            
            if([newItems isKindOfClass:[NSDictionary class]]){
                newItems = @[newItems];
            }
            
            if (newItems.count!=0) {
                [self.mPins addObjectsFromArray:newItems];
                [self.mBoardPinCollectionView reloadData];
            }
            
            [self.mActivity stopAnimating];
        }
    }];
}

-(void)reloadPins{
    mIsLoading = YES;
   
    WUBoardServices* services = [WUBoardServices sharedWUBoardServices];
    
    @weakify(self);
    [services getBoardPinsForBoardID:self.mBoardID offset:0 limit:self.mPins.count completionBlock:^(id JSON, NSError *error) {
        @strongify(self);
        [self hideEgoRefreshView];

        
        if (error == nil) {
            //MainPassionCell *cell = (MainPassionCell *)[mTableView dequeueReusableCellWithIdentifier:zMainPassionCellReuseIdentifier];
            NSDictionary *allInfo = (NSDictionary *)JSON;
            [self.mPins removeAllObjects];
            NSArray *newItems = allInfo[@"Board"][@"Item"];
            
            if (newItems.count!=0) {
                [self.mPins addObjectsFromArray:newItems];
            }
            [self.mBoardPinCollectionView reloadData];
        }
    }];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [egoPullView egoRefreshScrollViewDidScroll:scrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
    [egoPullView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -  EGO Pull Refresh Delegates

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadPins];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return mIsLoading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark - Gesture recognizers
- (void)cellLongPressedWithGestureRegonizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer{
   
    return;
    
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        WUBoardPinCell *pinCell = (WUBoardPinCell *)longPressGestureRecognizer.view;
        
        if([pinCell isKindOfClass:[WUBoardPinCell class]]){
            [UIView animateWithDuration:0.2f animations:^{
                pinCell.alpha = 0.75f;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    pinCell.alpha = 1.0f;
                }];
            }];
            
           /*
            NSIndexPath *indexPath= [mBoardPinCollectionView indexPathForCell:pinCell];
            NSLog(@"%@",indexPath);
            mSelectedPinInfo = self.mPins[indexPath.row];
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pin Board" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Like",@"Share",@"Mail",nil];
            [actionSheet showInView:self.view];*/
        }
    }
}

-(void)howerGesture:(WUHowerGestureRecognizer *)gestureRecog
{
    
    NSLog(@"gestureRecog.state %d",gestureRecog.state);
    if (gestureRecog.state == UIGestureRecognizerStateBegan) {

        CGPoint tapPoint = [gestureRecog locationInView:self.mBoardPinCollectionView];
        
        NSIndexPath *indexPath = (NSIndexPath *)[mBoardPinCollectionView indexPathForItemAtPoint:tapPoint];
        
        mSelectedPinInfo = self.mPins[indexPath.row];
   
    }
}


-(void)sharePinPressed:(CGPoint)anchorPoint
{
    
    NSIndexPath *indexPath = (NSIndexPath *)[mBoardPinCollectionView indexPathForItemAtPoint:anchorPoint];
    
    mSelectedPinInfo = self.mPins[indexPath.row];
    NSLog(@"pin info is %@",mSelectedPinInfo);
    
    
    
    WUCommentsVC* pinVC = [[WUCommentsVC alloc] initWithNibName:[WUUtilities xibBundlefileName:@"WUCommentsVC"] bundle:nil];
    pinVC.mPassionLinkKey = mSelectedPinInfo[@"Board_Id"];
    pinVC.mFullPinInfo = mSelectedPinInfo;
    pinVC.mCommentType = kBoardPinScreen;
    [self.navigationController pushViewController:pinVC animated:YES];
    
}


-(void)linkPinPressed:(CGPoint)anchorPoint
{
    NSIndexPath *indexPath = (NSIndexPath *)[mBoardPinCollectionView indexPathForItemAtPoint:anchorPoint];
    
    mSelectedPinInfo = self.mPins[indexPath.row];
    NSLog(@"pin info is %@",mSelectedPinInfo);
    
    
    InAppBrowserVC *inAppBrowserVC = [[InAppBrowserVC alloc] initWithNibName:[WUUtilities xibBundlefileName:@"InAppBrowserVC"] bundle:nil];
    
    NSString* mPinUrl = mSelectedPinInfo[@"Pin_URL"];
    inAppBrowserVC.mURLString = mPinUrl;
    [self.navigationController pushFadeViewController:inAppBrowserVC];

}



-(void)likePinPressed:(CGPoint)anchorPoint
{
    NSIndexPath *indexPath = (NSIndexPath *)[mBoardPinCollectionView indexPathForItemAtPoint:anchorPoint];
    
    mSelectedPinInfo = self.mPins[indexPath.row];
    NSLog(@"pin info is %@",mSelectedPinInfo);
    
    [self likePinItemPressed:nil];
}



-(void)likePinItemPressed:(UIButton *)sender
{

    if (sender != nil) {
        
        WUBoardPinCell *pinCell = (WUBoardPinCell *)sender.superview.superview;
        
        NSIndexPath *indexPath = [mBoardPinCollectionView indexPathForCell:pinCell];
        
        mSelectedPinInfo = self.mPins[indexPath.row];

    }
    
    NSLog(@"mselected pin info is %@",mSelectedPinInfo);
    
     NSString *memberID = [WUSharedCache getUserToken];
    if (memberID == nil) {
        [[WUSharedCache wuSharedCache] loginWeUnite:self];
        typeOfOperation = 1;
        return;
    }
    
    [self likePin];
}

-(void)likePin
{
    NSString *pinID = mSelectedPinInfo[@"Pin_Id"];
    
    WUBoardServices *boardServices = [WUBoardServices sharedWUBoardServices];
    [self.mActivity startAnimating];
    
    @weakify(self);
    [boardServices likePin:pinID likeStatus:YES completionBlock:^(id JSON, NSError *error) {
        @strongify(self);
        
        
        
        NSDictionary *responseDict = (NSDictionary *)JSON;
        int status = [responseDict[@"Pin"][@"Status"] intValue];
        
        if (status == 1) {
            [WUUtilities flashMessage:@"Post Liked Successfully"];
            double delayInSeconds = 0.20;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self reloadPin:mSelectedPinInfo];
            });
        }
        else{
            [WUUtilities flashMessage:@"Cannot update the same status again"];
        }

        
        [self.mActivity stopAnimating];
       
    }];
    
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Like"]) {
        [self likePin];
    }
    else if([buttonTitle isEqualToString:@"Share"]) {
    }
    else if([buttonTitle isEqualToString:@"Mail"]) {
    }
}

- (void)viewDidUnload {
    [self setMActivity:nil];
    [super viewDidUnload];
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
        NSLog(@"typeOfOperation is %d",typeOfOperation);
        
        if (typeOfOperation == 1) {
            
            [self likePin];
        }

        return;
    }
    
    
    
    
}
@end
