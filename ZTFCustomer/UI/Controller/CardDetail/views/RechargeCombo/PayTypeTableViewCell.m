//
//  PayTypeTableViewCell.m
//  WeiTown
//
//  Created by kakatool on 15/12/1.
//  Copyright © 2015年 Hairon. All rights reserved.
//

#import "PayTypeTableViewCell.h"

@implementation PayTypeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.icon.clipsToBounds = YES;
    self.icon.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.selectedIcon.selected = selected;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    return self;
}


@end
