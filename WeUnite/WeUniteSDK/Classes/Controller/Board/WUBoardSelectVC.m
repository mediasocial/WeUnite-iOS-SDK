//
//  WUBoardSelectVC.m
//  WeUnite
//
//  Created by Anthony Gonsalves on 16/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import "WUBoardSelectVC.h"
#import "TKImageCache.h"
#import "WeUnite.h"
#import "WUSharedCache.h"
#import "WUUtilities.h"
#import <QuartzCore/QuartzCore.h>
#import "WUTextImageCell.h"

#import "WUPassionServices.h"

@interface WUBoardSelectVC (){
    TKImageCache *mImageCache;
    NSArray *mAllBoards;
}
@property(nonatomic,strong)NSArray *mAllBoards;
@end

@implementation WUBoardSelectVC
@synthesize mSelectedBoardID,mAllBoards,mPassionID,completionBlock;

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
    
  //  [mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [mTableView registerNib:[UINib nibWithNibName:[WUUtilities xibBundlefileName: @"WUTextImageCell"] bundle:nil] forCellReuseIdentifier:@"WUTextImageCell"];
    [self setUpImageCaching];
    [self loadAllBoards];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backItemPressed:(id)sender{
    self.completionBlock((self.mSelectedBoardID?YES:NO),self.mSelectedBoardID);
    if([self.navigationController.viewControllers[0] isEqual:self]){
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}


#pragma mark - TableView Delegate Methods



- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return self.mAllBoards.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedRow != -1) {
        WUTextImageCell *cell = (WUTextImageCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];

        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedRow = indexPath.row;
    WUTextImageCell *cell = (WUTextImageCell*) [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    

    NSDictionary *boardInfo = self.mAllBoards[indexPath.row];
    NSString *boardID = boardInfo[@"Board_Id"];
     NSString *boardName = boardInfo[@"Board_Short_Name"];
    NSString *message = [NSString stringWithFormat:@"Board Selected: %@",boardName];
    self.mSelectedBoardID = boardID;
    self.mSelectedBoardName = boardName;
    [WUUtilities flashMessage:message];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 //   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    WUTextImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WUTextImageCell" forIndexPath:indexPath];

    NSDictionary *boardInfo = self.mAllBoards[indexPath.row];
    NSString *boardName = boardInfo[@"Board_Short_Name"];
    NSString *thumbURLString = boardInfo[@"Board_Image_URL"];
    NSString *thumbFileName = [thumbURLString lastPathComponent];
    NSURL *thumbURL = [NSURL URLWithString:thumbURLString];
    UIImage* img = [mImageCache imageForKey: thumbFileName url: thumbURL queueIfNeeded:YES tag:indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.mTextLabel.text = boardName;
    cell.mImageView.image = img;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    cell.layer.borderWidth = 1.0f;
 	return cell;
}



-(void)setUpImageCaching{
    mImageCache = [[TKImageCache alloc] initWithCacheDirectoryName:@"WUBoardImages"];
    NSString *notificationName = [NSString stringWithFormat:@"self %@",self];
	mImageCache.notificationName = notificationName;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newImageRetrieved:) name:notificationName object:nil];
}


-(void)loadAllBoards
{
    WUPassionServices* service = [WUPassionServices sharedWUPassionServices];
    [service getAllBoardsUnderPassion:self.mPassionID completionBlock:^(id JSON, NSError *error) {
        
       if(error == nil){
            self.mAllBoards = (NSArray *)JSON;
            [mTableView reloadData];
        }
        
        [_mAcitivty stopAnimating];
        
    }];
}

- (void) newImageRetrieved:(NSNotification*)sender{
	NSDictionary *dict = [sender userInfo];
	NSInteger tag = [dict[@"tag"] intValue];
	NSArray *paths = [mTableView indexPathsForVisibleRows];
	for(NSIndexPath *path in paths){
		NSInteger index = path.row;
        WUTextImageCell *cell = (WUTextImageCell*)[mTableView cellForRowAtIndexPath:path];
        if(cell.imageView.image == nil && tag == index){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage* img = dict[@"image"];
                cell.mImageView.image = img;
                [cell setNeedsLayout];
            });
            
		}
	}
}


- (void)viewDidUnload {
    [self setMAcitivty:nil];
    [super viewDidUnload];
}
@end
