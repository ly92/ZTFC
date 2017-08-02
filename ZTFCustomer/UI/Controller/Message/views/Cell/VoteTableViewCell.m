//
//  VoteTableViewCell.m
//  colourlife
//
//  Created by ly on 16/1/22.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "VoteTableViewCell.h"

@interface VoteTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *intro;

@end

@implementation VoteTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.btn.selected = selected;
    
    // Configure the view for the selected state
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    return self;
}

- (void)dataDidChange{
    VoteItemModel *item = self.data;
    [self.btn setImage:[UIImage imageNamed:@"icon_select_5"] forState:UIControlStateNormal];
    [self.btn setImage:[UIImage imageNamed:@"icon_select_4"] forState:UIControlStateSelected];
    self.intro.text = item.item_name;
}
@end
