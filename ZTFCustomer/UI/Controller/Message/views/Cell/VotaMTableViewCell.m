//
//  VotaMTableViewCell.m
//  colourlife
//
//  Created by ly on 16/1/22.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "VotaMTableViewCell.h"

@interface VotaMTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *intro;

@end

@implementation VotaMTableViewCell

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
    VoteItemModel *item =(VoteItemModel *) self.data;
    [self.btn setImage:[UIImage imageNamed:@"icon_select_2"] forState:UIControlStateNormal];
    [self.btn setImage:[UIImage imageNamed:@"icon_select_3"] forState:UIControlStateSelected];
    self.intro.text = item.item_name;
}
@end
