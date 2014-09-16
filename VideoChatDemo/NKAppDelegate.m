//
//  NKAppDelegate.m
//  VideoChatDemo
//
//  Created by Nick Kibish on 13.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import "NKAppDelegate.h"
#import "NKPageViewController.h"
#import "TPCircularBuffer.h"

#define kBufferLength 32768
#define qbAudioDataSizeForSecods(second) 512*(32*second)

@implementation NKAppDelegate
{
    UIAlertView *recieveCallAlert;
    TPCircularBuffer circularBuffer;
}

+ (NKAppDelegate *)sharedDelegate
{
    NKAppDelegate *delegate = (NKAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [QBApplication sharedApplication].applicationId = 14325;
    [QBConnection registerServiceKey:@"GafPfbAPuJPBuyh"];
    [QBConnection registerServiceSecret:@"BynR6rqmJnhMSQU"];
    [QBSettings setAccountKey:@"dFyArsEvoYXKCLSKAspy"];
    
    return YES;
}

- (void)instanceChat
{
    [QBChat instance].delegate = self;
    [NSTimer scheduledTimerWithTimeInterval:30
                                     target:[QBChat instance]
                                   selector:@selector(sendPresence)
                                   userInfo:nil
                                    repeats:YES];
}

#pragma mark - Chat Delegate
- (void)chatDidReceiveCallRequestFromUser:(NSUInteger)userID
                            withSessionID:(NSString *)sessionID
                           conferenceType:(enum QBVideoChatConferenceType)conferenceType
{
    _sessionID = sessionID;
    _oponentID = userID;
    
    [QBRequest userWithID:userID successBlock:^(QBResponse *response, QBUUser *user) {
        if (!_callAlert) {
            _callAlert = [[UIAlertView alloc] initWithTitle:user.fullName
                                                    message:@"Ответить"
                                                   delegate:self
                                          cancelButtonTitle:@"Отклонить"
                                          otherButtonTitles:@"Принять", nil];
            [_callAlert show];
            if(ringingPlayer == nil){
                NSString *path =[[NSBundle mainBundle] pathForResource:@"ringing" ofType:@"wav"];
                NSURL *url = [NSURL fileURLWithPath:path];
                ringingPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
                ringingPlayer.delegate = self;
                [ringingPlayer setVolume:1.0];
                [ringingPlayer play];
            }
        }
    } errorBlock:^(QBResponse *response) {
        
    }];
    
}

- (void)chatCallUserDidNotAnswer:(NSUInteger)userID
{
    NSLog(@"chat Call User Did Not Answer");
}

- (void)chatCallDidRejectByUser:(NSUInteger)userID
{
    NSLog(@"chat Call Did Reject By User");
}

- (void)chatCallDidAcceptByUser:(NSUInteger)userID
{
    NSLog(@"chat Call Did Accept By User");
}

- (void)chatCallDidStopByUser:(NSUInteger)userID status:(NSString *)status
{
    NSLog(@"chat Call Did Stop By User %ld eith status: %@", userID, status);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    ringingPlayer = nil;
}

- (void)didReceiveAudioBuffer:(AudioBuffer)buffer
{
    TPCircularBufferProduceBytes(&circularBuffer, buffer.mData, buffer.mDataByteSize);
    int32_t availableBytes;
    TPCircularBufferTail(&circularBuffer, &availableBytes);
    if([[QBAudioIOService shared] outputBlock] == nil && availableBytes > qbAudioDataSizeForSecods(0.5)){
        
        QBDLogEx(@"Set output block");
        [[QBAudioIOService shared] setOutputBlock:^(AudioBuffer buffer) {
            
            int32_t availableBytesInBuffer;
            void *cbuffer = TPCircularBufferTail(&circularBuffer, &availableBytesInBuffer);
            
            if(availableBytesInBuffer > 0){
                int min = MIN(buffer.mDataByteSize, availableBytesInBuffer);
                memcpy(buffer.mData, cbuffer, min);
                TPCircularBufferConsume(&circularBuffer, min);
            }else{
                QBDLogEx(@"No data to play -> mute output");
                [[QBAudioIOService shared] setOutputBlock:nil];
            }
            if(availableBytes > qbAudioDataSizeForSecods(3)) {
                QBDLogEx(@"There is to much audio data to play -> clear buffer & mute output");
                TPCircularBufferClear(&circularBuffer);
                
                [[QBAudioIOService shared] setOutputBlock:nil];
            }
        }];
    }
}

#pragma mark - AlerView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            // Reject
        case 0:
            [self reject];
            break;
            // Accept
        case 1:
            [self accept];
            break;
            
        default:
            break;
    }
}

- (void)accept
{
    UIViewController *rootViewController = _window.rootViewController;
    NKPageViewController *controller = [rootViewController.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    controller.userID = _oponentID;
    [rootViewController presentViewController:controller animated:YES completion:nil];
    _oponentVideoChat = [controller videoChatController];
    [_oponentVideoChat setupAudioCapture];
    _oponentVideoChat.videoChatOpponentID = _oponentID;
    _oponentVideoChat.sessionID = _sessionID;
    [_oponentVideoChat accept];
}

- (void)reject
{
    QBVideoChat *videoChat = [[QBChat instance] createAndRegisterVideoChatInstanceWithSessionID:_sessionID];
    [videoChat rejectCallWithOpponentID:_oponentID];
    [[QBChat instance] unregisterVideoChatInstance:videoChat];
    _callAlert = nil;
}

@end
