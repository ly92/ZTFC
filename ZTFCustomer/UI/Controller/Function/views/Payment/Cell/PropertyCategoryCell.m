//
//  PropertyCategoryCell.m
//  colourlife
//
//  Created by liuyadi on 16/1/8.
//  Copyright © 2016年 liuyadi. All rights reserved.
//  预缴物业费信息列表详情

#import "PropertyCategoryCell.h"

@interface PropertyCategoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *propertyMoney;
@property (weak, nonatomic) IBOutlet UILabel *propertyName;

@end

@implementation PropertyCategoryCell

- (void)dataDidChange
{
    AppearModel * appear = self.data;
    if ( appear )
    {
        self.propertyName.text = appear.itemname;
        self.propertyMoney.text = [NSString stringWithFormat:@"%@元", appear.fee];
    }
}

@end
