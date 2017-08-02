//
//  MoreHouseTypeCell.m
//  ztfCustomer
//
//  Created by mac on 16/7/11.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MoreHouseTypeCell.h"

@interface MoreHouseTypeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *houseTypeImgView;
@property (weak, nonatomic) IBOutlet UILabel *houseTypeNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *areaLbl;

@end

@implementation MoreHouseTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dataDidChange{
    if ([self.data isKindOfClass:[HouseTypeModel class]]) {
        HouseTypeModel *houseTypeModel = (HouseTypeModel *)self.data;
        
        if (houseTypeModel.album.resources.count > 0) {
             ResourceModel *resourceModel = houseTypeModel.album.resources[0];
            [self.houseTypeImgView setImageWithURL:[NSURL URLWithString:resourceModel.url] placeholder:[UIImage imageNamed:@"cardImage_no_bg"]];
        }

        self.houseTypeNameLbl.text = houseTypeModel.name;
        self.priceLbl.text = [NSString stringWithFormat:@"%@元/㎡起",houseTypeModel.covered_price];
        
        self.areaLbl.text = [NSString stringWithFormat:@"%@㎡",houseTypeModel.covered_area];
    
    }
    
    
    
}

@end
