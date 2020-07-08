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
#import "ComposeViewController.h"
#import "PostCell.h"


@interface MainTimelineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *timelinePosts;
- (IBAction)onLogoutTap:(id)sender;
@end

@implementation MainTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // construct query
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self loadPosts];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"composeSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    }
}

-(void)loadPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
       query.limit = 20;

       // fetch data asynchronously
       [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
           if (posts != nil) {
               // do something with the array of object returned by the call
               self.timelinePosts = posts;
               NSLog(@"%@", self.timelinePosts[0]);
               [self.tableView reloadData];
           } else {
               NSLog(@"%@", error.localizedDescription);
           }
       }];
}

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.timelinePosts.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.timelinePosts[indexPath.row];
    [cell setCellPost:post];

    return cell;
}
/*
 -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
     
     Tweet *tweet = self.arrayOfTweets[indexPath.row];
     cell.tweet = tweet;
     [cell setCellTweet:tweet];
     [cell refreshData];
     cell.delegate = self;
     
     return cell;
 }
 */

@end
