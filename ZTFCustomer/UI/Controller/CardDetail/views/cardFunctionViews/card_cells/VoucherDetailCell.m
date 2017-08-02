//
//  VoucherDetailCell.m
//  colourlife
//
//  Created by ly on 16/1/12.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "VoucherDetailCell.h"
#import "CouponListModel.h"

@interface VoucherDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *amountL;
@property (weak, nonatomic) IBOutlet UILabel *snL;
@property (weak, nonatomic) IBOutlet UILabel *dateLimit;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (weak, nonatomic) IBOutlet UIImageView *stateImgV;

@end

@implementation VoucherDetailCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)dataDidChange{

    SnModel *sn = self.data;
    if (sn){
        float amount = [self.amount doubleValue];
        self.amountL.text = [NSString stringWithFormat:@"%.2f",amount];
        self.snL.text = sn.sn;
        self.dateLimit.text = [NSString stringWithFormat:@"有效期:%@-%@",sn.start_date,sn.end_date];
        
        NSString *endDate = sn.end_date;
        NSString *now = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
        NSLog(@"%@",endDate);
        if ([now compare:endDate] == NSOrderedDescending) {//过期
            self.stateImgV.hidden = NO;
            self.bgImgV.image = [UIImage imageNamed:@"e6_card3_grey_bg"];
            self.stateImgV.image = [UIImage imageNamed:@"e6_ticket_overdue"];
        }
        
         //状态 0未使用，1已使用
        if ([sn.status intValue] == 1){
            self.stateImgV.hidden = NO;
            self.bgImgV.image = [UIImage imageNamed:@"e6_card3_grey_bg"];
            self.stateImgV.image = [UIImage imageNamed:@"e6_ticket_used"];
        }else if ([sn.status intValue] == 0 && [now compare:endDate] != NSOrderedDescending){//可使用
            self.bgImgV.image = [UIImage imageNamed:@"e6_card3_bg"];
            self.stateImgV.hidden = YES;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
