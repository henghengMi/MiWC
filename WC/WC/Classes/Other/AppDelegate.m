//
//  AppDelegate.m
//  XMPP-USE
//
//  Created by YuanMiaoHeng on 16/5/27.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "AppDelegate.h"
#import "WCNavgationController.h"
#import "XMPP.h"

@interface AppDelegate ()<XMPPStreamDelegate>

@property(nonatomic, strong) XMPPStream  * xmppStream;

//// 1. 初始化XMPPStream
//-(void)setupXMPPStream;
//
//
//// 2.连接到服务器
//-(void)connectToHost;
//
//// 3.连接到服务成功后，再发送密码授权
//-(void)sendPwdToHost;
//
//
//// 4.授权成功后，发送"在线" 消息
//-(void)sendOnlineToHost;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 设置导航栏背景
    [WCNavgationController setupNavTheme];
    
//    [application setStatusBarStyle:<#(UIStatusBarStyle)#>]
    
    // 从沙里加载用户的数据到单例
     [[UserInfo sharedUserInfo] loadUserInfoFormSanBox];
    // 判断用户的登录状态，YES 直接来到主界面
    if([UserInfo sharedUserInfo].logined){
        UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = storayobard.instantiateInitialViewController;
        
        // 自动登录服务
        [[WCXMPPTool sharedWCXMPPTool] loginWithResultBlock:nil];
    }

    
    return YES;
}

//#pragma mark 初始化XMPPStream
//-(void)setupXMPPStream
//{
//    _xmppStream = [[XMPPStream alloc] init];
//    // 设置代理
//    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
//}
//
//#pragma mark 连接到服务器
//-(void)connectToHost
//{
//    NSLog(@"开始连接到服务器");
//    if (!_xmppStream) {
//        [self setupXMPPStream];
//    }
//    
//    NSString *account = nil;
//    if (self.isRegisterOperation) {  // 是注册操作
//        account = [UserInfo sharedUserInfo].registAccount;
//    }else {
//        account = [UserInfo sharedUserInfo].account;
//    }
//
//    // 设置登录用户JID
//    // resource 标识用户登录的客户端 iphone android
//    XMPPJID *myJID = [XMPPJID jidWithUser:account domain:@"hengheng.local" resource:@"iphone"];
//    _xmppStream.myJID = myJID;
//    // 设置服务器域名
//    _xmppStream.hostName = @"hengheng.local";
//    
//    // 设置端口 如果服务器端口是5222,可以省略
//    
//    // 连接
//    NSError *err = nil;
//    if(![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]) {
//        NSLog(@"%@",err);
//    }
//}
//
//
//#pragma mark 3.连接到服务成功后，再发送密码授权
//-(void)sendPwdToHost {
//    NSLog(@"发送密码授权");
//    NSError *err = nil;
//    
//    // 发送注册的密码 还是 登录密码?
//    [_xmppStream authenticateWithPassword:[UserInfo sharedUserInfo].password error:&err];
//    if (err) {
//        NSLog(@"%@",err);
//    }
//}
//
//
//#pragma mark  4.授权成功后，发送"在线" 消息
//-(void)sendOnlineToHost {
//    NSLog(@"发送 在线 消息");
//    XMPPPresence *presence = [XMPPPresence presence];
//    NSLog(@"%@",presence);
//    [_xmppStream sendElement:presence];
//}
//
//#pragma mark -XMPPStream的代理
//- (void)xmppStreamDidConnect:(XMPPStream *)sender
//{
//    NSLog(@"与主机连接成功");
//    
//    if (self.isRegisterOperation) {//注册操作，发送注册的密码
//        NSString *pwd = [UserInfo sharedUserInfo].registPassword;
//        [_xmppStream registerWithPassword:pwd error:nil];
//    }else{//登录操作
//        // 主机连接成功后，发送密码进行授权
//        [self sendPwdToHost];
//    }
//}
//
//- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
//{
//    NSLog(@"与主机断开连接 %@",error);
//}
//
//#pragma mark 授权成功
//- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
//{
//    NSLog(@"授权成功");
//    [self sendOnlineToHost];
//    
//    // 存储密码和账号
//    
//    // 登录成功来到主界面
//    if (self.loginResultBlock) {
//        self.loginResultBlock(XMPPLoginStatusSuccess);
//    }
//    
//}
//
//#pragma mark 授权失败
//-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
//{
// 
//    NSLog(@"授权失败 %@",error);
//    if (self.loginResultBlock) {
//        self.loginResultBlock(XMPPLoginStatusFailure);
//    }
//}
//
//#pragma mark 注册成功
//-(void)xmppStreamDidRegister:(XMPPStream *)sender{
//     NSLog(@"注册成功");
//    if (self.loginResultBlock) {
//        self.loginResultBlock(XMPPRegistStatusSuccess);
//    }
//}
//
//#pragma mark 注册失败
//-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
//    if (self.loginResultBlock) {
//        self.loginResultBlock(XMPPRegistStatusFailure);
//    }
//    NSLog(@"注册失败 %@",error);
//}
//
//#pragma mark 公共方法
//-(void)logout{
//    // 1. 发送“离线”消息
//    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
//    [_xmppStream sendElement:offline];
//    
//    // 2. 与服务器断开连接
//    [_xmppStream disconnect];
//    
//    // 3. 回到登录界面
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    self.window.rootViewController = storyboard.instantiateInitialViewController;
//    
//    //4.更新用户的登录状态
//    [UserInfo sharedUserInfo].logined = NO;
//    [[UserInfo sharedUserInfo] saveUserInfoToSanBox];
//}
//
//#pragma mark 登录
//-(void)loginWithResultBlock:(XMPPLoginResultBlock)loginResultBlock{
//    // 保留Block
//    self.loginResultBlock = loginResultBlock;
//    
//    // 如果以前连接过服务，要断开
//    if ([_xmppStream isConnected]) {
//        [_xmppStream disconnect];
//    }
//    
//    [self connectToHost];
//}
//
//
//#pragma mark 注册
//-(void)registWithResultBlock:(XMPPLoginResultBlock)loginResultBlock{
//    // 保留Block
//    self.loginResultBlock = loginResultBlock;
//    
//    // 如果以前连接过服务，要断开
//    if ([_xmppStream isConnected]) {
//        [_xmppStream disconnect];
//    }
//    
//    [self connectToHost];
//}
@end
