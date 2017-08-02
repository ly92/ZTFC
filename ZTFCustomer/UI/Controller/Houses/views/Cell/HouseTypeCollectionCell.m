//
//  HouseTypeCollectionCell.m
//  ztfCustomer
//
//  Created by mac on 16/7/11.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HouseTypeCollectionCell.h"

@interface HouseTypeCollectionCell ()


@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (weak, nonatomic) IBOutlet UILabel *houseTypeLbl;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *areaLbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;


@end

@implementation HouseTypeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.topImgView.layer.cornerRadius = 4;
    self.imgWidth.constant = self.imgHeight.constant = (SCREENWIDTH-40)/3.0-20;
    
}

-(void)dataDidChange{
    
    if ([self.data isKindOfClass:[HouseTypeModel class]]) {
        HouseTypeModel *houseTypeModel = (HouseTypeModel *)self.data;
        
        if (houseTypeModel.album.resources.count > 0) {
            ResourceModel *resourceModel = houseTypeModel.album.resources[0];
            [self.topImgView setImageWithURL:[NSURL URLWithString:resourceModel.url] placeholder:[UIImage imageNamed:@"cardImage_no_bg"]];
        }
        
        self.houseTypeLbl.text = houseTypeModel.model;
        self.nameLbl.text = houseTypeModel.name;
        self.areaLbl.text =[NSString stringWithFormat:@"%@㎡",houseTypeModel.covered_area];
    }
    
}


@end
