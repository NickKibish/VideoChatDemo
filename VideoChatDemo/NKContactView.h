//
//  NKContactView.h
//  VideoChatDemo
//
//  Created by Nick Kibish on 16.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKContactView : UIViewController
@property (assign, nonatomic) NSUInteger userID;
@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *LoginLabe;

@end
