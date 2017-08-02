//
//  SearchCardCell.m
//  colourlife
//
//  Created by 李勇 on 16/3/23.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "SearchCardCell.h"

@interface SearchCardCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *introLbl;
@property (weak, nonatomic) IBOutlet UIImageView *markImg;

@end

@implementation SearchCardCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void)dataDidChange{
    NoMemberCardInfo *search = (NoMemberCardInfo *)self.data;
    if (search) {
        
        [self.icon setImageWithURL:[NSURL URLWithString:search.bizcard.frontimageurl] placeholder:[UIImage imageNamed:@"b0_card_2_loading"]];
        
        
        self.nameLbl.text = search.name;
        
        self.introLbl.text = search.intro;
        
        //会员卡所属标记
        int cardnum = [search.cardnum intValue];
        if (cardnum != 0) { //已领取
            self.markImg.hidden = NO;
        }
        else {
            self.markImg.hidden = YES;
        }
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
