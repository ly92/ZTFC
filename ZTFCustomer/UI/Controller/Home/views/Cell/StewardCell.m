//
//  StewardCell.m
//  ZTFCustomer
//
//  Created by mac on 16/11/4.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "StewardCell.h"

@interface StewardCell ()


@property (weak, nonatomic) IBOutlet UIView *propertyView;

@property (weak, nonatomic) IBOutlet UIImageView *propertyIconImg;
@property (weak, nonatomic) IBOutlet UILabel *propertyNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *consultBtn;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;


@property (weak, nonatomic) IBOutlet UIView *stewardView;
@property (weak, nonatomic) IBOutlet UIImageView *stewardIconImg;
@property (weak, nonatomic) IBOutlet UILabel *stewardNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *chatbtn;

@end

@implementation StewardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.consultBtn setViewCornerRadius:4];
    [self.bindBtn setViewCornerRadius:4];
    [self.chatbtn setViewCornerRadius:4];
    
//    [self.propertyView addTapAction:@selector(propertyViewClick) forTarget:self];
    [self.propertyIconImg addTapAction:@selector(propertyImgClick) forTarget:self];
    [self.stewardView addTapAction:@selector(stewardViewClick) forTarget:self];
    [self.stewardIconImg addTapAction:@selector(stewardImgClick) forTarget:self];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dataDidChange{
    
    if ([self.data isKindOfClass:[PropertyConstrulantModel class]]) {
        
        self.propertyIconImg.userInteractionEnabled = YES;
        
        [self.propertyView addTapAction:@selector(propertyViewClick) forTarget:self];
        
        self.bindBtn.hidden = YES;
        self.consultBtn.hidden = NO;
        PropertyConstrulantModel *model = (PropertyConstrulantModel *)self.data;
        
        [self.propertyIconImg setImageWithURL:[NSURL URLWithString:model.image] placeholder:SaleHeadImage];
        
        [self.stewardIconImg setImageWithURL:[NSURL URLWithString:@""] placeholder:SaleHeadImage];
        
        self.propertyNameLbl.text = [NSString stringWithFormat:@"置业顾问：%@",model.name];
        
        
    }else{
//        [self.propertyView addTapAction:@selector(propertyViewClick) forTarget:self];
        self.propertyView.userInteractionEnabled = YES;
        self.propertyView.gestureRecognizers = nil;
        self.propertyIconImg.userInteractionEnabled = NO;
        self.bindBtn.hidden = NO;
        self.consultBtn.hidden = YES;
        self.propertyIconImg.image = SaleHeadImage;
        self.propertyNameLbl.text = @"未绑定置业顾问";
    }
}

#pragma mark-click
//顾问view点击，跳转顾问消息列表
-(void)propertyViewClick{
    if ([self.delegate respondsToSelector:@selector(clickWithTag:)]) {
        [self.delegate clickWithTag:1];
    }
    
}
//顾问头像点击，跳转顾问详情
-(void)propertyImgClick{
    if ([self.delegate respondsToSelector:@selector(clickWithTag:)]) {
        [self.delegate clickWithTag:2];
    }
}
- (IBAction)propertyChatClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickWithTag:)]) {
        [self.delegate clickWithTag:5];
    }
}


//管家view点击，跳转管家消息列表
-(void)stewardViewClick{
    if ([self.delegate respondsToSelector:@selector(clickWithTag:)]) {
        [self.delegate clickWithTag:3];
    }
}
//管家头像点击，跳转管家详情
-(void)stewardImgClick{
    if ([self.delegate respondsToSelector:@selector(clickWithTag:)]) {
        [self.delegate clickWithTag:4];
    }
}
- (IBAction)stewardChatClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickWithTag:)]) {
        [self.delegate clickWithTag:6];
    }
}
//绑定跳转
- (IBAction)bindBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickWithTag:)]) {
        [self.delegate clickWithTag:7];
    }
}

@end
