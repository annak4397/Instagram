//
//  PostCollectionViewCell.m
//  Instagram
//
//  Created by Anna Kuznetsova on 7/9/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "PostCollectionViewCell.h"
#import "Post.h"

@implementation PostCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(void)setCellPost:(Post *)post{
    self.postImageView.file = post[@"image"];
    [self.postImageView loadInBackground];
}
@end
