//
//  PropertyOrderCell.m
//  colourlife
//
//  Created by liuyadi on 16/1/8.
//  Copyright © 2016年 liuyadi. All rights reserved.
//  预缴物业费订单cell

#import "PropertyOrderCell.h"

@interface PropertyOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@end

@implementation PropertyOrderCell

- (void)dataDidChange
{
    OrderInfoModel * orderInfo = self.data;
    if ( orderInfo )
    {
        self.moneyLabel.text = [NSString stringWithFormat:@"%@元", orderInfo.totalMoney];
        self.timeLabel.text = orderInfo.time;
        if ( orderInfo.isOpen )
        {
            self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
        }
        else
        {
            self.arrowImage.transform = CGAffineTransformMakeRotation(0);
        }
    }
}

@end
