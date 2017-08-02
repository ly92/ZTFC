//
//  CompleteCell.m
//  ZTFCustomer
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CompleteCell.h"

@interface CompleteCell ()
@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@end

@implementation CompleteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.completeButton.clipsToBounds = YES;
    self.completeButton.layer.cornerRadius = 4;
    self.completeButton.backgroundColor = BUTTON_BLUECOLOR;
    [self.completeButton setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
