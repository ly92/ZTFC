//
//  voucherTableViewCell.m
//  colourlife
//
//  Created by 李勇 on 16/1/7.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "voucherTableViewCell.h"
#import "CouponListModel.h"

@interface voucherTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *subNameL;
@property (weak, nonatomic) IBOutlet UILabel *unuseL;
@property (weak, nonatomic) IBOutlet UILabel *expireL;
@property (weak, nonatomic) IBOutlet UILabel *usedL;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@end
@implementation voucherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)dataDidChange{
//
    CouponModel *voucher = self.data;
    if (voucher){
        self.nameL.text = voucher.name;
        self.subNameL.text = voucher.title;
        self.unuseL.text = voucher.unuse;
        self.expireL.text = voucher.expire;
        self.usedL.text = voucher.used;
        [self.imgV setImageWithURL:[NSURL URLWithString:voucher.imageurl] placeholder:[UIImage imageNamed:@"contentIamge_no_bg"]];
    }
    
}  

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
