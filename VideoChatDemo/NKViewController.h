//
//  NKViewController.h
//  VideoChatDemo
//
//  Created by Nick Kibish on 13.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKContactsTableViewController.h"

@interface NKViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *login;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) NKContactsTableViewController *tableView;

- (IBAction)signin:(id)sender;
@end
