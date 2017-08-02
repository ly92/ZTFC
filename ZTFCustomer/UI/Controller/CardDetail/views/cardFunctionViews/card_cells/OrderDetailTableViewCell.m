//
//  OrderDetailTableViewCell.m
//  colourlife
//
//  Created by ly on 16/1/19.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "OrderDetailTableViewCell.h"
#import "CardOrderDetailModel.h"
@interface OrderDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *amountL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;

@end

@implementation OrderDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dataDidChange{
    
    OrderDetailModel *order = self.data;
    
    self.titleL.text = order.title;
    self.amountL.text = [NSString stringWithFormat:@"X%@",order.amount];
    self.priceL.text = [NSString stringWithFormat:@"¥ %@",order.totalprice];
}

@end
