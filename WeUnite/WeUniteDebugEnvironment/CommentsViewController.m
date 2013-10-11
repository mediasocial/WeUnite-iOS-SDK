//
//  CommentsViewController.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 27/08/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "CommentsViewController.h"
#import "AppDelegate.h"
#import "UIKit+Extensions.h"
#import "AFNetworking.h"
#import "WeUnite.h"
#import "CommentCell.h"



/*
 {
 "Abuse_Status" = 0;
 "Board_Data_Status" = 0;
 "Board_Id" = 0;
 "Board_Status" = 0;
 "Comments_Count" = 0;
 Date = "2013-08-25T19:53:09.247";
 "Like_Count" = 0;
 "Like_Status" = 0;
 Link = "<null>";
 "Member_Id" = 1894;
 "Member_Name" = "enest.test001";
 "Member_Pic" = "https://az29184.vo.msecnd.net/image-container/1979/original/186207_100005078320982_1674530219_q.jpg_1375332338";
 "Mentioned_User_Details" = "<null>";
 Message = "this is grewal";
 "Post_Id" = 53041;
 "Rank_Icon" = "http://az29184.vo.msecnd.net/image-container/rank_passionist_next_rank.png";
 "Rank_Type" = Passionist;
 "Rank_Value" = 5;
 "Slug_Name" = Art;
 "Wall_Id" = 444;
 "Wall_Title" = "Art & Photography";
 "Wall_Type" = Passion;
 }
 */



@interface CommentsViewController ()

@end

static NSString *zCommentCellReuseIdentifier = @"CommentCell";

@implementation CommentsViewController
@synthesize mComments;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[super dealloc];
}



- (void)viewDidLoad
{
        [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpImageCaching];
    [self loadComments];
    //[self setUpCommentTextView];
    [mTableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:zCommentCellReuseIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

-(void)setUpCommentTextView{
    
   	
    mTableView.userInteractionEnabled = NO;
    mContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    
	mHPGrowingTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, 40)];
    mHPGrowingTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	mHPGrowingTextView.minNumberOfLines = 1;
	mHPGrowingTextView.maxNumberOfLines = 4;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
	mHPGrowingTextView.returnKeyType = UIReturnKeyGo; //just as an example
	mHPGrowingTextView.font = [UIFont systemFontOfSize:15.0f];
	mHPGrowingTextView.delegate = self;
    mHPGrowingTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    mHPGrowingTextView.backgroundColor = [UIColor whiteColor];
    mHPGrowingTextView.placeholder = @"Type here to post message";
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    [self.view addSubview:mContainerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, 248, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, mContainerView.frame.size.width, mContainerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    mHPGrowingTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [mContainerView addSubview:imageView];
    [mContainerView addSubview:mHPGrowingTextView];
    [mContainerView addSubview:entryImageView];
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(mContainerView.frame.size.width - 69, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"Post" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[mContainerView addSubview:doneBtn];
    mContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [mHPGrowingTextView becomeFirstResponder];
}

-(void)setUpImageCaching{
    mImageCache = [[TKImageCache alloc] initWithCacheDirectoryName:@"WUCommentImages"];
    NSString *notificationName = [NSString stringWithFormat:@"self %@",self];
	mImageCache.notificationName = notificationName;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newImageRetrieved:) name:notificationName object:nil];
}


-(void)loadComments{
    
    return;
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //TODO -- This method has been moved to WUPassionServices.
//    [appDel.mWeUnite getCommentsForPassionID:kPassionId completionBlock:^(id JSON, NSError *error) {
//        NSLog(@"%@,%@",JSON,error);
//        self.mComments = (NSArray *)JSON;
//        
//        [mTableView reloadData];
//    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 10;
    }
    else if (indexPath.section == 1){
        return 10;
    }
    else if (indexPath.section == 2){
        return 70;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    mSelectedCommentInfo = self.mComments[indexPath.row];
    [self setUpCommentTextView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:zCommentCellReuseIdentifier];
    NSDictionary *commentInfo = self.mComments[indexPath.row];
    
   // cell.textLabel.text = commentInfo[@"Message"];
    
    NSString *thumbURLString = commentInfo[@"Member_Pic"];
    NSString *thumbFileName = [thumbURLString lastPathComponent];
    NSURL *thumbURL = [NSURL URLWithString:thumbURLString];
    UIImage* img = [mImageCache imageForKey: thumbFileName url: thumbURL queueIfNeeded:YES tag:indexPath.row];
    
    cell.mAuthorLabel.text = [NSString stringWithFormat:@"%@ @ %@",commentInfo[@"Member_Name"],commentInfo[@"Date"]];
    cell.mMessageLabel.text = commentInfo[@"Message"];
    //[cell.mMessageLabel sizeToFit];
    cell.mProfileImageView.image = img;
    
 	return cell;
}

- (void) newImageRetrieved:(NSNotification*)sender{
	NSDictionary *dict = [sender userInfo];
	NSInteger tag = [dict[@"tag"] intValue];
	NSArray *paths = [mTableView indexPathsForVisibleRows];
	for(NSIndexPath *path in paths){
		NSInteger index = path.row;
		
		CommentCell *cell = (CommentCell*)[mTableView cellForRowAtIndexPath:path];
        if(cell.imageView.image == nil && tag == index){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage* img = dict[@"image"];
                cell.mProfileImageView.image = img;
                [cell setNeedsLayout];
            });
            
		}
	}
}

-(IBAction)backItemPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)resignTextView
{
	[mHPGrowingTextView resignFirstResponder];
    [mContainerView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.1];
    
    NSString *memberID = mSelectedCommentInfo[@"Member_Id"];
    
    
    //TOOD -- This method has been moved to WUPassionServices
    
//    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDel.mWeUnite comment:mHPGrowingTextView.text passionID:kPassionId ForMemberID:memberID completionBlock:^(id JSON, NSError *error) {
//        NSLog(@"%@ %@",JSON,error);
//        NSString *message = nil;
//        if (error==nil) {
//            message = @"Posting successfull";
//        }
//        else {
//            message = @"Posting failure";
//        }
//        [UIAlertView showAlertMessage:message];
//    }];
    mTableView.userInteractionEnabled = YES;
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = mContainerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	mContainerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = mContainerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	mContainerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = mContainerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	mContainerView.frame = r;
}


//////////New UI Start Here


@end
