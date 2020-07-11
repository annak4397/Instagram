//
//  DetailPostViewController.m
//  Instagram
//
//  Created by Anna Kuznetsova on 7/8/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "DetailPostViewController.h"
#import <DateTools.h>
@import Parse;

@interface DetailPostViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation DetailPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
    // Do any additional setup after loading the view.
    PFUser *postCreator = self.post[@"author"];
    self.profileImageView.file = postCreator[@"profileImage"];
    [self.postImageView loadInBackground];
    self.usernameLabel.text = postCreator[@"username"];
    
    self.postImageView.file = self.post[@"image"];
    [self.postImageView loadInBackground];
    self.captionLabel.text = self.post[@"caption"];
    self.dateLabel.text = self.post[@"createdAtString"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
