//
//  WCXMPPTool.m
//  WC
//
//  Created by YuanMiaoHeng on 16/5/30.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "WCXMPPTool.h"
#import "WCNavgationController.h"
#import "XMPPFramework.h"
#import "UIStoryboard+WF.h"

@interface WCXMPPTool ()<XMPPStreamDelegate>
{

    XMPPvCardCoreDataStorage *_vCardStorage; // 电子名片的数据存储
    XMPPvCardAvatarModule *_vCardAvatar; // 头像模块
    XMPPReconnect *_reconnect; // 自动连接模块
    XMPPRoster *_roster; // 花名册


}

@property(nonatomic, strong) XMPPStream  * xmppStream;

// 1. 初始化XMPPStream
-(void)setupXMPPStream;


// 2.连接到服务器
-(void)connectToHost;

// 3.连接到服务成功后，再发送密码授权
-(void)sendPwdToHost;


// 4.授权成功后，发送"在线" 消息
-(void)sendOnlineToHost;

@end

@implementation WCXMPPTool
singleton_implementation(WCXMPPTool)


#pragma mark 初始化XMPPStream
-(void)setupXMPPStream
{
    _xmppStream = [[XMPPStream alloc] init];
    
    // 注意：每个模块都要激活
    
    // 添加自动连接模块
    _reconnect = [[XMPPReconnect alloc] init];
    [_reconnect activate:_xmppStream];
    
    // 添加电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    [_vCard activate:_xmppStream];
    
    // 头像模块
    _vCardAvatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    [_vCardAvatar activate:_xmppStream];
    
    // 花名册模块
    _rosterStorage = [XMPPRosterCoreDataStorage sharedInstance];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

#pragma mark 连接到服务器
-(void)connectToHost
{
    NSLog(@"开始连接到服务器");
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    NSString *account = nil;
    if (self.isRegisterOperation) {  // 是注册操作
        account = [UserInfo sharedUserInfo].registAccount;
    }else {
        account = [UserInfo sharedUserInfo].account;
    }
    
    // 设置登录用户JID
    // resource 标识用户登录的客户端 iphone android
    XMPPJID *myJID = [XMPPJID jidWithUser:account domain:@"hengheng.local" resource:@"iphone"];
    _xmppStream.myJID = myJID;
    // 设置服务器域名
    _xmppStream.hostName = @"hengheng.local";
    
    // 设置端口 如果服务器端口是5222,可以省略
    
    // 连接
    NSError *err = nil;
    if(![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]) {
        NSLog(@"%@",err);
    }
}

#pragma mark 3.连接到服务成功后，再发送密码授权
-(void)sendPwdToHost {
    NSLog(@"发送密码授权");
    NSError *err = nil;
    
    // 发送注册的密码 还是 登录密码?
    [_xmppStream authenticateWithPassword:[UserInfo sharedUserInfo].password error:&err];
    if (err) {
        NSLog(@"%@",err);
    }
}

#pragma mark  4.授权成功后，发送"在线" 消息
-(void)sendOnlineToHost {
    NSLog(@"发送 在线 消息");
    XMPPPresence *presence = [XMPPPresence presence];
    NSLog(@"%@",presence);
    [_xmppStream sendElement:presence];
}

#pragma mark -XMPPStream的代理
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"与主机连接成功");
    
    if (self.isRegisterOperation) {//注册操作，发送注册的密码
        NSString *pwd = [UserInfo sharedUserInfo].registPassword;
        [_xmppStream registerWithPassword:pwd error:nil];
    }else{//登录操作
        // 主机连接成功后，发送密码进行授权
        [self sendPwdToHost];
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"与主机断开连接 %@",error);
}

#pragma mark 授权成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"授权成功");
    [self sendOnlineToHost];
    
    // 存储密码和账号
    
    // 登录成功来到主界面
    if (self.loginResultBlock) {
        self.loginResultBlock(XMPPLoginStatusSuccess);
    }
    
}

#pragma mark 授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    
    NSLog(@"授权失败 %@",error);
    if (self.loginResultBlock) {
        self.loginResultBlock(XMPPLoginStatusFailure);
    }
}

#pragma mark 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功");
    if (self.loginResultBlock) {
        self.loginResultBlock(XMPPRegistStatusSuccess);
    }
}

#pragma mark 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    if (self.loginResultBlock) {
        self.loginResultBlock(XMPPRegistStatusFailure);
    }
    NSLog(@"注册失败 %@",error);
}

#pragma mark 公共方法
-(void)logout{
    // 1. 发送“离线”消息
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    // 2. 与服务器断开连接
    [_xmppStream disconnect];
    
    // 3. 回到登录界面
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    self.window.rootViewController = storyboard.instantiateInitialViewController;
    [UIStoryboard showInitialVCWithName:@"Login"];
    
    
    //4.更新用户的登录状态
    [UserInfo sharedUserInfo].logined = NO;
    [[UserInfo sharedUserInfo] saveUserInfoToSanBox];
}

#pragma mark 登录
-(void)loginWithResultBlock:(XMPPLoginResultBlock)loginResultBlock{
    // 保留Block
    self.loginResultBlock = loginResultBlock;
    
    // 如果以前连接过服务，要断开
    if ([_xmppStream isConnected]) {
        [_xmppStream disconnect];
    }
    
    [self connectToHost];
}

#pragma mark 注册
-(void)registWithResultBlock:(XMPPLoginResultBlock)loginResultBlock{
    // 保留Block
    self.loginResultBlock = loginResultBlock;
    
    // 如果以前连接过服务，要断开
    if ([_xmppStream isConnected]) {
        [_xmppStream disconnect];
    }
    
    [self connectToHost];
}


- (void)dealloc
{
    [self teardownXMPP];
}

#pragma mark 释放XMPP相关资源
-(void)teardownXMPP
{
    // 移除代理
    [_xmppStream removeDelegate:self];
    // 停止模块
    [_reconnect deactivate];
    [_vCard deactivate];
    [_vCardAvatar deactivate];
    [_roster deactivate];
    
    // 断开连接
    [_xmppStream disconnect];
    // 清空资源
    _reconnect = nil;
    _vCard = nil;
    _vCardStorage = nil;
    _vCardAvatar = nil;
    _xmppStream = nil;
    _roster = nil;
    
}

@end

