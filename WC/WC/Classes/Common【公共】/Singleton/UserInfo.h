//
//  UserInfo.h
//  WC
//
//  Created by YuanMiaoHeng on 16/5/30.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Singleton.h"

@interface UserInfo : NSObject

singleton_interface(UserInfo);

@property(nonatomic, copy) NSString * account;
@property(nonatomic, copy) NSString * password;
@property(nonatomic, copy) NSString * registAccount;
@property(nonatomic, copy) NSString * registPassword;
@property(nonatomic, assign) BOOL logined;



-(void)loadUserInfoFormSanBox;
-(void)saveUserInfoToSanBox;

@end
