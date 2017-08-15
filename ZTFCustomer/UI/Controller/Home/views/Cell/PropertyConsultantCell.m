//
//  PropertyConsultantCell.m
//  ztfCustomer
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "PropertyConsultantCell.h"

@interface PropertyConsultantCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconimageView;
@property (weak, nonatomic) IBOutlet UILabel *propertyLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *saleRankLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleRankLblWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propertyLblWidth;
@property (weak, nonatomic) IBOutlet UIView *chtView;

@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@property (weak, nonatomic) IBOutlet UIButton *bindingButton;

@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UIImageView *starImg1;
@property (weak, nonatomic) IBOutlet UIImageView *starImg2;
@property (weak, nonatomic) IBOutlet UIImageView *starImg3;
@property (weak, nonatomic) IBOutlet UIImageView *starImg4;
@property (weak, nonatomic) IBOutlet UIImageView *starImg5;


@end

@implementation PropertyConsultantCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bindingButton.layer.cornerRadius = 4;
    self.iconimageView.layer.cornerRadius = 10;
    
    [self.iconimageView addTapAction:@selector(propertyImgClick) forTarget:self];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dataDidChange{
    //已经绑定（显示头像，名字，级别，聊天按钮）
    
    if ([self.data isKindOfClass:[PropertyConstrulantModel class]]) {
        
        PropertyConstrulantModel *model = (PropertyConstrulantModel *)self.data;
        
        self.iconimageView.userInteractionEnabled = YES;
        
        [self.iconimageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:SaleHeadImage options:EMSDWebImageRefreshCached];
        
        self.iconimageView.contentMode =  UIViewContentModeScaleAspectFill;
        self.iconimageView.clipsToBounds = YES;
        
        self.propertyLbl.text = @"楼栋管家";
        self.nameLbl.text = model.name;
        self.nameLbl.hidden = NO;
        self.propertyLblWidth.constant = 60;
        self.saleRankLbl.text = model.star_name;
        self.chtView.hidden = NO;
        self.chatButton.hidden = NO;
        self.bindingButton.hidden = YES;
        
        self.starView.hidden = NO;
        self.saleRankLblWidth.constant = 76;
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
    if (self.data == nil) {
        self.iconimageView.userInteractionEnabled = NO;
       // 未绑定(显示默认头像，绑定按钮）
        [self.iconimageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:SaleHeadImage options:EMSDWebImageRefreshCached];
        self.starView.hidden = YES;
        
        self.nameLbl.hidden = YES;
        self.propertyLbl.text = @"未绑定楼栋管家";
        
        CGFloat propertyWidth = [self.propertyLbl resizeWidth];
        self.propertyLblWidth.constant = propertyWidth;
        self.propertyLbl.textColor = [UIColor grayColor];
        
        self.saleRankLbl.text = @"立即绑定楼栋管家";
        self.saleRankLbl.textColor = [UIColor blackColor];
        self.chtView.hidden = YES;
        self.chatButton.hidden = YES;
        self.bindingButton.hidden = NO;
        self.saleRankLblWidth.constant = 120;
    }
    
    
}

#pragma mark-click

//聊天
- (IBAction)chatClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(chatClick)]) {
        [self.delegate chatClick];
    }

}

 //绑定
- (IBAction)bindingButtonClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(bindingClick)]) {
        [self.delegate bindingClick];
    }
}

//头像点击
-(void)propertyImgClick{
    if ([self.delegate respondsToSelector:@selector(iconImgClick)]) {
        [self.delegate iconImgClick];
    }
    
}

@end
