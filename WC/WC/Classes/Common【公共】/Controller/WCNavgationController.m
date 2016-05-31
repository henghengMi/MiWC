//
//  WCNavgationController.m
//  WC
//
//  Created by YuanMiaoHeng on 16/5/30.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "WCNavgationController.h"

@interface WCNavgationController ()

@end

@implementation WCNavgationController


// 设置导航栏的主题
+(void)setupNavTheme{
    // 设置导航样式
    
    UINavigationBar *navBar = [UINavigationBar appearance
                               ];
    // 1.设置导航条的背景
    
    // 高度不会拉伸，但是宽度会拉伸
    [navBar setBackgroundImage:[UIImage imageNamed:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];
    
    // 2.设置栏的字体
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSForegroundColorAttributeName] = [UIColor whiteColor];
    att[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    
    [navBar setTitleTextAttributes:att];
    
    // 设置状态栏的样式
    // xcode5以上，创建的项目，默认的话，这个状态栏的样式由控制器决定
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];


}
//
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}


@end
