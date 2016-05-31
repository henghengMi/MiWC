//
//  WCRegistViewController.m
//  WC
//
//  Created by YuanMiaoHeng on 16/5/30.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "WCRegistViewController.h"
#import "AppDelegate.h"
#import "UITextField+WF.h"
@interface WCRegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@end

@implementation WCRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftConstraints.constant = 10;
        self.rightConstraint.constant = 10;
    }
    self.accountTF.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pswTF.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.registBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    self.registBtn.enabled = NO;
}

- (IBAction)back:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)regist {
    
    
    if (![self.accountTF isTelphoneNum]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    
    [MBProgressHUD showMessage:@"注册中" toView:self.view];

    UserInfo *userInfo = [UserInfo sharedUserInfo];
    userInfo.registAccount = self.accountTF.text;
    userInfo.registPassword = self.pswTF.text;
    
    [WCXMPPTool sharedWCXMPPTool].registerOperation = YES;
    [[WCXMPPTool sharedWCXMPPTool] registWithResultBlock:^(XMPPLoginStatus status) {
        [self registResultHanddleWithStatus:status];
    }];
    
}

- (void)registResultHanddleWithStatus:(XMPPLoginStatus)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        switch (status) {
            case XMPPRegistStatusSuccess:
                [MBProgressHUD showSuccess:@"注册成功" toView:self.view];
                // 回到上个控制器
                [self dismissViewControllerAnimated:YES completion:nil];
                
                if ([self.delegate respondsToSelector:@selector(regisgerViewControllerDidFinishRegister)]) {
                    [self.delegate regisgerViewControllerDidFinishRegister];
                }
                break;
            case XMPPRegistStatusFailure:
                [MBProgressHUD showError:@"注册失败,用户名重复" toView:self.view];
                break;
            default:
                break;
        }
    });
}

- (IBAction)textChanged
{
   self.registBtn.enabled = self.accountTF.text.length && self.pswTF.text.length;
}

@end
