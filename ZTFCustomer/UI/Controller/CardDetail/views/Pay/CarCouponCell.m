//
//  CarCouponCell.m
//  WeiTown
//
//  Created by kakatool on 15/12/2.
//  Copyright © 2015年 Hairon. All rights reserved.
//

#import "CarCouponCell.h"

@implementation CarCouponCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.selectedIcon.hidden = !selected;
}

@end
