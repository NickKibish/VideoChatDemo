//
//  NKPageViewControllerDelegate.h
//  VideoChatDemo
//
//  Created by Nick Kibish on 14.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKPageViewControllerDelegate : NSObject <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) IBOutlet UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *controllers;

@end
