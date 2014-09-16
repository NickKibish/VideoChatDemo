//
//  NKContactView.m
//  VideoChatDemo
//
//  Created by Nick Kibish on 16.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import "NKContactView.h"

@interface NKContactView ()

@end

@implementation NKContactView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [QBRequest userWithID:self.userID successBlock:^(QBResponse *response, QBUUser *user) {

        self.fullNameLabel.text = user.fullName;
        self.emailLabel.text = user.email;
        self.LoginLabe.text = user.login;
    } errorBlock:^(QBResponse *response) {
        NSLog(@"User not found");
    }];
}

@end
