//
//  WCOtherLoginController.m
//  WC
//
//  Created by YuanMiaoHeng on 16/5/27.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "WCOtherLoginController.h"
#import "AppDelegate.h"

@interface WCOtherLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;

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
}

#pragma mark 登录
- (IBAction)loginBtnClick:(UIButton *)sender {
    
    [USERDEFAULTS setObject:self.accountTF.text forKey:@"User"];
    [USERDEFAULTS setObject:self.pswTF.text forKey:@"Psw"];
    [USERDEFAULTS synchronize];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app login];
}

@end
