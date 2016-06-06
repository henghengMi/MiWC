//
//  WCUserInfoController.m
//  WC
//
//  Created by YuanMiaoHeng on 16/5/31.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "WCUserInfoController.h"
#import "XMPPvCardTemp.h"
#import "WCXMPPTool.h"
#import "WCVCarEditController.h"
@interface WCUserInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,WCVCarEditControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *wcNum;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *department;
@property (weak, nonatomic) IBOutlet UILabel *job;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *email;

@end

@implementation WCUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadVCarInfo];
}

#pragma mark 加载个人信息
- (void)loadVCarInfo
{
    XMPPvCardTemp * myVCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    
    // 头像
    if (myVCard.photo) {
        self.iconImageView.image = [UIImage imageWithData:myVCard.photo];
    }
    
    // 昵称
    self.nickName.text = myVCard.nickname;
    
    // 微信号
    self.wcNum.text = [UserInfo sharedUserInfo].account;
    
    // 公司
    self.company.text = myVCard.orgName;
    
    // 部门
    if (myVCard.orgUnits.count) {
        self.department.text = myVCard.orgUnits[0];
    }
    
    // 职位
    self.job.text = myVCard.title;
    
    // 电话 （没解析）  获取不到电话
    // 使用Note字段充当电话
    self.phone.text = myVCard.note;
    
    //邮件解析   //不管有多少个邮件，只取第一个
    if (myVCard.emailAddresses.count > 0) self.email.text = myVCard.emailAddresses[0];

}

#pragma mark tableviewtalegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger tag = cell.tag;
    
    if (tag == 0) { // 头像
         NSLog(@"点击了头像");
        
       
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择照骗" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];

        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"照相" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *  action) {
           
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction *  action) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing = YES;
             picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];

        }];
        
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *  action) {
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:action3];

//        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            textField.textColor = [UIColor redColor];
//        }];
//        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            textField.textColor = [UIColor redColor];
//            textField.placeholder = @"请输入密码";
//            textField.secureTextEntry = YES;
//        }];
        
        [self presentViewController:alert animated:YES completion:nil];

        
    } else if (tag == 1)
    {
        
        [self performSegueWithIdentifier:@"vCarEdit" sender:cell];
        
         NSLog(@"点击过去控制器");
    } else if (tag == 2)
    {
         NSLog(@"点击不过去");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//    NSLog(@"info :%@",info);
    UIImage *selectedImg = info[UIImagePickerControllerEditedImage];
    self.iconImageView.image = selectedImg;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self editUserInfoToUpdate];
}

#pragma mark 全部信息的更新
- (void)editUserInfoToUpdate
{
    // 更新（上传服务器）
    XMPPvCardTemp *myVCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    // 图片
    myVCard.photo = UIImagePNGRepresentation(self.iconImageView.image );
    
    // 昵称
    myVCard.nickname = self.nickName.text;
    // 公司
    myVCard.orgName = self.company.text;
    // 部门
    if(self.department.text.length > 0) {
        myVCard.orgUnits = @[self.department.text];
    }
    // 职位
    myVCard.title = self.job.text;
    // 电话
    myVCard.note = self.phone.text;
    // 邮件
    if (myVCard.emailAddresses.count > 0) {
//        self.email.text = myVCard.emailAddresses[90];
        myVCard.emailAddresses = @[self.email.text];
    }
//    myVCard.emailAddresses = self.email.text;
    
    // 上传更新 自动上传至服务器 无需客户端操作
//    [[WCXMPPTool sharedWCXMPPTool].vCard updatemyVCarddTemp:myVCard];
    [[WCXMPPTool sharedWCXMPPTool].vCard updateMyvCardTemp:myVCard];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id desVC = segue.destinationViewController;
    if ([desVC isKindOfClass:[WCVCarEditController class]]) {
        WCVCarEditController *editVC = (WCVCarEditController *)desVC;
        editVC.delegate = self;
       UITableViewCell *cell =  ( UITableViewCell *)sender;
//        editVC.cellTitle = cell.textLabel.text;
//        editVC.descritionTitle = cell.detailTextLabel.text;
        editVC.cell = cell;
    }
}

#pragma mark 保存成功代理回调
- (void)saveUserInfoSuccess
{
    [self editUserInfoToUpdate];
}

@end
