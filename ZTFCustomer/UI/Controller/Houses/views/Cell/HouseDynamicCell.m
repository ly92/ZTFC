//
//  HouseDynamicCell.m
//  ZTFCustomer
//
//  Created by 李勇 on 2017/9/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HouseDynamicCell.h"
#import "HouseDynamicModel.h"

@interface HouseDynamicCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@end

@implementation HouseDynamicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dataDidChange{
    if ([self.data isKindOfClass:[HouseDynamicModel class]]) {
        HouseDynamicModel *houseDynamicModel = (HouseDynamicModel *)self.data;
        
        self.timeLbl.text = houseDynamicModel.create_at;
        self.titleLbl.text = houseDynamicModel.progress_title;
        [self.iconImgV setImageWithURL:[NSURL URLWithString:houseDynamicModel.progress_introduce_img] placeholder:[UIImage imageNamed:@"cardImage_no_bg"]];
        self.descLbl.text = houseDynamicModel.progress_introduce;
    }
}

@end
