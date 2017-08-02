//
//  AllowAuthCell.m
//  colourlife
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "AllowAuthCell.h"

@interface AllowAuthCell ()

@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation AllowAuthCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dataDidChange{
    
    Community *community = self.data;
    if (community) {
        self.nameLabel.text = community.name;
        if (community.selected == YES) {
            self.nameLabel.textColor = [UIColor orangeColor];
            self.markLabel.backgroundColor = [UIColor orangeColor];
        }else{
            self.nameLabel.textColor = [UIColor lightGrayColor];
            self.markLabel.backgroundColor = [UIColor lightGrayColor];
        }
    }
    
}



@end
