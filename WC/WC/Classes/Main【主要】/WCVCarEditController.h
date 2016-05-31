//
//  WCVCarEditController.h
//  WC
//
//  Created by YuanMiaoHeng on 16/5/31.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WCVCarEditControllerDelegate  <NSObject>

- (void)saveUserInfoSuccess;

@end

@interface WCVCarEditController : UITableViewController

@property(nonatomic, strong) UITableViewCell * cell ;

@property(nonatomic, weak) id <WCVCarEditControllerDelegate> delegate ;


@end
