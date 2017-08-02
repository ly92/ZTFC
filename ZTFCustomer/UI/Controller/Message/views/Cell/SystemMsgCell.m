//
//  SystemMsgCell.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SystemMsgCell.h"

@interface SystemMsgCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet UILabel *dateTimeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *unreadImg;

@end

@implementation SystemMsgCell

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
    
    self.dateTimeLbl.sd_layout
    .leftEqualToView(self.nameLbl)
    .topSpaceToView(self.contentLbl,10)
    .rightSpaceToView (self.contentView, 10)
    .heightIs(20);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)dataDidChange{
    MessageModel *merchantMsg = (MessageModel *)self.data;
    if (merchantMsg) {
        
        if ([merchantMsg.isread intValue] == 0) {
            self.unreadImg.hidden = NO;
        }else{
            self.unreadImg.hidden = YES;
        }
        
//        if (merchantMsg.imageurl.length == 0) {
//            self.iconImageView.hidden = YES;
//            self.nameLbl.sd_layout
//            .leftSpaceToView(self.contentView,10);
//            
//        }else{
            self.iconImageView.hidden = NO;
        
        [self.iconImageView setImageWithURL:[NSURL URLWithString:merchantMsg.imageurl] placeholder:[UIImage imageNamed:@"icon_default"]];
                    
            self.iconImageView.sd_layout
            .leftSpaceToView(self.contentView,10);
            self.nameLbl.sd_layout
            .leftSpaceToView(self.iconImageView,10);
//        }
        
       
        
        self.nameLbl.text = merchantMsg.name;
        
        self.contentLbl.text = merchantMsg.content;
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        
        [self.dateTimeLbl setText:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[merchantMsg.creationtime intValue]]]];
        
        
    }
    
}

@end
