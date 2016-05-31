//
//  WCContactController.m
//  WC
//
//  Created by YuanMiaoHeng on 16/5/31.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "WCContactController.h"
#import "WCXMPPTool.h"

@interface WCContactController ()
@property(nonatomic, strong) NSArray * friends;
@end

@implementation WCContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadFriends];
}

-(void)loadFriends
{
    //  如何用core获取数据
    // 1. 上下文【关连到数据库】XMPPRoster.sqlite
    
   NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    // 2. 请求对象FetchRequst【查哪张表】
    NSFetchRequest *requst = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 3. 设置过滤和排序
    // 过滤当前登录用户的好友
    NSString *jid = [UserInfo sharedUserInfo].jid;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    requst.predicate = pre;
    
    // 排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    requst.sortDescriptors = @[sort];
    
    // 4. 执行请求获取数据
    self.friends = [context executeFetchRequest:requst error:nil];
     NSLog(@"%@",self.friends);
}

#pragma mark tableView dataSource & dalegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    XMPPUserCoreDataStorageObject *object = self.friends[indexPath.row];
    cell.textLabel.text = object.nickname;
    cell.detailTextLabel.text = object.jidStr;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


@end
