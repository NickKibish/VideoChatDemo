//
//  NKContactsTableViewController.h
//  
//
//  Created by Nick Kibish on 14.09.14.
//
//

#import <UIKit/UIKit.h>

@interface NKContactsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_friends;
    NSMutableArray *_users;
}

- (void)login;

@end
