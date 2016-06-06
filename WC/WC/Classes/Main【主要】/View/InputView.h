//
//  InputView.h
//  WC
//
//  Created by YuanMiaoHeng on 16/6/4.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputView : UIView

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

+ (instancetype)inputView;

@end
