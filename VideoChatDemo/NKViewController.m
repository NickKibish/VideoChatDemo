//
//  NKViewController.m
//  VideoChatDemo
//
//  Created by Nick Kibish on 13.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import "NKViewController.h"
#import "NKAppDelegate.h"
#import "NKContactsTableViewController.h"

@interface NKViewController ()

@end

@implementation NKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signin:(id)sender
{
    QBSessionParameters *parameters = [QBSessionParameters new];
    parameters.userEmail = _login.text;
    parameters.userPassword = _password.text;
    
    [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session) {
        NKAppDelegate *appDelegate = (NKAppDelegate *)[UIApplication sharedApplication].delegate;
        [QBChat instance].delegate = self;
        QBUUser *user = [QBUUser user];
        user.ID = session.userID;
        user.password = parameters.userPassword;
        [[QBChat instance] loginWithUser:user];
        appDelegate.currentUser = user.ID;
        
        [self.tableView login];
        [self dismissViewControllerAnimated:YES completion:nil];
    } errorBlock:^(QBResponse *response) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", "")
                                                        message:[response.error description]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", "")
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

@end
