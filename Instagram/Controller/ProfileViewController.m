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
#import "DetailPostViewController.h"

@interface ProfileViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSArray *posts;
@property (weak, nonatomic) IBOutlet UICollectionView *postCollectionView;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *postFlowLayout;
- (IBAction)onEditButtonTap:(id)sender;

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
    
    self.profileImageView.file = PFUser.currentUser[@"profileImage"];
    [self.profileImageView loadInBackground];
}
-(void) viewDidAppear:(BOOL)animated{
    [self getUserPosts];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"detailViewSegue"]) {
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.postCollectionView indexPathForCell:tappedCell];
        Post *tappedPost = self.posts[indexPath.row];
        DetailPostViewController *detailController = [segue destinationViewController];
        detailController.post = tappedPost;
    }
}


- (IBAction)onEditButtonTap:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    UIImage *profileImage = [self resizeImage:originalImage withSize:CGSizeMake(300, 150)];

    // Do something with the images (based on your use case)
    [self.profileImageView setImage:profileImage];
    //newPost.image = [self getPFFileFromImage:image];
    PFUser *current = [PFUser currentUser];
    current[@"profileImage"] = [Post getPFFileFromImage:profileImage];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"saved");
        }
        else{
            NSLog(@"didn't save: %@", error.localizedDescription);
        }
    }];
    
    /*PFUser.currentUser[@"profileImage"] = [Post getPFFileFromImage:originalImage];
    [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Unable to update user picture: %@", error.localizedDescription);
        }
    }];*/
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
