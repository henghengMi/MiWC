//
//  WCChatViewController.m
//  WC
//
//  Created by YuanMiaoHeng on 16/6/4.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "WCChatViewController.h"
#import "InputView.h"
#import "HttpTool.h"

@interface WCChatViewController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSLayoutConstraint *inputViewbottomConstraint;//inputView底部约束
@property (nonatomic, strong) NSLayoutConstraint *inputViewHeightConstraint;//inputView高度约束
@property (nonatomic, strong) NSFetchedResultsController *resultContrl;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) HttpTool *httpTool;

@end

@implementation WCChatViewController

- (HttpTool *)httpTool
{
    if (!_httpTool) {
        _httpTool = [[HttpTool alloc] init];
    }
    return _httpTool;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupView];
    
    [self loadstorage];
    // 键盘监听
    // 监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)noti{
    NSLog(@"%@",noti);
    
    // 获取键盘的高度
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat kbHeight =  kbEndFrm.size.height;
    
    
    //竖屏{{0, 0}, {768, 264}
    //横屏{{0, 0}, {352, 1024}}
    // 如果是ios7以下的，当屏幕是横屏，键盘的高底是size.with
    if([[UIDevice currentDevice].systemVersion doubleValue] < 8.0
       && UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        kbHeight = kbEndFrm.size.width;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.inputViewbottomConstraint.constant = kbHeight;
    } completion:^(BOOL finished) {
            [self scrollToLastRow];
    }];
}

-(void)keyboardWillHide:(NSNotification *)noti{
    [UIView animateWithDuration:0.25 animations:^{
        // 隐藏键盘的进修 距离底部的约束永远为0
        self.inputViewbottomConstraint.constant = 0;
   }];
}

- (void)setupView
{
    // tableview
    UITableView *tableView = [[UITableView alloc] init];
//    tableView.backgroundColor = [UIColor redColor];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // inputView
    InputView *inputView = [InputView inputView];
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    inputView.textView.delegate = self;
    [self.view addSubview:inputView];
    [inputView.addBtn addTarget: self action:@selector(addBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 约束
    // 1. tablview水平约束
    NSDictionary *views = @{
                            @"tableview" : tableView,
                            @"inputview" : inputView
                            };
   NSArray *tableviewHContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableview]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tableviewHContraints];
    // 2. inputview 水平方向约束
    NSArray *inputViewHContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputview]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:inputViewHContraints];
    
    //  垂直方向约束
    NSArray *vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableview]-(0)-[inputview(50)]-(0)-|" options:0 metrics:nil views:views];
    self.inputViewbottomConstraint = [vContraints lastObject];
    self.inputViewHeightConstraint = vContraints[2];
    [self.view addConstraints:vContraints];

}

#pragma mark addBtnClick
- (void)addBtnClick
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image =  info[UIImagePickerControllerOriginalImage];
    
    // 将image上传到服务器
    // 1.图片名字：用户名加时间
    NSString *user = [UserInfo sharedUserInfo].account;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *timeStr = [formatter stringFromDate:[NSDate date]];
    
    // 针对我的服务，文件名不用加后缀
    NSString *imageName = [user stringByAppendingString:timeStr];

    // 2. 拼接路径
//    NSString *uploadUrl = [@"http://localhost:8080/imfileserver/Upload/Image/" stringByAppendingString:imageName];
    NSString *uploadUrl = @"http://img1.imgtn.bdimg.com/it/u=2379451779,1873192372&fm=21&gp=0.jpg";
    
    // 3. 上传 (貌似服务器已经失效)
    [self.httpTool uploadData:UIImageJPEGRepresentation(image, 0.75) url:[NSURL URLWithString:uploadUrl] progressBlock:^(CGFloat progress) {
        
    } completion:^(NSError *error) {
        if (error) {
            NSLog(@"error: %@",error);
        }else
        {
            NSLog(@"上传成功");
        }
    }];
    
    [self sendMessagewithText:uploadUrl bodyType:@"image"];
    
}


#pragma mark textViewDidChange
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat contentSizeHeight = textView.contentSize.height;
    NSLog(@"contentSizeHeigt : %f ",contentSizeHeight);
    if (contentSizeHeight > 33 && contentSizeHeight < 68) {
        self.inputViewHeightConstraint.constant = contentSizeHeight + 18;
    }
    
    NSString *text = textView.text;
    if ([text rangeOfString:@"\n"].length != 0) {
        // 换行了证明点击了发送键
         NSLog(@"发送消息");
        // 去除换行字符
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        // 变回50高度
        self.inputViewHeightConstraint.constant = 50;
        
        [self sendMessagewithText:text bodyType:@"text"];
        
        textView.text = nil;
    }
}

- (void)sendMessagewithText:(NSString *)text bodyType:(NSString *)bodyType
{
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    
    // 添加标签（用于分辨上传至服务器的东西是视频还是文本还是语音类型）
    [message addAttributeWithName:@"bodyType" stringValue:bodyType];
    
    // 设置内容
    [message addBody:text];
     NSLog(@"%@",message);
    [[WCXMPPTool sharedWCXMPPTool].xmppStream sendElement:message];
}

- (void)loadstorage
{
    // 1. 上下文
    NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].msgStorage.mainThreadManagedObjectContext;
    // 2. 请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    // 3. 过滤 排序
    // 3.1 当前登陆用户的jid的消息
    // 3.2 好友的jid消息
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[UserInfo sharedUserInfo].jid,self.friendJid.bare];
     NSLog(@"self.friendJid.bare%@",self.friendJid.bare);
    request.predicate = pre;
    
    // 3.3 排序
    NSSortDescriptor *timesort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timesort];
    
    // 4. 执行
    _resultContrl = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    NSError *err = nil;
    [_resultContrl performFetch:&err];
    if (err) {
         NSLog(@"err:%@",err);
    }
     NSLog(@"_resultContrl.fetchedObjects.count : %ld",_resultContrl.fetchedObjects.count);
    
    _resultContrl.delegate = self;
}

#pragma mark - 消息数据库改变时会调用
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
     NSLog(@"消息数据发生改变");
    [self.tableView reloadData];
    [self scrollToLastRow];
}


#pragma mark tableView dataSource & dalegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//     NSLog(@"_resultContrl.fetchedObjects.count %d",_resultContrl.fetchedObjects.count);
    return _resultContrl.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
   XMPPMessageArchiving_Message_CoreDataObject *msg = self.resultContrl.fetchedObjects[indexPath.row];
    
    NSString *bodyType = [msg.message attributeStringValueForName:@"bodyType"];
    if([bodyType isEqualToString:@"image"])
    {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:msg.body] placeholderImage:[UIImage imageNamed:@"DefaultProfileHead_qq"]];
         NSLog(@"msg.body %@",msg.body);
        cell.textLabel.text = nil;
    }else if ([bodyType isEqualToString:@"text"]) {
        // 显示消息：
        if ([msg.outgoing boolValue]) { // 自己发的
            cell.textLabel.text = [NSString stringWithFormat:@"Me : %@",msg.body];
        }else{ // 别人发的
            cell.textLabel.text = [NSString stringWithFormat:@"Other : %@",msg.body];
        }
        cell.imageView.image = nil;
    }

    // 只执行一次
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self scrollToLastRow];
        });
   
    
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

#pragma mark 滚动到底部
- (void)scrollToLastRow
{
    NSInteger lastRow = self.resultContrl.fetchedObjects.count - 1;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastRow inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}






@end
