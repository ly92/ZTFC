//
//  BindingPropertyConstrulantCell.m
//  ztfCustomer
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "BindingPropertyConstrulantCell.h"

@interface BindingPropertyConstrulantCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *mobileLbl;
@property (weak, nonatomic) IBOutlet UILabel *saleRankLbl;


@property (weak, nonatomic) IBOutlet UIImageView *starImg1;
@property (weak, nonatomic) IBOutlet UIImageView *starImg2;
@property (weak, nonatomic) IBOutlet UIImageView *starImg3;
@property (weak, nonatomic) IBOutlet UIImageView *starImg4;
@property (weak, nonatomic) IBOutlet UIImageView *starImg5;


@end

@implementation BindingPropertyConstrulantCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bindingButton.backgroundColor = BUTTON_BLUECOLOR;
    [self.bindingButton setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    self.iconImageView.layer.cornerRadius = 10;
    self.bindingButton.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dataDidChange{
    
    if ([self.data isKindOfClass:[PropertyConstrulantModel class]]) {
        
        PropertyConstrulantModel *model = (PropertyConstrulantModel *)self.data;
        
        
          [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:SaleHeadImage options:EMSDWebImageRefreshCached];
        self.iconImageView.contentMode =  UIViewContentModeScaleAspectFill;
        self.iconImageView.clipsToBounds = YES;
//        [self.iconImageView setImageWithURL:[NSURL URLWithString:model.image] placeholder:SaleHeadImage];
        
        self.nameLbl.text = model.name;
        self.mobileLbl.text = model.mobile;
        self.saleRankLbl.text = model.star_name;
        int star = [model.star intValue];
        
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
//绑定
- (IBAction)bindingClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(bindingClickWithStr:)]) {
        [self.delegate bindingClickWithStr:self.data];
    }
    
}


@end
