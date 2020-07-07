//
//  MainTimelineViewController.m
//  Instagram
//
//  Created by Anna Kuznetsova on 7/6/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "MainTimelineViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>


@interface MainTimelineViewController ()
- (IBAction)onLogoutTap:(id)sender;

@end

@implementation MainTimelineViewController

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

- (IBAction)onLogoutTap:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if(error){
            NSLog(@"Some error occured during logout: %@", error.localizedDescription);
        }
    }];
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
                   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
    //[[APIManager shared] logout];
}
@end
