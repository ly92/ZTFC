//
//  MerchantMsgCell.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MerchantMsgCell.h"


@interface MerchantMsgCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;


@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@property (weak, nonatomic) IBOutlet UILabel *dateTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *lineLbl;
@property (weak, nonatomic) IBOutlet UIImageView *unreadImg;

@end

@implementation MerchantMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageView.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .widthIs(50)
    .heightIs(55);
    
    
    self.nameLbl.sd_layout
    .leftSpaceToView(self.iconImageView,10)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .heightIs(20);
    
    self.contentLbl.sd_layout
    .leftEqualToView(self.nameLbl)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.nameLbl,10)
    .heightIs(20);
    
    
    self.contentImageView.sd_layout
    .leftEqualToView(self.contentLbl)
    .topSpaceToView(self.contentLbl, 10)
    .rightSpaceToView(self.contentView,10)
    .heightEqualToWidth(0);
    
    self.dateTimeLbl.sd_layout
    .leftEqualToView(self.contentLbl)
    .topEqualToView(self.contentImageView)
    .rightSpaceToView (self.contentView, 10)
    .heightIs(20);
    
    self.lineLbl.sd_layout
    .leftEqualToView(self.contentView)
    .topSpaceToView(self.dateTimeLbl,10)
    .rightEqualToView(self.contentView)
    .heightIs(1);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dataDidChange{
    MessageModel *merchantMsg = (MessageModel *)self.data;
    if (merchantMsg) {
        
        self.nameLbl.text = merchantMsg.name;
        
        self.contentLbl.text = merchantMsg.content;
        
        
        if ([merchantMsg.isread intValue] == 0) {
            self.unreadImg.hidden = NO;
        }else{
            self.unreadImg.hidden = YES;
        }
        
        if (merchantMsg.imageurl.length == 0) {
            
//            self.iconImageView.hidden = YES;
            self.nameLbl.sd_layout.leftSpaceToView(self.contentView,70);
            
            self.contentImageView.hidden = YES;
            
            self.dateTimeLbl.sd_layout.topSpaceToView(self.contentLbl,10);
            self.lineLbl.sd_layout.topSpaceToView(self.dateTimeLbl,10);

        }else{
           
            self.iconImageView.hidden = NO;
            
//            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:merchantMsg.imageurl] placeholderImage:[UIImage imageNamed:@""]];
            
            self.nameLbl.sd_layout.leftSpaceToView(self.contentView,70);
            
            self.contentImageView.hidden = NO;
            
            self.contentImageView.contentMode =  UIViewContentModeScaleAspectFill;
            self.contentImageView.clipsToBounds = YES;
            
            [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:merchantMsg.imageurl] placeholderImage:[UIImage imageNamed:@""]];
            
            [self.contentView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            self.contentView.contentMode =  UIViewContentModeScaleAspectFill;
            self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            self.contentView.clipsToBounds  = YES;
            
            self.dateTimeLbl.sd_layout.topSpaceToView(self.contentImageView,10);
            self.lineLbl.sd_layout.topSpaceToView(self.dateTimeLbl,10);
            
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        
        [self.dateTimeLbl setText:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[merchantMsg.creationtime intValue]]]];
        
        [self setupAutoHeightWithBottomView:self.lineLbl bottomMargin:0];
        
    }
    
}

@end
