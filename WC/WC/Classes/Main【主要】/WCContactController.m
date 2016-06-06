//
//  WCContactController.m
//  WC
//
//  Created by YuanMiaoHeng on 16/5/31.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "WCContactController.h"
#import "WCXMPPTool.h"
#import "WCChatViewController.h"

@interface WCContactController ()<NSFetchedResultsControllerDelegate>
@property(nonatomic, strong) NSArray * friends;
@property(nonatomic, strong) NSFetchedResultsController * resultController;
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
//    self.friends = [context executeFetchRequest:requst error:nil];
//     NSLog(@"%@",self.friends);
    
    _resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:requst managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultController.delegate = self; // 数据库改变会通知代理
    NSError *err = nil;
    [_resultController performFetch:&err];
    if (err) {
         NSLog(@"err:%@",err);
    }
}

#pragma mark 数据库改变会通知此方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
     NSLog(@"数据发生改变");
    [self.tableView reloadData];
}

#pragma mark tableView dataSource & dalegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     sectionNum
     0 在线
     1 离开
     2 离线
     */
    
    static NSString *ID = @"id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    XMPPUserCoreDataStorageObject *friend = self.resultController.fetchedObjects[indexPath.row];
    
    cell.textLabel.text = friend.jidStr;
    
    cell.detailTextLabel.text = ([friend.sectionNum isEqual: @(0)]) ? @"在线" :  ([friend.sectionNum isEqual: @(1)]) ? @"离开" : @"离线";
    
//    cell.detailTextLabel.text = friend.jidStr;
    
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPUserCoreDataStorageObject *friend = self.resultController.fetchedObjects[indexPath.row];
    [[WCXMPPTool sharedWCXMPPTool].roster removeUser:friend.jid];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     XMPPUserCoreDataStorageObject *friend = self.resultController.fetchedObjects[indexPath.row];
    XMPPJID  *friendJid = friend.jid;
//    WCChatViewController *chatVC = [WCChatViewController new];
//    [self.navigationController pushViewController:chatVC animated:YES];
    [self performSegueWithIdentifier:@"chatSegue" sender:friendJid];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id desVC = segue.destinationViewController;
    if ([desVC isKindOfClass:[WCChatViewController class]]) {
        WCChatViewController *chatVC = (WCChatViewController *)desVC;
        chatVC.friendJid = sender;
    }
}

@end
