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
#import "DetailPostViewController.h"
#import "Constants.h"


@interface MainTimelineViewController ()<UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *timelinePosts;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;
- (IBAction)onLogoutTap:(id)sender;
@end

@implementation MainTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // construct query
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.loadingActivity startAnimating];
    [self loadPosts];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"composeSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    else if([[segue identifier] isEqualToString:@"detailSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *tappedPost = self.timelinePosts[indexPath.row];
        DetailPostViewController *detailController = [segue destinationViewController];
        detailController.post = tappedPost;
    }

}

-(void)loadPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    query.limit = POST_QUERY_LIMIT;
    [query includeKey:@"author"];
       // fetch data asynchronously
       [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
           if (posts != nil) {
               self.timelinePosts = posts;
               [self.loadingActivity stopAnimating];
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

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self loadPosts];
    [refreshControl endRefreshing];
}
-(void)didPost{
    [self loadPosts];
}

@end
