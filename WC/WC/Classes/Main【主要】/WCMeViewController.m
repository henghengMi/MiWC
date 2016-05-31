//
//  WCMeViewController.m
//  WC
//
//  Created by YuanMiaoHeng on 16/5/30.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "WCMeViewController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"
@interface WCMeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wcNumLabel;

@end

@implementation WCMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //  显示当前个人用户
    
    //  如何用core获取数据
    // 1. 上下文【关连到数据】
    // 2. 请求对象FetchRequst
    // 3. 设置过滤和排序
    // 4. 执行请求获取数据
    
    // XMPP提供一个方法直接获取个人信息
    
   XMPPvCardTemp *temp = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    if (temp.photo) {
        self.iconImageView.image = [UIImage imageWithData:temp.photo];
    }
    self.nicNameLabel.text = [NSString stringWithFormat:@"昵称:%@",temp.nickname];
    // 获取不到用户名。JID为空
    self.wcNumLabel.text = [NSString stringWithFormat:@"微信号:%@",[UserInfo sharedUserInfo].account];

}
- (IBAction)logout:(UIBarButtonItem *)sender {
    

//    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [[WCXMPPTool sharedWCXMPPTool] logout];
    
}


@end
