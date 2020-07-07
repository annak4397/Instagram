//
//  ComposeViewController.m
//  Instagram
//
//  Created by Anna Kuznetsova on 7/7/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "ComposeViewController.h"
#import <UIKit/UIKit.h>
#import "Post.h"
#import <Parse/Parse.h>

@interface ComposeViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *captionTextFiled;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
- (IBAction)onTapImage:(id)sender;
- (IBAction)onCancelButtonTap:(id)sender;
- (IBAction)onShareButtonTap:(id)sender;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    [self.postImageView setImage:originalImage];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onShareButtonTap:(id)sender {
    [Post postUserImage:self.postImageView.image withCaption:self.captionTextFiled.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Something went wrong with posting: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Image is posted");
        }
    }];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)onCancelButtonTap:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)onTapImage:(id)sender {
    NSLog(@"Tapped on image");
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
@end
