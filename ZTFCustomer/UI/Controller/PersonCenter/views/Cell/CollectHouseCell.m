//
//  CollectHouseCell.m
//  ZTFCustomer
//
//  Created by ly on 16/11/4.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CollectHouseCell.h"

@interface CollectHouseCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *houseNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *arealbl;
@end

@implementation CollectHouseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImgV.layer.cornerRadius = 6;
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
            [self.iconImgV setImageWithURL:[NSURL URLWithString:resourceModel.url] placeholder:[UIImage imageNamed:@"noHouseImage"]];
        }else{
            self.iconImgV.image = [UIImage imageNamed:@"noHouseImage"];
        }

        self.houseNameLbl.text = houseModel.name;
        self.priceLbl.text = [NSString stringWithFormat:@"%@元／㎡起",houseModel.average_price];
        self.arealbl.text = houseModel.address;
    }else if ([self.data isKindOfClass:[HouseTypeModel class]]){
        HouseTypeModel *houseTypeModel = (HouseTypeModel *)self.data;
        if (houseTypeModel.album.resources.count >0) {
            ResourceModel *resourceModel = houseTypeModel.album.resources[0];
             [self.iconImgV setImageWithURL:[NSURL URLWithString:resourceModel.url] placeholder:[UIImage imageNamed:@"noHouseImage"]];
        }else{
            self.iconImgV.image = [UIImage imageNamed:@"noHouseImage"];
        }
        
        self.houseNameLbl.text = houseTypeModel.name;
        self.priceLbl.text = [NSString stringWithFormat:@"%@元／㎡起",houseTypeModel.covered_price];
        self.arealbl.text = [NSString stringWithFormat:@"面积%@㎡",houseTypeModel.covered_area];
    }
}
@end
