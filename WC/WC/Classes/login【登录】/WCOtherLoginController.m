//
//  WCOtherLoginController.m
//  WC
//
//  Created by YuanMiaoHeng on 16/5/27.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "WCOtherLoginController.h"
#import "AppDelegate.h"
#import "UIButton+WF.h"
#import "UserInfo.h"

@interface WCOtherLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation WCOtherLoginController

- (IBAction)dismiss:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftConstraints.constant = 10;
        self.rightConstraint.constant = 10;
    }
    self.accountTF.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pswTF.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];

    
    // 取出账号密码
//    [[UserInfo sharedUserInfo] loadUserInfoFormSanBox];
//    self.accountTF.text = [UserInfo sharedUserInfo].account;
//    self.pswTF.text = [UserInfo sharedUserInfo].password;

}

//#pragma mark 登录
- (IBAction)loginBtnClick:(UIButton *)sender {
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    userInfo.account = self.accountTF.text ;
    userInfo.password = self.pswTF.text;
    
    [super login];
}
//
//- (void)loginHanddleWithStatus:(XMPPLoginStatus)status
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//     [MBProgressHUD hideHUD];
//
//        switch (status) {
//            case XMPPLoginStatusSuccess:
//            {
//                NSLog(@"登录成功");
//                [self loginSuccessHanddle];
//            }
//                break;
//                
//            case XMPPLoginStatusFailure:
//            {
//                NSLog(@"登录失败");
//                [MBProgressHUD showError:@"账号或密码不正确"];
//            }
//
//            default:
//                break;
//        }
//    });
//
//}
//
//-(void)loginSuccessHanddle
//{
//    __weak typeof (self) weakSelf = self;
//    [MBProgressHUD showSuccess:@"登录成功"];
//    // 保存账号和密码
//    
//    // 单例存储账号密码
//    [UserInfo sharedUserInfo].logined = YES;
//    [[UserInfo sharedUserInfo] saveUserInfoToSanBox];
//    
//    [weakSelf dismissViewControllerAnimated:YES completion:nil];
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    weakSelf.view.window.rootViewController = mainStoryboard.instantiateInitialViewController;
//}

- (void)dealloc
{
     NSLog(@"dealloc");
}

@end
