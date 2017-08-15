//
//  PropertyMessageCell.m
//  ZTFCustomer
//
//  Created by wangshanshan on 16/11/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "PropertyMessageCell.h"
#import "SDWeiXinPhotoContainerView.h"

@interface PropertyMessageCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet SDWeiXinPhotoContainerView *photoView;


@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end

@implementation PropertyMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    _photoView = [SDWeiXinPhotoContainerView new];
    
//    self.iconImgV.sd_layout
//    .leftSpaceToView(self.contentView,10)
//    .topSpaceToView(self.contentView,10)
//    .widthIs(50)
//    .heightEqualToWidth();
//    
//    
//    self.bubbleLbl.sd_layout
//    .topEqualToView(self.iconImgV)
//    .rightEqualToView(self.iconImgV)
//    .widthIs(6)
//    .heightEqualToWidth();
//    
//    self.nameLbl.sd_layout
//    .leftSpaceToView(self.iconImgV,10)
//    .topEqualToView(self.iconImgV)
//    .rightSpaceToView(self.contentView,10)
//    .heightIs(20);
//    
//    
//    self.contentLbl.sd_layout
//    .leftEqualToView(self.nameLbl)
//    .topSpaceToView(self.nameLbl,10)
//    .rightEqualToView(self.nameLbl)
//    .heightIs(20);
//    
//    self.photoView.sd_layout
//    .leftEqualToView(self.nameLbl);
//    
//    self.timeLbl.sd_layout
//    .leftEqualToView(self.nameLbl)
//    .topSpaceToView(self.photoView,10)
//    .rightEqualToView(self.nameLbl)
//    .heightIs(20);
//    
//    self.contentLbl.sd_layout
//    .leftEqualToView(self.nameLbl)
//    .topSpaceToView(self.nameLbl,10)
//    .rightEqualToView(self.nameLbl)
//    .autoHeightRatio(0);
//    
//    self.photoView.sd_layout
//    .leftEqualToView(self.nameLbl);
//    
//    self.timeLbl.sd_layout
//    .leftEqualToView(self.nameLbl)
//    .topSpaceToView(self.photoView,10)
//    .rightEqualToView(self.nameLbl)
//    .heightIs(20);
 
    
    [self.bubbleLbl setViewCornerRadius:self.bubbleLbl.width/2.0];
    
    [self.iconImgV setViewCornerRadius:4];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPropertyMessageModel:(PropertyMessageModel *)propertyMessageModel{
    
    
    self.iconImgV.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .widthIs(50)
    .heightEqualToWidth();
    
    
    self.bubbleLbl.sd_layout
    .topEqualToView(self.iconImgV)
    .rightEqualToView(self.iconImgV)
    .widthIs(6)
    .heightEqualToWidth();
    
    self.nameLbl.sd_layout
    .leftSpaceToView(self.iconImgV,10)
    .topEqualToView(self.iconImgV)
    .rightSpaceToView(self.contentView,10)
    .heightIs(20);
    
    
        self.contentLbl.sd_layout
        .leftEqualToView(self.nameLbl)
        .topSpaceToView(self.nameLbl,10)
        .rightEqualToView(self.nameLbl)
        .heightIs(20);
        
        self.photoView.sd_layout
        .leftEqualToView(self.nameLbl);
        
        self.timeLbl.sd_layout
        .leftEqualToView(self.nameLbl)
        .topSpaceToView(self.photoView,10)
        .rightEqualToView(self.nameLbl)
        .heightIs(20);
    
  
    _propertyMessageModel = propertyMessageModel;
    
    _photoView.picPathStringsArray = propertyMessageModel.album.resources;
//    [_iconImgV setImageWithURL:[NSURL URLWithString:propertyMessageModel.] placeholder:SaleHeadImage];
    
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:propertyMessageModel.employee.image] placeholderImage:SaleHeadImage options:EMSDWebImageRefreshCached];
    
    self.iconImgV.contentMode =  UIViewContentModeScaleAspectFill;
    self.iconImgV.clipsToBounds = YES;
    
    NSInteger isRead = [propertyMessageModel.is_read integerValue];
    if (isRead == 1) {
        self.bubbleLbl.hidden = YES;
    }else{
        self.bubbleLbl.hidden = NO;
    }
    
    if (self.isSteward) {
        _nameLbl.text = [NSString stringWithFormat:@"专属管家%@",propertyMessageModel.employee.name.length>0?propertyMessageModel.employee.name:@""];
    }else{
        _nameLbl.text = [NSString stringWithFormat:@"楼栋管家%@",propertyMessageModel.employee.name.length>0?propertyMessageModel.employee.name:@""];
    }
    _contentLbl.text = propertyMessageModel.content;
    
    CGFloat picContainerTopMargin = 0;
    if (propertyMessageModel.album.resources.count) {
        picContainerTopMargin = 10;
    }
    
    _photoView.sd_layout.topSpaceToView(_contentLbl,picContainerTopMargin);
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[propertyMessageModel.creationtime  longLongValue]];
    self.timeLbl.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
    
    [self setupAutoHeightWithBottomView:_timeLbl bottomMargin:10];
    
}


-(void)setPropertyMessageDetailModel:(PropertyMessageModel *)propertyMessageDetailModel{
    
    
    self.iconImgV.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .widthIs(50)
    .heightEqualToWidth();
    
    self.bubbleLbl.sd_layout
    .topEqualToView(self.iconImgV)
    .rightEqualToView(self.iconImgV)
    .widthIs(6)
    .heightEqualToWidth();
    
    
    self.nameLbl.sd_layout
    .leftSpaceToView(self.iconImgV,10)
    .topEqualToView(self.iconImgV)
    .rightSpaceToView(self.contentView,10)
    .heightIs(20);
    
    
    self.contentLbl.sd_layout
    .leftEqualToView(self.nameLbl)
    .topSpaceToView(self.nameLbl,10)
    .rightEqualToView(self.nameLbl)
    .autoHeightRatio(0);
    
    self.photoView.sd_layout
    .leftEqualToView(self.nameLbl);
    
    self.timeLbl.sd_layout
    .leftEqualToView(self.nameLbl)
    .topSpaceToView(self.photoView,10)
    .rightEqualToView(self.nameLbl)
    .heightIs(20);
    
    self.contentLbl.sd_layout
    .leftEqualToView(self.nameLbl)
    .topSpaceToView(self.nameLbl,10)
    .rightEqualToView(self.nameLbl)
    .autoHeightRatio(0);
    
    self.photoView.sd_layout
    .leftEqualToView(self.nameLbl);
    
    self.timeLbl.sd_layout
    .leftEqualToView(self.nameLbl)
    .topSpaceToView(self.photoView,10)
    .rightEqualToView(self.nameLbl)
    .heightIs(20);
    
    _propertyMessageDetailModel = propertyMessageDetailModel;
    
    
    _photoView.picPathStringsArray = propertyMessageDetailModel.album.resources;
    
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:propertyMessageDetailModel.employee.image] placeholderImage:SaleHeadImage options:EMSDWebImageRefreshCached];
    self.iconImgV.contentMode =  UIViewContentModeScaleAspectFill;
    self.iconImgV.clipsToBounds = YES;
    
    
    if (self.isSteward) {
        _nameLbl.text = [NSString stringWithFormat:@"专属管家%@",propertyMessageDetailModel.employee.name.length>0?propertyMessageDetailModel.employee.name:@""];
    }else{
        _nameLbl.text = [NSString stringWithFormat:@"楼栋管家%@",propertyMessageDetailModel.employee.name.length>0?propertyMessageDetailModel.employee.name:@""];
    }
    _contentLbl.text = propertyMessageDetailModel.content;
    
    CGFloat picContainerTopMargin = 0;
    if (propertyMessageDetailModel.album.resources.count) {
        picContainerTopMargin = 10;
    }
    
    _photoView.sd_layout.topSpaceToView(_contentLbl,picContainerTopMargin);
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[propertyMessageDetailModel.creationtime  longLongValue]];
    self.timeLbl.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
    
    [self setupAutoHeightWithBottomView:_timeLbl bottomMargin:10];
    
}



    
    


@end
