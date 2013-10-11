//
//  WUCommentsVC.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 02/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Foundation+Extensions.h"
#import "UIKit+Extensions.h"

#import "WUCommentsVC.h"
#import "CommentCell.h"
#import "MainPassionCell.h"
#import "WUPostCommentCell.h"
#import "WUCommentCell.h"
#import "WUSharedCache.h"

#import "WUBoardServices.h"
#import "WUConstants.h"
#import "WeUnite.h"
#import "TKImageCache.h"
#import "WUUtilities.h"

#import "WUPassionServices.h"
#import "InAppBrowserVC.h"

#import "EXTScope.h"

#import "EGORefreshTableHeaderView.h"

@interface WUCommentsVC ()
{
    IBOutlet UIActivityIndicatorView *mLoadingIndicatorView;
    EGORefreshTableHeaderView *egoPullView;
    BOOL mIsLoading;
}
@end

static NSString *zCommentCellReuseIdentifier = @"WUCommentCell";
static NSString *zCommentCellReuseIdentifier1 = @"WUCommentCell1";
static NSString *zPostCellReuseIdentifier = @"WUPostCommentCell";
static NSString *zMainPassionCellReuseIdentifier = @"MainPassionCell";
static NSString *zMainPassionCellReuseIdentifier1 = @"MainPassionCell1";

@implementation WUCommentsVC

@synthesize mComments;
@synthesize mFullPinInfo,mPassionInfo;
@synthesize mCommentType,mTableView;

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

- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [mImageCache removeAllObjects];
    mImageCache = nil;
    
   
    self.mTableView = nil;
    
    self.mComments = nil;
    self.mFullPinInfo = nil;
    self.mPassionInfo = nil;
    
    
    
    [self.view removeAllSubviews];
    NSLog(@"%s",__func__);
    //[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    [mLoadingIndicatorView stopAnimating];
    
    [WUUtilities findCurrentLocation];
    
    [self loadPassionBasicInfo];
    [self registerTableCells];
    [self setUpImageCaching];
    
    if ([mCommentType isEqualToString:BOARD_PIN_SCREEN]) {
        [self loadPinComments];
        [_mScreenTitle setText:mFullPinInfo[@"Data_1"]];
    }else{
        self.mComments = [NSMutableArray array];
        [self addPullToRefresh];
        [self loadNextPassionComments];
        [self addGestures];
        [_mScreenTitle setText:@"Passion"];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate Methods

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
        return self.mComments.count;
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
        return 350;
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
    
    if (![self.mCommentType isEqualToString:BOARD_PIN_SCREEN]) {
        
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MainPassionCell *cell = nil;
        
        if ([self.mCommentType isEqualToString:BOARD_PIN_SCREEN]) {
            cell = (MainPassionCell *)[tableView dequeueReusableCellWithIdentifier:zMainPassionCellReuseIdentifier];
        }
        else {
            cell = (MainPassionCell *)[tableView dequeueReusableCellWithIdentifier:zMainPassionCellReuseIdentifier1];
        }
        
        cell.mPassionImageView.layer.borderColor = [UIColor grayColor].CGColor;
        cell.mPassionImageView.layer.borderWidth = 0.50f;
        cell.layer.borderColor = [UIColor grayColor].CGColor;
        cell.layer.borderWidth = 1.0f;
        
        UIImage *mainImage = nil;
        NSString *thumbFileName = nil;
        NSURL *thumbURL = nil;
        if ([self.mCommentType isEqualToString:BOARD_PIN_SCREEN]) {

            NSString *thumbURLString = mFullPinInfo[@"Data_3"];
            thumbFileName = [thumbURLString lastPathComponent];
            thumbURL = [NSURL URLWithString:thumbURLString];
           
            
            
            [cell.mLikeBtn addTarget:self action:@selector(likeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
          //  "Group_Picture" = "https://az29184.vo.msecnd.net/newdev-container/WeuniteArt634716527057584410.png";
            NSString *thumbURLString = mPassionInfo[@"Group_Picture"];
            thumbFileName = [thumbURLString lastPathComponent];
            thumbURL = [NSURL URLWithString:thumbURLString];
            [cell.mLikeBtn setHidden:YES];
        }
        
         mainImage = [mImageCache imageForKey: thumbFileName url: thumbURL queueIfNeeded:YES tag:10000];
        cell.mPassionImageView.image = mainImage;
        //[cell.mPassionImageView ]
        return cell;
    }
    else if (indexPath.section ==1) {
        WUPostCommentCell *cell = (WUPostCommentCell *)[tableView dequeueReusableCellWithIdentifier:zPostCellReuseIdentifier];
        cell.mPostCommentTextField.delegate = self;
        return cell;
    }
    else if (indexPath.section == 2)
    {
       
        
        

        NSDictionary *commentInfo = self.mComments[indexPath.row];
        WUCommentCell *cell = nil;
        
        
        NSString *eventTimeText = nil;
        if ([mCommentType isEqualToString:BOARD_PIN_SCREEN])
        {
            
            cell = (WUCommentCell *)[tableView dequeueReusableCellWithIdentifier:zCommentCellReuseIdentifier];
            
            NSString *thumbURLString = commentInfo[@"Member_Info"][@"Member_Pic"];
            
            
            NSString *thumbFileName = [thumbURLString lastPathComponent];
            NSURL *thumbURL = [NSURL URLWithString:thumbURLString];
            UIImage* img = [mImageCache imageForKey: thumbFileName url: thumbURL queueIfNeeded:YES tag:indexPath.row];
            cell.mProfileImageView.image = img;
            
            
            NSString *userName = [NSString stringWithFormat:@"%@",commentInfo[@"Member_Info"][@"Member_User_Name"]];
            cell.mAuthorLabel.text = userName;
            
            NSString *commentText = [NSString stringWithFormat:@"%@",commentInfo[@"Comment_Text"]];
            cell.mMessageLabel.text = commentText;
            eventTimeText = commentInfo[@"Comment_Created"];
            
        }
        else
        {
            
            if(indexPath.row == self.mComments.count-1 && mIsLoading == NO){
                [self loadNextPassionComments];
            }
            
            NSString* message = [WUUtilities decodeForString:commentInfo[@"Message"]];
            
            if ([message hasPrefix:@"<"])
            {
                cell = (WUCommentCell *)[tableView dequeueReusableCellWithIdentifier:zCommentCellReuseIdentifier1];
                [cell.mMessageWebview loadHTMLString:message baseURL:nil];
                cell.mMessageWebview.delegate = self;
            }
            else
            {
                cell = (WUCommentCell *)[tableView dequeueReusableCellWithIdentifier:zCommentCellReuseIdentifier];
                cell.mMessageLabel.text = message;
            }
           
            
            
            NSString *thumbURLString = commentInfo[@"Member_Pic"];
            NSString *thumbFileName = [thumbURLString lastPathComponent];
            NSURL *thumbURL = [NSURL URLWithString:thumbURLString];
            UIImage* img = [mImageCache imageForKey: thumbFileName url: thumbURL queueIfNeeded:YES tag:indexPath.row];
            
            if (img != NULL) {
                cell.mProfileImageView.image = img;
            }
            
            cell.mAuthorLabel.text = commentInfo[@"Member_Name"];
            
            
            
            eventTimeText = commentInfo[@"Date"];
            
            cell.mLikesLabel.hidden = NO;
            
            int likesCount = [commentInfo[@"Like_Count"] integerValue];
            
            
            cell.mLikesLabel.text = [NSString stringWithFormat:@"Likes: %d",likesCount];
        }
        
 
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
    
 	return nil;
}



-(void) textFieldDidBeginEditing:(UITextField *)textField {
    
}


-(void)adjustTableViewForPost{
    
    [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    self.mTableView.scrollEnabled = NO;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self postComment:textField.text];
    textField.text = @"";
    [textField resignFirstResponder];
    return YES;
}

-(void)setUpImageCaching{
    mImageCache = [[TKImageCache alloc] initWithCacheDirectoryName:@"WUPassionCommentImages"];
    NSString *notificationName = [NSString stringWithFormat:@"self %@",self];
	mImageCache.notificationName = notificationName;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newImageRetrieved:) name:notificationName object:nil];
}

-(void)registerTableCells
{
    
    [self.mTableView registerNib:[UINib nibWithNibName:@"WUCommentCell1" bundle:nil] forCellReuseIdentifier:zCommentCellReuseIdentifier1];

    
    [self.mTableView registerNib:[UINib nibWithNibName:@"WUCommentCell" bundle:nil] forCellReuseIdentifier:zCommentCellReuseIdentifier];
    
    
    
    
    [self.mTableView registerNib:[UINib nibWithNibName:@"WUPostCommentCell" bundle:nil] forCellReuseIdentifier:@"WUPostCommentCell"];
    
    
    [self.mTableView registerNib:[UINib nibWithNibName:@"MainPassionCell" bundle:nil] forCellReuseIdentifier:zMainPassionCellReuseIdentifier];
    [self.mTableView registerNib:[UINib nibWithNibName:@"MainPassionCell1" bundle:nil] forCellReuseIdentifier:zMainPassionCellReuseIdentifier1];

}

#pragma mark - Get Passion Posts
-(void)addGestures{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5f; //seconds
    lpgr.delegate = self;
    [self.mTableView addGestureRecognizer:lpgr];
}

-(void)loadPassionComments{
    WUPassionServices* services = [WUPassionServices sharedWUPassionServices];
    [mLoadingIndicatorView startAnimating];
    
    @weakify(self);
    [services getPostsForPassionID:kSamplePassionId completionBlock:^(id JSON, NSError *error) {
        @strongify(self);
        NSLog(@"%@,%@",JSON,error);
        //self.mComments =  (NSArray *)JSON;
        [mLoadingIndicatorView stopAnimating];
        [self.mTableView reloadData];
    }];
    
}

-(void)loadNextPassionComments{
    WUPassionServices* services = [WUPassionServices sharedWUPassionServices];
    [mLoadingIndicatorView startAnimating];
    
    mIsLoading = YES;
    @weakify(self);
    
    [services getPostsForPassionID:kSamplePassionId offset:self.mComments.count limit:15 completionBlock:^(id JSON, NSError *error)
    {
        @strongify(self);
        [self hideEgoRefreshView];

        NSLog(@"%@,%@",JSON,error);
        
        if (error == nil) {
            NSArray *newItems = (NSArray *)JSON;
            if([newItems isKindOfClass:[NSDictionary class]]){
                newItems = @[newItems];
            }
            if (newItems.count!=0) {
                [self.mComments addObjectsFromArray:newItems];
            }
            [self.mTableView reloadData];
        }
        else{
            [UIAlertView showAlertMessage:error.localizedDescription];
        }
        [mLoadingIndicatorView stopAnimating];
        
    }];
}

-(void)reloadPassionComments{
    WUPassionServices* services = [WUPassionServices sharedWUPassionServices];
    [mLoadingIndicatorView startAnimating];
    mIsLoading = YES;

    @weakify(self);
    [services getPostsForPassionID:kSamplePassionId offset:0 limit:self.mComments.count completionBlock:^(id JSON, NSError *error) {
        @strongify(self);
        [self hideEgoRefreshView];
        NSLog(@"%@,%@",JSON,error);
        
        if (error == nil) {
            NSArray *newItems = (NSArray *)JSON;
            if([newItems isKindOfClass:[NSDictionary class]]){
                newItems = @[newItems];
            }
            if (newItems.count!=0) {
                [self.mComments addObjectsFromArray:newItems];
            }
            [self.mTableView reloadData];

        }
        else{
            [UIAlertView showAlertMessage:error.localizedDescription];
        }
        
        [mLoadingIndicatorView stopAnimating];
    }];
}


-(void)loadPassionBasicInfo{
    WUPassionServices* services = [WUPassionServices sharedWUPassionServices];
    
    @weakify(self);
    [services getPassionInfoForID:@"444" completionBlock:^(id JSON, NSError *error) {
        @strongify(self);
        
        if (JSON == nil ) {
            return ;
        }
        
        self.mPassionInfo = JSON[@"Passion"];
        NSRange range = NSMakeRange(0, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.mTableView reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - Get Pin Comments

-(void)loadPinComments
{
    WUBoardServices* services = [WUBoardServices sharedWUBoardServices];

    @weakify(self);
    [services getCommentsForPinID:mFullPinInfo[@"Pin_Id"] completionBlock:^(id JSON, NSError *error) {
        @strongify(self);
        
        
        if (error == nil) {
            if ([JSON isKindOfClass:[NSDictionary class]])
            {
                self.mComments = [[NSArray alloc] initWithObjects:JSON, nil];
            }
            else{
                self.mComments = JSON;
            }
            [self.mTableView reloadData];
            
        }else{
            [UIAlertView showAlertMessage:error.localizedDescription];
        }
        
        
        
    }];
}


-(void)postComment:(NSString *)comment
{

    NSString *memberID = [WUSharedCache getUserToken];

    
    
    if (memberID == nil) {
        WeUnite *weUnite = [[WUSharedCache wuSharedCache] mWeUnite];
        [weUnite loginWeUnite:self];
        mCommentToBePosted = comment;
        return;
    }

    
    
    if ([mCommentType isEqualToString:BOARD_PIN_SCREEN]) {
        
        WUBoardServices* services = [WUBoardServices sharedWUBoardServices];
        @weakify(self);
        [services comment:comment pinId:mFullPinInfo[@"Pin_Id"] ForMember:memberID completionBlock:^(id JSON, NSError *error) {
            @strongify(self);

            
            
            NSLog(@"Pin post comment response %@ and error %@",JSON,error);
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
    else{
        
        WUPassionServices* services = [WUPassionServices sharedWUPassionServices];
        @weakify(self);
        [services comment:comment passionID:kSamplePassionId ForMemberID:memberID completionBlock:^(id JSON, NSError *error) {
            @strongify(self);

            NSLog(@"%@ %@",JSON,error);
            NSString *message = nil;
            if (error==nil) {
                message = @"Posting successfull";
                if ([mCommentType isEqualToString:BOARD_PIN_SCREEN]) {
                    [self loadPinComments];
                }else{
                    [self reloadPassionComments];
                }
                
            }
            else {
                message = @"Posting failure";
            }
            [UIAlertView showAlertMessage:message];
        }];


        
    }
    
    
    WUPostCommentCell *cell = (WUPostCommentCell *)[self.mTableView dequeueReusableCellWithIdentifier:zPostCellReuseIdentifier];
    cell.mPostCommentTextField.text = @"";
    self.mTableView.userInteractionEnabled = YES;
}


-(IBAction)backItemPressed:(id)sender
{
    
    if ([mCommentType isEqualToString:BOARD_PIN_SCREEN]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(void) likeBtnPressed:(id)sender{
    
    if ([mCommentType isEqualToString:BOARD_PIN_SCREEN])
    {
        @weakify(self);
        WUBoardServices* boardServices = [WUBoardServices sharedWUBoardServices];
        [boardServices likePin:mFullPinInfo[@"Pin_Id"] likeStatus:YES completionBlock:^(id JSON, NSError *error) {
            @strongify(self);
            NSLog(@"response is %@",JSON);
            
            if (error == NULL) {
                
                NSString* status = JSON[@"Pin"][@"Status"];
                
                if ([status intValue] == 1) {
                    [UIAlertView showAlertMessage:@"You have succesfully liked pin."];
                    //TODO -- Server returns the new total number of likes. Update that in database of Pin.
                    
                }
                else{
                    [UIAlertView showAlertMessage:JSON[@"Pin"][@"Message"]];
                }
                
            }
            else{
                [UIAlertView showAlertMessage:@"Some error in liking pin. Please try again later."];
            }
            
            
        }];
        
        
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
    
    
	CGRect containerFrame = self.mTableView.frame;
     
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.mTableView.height = containerFrame.size.height -keyboardBounds.size.height-44;
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
    
	self.mTableView.height = self.view.height-44;
	
	// commit animations
	[UIView commitAnimations];
    self.mTableView.scrollEnabled = YES;
}




#pragma mark - Image Cache Delegate Methods

- (void) newImageRetrieved:(NSNotification*)sender{
	NSDictionary *dict = [sender userInfo];
	NSInteger tag = [dict[@"tag"] intValue];
    
    if (tag == 10000) {
        MainPassionCell *cell = nil;
        
        if ([self.mCommentType isEqualToString:BOARD_PIN_SCREEN]) {
            cell = (MainPassionCell *)[self.mTableView dequeueReusableCellWithIdentifier:zMainPassionCellReuseIdentifier];
        }
        else {
            cell = (MainPassionCell *)[self.mTableView dequeueReusableCellWithIdentifier:zMainPassionCellReuseIdentifier1];
        }
        cell.mPassionImageView.image = dict[@"image"];
        NSRange range = NSMakeRange(0, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.mTableView reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
        //[cell setNeedsLayout];
        return;
    }
    
    
	NSArray *paths = [self.mTableView indexPathsForVisibleRows];
	for(NSIndexPath *path in paths){
		NSInteger index = path.row;
		
		CommentCell *cell = (CommentCell*)[self.mTableView cellForRowAtIndexPath:path];
        if(cell.imageView.image == nil && tag == index && path.section == 2){
            @weakify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                UIImage* img = dict[@"image"];
                cell.mProfileImageView.image = img;
                [cell setNeedsLayout];
            });
            
		}
	}
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
        NSLog(@"mCommentToBePosted is %@",mCommentToBePosted);
        [self postComment:mCommentToBePosted];
        return;
    }
    
    
    
    
}

- (void)viewDidUnload {
    
    [self setMScreenTitle:nil];
    [super viewDidUnload];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //For WUCommentCell we ll direct the tap request to In app browser.
    if ([request.URL.absoluteString hasPrefix:@"http"]) {
        NSLog(@"%@",request.URL);
        InAppBrowserVC *browserVC = [[InAppBrowserVC alloc] initWithNibName:@"InAppBrowserVC" bundle:nil];
        browserVC.mURLString = @"https://dev.weunite.com/";
        [self.navigationController pushViewController:browserVC animated:YES];
        return NO;
    }
    return YES;
}

#pragma mark - Handling long press cell like
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint p = [gestureRecognizer locationInView:self.mTableView];
        NSIndexPath *indexPath = [self.mTableView indexPathForRowAtPoint:p];
        if (indexPath != nil){
           
            if (indexPath.section != 2) {
                return;
            }
            NSLog(@"long press on table view at row %d", indexPath.row);
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:kWUAppName delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Like", nil];
            actionSheet.tag = indexPath.row;
            [actionSheet showInView:self.mBaseView];
            
        }
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Like"]) {
        WUPassionServices *ps = [WUPassionServices sharedWUPassionServices];
        NSDictionary *postInfo = mComments[actionSheet.tag];
        [mLoadingIndicatorView startAnimating];
        @weakify(self);
        [ps likePassionPostID:postInfo[@"Post_Id"] likeStatus:YES completionBlock:^(id JSON, NSError *error) {
            
            @strongify(self);

            [mLoadingIndicatorView stopAnimating];
            
            
            NSDictionary *responseDict = (NSDictionary *)JSON;
            int status = [responseDict[@"Post"][@"Status"] intValue];
            
            if (status == 1) {
                [WUUtilities flashMessage:@"Post Liked Successfully"];
                double delayInSeconds = 0.10;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self reloadPassionComments];
                });
            }
            else{
                [WUUtilities flashMessage:@"Cannot update the same status again"];
            }
            
            NSLog(@"%@",JSON);
        }];
    }
}


#pragma mark -
#pragma mark Ego Support Methods

-(void)addPullToRefresh{
    egoPullView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.mTableView.bounds.size.height, self.mTableView.frame.size.width, self.mTableView.bounds.size.height)];
    
    //NSLog(@"view is %@",view);
    egoPullView.delegate = self;
    [self.mTableView addSubview:egoPullView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [egoPullView egoRefreshScrollViewDidScroll:scrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
    [egoPullView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -  EGO Pull Refresh Delegates

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadPassionComments];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return mIsLoading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}

-(void)hideEgoRefreshView{
    mIsLoading = NO;
    [egoPullView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mTableView];
}


@end
