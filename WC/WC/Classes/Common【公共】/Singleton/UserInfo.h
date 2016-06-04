//
//  UserInfo.h
//  WC
//
//  Created by YuanMiaoHeng on 16/5/30.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Singleton.h"
static NSString *domain = @"hengheng.local";
@interface UserInfo : NSObject


singleton_interface(UserInfo);

@property(nonatomic, copy) NSString * account;
@property(nonatomic, copy) NSString * password;
@property(nonatomic, copy) NSString * registAccount;
@property(nonatomic, copy) NSString * registPassword;
@property(nonatomic, assign) BOOL logined;
@property(nonatomic, copy) NSString * jid;



-(void)loadUserInfoFormSanBox;
-(void)saveUserInfoToSanBox;

@end
