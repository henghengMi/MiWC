//
//  AppDelegate.m
//  XMPP-USE
//
//  Created by YuanMiaoHeng on 16/5/27.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "AppDelegate.h"
#import "WCNavgationController.h"
#import "XMPPFramework.h"

#import "DDLog.h"
#import "DDTTYLogger.h"

@interface AppDelegate ()<XMPPStreamDelegate>

@property(nonatomic, strong) XMPPStream  * xmppStream;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
     NSLog(@"path:%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] );
    // 打开XMPP的日志
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // 设置导航栏背景
    [WCNavgationController setupNavTheme];
    
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

@end
