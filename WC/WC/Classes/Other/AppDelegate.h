//
//  AppDelegate.h
//  WC
//
//  Created by YuanMiaoHeng on 16/5/27.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef enum {
//    XMPPLoginStatusSuccess = 0,
//    XMPPLoginStatusFailure,
//    XMPPRegistStatusSuccess,
//    XMPPRegistStatusFailure,
//    XMPPLoginConnectError
//    
//}XMPPLoginStatus;

//typedef void (^XMPPLoginResultBlock) (XMPPLoginStatus status);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (copy, nonatomic)XMPPLoginResultBlock loginResultBlock;

///**
// *  注册标识 YES 注册 / NO 登录
// */
//@property (nonatomic, assign,getter=isRegisterOperation) BOOL  registerOperation;//注册操作
//
//-(void)logout;
//
//-(void)loginWithResultBlock:(XMPPLoginResultBlock ) loginResultBlock;
//
//-(void)registWithResultBlock:(XMPPLoginResultBlock ) loginResultBlock;

@end

