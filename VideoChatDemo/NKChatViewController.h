//
//  NKChatViewController.h
//  VideoChatDemo
//
//  Created by Nick Kibish on 16.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, QBChatDelegate>
{
    NSMutableArray *messagrs;
}

@property (assign, nonatomic) NSUInteger opponentID;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *messageField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sendBtn;

- (IBAction)send:(id)sender;
- (void)pushNewMessage:(QBChatMessage *)message;

@end
