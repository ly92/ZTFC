//
//  CardPromotionTableViewCell.m
//  colourlife
//
//  Created by 李勇 on 16/1/14.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "CardPromotionTableViewCell.h"
#import "CardPromotionModel.h"

@interface CardPromotionTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *stypeL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@end

@implementation CardPromotionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)dataDidChange{
    PromotionModel *promotion = self.data;
    if (promotion && [promotion.msg_type isEqualToString:@"msg"]) {
        self.stypeL.text = @"商家促销";
    }
    else if (promotion && [promotion.msg_type isEqualToString:@"vote"])
    {
        self.stypeL.text = @"商家投票";
    }
    else if (promotion && [promotion.msg_type isEqualToString:@"events"])
    {
        self.stypeL.text = @"商家活动";
    }
    
//    NSDate *date = [NSDate dateFromStr:[NSDate longlongToDateTime:promotion.creationtime] withFormat:[NSDate timestampFormatString]];
//    self.timeL.text = [date timeAgo];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[promotion.creationtime  longLongValue]];
    self.timeL.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
    
    
    self.contentL.text = promotion.content;

    }
@end
