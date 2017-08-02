//
//  AuthrozationCell.m
//  colourlife
//
//  Created by mac on 16/1/7.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "AuthrozationCell.h"
//未批复颜色
#define UNAPPROVECOLOR RGBACOLOR(253, 61, 65, 1.0)

//通过
#define PASSCOLOR RGBACOLOR(25, 177, 13, 1.0)
//拒绝
#define REFUSECOLOR RGBACOLOR(191, 199, 204, 1.0)
@interface AuthrozationCell ()

@property (weak, nonatomic) IBOutlet UILabel *authName;

@property (weak, nonatomic) IBOutlet UILabel *authCommunity;
@property (weak, nonatomic) IBOutlet UILabel *authTime;
@property (weak, nonatomic) IBOutlet UILabel *authStatus;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authCommunityHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authTimeTop;

@end

@implementation AuthrozationCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dataDidChange{
    
    ApplyModel *apply = (ApplyModel *) self.data;
    
    if (apply) {
        //名字
        if (![ISNull isNilOfSender:apply.toname]) {
            self.authName.text = apply.toname;
        }else {
            self.authName.text = @"";
        }
        //申请小区
        self.authCommunity.text=[NSString stringWithFormat:@"小区名称：%@",apply.name];
        
        //申请时间
        if (![ISNull isNilOfSender:apply.creationtime]) {
            NSDate *date=[NSDate dateWithTimeIntervalSince1970:[apply.creationtime intValue]];
            NSString *str = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
            self.authTime.text = [NSString stringWithFormat:@"申请时间：%@",str];
        }else {
            self.authTime.text = @"";
        }
        //申请状态
        int type = [apply.type intValue];
        int isdeleted = [apply.isdeleted intValue];
        
        //申请状态
        if (type==1) {
            if (isdeleted == 0) {
                self.authStatus.text = @"未批复";
                self.authStatus.textColor = UNAPPROVECOLOR;
            }else{
                self.authStatus.text = @"拒绝";
                self.authStatus.textColor = REFUSECOLOR;
            }
            
            self.authCommunity.hidden = YES;
            self.authCommunityHeight.constant = 0;
            self.authTimeTop.constant = 0;
        }
        //成功授权
        else if (type == 2){
            if (isdeleted == 1) {//已失效
                self.authStatus.text = @"已失效";
                self.authStatus.textColor = [UIColor blackColor];
            }
            else{//已通过
                //授权类型，=0未处理，=1表示 永久，=2表示7天，=3表示1天，=5表示1年，=4表示2小时
                int usertype = [apply.usertype intValue];
                
                if (usertype == 1){ //永久
                    self.authStatus.text = @"永久";
                }
                else if (usertype == 2) {   //7天
                    self.authStatus.text = @"7天";
                }
                else if (usertype == 3) {   //1天
                    self.authStatus.text = @"1天";
                }
                else if (usertype == 4) {   //2小时
                    self.authStatus.text = @"2小时";
                }
                else if (usertype == 5) {   //1年
                    self.authStatus.text = @"1年";
                }
                
                self.authStatus.textColor = PASSCOLOR;
            }
            self.authCommunity.hidden = NO;
            self.authCommunityHeight.constant = 20;
            self.authTimeTop.constant = 10;
        }
    }
    
}
//返回cell的高度
-(CGFloat)cellHeight{
    if (self.authCommunity.hidden == YES) {
        return 80;
    }
    return 110;
}


@end
