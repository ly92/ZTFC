//
//  CardPointTableViewCell.m
//  colourlife
//
//  Created by ly on 16/1/20.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "CardPointTableViewCell.h"
#import "CardPointModel.h"
@interface CardPointTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *amountL;

@end

@implementation CardPointTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dataDidChange{
    CardPointData *point = self.data;
    
    if ([point.cptypes intValue] == 1 && [point.subtype intValue] == 4){
        self.typeL.text = @"积分充值";
    }else if ([point.cptypes intValue] == 2 && [point.subtype intValue] == 4){
        self.typeL.text = @"积分消费";
    }else{
        self.typeL.text = @"积分奖励";
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[point.creationtime  longLongValue]];
    self.timeL.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
    
//    self.timeL.text = [NSDate longlongToDateTime:point.creationtime];

    
    self.amountL.text = [NSString stringWithFormat:@"%@分",point.points];
}

@end
