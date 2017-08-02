//
//  SystemMsgDetailCell.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SystemMsgDetailCell.h"

@implementation SystemMsgDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dataDidChange{
    MessageModel *systemMsgModel = (MessageModel *)self.data;
    
    if (systemMsgModel) {
        [self.titleLbl setText:systemMsgModel.name];
        [self.contentLbl setText:systemMsgModel.content];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        [self.dateTimeLbl setText:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[systemMsgModel.creationtime intValue]]]];
    }
    
    [self setupAutoHeightWithBottomView:self.contentLbl bottomMargin:10];
    
}

@end
