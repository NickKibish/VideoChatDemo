//
//  NKVideochatViewController.h
//  VideoChatDemo
//
//  Created by Nick Kibish on 14.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface NKVideochatViewController : UIViewController <AVAudioPlayerDelegate, UIAlertViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
{
    IBOutlet UIBarButtonItem *callButton;
    IBOutlet UIImageView *opponentVideoView;
    IBOutlet UIImageView *myVideoView;
    
    AVAudioPlayer *ringingPlayer;
    NSUInteger videoChatOpponentID;
    enum QBVideoChatConferenceType videoChatConferenceType;
    NSString *sessionID;
}

@property (strong) NSNumber *opponentID;
@property (strong) QBVideoChat *videoChat;
@property (strong) UIAlertView *callAlert;
@property (strong) AVCaptureSession *captureSession;
@property (assign) NSUInteger videoChatOpponentID;
@property (strong) NSString *sessionID;

- (IBAction)call:(id)sender;
- (void)reject;
- (void)accept;
- (void)setupAudioCapture;

@end
