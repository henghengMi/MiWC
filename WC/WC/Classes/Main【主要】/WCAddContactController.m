//
//  WCAddContactController.m
//  WC
//
//  Created by YuanMiaoHeng on 16/6/3.
//  Copyright © 2016年 Mi. All rights reserved.
//

/** 提示 */
#define  SHOWALERT(mesageString) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:mesageString delegate:nil cancelButtonTitle:@"嗯嗯，好" otherButtonTitles:nil];\
[alert show];


#import "WCAddContactController.h"

@interface WCAddContactController ()<UITextFieldDelegate>

@end

@implementation WCAddContactController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
     NSLog(@" text:%@ ",textField.text);
    
    NSString* user = textField.text;
    
    // 判断是否为帐号！
    
    // 判断是否添加了自己
    if ([[UserInfo sharedUserInfo].account isEqualToString:user]) {
        SHOWALERT(@"添加了自己");
        return YES;
    }
    
    NSString *JID = [NSString stringWithFormat:@"%@@%@",textField.text,domain];
    // 利用输入的账户拼接主机形成jid
    XMPPJID *xmppjid = [XMPPJID jidWithString:JID];
    
    // 判断好友是否已存在
    if ([[WCXMPPTool sharedWCXMPPTool].rosterStorage userExistsWithJID:xmppjid xmppStream:[WCXMPPTool sharedWCXMPPTool].xmppStream]) {
        SHOWALERT(@"好友已存在");
        return YES;
    }
    
    // 加好友
    [[WCXMPPTool sharedWCXMPPTool].roster subscribePresenceToUser:xmppjid];
    
    
    return YES;
}



@end
