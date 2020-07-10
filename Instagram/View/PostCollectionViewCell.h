//
//  PostCollectionViewCell.h
//  Instagram
//
//  Created by Anna Kuznetsova on 7/9/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@import Parse;
#import "Post.h"


NS_ASSUME_NONNULL_BEGIN

@interface PostCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
-(void)setCellPost:(Post *)post;
@end

NS_ASSUME_NONNULL_END
