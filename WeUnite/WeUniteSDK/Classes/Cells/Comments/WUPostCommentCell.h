//
//  WUPostCommentCell.h
//  WeUnite
//
//  Created by Anthony Gonsalves on 02/09/13.
//  Copyright (c) 2013 Demansol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WUPostCommentCell : UITableViewCell{
    IBOutlet __weak UITextField *mPostCommentTextField;
}
@property (nonatomic,weak)  IBOutlet UITextField *mPostCommentTextField;
@end
