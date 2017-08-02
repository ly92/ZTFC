//
//  ConfirmOrderListCell.m
//  colourlife
//
//  Created by liuyadi on 16/1/9.
//  Copyright © 2016年 liuyadi. All rights reserved.
//  缴费信息列表详情

#import "ConfirmOrderListCell.h"

@interface ConfirmOrderListCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation ConfirmOrderListCell

- (void)dataDidChange
{
    if ( [self.data isKindOfClass:[OrderInfoModel class]] )
    {
        OrderInfoModel * orderInfo = self.data;
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%@", orderInfo.totalMoney];
        self.timeLabel.text = orderInfo.time;
        self.moneyLabel.textColor = [UIColor colorWithRGBValue:0xFF8236];
    }
//    else if ( [self.data isKindOfClass:[PARKINGINFO class]] )
//    {
//        PARKINGINFO * info = self.data;
//        self.timeLabel.text = info.name;
//        self.moneyLabel.text = info.value;
//        self.moneyLabel.textColor = [AppTheme titleColor];
//    }
}

@end
