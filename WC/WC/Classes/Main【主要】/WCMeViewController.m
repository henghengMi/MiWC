//
//  WCMeViewController.m
//  WC
//
//  Created by YuanMiaoHeng on 16/5/30.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "WCMeViewController.h"
#import "AppDelegate.h"

@interface WCMeViewController ()

@end

@implementation WCMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];



}
- (IBAction)logout:(UIBarButtonItem *)sender {
    

//    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [[WCXMPPTool sharedWCXMPPTool] logout];
    
}


@end
