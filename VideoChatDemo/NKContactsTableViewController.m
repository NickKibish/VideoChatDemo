//
//  NKContactsTableViewController.m
//  
//
//  Created by Nick Kibish on 14.09.14.
//
//

#import "NKContactsTableViewController.h"
#import "NKAppDelegate.h"
#import "NKPageViewController.h"
#import "NKViewController.h"

@interface NKContactsTableViewController ()

@end

@implementation NKContactsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NKViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginWindow"];
    controller.tableView = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)login
{
    NKAppDelegate *appDelegate = (NKAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    NSString *userIDStr = [NSString stringWithFormat:@"%d", appDelegate.currentUser];
    
    [request setObject:[NSString stringWithFormat:userIDStr, appDelegate.currentUser] forKey:@"user_id"];
 
    [QBRequest objectsWithClassName:@"FriendList" extendedRequest:request successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        _friends = [NSArray arrayWithArray:objects];
        [self createTitles];
        [[NKAppDelegate sharedDelegate] instanceChat];
    } errorBlock:^(QBResponse *response) {
        NSLog(@"Error: %@", response.error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTitles
{
    if (!_users)
        _users = [NSMutableArray array];
    for (QBCOCustomObject *friend in _friends) {
        NSString *friend_id = [friend.fields valueForKey:@"FriendID"];
        NSInteger id_ = [friend_id integerValue];
        [QBRequest userWithID:id_ successBlock:^(QBResponse *response, QBUUser *user) {
            [_users addObject:user];
            [self.tableView reloadData];
        } errorBlock:^(QBResponse *response) {
            [_users addObject:[QBUUser user]];
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_users)
        return _users.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    QBUUser *user = [_users objectAtIndex:indexPath.row];
    cell.textLabel.text = user.fullName;
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ContactsSeg"]) {
        NKPageViewController *pageViewController = segue.destinationViewController;
        NSInteger *index = [[self.tableView indexPathForSelectedRow] row];
        QBUUser *user =[_users objectAtIndex:index];
        pageViewController.userID = user.ID;
        [NKAppDelegate sharedDelegate].userVideoChat = [pageViewController videoChatController];
    }
}


@end
