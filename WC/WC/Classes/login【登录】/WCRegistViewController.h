//
//  WCRegistViewController.h
//  WC
//
//  Created by YuanMiaoHeng on 16/5/30.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol WCRegistViewControllerDelegate <NSObject>

- (void)regisgerViewControllerDidFinishRegister;
@end

@interface WCRegistViewController : UIViewController

@property(nonatomic, weak) id <WCRegistViewControllerDelegate> delegate ;


@end
