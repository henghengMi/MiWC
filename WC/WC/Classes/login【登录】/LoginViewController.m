//
//  LoginViewController.m
//  WC
//
//  Created by YuanMiaoHeng on 16/5/30.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "LoginViewController.h"
#import "WCRegistViewController.h"
#import "WCNavgationController.h"

@interface LoginViewController ()<WCRegistViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
    // 设置TextField和Btn的样式
    self.pswTF.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.pswTF addLeftViewWithImage:@"Card_Lock"];
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];

    // 设置上次登录的用户名
    [[UserInfo sharedUserInfo] loadUserInfoFormSanBox];
    NSString *user = [UserInfo sharedUserInfo].account;
    self.userName.text = user;
}

- (IBAction)loginBtnClick:(UIButton *)sender {
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    userInfo.account = self.userName.text;
    userInfo.password = self.pswTF.text;
    [super login];
}

- (IBAction)registBtnClick:(id)sender {
    
}

- (IBAction)forgetPswBtn:(id)sender {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     id desVC = segue.destinationViewController;
    if ([desVC isKindOfClass : [WCNavgationController class]]) {
        WCNavgationController *nav = (WCNavgationController *)desVC;
        if ([nav.topViewController isKindOfClass:[WCRegistViewController class]]) {
            WCRegistViewController *registVC = (WCRegistViewController *)nav.topViewController;
            registVC.delegate = self;
        }
    }
}

#pragma mark 注册成功回调
- (void)regisgerViewControllerDidFinishRegister
{
     NSLog(@"-----注册成功回调");
    UserInfo *info = [UserInfo sharedUserInfo];
    self.userName.text = info.registAccount;
    
}


@end
