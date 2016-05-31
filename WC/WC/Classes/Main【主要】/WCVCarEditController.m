//
//  WCVCarEditController.m
//  WC
//
//  Created by YuanMiaoHeng on 16/5/31.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "WCVCarEditController.h"

@interface WCVCarEditController ()

@property (weak, nonatomic) IBOutlet UITextField *tf;

@end

@implementation WCVCarEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = self.cellTitle;
//    self.tf.text = self.descritionTitle;
//
    self.title = self.cell.textLabel.text;
    self.tf.text = self.cell.detailTextLabel.text;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(save)];
    
}

- (void)save
{
    self.cell.detailTextLabel.text = self.tf.text;
    if ([self.delegate respondsToSelector:@selector(saveUserInfoSuccess)]) {
        [self.delegate saveUserInfoSuccess];
    }
    [self.navigationController popViewControllerAnimated:YES];

}

@end
