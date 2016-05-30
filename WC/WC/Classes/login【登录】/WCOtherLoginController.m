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
@interface WCOtherLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation WCOtherLoginController


- (void)viewDidLoad {
    [super viewDidLoad];

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftConstraints.constant = 10;
        self.rightConstraint.constant = 10;
    }
    self.accountTF.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pswTF.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.accountTF.text = [USERDEFAULTS objectForKey:@"User"];
    self.pswTF.text = [USERDEFAULTS objectForKey:@"Psw"];
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
}

#pragma mark 登录
- (IBAction)loginBtnClick:(UIButton *)sender {
    
    [MBProgressHUD showMessage:@"登录中.."];
    
    [USERDEFAULTS setObject:self.accountTF.text forKey:@"User"];
    [USERDEFAULTS setObject:self.pswTF.text forKey:@"Psw"];
    [USERDEFAULTS synchronize];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    __weak typeof (self) weakSelf = self;
    [app loginWithResultBlock:^(XMPPLoginStatus status) {
        [weakSelf loginHanddleWithStatus:status];
    }];
}

- (void)loginHanddleWithStatus:(XMPPLoginStatus)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
     [MBProgressHUD hideHUD];
        __weak typeof (self) weakSelf = self;

        switch (status) {
            case XMPPLoginStatusSuccess:
            {
                NSLog(@"登录成功");
                [MBProgressHUD showSuccess:@"登录成功"];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                weakSelf.view.window.rootViewController = mainStoryboard.instantiateInitialViewController;
            }
                break;
                
            case XMPPLoginStatusFailure:
            {
                NSLog(@"登录失败");
                [MBProgressHUD showError:@"账号或密码不正确"];
            }
            case XMPPLoginConnectError:
            {
                NSLog(@"连接失败或连接中");
                [MBProgressHUD showError:@"连接失败或连接中"];
            }
            default:
                break;
        }
    });

}

- (void)dealloc
{
     NSLog(@"dealloc");
}

@end
