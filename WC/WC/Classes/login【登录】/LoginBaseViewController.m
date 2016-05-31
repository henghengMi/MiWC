//
//  LoginBaseViewController.m
//  WC
//
//  Created by YuanMiaoHeng on 16/5/30.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "LoginBaseViewController.h"
#import "AppDelegate.h"

@interface LoginBaseViewController ()

@end

@implementation LoginBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark 登录
- (void)login {
    [MBProgressHUD showMessage:@"登录中.."];
    [self.view endEditing:YES];
     [WCXMPPTool sharedWCXMPPTool].registerOperation = NO;
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
    __weak typeof (self) weakSelf = self;
    [[WCXMPPTool sharedWCXMPPTool] loginWithResultBlock:^(XMPPLoginStatus status) {
        [weakSelf loginHanddleWithStatus:status];
    }];
}

- (void)loginHanddleWithStatus:(XMPPLoginStatus)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        
        switch (status) {
            case XMPPLoginStatusSuccess:
            {
                NSLog(@"登录成功");
                [self loginSuccessHanddle];
            }
                break;
                
            case XMPPLoginStatusFailure:
            {
                NSLog(@"登录失败");
                [MBProgressHUD showError:@"账号或密码不正确"];
            }
                
            default:
                break;
        }
    });
    
}

-(void)loginSuccessHanddle
{
    __weak typeof (self) weakSelf = self;
    [MBProgressHUD showSuccess:@"登录成功"];
    // 保存账号和密码
    
    // 单例存储账号密码
    [UserInfo sharedUserInfo].logined = YES;
    [[UserInfo sharedUserInfo] saveUserInfoToSanBox];
    
    [weakSelf dismissViewControllerAnimated:YES completion:nil];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    weakSelf.view.window.rootViewController = mainStoryboard.instantiateInitialViewController;
}


@end
