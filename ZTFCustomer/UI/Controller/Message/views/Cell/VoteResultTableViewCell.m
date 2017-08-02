//
//  VoteResultTableViewCell.m
//  colourlife
//
//  Created by ly on 16/1/22.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "VoteResultTableViewCell.h"

@interface VoteResultTableViewCell ()


@end

@implementation VoteResultTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.botView.layer.cornerRadius = 3;
    self.topView.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
