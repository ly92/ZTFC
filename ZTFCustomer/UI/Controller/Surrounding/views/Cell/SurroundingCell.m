//
//  SurroundingCell.m
//  colourlife
//
//  Created by mac on 16/1/18.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "SurroundingCell.h"

@interface SurroundingCell ()
@property (weak, nonatomic) IBOutlet UIImageView *merchantImageView;
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantCatLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantAddressLabel;

@property (weak, nonatomic) IBOutlet UILabel *merchantDistanceLabel;

@end

@implementation SurroundingCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)dataDidChange{
    Shop *surrounding = (Shop *)self.data;
    if (surrounding) {
        
        
        [self.merchantImageView setImageWithURL:[NSURL URLWithString:surrounding.frontimageurl] placeholder:[UIImage imageNamed:@"cardImage_no_bg"]];
        
        self.merchantNameLabel.text = surrounding.name;
        
        self.merchantCatLabel.text = surrounding.industryname;
        
        self.merchantAddressLabel.text = surrounding.address;
        
        if ([surrounding.distance judgePositiveIntegerNumberOfDigits] <= 3) {
            self.merchantDistanceLabel.text = [NSString stringWithFormat:@"%@m",surrounding.distance];
        }
        else if ([surrounding.distance judgePositiveIntegerNumberOfDigits] >= 4) {
            self.merchantDistanceLabel.text = [NSString stringWithFormat:@"%.1fkm",[surrounding.distance intValue]/1000.0];
        }
    }
}

@end
