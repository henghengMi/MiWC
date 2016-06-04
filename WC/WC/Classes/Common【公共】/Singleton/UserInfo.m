//
//  UserInfo.m
//  WC
//
//  Created by YuanMiaoHeng on 16/5/30.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "UserInfo.h"

#define accountKey @"account"
#define pswKey @"psw"
#define loginStatusKey @"loginStatus"



@implementation UserInfo

singleton_implementation(UserInfo)

// 读取
-(void)loadUserInfoFormSanBox
{
    self.account =  [USERDEFAULTS objectForKey:accountKey];
    self.password =  [USERDEFAULTS objectForKey:pswKey];
    self.logined =  [USERDEFAULTS boolForKey:loginStatusKey];
}

// 保存
-(void)saveUserInfoToSanBox
{
    [USERDEFAULTS setObject:self.account forKey:accountKey];
    [USERDEFAULTS setObject:self.password forKey:pswKey];
    [USERDEFAULTS setBool:self.logined forKey:loginStatusKey];
    [USERDEFAULTS synchronize];
}

- (NSString *)jid
{
    return [NSString stringWithFormat:@"%@@%@",self.account,domain];
}

@end
