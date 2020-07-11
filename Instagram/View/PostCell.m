//
//  PostCell.m
//  Instagram
//
//  Created by Anna Kuznetsova on 7/7/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellPost:(Post *)postPassed{
    self.post = postPassed;
    PFUser *postUser = postPassed[@"author"];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
    if(postUser != nil){
        self.profileImageView.file = postUser[@"profileImage"];
        [self.profileImageView loadInBackground];
        self.usernameLabel.text = postUser[@"username"];
    }
    self.postImageView.file = postPassed[@"image"];
    [self.postImageView loadInBackground];
    
    self.captionLabel.text = postPassed[@"caption"];
    self.dateLabel.text = postPassed[@"createdAtString"];
    
}

@end
