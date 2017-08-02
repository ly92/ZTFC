//
//  PaymentMonthCell.m
//  colourlife
//
//  Created by liuyadi on 16/1/8.
//  Copyright © 2016年 liuyadi. All rights reserved.
//  预缴物业费每项需要缴的信息

#import "PaymentMonthCell.h"

@interface PaymentMonthCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation PaymentMonthCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.borderColor = [AppTheme mainColor].CGColor;
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
}

- (void)dataDidChange
{
    OrderInfoModel * orderInfo = self.data;
    if ( orderInfo )
    {
        self.timeLabel.text = orderInfo.time;
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%@", orderInfo.totalMoney];
        
        if ( orderInfo.isSelected )
        {
            self.backgroundColor = BUTTON_BLUECOLOR;
            self.timeLabel.textColor = [UIColor whiteColor];
            self.moneyLabel.textColor = [UIColor whiteColor];
        }
        else
        {
            self.backgroundColor = [UIColor whiteColor];
            self.timeLabel.textColor = [AppTheme titleColor];
            self.moneyLabel.textColor = [AppTheme subTitleColor];
        }
    }
}

@end
