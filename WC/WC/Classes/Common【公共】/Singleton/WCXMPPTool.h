//
//  WCXMPPTool.h
//  WC
//
//  Created by YuanMiaoHeng on 16/5/30.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPFramework.h"

@interface WCXMPPTool : NSObject

singleton_interface(WCXMPPTool)

typedef enum {
    XMPPLoginStatusSuccess = 0,
    XMPPLoginStatusFailure,
    XMPPRegistStatusSuccess,
    XMPPRegistStatusFailure,
    XMPPLoginConnectError
    
}XMPPLoginStatus;

typedef void (^XMPPLoginResultBlock) (XMPPLoginStatus status);

@property (copy, nonatomic)XMPPLoginResultBlock loginResultBlock;

@property(nonatomic, strong) XMPPStream  * xmppStream;

/**
 *  注册标识 YES 注册 / NO 登录
 */
@property (nonatomic, assign,getter=isRegisterOperation) BOOL  registerOperation;//注册操作

@property(nonatomic, strong, readonly) XMPPvCardTempModule *vCard; // 电子名片

@property(nonatomic, strong, readonly) XMPPRoster *roster; // 花名册

@property(nonatomic, strong, readonly) XMPPRosterCoreDataStorage *rosterStorage; // 花名册数据存储

@property(nonatomic, strong, readonly) XMPPMessageArchivingCoreDataStorage *msgStorage; // 消息数据存储





-(void)logout;

-(void)loginWithResultBlock:(XMPPLoginResultBlock ) loginResultBlock;

-(void)registWithResultBlock:(XMPPLoginResultBlock ) loginResultBlock;



@end
