//
//  PropertyConstrulantDetailHeaderCell.m
//  ztfCustomer
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "PropertyConstrulantDetailHeaderCell.h"

@interface PropertyConstrulantDetailHeaderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icomImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *rankLevelLbl;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telBtnLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatLeading;

@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UIImageView *starImg1;
@property (weak, nonatomic) IBOutlet UIImageView *starImg2;
@property (weak, nonatomic) IBOutlet UIImageView *starImg3;
@property (weak, nonatomic) IBOutlet UIImageView *starImg4;
@property (weak, nonatomic) IBOutlet UIImageView *starImg5;


@end

@implementation PropertyConstrulantDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.telBtnLeading.constant = self.chatLeading.constant = (SCREENWIDTH-70-60)/4.0;
    self.icomImageView.layer.cornerRadius = 35;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dataDidChange{
    if ([self.data isKindOfClass:[PropertyConstrulantModel class]]) {
        PropertyConstrulantModel *propertyDetailModel = (PropertyConstrulantModel *)self.data;
        
        
        [self.icomImageView sd_setImageWithURL:[NSURL URLWithString:propertyDetailModel.image] placeholderImage:SaleHeadImage options:EMSDWebImageRefreshCached];
//        [self.icomImageView setImageWithURL:[NSURL URLWithString:propertyDetailModel.image] placeholder:SaleHeadImage];
        
        if (self.isSteward) {
            self.starView.hidden = YES;
            self.nameLbl.text = [NSString stringWithFormat:@"专属管家  %@",propertyDetailModel.name];
        }else{
            self.starView.hidden = NO;
            self.nameLbl.text = [NSString stringWithFormat:@"专属楼栋管家  %@",propertyDetailModel.name];
        }
        
         self.rankLevelLbl.text = propertyDetailModel.star_name;
        
        int star = [propertyDetailModel.star intValue];
        
        if (star == 1) {
            self.starImg1.image = [UIImage imageNamed:@"home_star"];
            self.starImg2.image = [UIImage imageNamed:@"home_star_no"];
            self.starImg3.image = [UIImage imageNamed:@"home_star_no"];
            self.starImg4.image = [UIImage imageNamed:@"home_star_no"];
            self.starImg5.image = [UIImage imageNamed:@"home_star_no"];
        }else if (star ==2){
            self.starImg1.image = [UIImage imageNamed:@"home_star"];
            self.starImg2.image = [UIImage imageNamed:@"home_star"];
            self.starImg3.image = [UIImage imageNamed:@"home_star_no"];
            self.starImg4.image = [UIImage imageNamed:@"home_star_no"];
            self.starImg5.image = [UIImage imageNamed:@"home_star_no"];
        }else if (star == 3){
            self.starImg1.image = [UIImage imageNamed:@"home_star"];
            self.starImg2.image = [UIImage imageNamed:@"home_star"];
            self.starImg3.image = [UIImage imageNamed:@"home_star"];
            self.starImg4.image = [UIImage imageNamed:@"home_star_no"];
            self.starImg5.image = [UIImage imageNamed:@"home_star_no"];
        }else if (star == 4){
            self.starImg1.image = [UIImage imageNamed:@"home_star"];
            self.starImg2.image = [UIImage imageNamed:@"home_star"];
            self.starImg3.image = [UIImage imageNamed:@"home_star"];
            self.starImg4.image = [UIImage imageNamed:@"home_star"];
            self.starImg5.image = [UIImage imageNamed:@"home_star_no"];
        }else if (star == 5){
            self.starImg1.image = [UIImage imageNamed:@"home_star"];
            self.starImg2.image = [UIImage imageNamed:@"home_star"];
            self.starImg3.image = [UIImage imageNamed:@"home_star"];
            self.starImg4.image = [UIImage imageNamed:@"home_star"];
            self.starImg5.image = [UIImage imageNamed:@"home_star"];
        }
    }
}

#pragma mark-click

//电话
- (IBAction)mobileClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(mobileClick)]) {
        [self.delegate mobileClick];
    }
    
}
// 聊天
- (IBAction)chatClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(chatClick)]) {
        [self.delegate chatClick];
    }
}

@end
