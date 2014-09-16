//
//  NKChatViewController.m
//  VideoChatDemo
//
//  Created by Nick Kibish on 16.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import "NKChatViewController.h"
#import "NKAppDelegate.h"

@interface NKChatViewController ()

@end

@implementation NKChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    messagrs = [NSMutableArray array];
    // Do any additional setup after loading the view.
}

#pragma mark - Table Data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messagrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    if (indexPath.row >= messagrs.count)
        return cell;
    QBChatMessage *message = [messagrs objectAtIndex:indexPath.row];
    if (message.senderID == [NKAppDelegate sharedDelegate].currentUser) {
        cell.textLabel.textAlignment = NSTextAlignmentRight;
    } else {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    cell.textLabel.text = message.text;
    return cell;
}

- (void)pushNewMessage:(QBChatMessage *)message
{
    [messagrs addObject:message];
    NSIndexPath *index = [NSIndexPath indexPathForRow:(messagrs.count - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (IBAction)send:(id)sender
{
    QBChatMessage *message = [QBChatMessage message];
    [message setText:self.messageField.text];
    message.senderID = [NKAppDelegate sharedDelegate].currentUser;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"save_to_history"] = @YES;
    [message setCustomParameters:params];
    [message setRecipientID:self.opponentID];
    [[QBChat instance] sendMessage:message];
    [self pushNewMessage:message];
}

@end
