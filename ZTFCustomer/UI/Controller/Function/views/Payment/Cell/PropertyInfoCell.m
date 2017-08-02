//
//  PropertyInfoCell.m
//  colourlife
//
//  Created by liuyadi on 16/1/8.
//  Copyright © 2016年 liuyadi. All rights reserved.
//  预交物业费信息

#import "PropertyInfoCell.h"

@interface PropertyInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumMoneyLabel;

@end

@implementation PropertyInfoCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.contentView.backgroundColor = ORANGE_VIEWCOLOR;
}

- (void)dataDidChange
{
    OrderInfoModel * orderInfo = self.data;
    if ( orderInfo )
    {
        if ( orderInfo.time && orderInfo.time.length )
        {
            self.monthLabel.text = orderInfo.time;
        }
        if ( orderInfo.totalMoney && orderInfo.totalMoney.length )
        {
            self.sumMoneyLabel.text = orderInfo.totalMoney;
        }
    }
}

@end
