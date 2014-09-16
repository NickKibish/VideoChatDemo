//
//  NKAppDelegate.h
//  VideoChatDemo
//
//  Created by Nick Kibish on 13.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKVideochatViewController.h"

@interface NKAppDelegate : UIResponder <UIApplicationDelegate, QBChatDelegate, UIAlertViewDelegate, AVAudioPlayerDelegate>
{
    NSString *_sessionID;
    NSUInteger _oponentID;
    
    AVAudioPlayer *ringingPlayer;
}

@property (assign, nonatomic) int currentUser;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIAlertView *callAlert;

@property (strong, nonatomic) NKVideochatViewController *userVideoChat;
@property (strong, nonatomic) NKVideochatViewController *oponentVideoChat;

+ (NKAppDelegate *)sharedDelegate;
- (void)instanceChat;

@end


/*
 nick.kibish@gmail.com      nick.kibish
 nyuta.lutsenko@gmail.com   nyuta.lutsenko
 istepanchenko7@gmail.com   istepanchenko7
*/