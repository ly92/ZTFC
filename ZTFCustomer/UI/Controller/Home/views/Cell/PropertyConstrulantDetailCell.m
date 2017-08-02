//
//  PropertyConstrulantDetailCell.m
//  ztfCustomer
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "PropertyConstrulantDetailCell.h"

@interface PropertyConstrulantDetailCell ()


@end

@implementation PropertyConstrulantDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.changePropertyButton setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark-click

//切换置业顾问
- (IBAction)changePropertyButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(changePropertyClick)]) {
        [self.delegate changePropertyClick];
    }
}

//拨打电话
- (IBAction)mobileClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(mobileClick)]) {
        [self.delegate mobileClick];
    }

}

//短信
- (IBAction)smsClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(smsClick)]) {
        [self.delegate smsClick];
    }

}


@end
