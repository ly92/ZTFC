//
//  VoucherHeaderView.m
//  colourlife
//
//  Created by 李勇 on 16/2/29.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "VoucherHeaderView.h"

@implementation VoucherHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self = [[[NSBundle mainBundle] loadNibNamed:@"VoucherHeaderView" owner:nil options:nil] firstObject];
    }
    return self;
}

@end
