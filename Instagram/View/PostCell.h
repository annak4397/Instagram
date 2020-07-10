//
//  PostCell.h
//  Instagram
//
//  Created by Anna Kuznetsova on 7/7/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

-(void)setCellPost:(Post *)postPassed;

@end

NS_ASSUME_NONNULL_END
