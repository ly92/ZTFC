//
//  HousesCell.m
//  ztfCustomer
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HousesCell.h"

@interface HousesCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLblWidth;

@property (weak, nonatomic) IBOutlet UILabel *addressLbl;

@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *couponLbl;

@property (weak, nonatomic) IBOutlet UIView *loveView;
@property (weak, nonatomic) IBOutlet UIButton *bigLovwBtn;
@property (weak, nonatomic) IBOutlet UILabel *loveLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewheight;

@end

@implementation HousesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.nameLblWidth.constant = (SCREENWIDTH-20)/2.0;
    
    self.bgImageView.layer.cornerRadius = 5;
    
    self.loveView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.85];
    self.infoView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5f];;
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dataDidChange{
    
    
    if ([self.data isKindOfClass:[HousesModel class]]) {
        HousesModel *houseModel = (HousesModel *)self.data;
        
        if (houseModel.album.resources.count > 0) {
            ResourceModel *resourceModel = houseModel.album.resources[0];
             [self.bgImageView setImageWithURL:[NSURL URLWithString:resourceModel.url] placeholder:[UIImage imageNamed:@"house_detail_noimage"]];
        }else{
            self.bgImageView.image = [UIImage imageNamed:@"house_detail_noimage"];
        }
        
        self.nameLbl.text = houseModel.name;
        self.addressLbl.text = houseModel.address;
        
        self.addressHeight.constant = [self.addressLbl resizeHeight]>20?[self.addressLbl resizeHeight]:20;
        self.infoViewheight.constant = 65-20+self.addressHeight.constant;
        
        self.priceLbl.text = [NSString stringWithFormat:@"%@元/㎡起",houseModel.average_price];
        self.couponLbl.text =houseModel.advertisement;
        self.loveLbl.text = [NSString stringWithFormat:@"%@",houseModel.favorites];
        NSInteger status = [houseModel.is_favorite integerValue];
        if (status == 1) {
            
            self.bigLovwBtn.selected = YES;
            self.loveButton.selected = YES;
//            [self.loveButton setImage:[UIImage imageNamed:@"house_love_pre"] forState:UIControlStateSelected];
//            
        }else{
            self.bigLovwBtn.selected = NO;
//            [self.loveButton setImage:[UIImage imageNamed:@"house_love"] forState:UIControlStateNormal];
            self.loveButton.selected = NO;
            
        }
        
//        self.loveButton.imageView.contentMode = UIViewContentModeCenter;
        
//         [self.loveButton buttonSetTitle:[NSString stringWithFormat:@"%@",houseModel.favorites] imageStr:@"house_love" selectImageStr:@"house_love_pre" imagePosition:TOPSTYLE];
    }
}

#pragma mark-click

//喜欢点击
- (IBAction)loveButtonClick:(id)sender {
    
    //如果已经点击过，则不执行代理方法
    
    if ([self.delegate respondsToSelector:@selector(loveButtonClick:)]) {
        [self.delegate loveButtonClick:self.data];
    }
    
}

@end
