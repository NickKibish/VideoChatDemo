//
//  NKVideochatViewController.m
//  VideoChatDemo
//
//  Created by Nick Kibish on 14.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import "NKVideochatViewController.h"
#import "NKAppDelegate.h"
#import "TPCircularBuffer.h"

#define kBufferLength 32768
#define qbAudioDataSizeForSecods(second) 512*(32*second)

@interface NKVideochatViewController ()

@end

@implementation NKVideochatViewController
{
    TPCircularBuffer circularBuffer;
}

@synthesize videoChatOpponentID = videoChatOpponentID;
@synthesize sessionID = sessionID;

- (void)dealloc
{
    TPCircularBufferCleanup(&circularBuffer);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupVideoCapture];
//    [self setupAudioCapture];
}

#pragma mark -
#pragma mark Video and audio setup

-(void) setupVideoCapture
{
    self.captureSession = [[AVCaptureSession alloc] init];
    
    __block NSError *error = nil;
    
    // set preset
    [self.captureSession setSessionPreset:AVCaptureSessionPresetLow];
    
    
    // Setup the Video input
    AVCaptureDevice *videoDevice = [self frontFacingCamera];
    //
    AVCaptureDeviceInput *captureVideoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if(error){
        QBDLogEx(@"deviceInputWithDevice Video error: %@", error);
    }else{
        if ([self.captureSession  canAddInput:captureVideoInput]){
            [self.captureSession addInput:captureVideoInput];
        }else{
            QBDLogEx(@"cantAddInput Video");
        }
    }
    
    // Setup Video output
    AVCaptureVideoDataOutput *videoCaptureOutput = [[AVCaptureVideoDataOutput alloc] init];
    videoCaptureOutput.alwaysDiscardsLateVideoFrames = YES;
    //
    // Set the video output to store frame in BGRA (It is supposed to be faster)
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [videoCaptureOutput setVideoSettings:videoSettings];
    /*And we create a capture session*/
    if([self.captureSession canAddOutput:videoCaptureOutput]){
        [self.captureSession addOutput:videoCaptureOutput];
    }else{
        QBDLogEx(@"cantAddOutput");
    }
    
    
    // set FPS
    int framesPerSecond = 3;
    AVCaptureConnection *conn = [videoCaptureOutput connectionWithMediaType:AVMediaTypeVideo];
    if (conn.isVideoMinFrameDurationSupported){
        conn.videoMinFrameDuration = CMTimeMake(1, framesPerSecond);
    }
    if (conn.isVideoMaxFrameDurationSupported){
        conn.videoMaxFrameDuration = CMTimeMake(1, framesPerSecond);
    }
    
    // set portrait orientation
    [conn setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    /*We create a serial queue to handle the processing of our frames*/
    dispatch_queue_t callbackQueue= dispatch_queue_create("cameraQueue", NULL);
    [videoCaptureOutput setSampleBufferDelegate:self queue:callbackQueue];
    
    // Add preview layer
    AVCaptureVideoPreviewLayer *prewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [prewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CGRect layerRect = [[myVideoView layer] bounds];
    [prewLayer setBounds:layerRect];
    [prewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
    myVideoView.hidden = NO;
    [myVideoView.layer addSublayer:prewLayer];
    
    
    /*We start the capture*/
    [self.captureSession startRunning];
}

-(void) setupAudioCapture{
    // start audio IO
    //
    [[QBAudioIOService shared] start];
    
    // Route audio to speaker
    //
    [[QBAudioIOService shared] routeToSpeaker];
    
    // Create ring buffer
    //
    TPCircularBufferInit(&circularBuffer, kBufferLength);
    
    // Start processing
    //
    [[QBAudioIOService shared] setInputBlock:^(AudioBuffer buffer){
        [self.videoChat processVideoChatCaptureAudioBuffer:buffer];
    }];
    //
    [[QBAudioIOService shared] start];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput  didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    [self.videoChat processVideoChatCaptureVideoSample:sampleBuffer];
}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *) backFacingCamera{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (AVCaptureDevice *) frontFacingCamera{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (IBAction)call:(id)sender{
    NSLog(@"// Call");
    if(callButton.tag == 101){
        callButton.tag = 102;
        
        // Setup video chat
        //
        if(self.videoChat == nil){
            self.videoChat = [[QBChat instance] createAndRegisterVideoChatInstance];
            self.videoChat.viewToRenderOpponentVideoStream = opponentVideoView;
            self.videoChat.viewToRenderOwnVideoStream = myVideoView;
        }
        
        self.videoChat.isUseCustomAudioChatSession = YES;
        self.videoChat.isUseCustomVideoChatCaptureSession = YES;
        [self.videoChat callUser:[_opponentID integerValue] conferenceType:QBVideoChatConferenceTypeAudioAndVideo];
        callButton.title = @"Hang Up";
        // Finish
    }else{
        callButton.tag = 101;
        
        // Finish call
        //
        [self.videoChat finishCall];
        
        myVideoView.hidden = YES;
        opponentVideoView.layer.contents = (id)[[UIImage imageNamed:@"user-icon-512.png"] CGImage];
        opponentVideoView.image = [UIImage imageNamed:@"user-icon-512.png"];
        NKAppDelegate *appDelegate = (NKAppDelegate *)[UIApplication sharedApplication].delegate;
        
        opponentVideoView.layer.borderWidth = 1;
        
        
        // release video chat
        //
        [[QBChat instance] unregisterVideoChatInstance:self.videoChat];
        self.videoChat = nil;
        callButton.title = @"Call";
    }
}

- (void)accept{
    NSLog(@"accept");
    if(self.videoChat == nil){
        self.videoChat = [[QBChat instance] createAndRegisterVideoChatInstanceWithSessionID:sessionID];
        self.videoChat.viewToRenderOpponentVideoStream = opponentVideoView;
        self.videoChat.viewToRenderOwnVideoStream = myVideoView;
    }
    self.videoChat.isUseCustomAudioChatSession = YES;
    self.videoChat.isUseCustomVideoChatCaptureSession = YES;
    
    [self.videoChat acceptCallWithOpponentID:videoChatOpponentID conferenceType:videoChatConferenceType];
    
    callButton.title = @"Hang up";
    callButton.tag = 102;
    
    opponentVideoView.layer.borderWidth = 0;
    
    myVideoView.hidden = NO;
    
    ringingPlayer = nil;
}
@end
