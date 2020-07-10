//
//  ProfileViewController.m
//  Instagram
//
//  Created by Anna Kuznetsova on 7/9/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "Constants.h"
#import "PostCollectionViewCell.h"
#import "Post.h"

@interface ProfileViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *posts;
@property (weak, nonatomic) IBOutlet UICollectionView *postCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *postFlowLayout;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.postCollectionView.dataSource = self;
    self.postCollectionView.delegate = self;
    
    [self getUserPosts];
    
    CGFloat cellWidth = self.postCollectionView.frame.size.width/POST_PER_LINE;
    CGFloat cellHeight = cellWidth;
    self.postFlowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    self.postFlowLayout.minimumLineSpacing = 0;
    self.postFlowLayout.minimumInteritemSpacing = 0;
}
-(void)getUserPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    //PFUser.currentUser.objectId;
    [query whereKey:@"author" equalTo:PFUser.currentUser];
    query.limit = POST_QUERY_LIMIT;
    
       // fetch data asynchronously
       [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
           if (posts != nil) {
               self.posts = posts;
               [self.postCollectionView reloadData];
           } else {
               NSLog(@"%@", error.localizedDescription);
           }
       }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"profilePostCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.row];
    [cell setCellPost:post];

    return cell;
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
