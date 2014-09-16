//
//  NKPageViewController.h
//  VideoChatDemo
//
//  Created by Nick Kibish on 14.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKPageViewControllerDelegate.h"
#import "NKVideochatViewController.h"

@interface NKPageViewController : UIPageViewController
{
    NKPageViewControllerDelegate *delegate;
}

@property (strong, nonatomic) NSArray *controllers;
@property (assign, nonatomic) NSUInteger userID;

- (NKVideochatViewController *)videoChatController;

@end
