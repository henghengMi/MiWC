//
//  InputView.m
//  WC
//
//  Created by YuanMiaoHeng on 16/6/4.
//  Copyright © 2016年 Mi. All rights reserved.
//

#import "InputView.h"

@implementation InputView

+ (instancetype)inputView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"InputView" owner:nil options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
