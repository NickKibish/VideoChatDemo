//
//  NKPageViewController.m
//  VideoChatDemo
//
//  Created by Nick Kibish on 14.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import "NKPageViewController.h"
#import "NKContactView.h"
#import "NKChatViewController.h"
#import "NKAppDelegate.h"

@interface NKPageViewController ()

@end

@implementation NKPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [(NKPageViewControllerDelegate *)self.delegate setControllers:self.controllers];
    NSArray *pageControllers = [NSArray arrayWithObject:[self.controllers objectAtIndex:1]];
    [self setViewControllers:pageControllers
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
    
}

- (NSArray *)controllers
{
    if (_controllers)
        return _controllers;
    
    NKVideochatViewController *videoChatController = [self.storyboard instantiateViewControllerWithIdentifier:@"CallController"];
    videoChatController.opponentID = [NSNumber numberWithInteger:self.userID];
    [videoChatController setupAudioCapture];
    
    NKChatViewController *chatController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatController"];
    chatController.opponentID = self.userID;
    [NKAppDelegate sharedDelegate].activeController = chatController;
    
    NKContactView *userInfoController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoController"];
    userInfoController.userID = self.userID;
    
    _controllers = [NSArray arrayWithObjects:userInfoController, videoChatController, chatController, nil];
    return _controllers;
}

- (NKVideochatViewController *)videoChatController
{
    NSArray *controllers = self.controllers;
    return [controllers objectAtIndex:1];
}

@end
