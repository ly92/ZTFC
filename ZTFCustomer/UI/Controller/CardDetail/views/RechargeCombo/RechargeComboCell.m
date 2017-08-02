//
//  RechargeComboCell.m
//  WeiTown
//
//  Created by 李勇 on 16/3/2.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "RechargeComboCell.h"

@interface RechargeComboCell ()
@property (retain, nonatomic) IBOutlet UILabel *nameLbl;
@property (retain, nonatomic) IBOutlet UILabel *amountsLbl;
@property (retain, nonatomic) IBOutlet UILabel *priceLbl;
@end

@implementation RechargeComboCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void)dataDidChange{
    RechargeComboModel *rechargeComboModel = (RechargeComboModel *)self.data;
    if (rechargeComboModel) {
        self.nameLbl.text = rechargeComboModel.name;
        self.amountsLbl.text = rechargeComboModel.amounts;
        self.priceLbl.text = [NSString stringWithFormat:@"%@元",rechargeComboModel.price];
    }
}

@end
