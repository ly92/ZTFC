//
//  PayOrderCell.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "PayOrderCell.h"

@interface PayOrderCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountsLbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountsWidth;

@end

@implementation PayOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dataDidChange{
    TransactionModel *payOrderModel = (TransactionModel *)self.data;
    if (payOrderModel) {
        
        
        NSArray *arr = [payOrderModel.content componentsSeparatedByString:@"\n\n"];
        NSString *content = [arr componentsJoinedByString:@""];
        
        self.nameLbl.text = content;
        
        self.amountsLbl.text = [NSString stringWithFormat:@"¥%@",payOrderModel.amount];
        
        CGFloat amountWidth = [self.amountsLbl resizeWidth];
        
        self.amountsWidth.constant = amountWidth;
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        [self.dateTimeLbl setText:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[payOrderModel.creationtime intValue]]]];
    }
}


@end
