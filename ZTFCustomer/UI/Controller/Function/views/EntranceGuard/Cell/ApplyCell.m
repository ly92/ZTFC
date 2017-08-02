//
//  ApplyCell.m
//  colourlife
//
//  Created by mac on 16/1/5.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "ApplyCell.h"

//未批复颜色
#define UNAPPROVECOLOR RGBACOLOR(253, 61, 65, 1.0)

//通过
#define PASSCOLOR RGBACOLOR(25, 177, 13, 1.0)
//拒绝
#define REFUSECOLOR RGBACOLOR(191, 199, 204, 1.0)

@interface ApplyCell ()
@property (weak, nonatomic) IBOutlet UILabel *applyName;
@property (weak, nonatomic) IBOutlet UILabel *applyCommunity;
@property (weak, nonatomic) IBOutlet UILabel *applyTime;
@property (weak, nonatomic) IBOutlet UILabel *applyType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyCommuntyHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyTimeTop;

@end

@implementation ApplyCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dataDidChange{
    ApplyModel *apply = (ApplyModel *)self.data;
    
    if (apply) {
        //名字
        if (![ISNull isNilOfSender:apply.fromname]) {
            self.applyName.text = apply.fromname;
        }else {
            self.applyName.text = @"";
        }
        //申请小区
        self.applyCommunity.text=[NSString stringWithFormat:@"申请小区：%@",apply.name];
        
        //申请时间
        if (![ISNull isNilOfSender:apply.creationtime]) {
            
            NSDate *date=[NSDate dateWithTimeIntervalSince1970:[apply.creationtime intValue]];
            NSString *str = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
            self.applyTime.text = [NSString stringWithFormat:@"申请时间:%@",str];
            
        }else {
            
            self.applyTime.text = @"";
            
        }
        //申请状态
        int type = [apply.type intValue];
        int isdeleted = [apply.isdeleted intValue];
        
        //申请状态
        if (type==1) {
            
            if (isdeleted == 0) {
                self.applyType.text = @"未批复";
                self.applyType.textColor = UNAPPROVECOLOR;
            }else{
                self.applyType.text = @"拒绝";
                self.applyType.textColor = REFUSECOLOR;
            }
            
            self.applyCommunity.hidden = YES;
            self.applyCommuntyHeight.constant = 0;
            self.applyTimeTop.constant = 0;
            
        }
        //成功授权
        else if (type == 2){
            if (isdeleted == 1) {//已失效
                self.applyType.text = @"已失效";
                self.applyType.textColor = [UIColor blackColor];
            }
            else{//已通过
                //授权类型，=0未处理，=1表示 永久，=2表示7天，=3表示1天，=5表示1年，=4表示2小时
                int usertype = [apply.usertype intValue];
                
                if (usertype == 1){ //永久
                    self.applyType.text = @"永久";
                }
                else if (usertype == 2) {   //7天
                    self.applyType.text = @"7天";
                }
                else if (usertype == 3) {   //1天
                    self.applyType.text = @"1天";
                }
                else if (usertype == 4) {   //2小时
                    self.applyType.text = @"2小时";
                }
                else if (usertype == 5) {   //1年
                    self.applyType.text = @"1年";
                }
                self.applyType.textColor = PASSCOLOR;
            }
            self.applyCommunity.hidden = NO;
            self.applyCommuntyHeight.constant = 20;
            self.applyTimeTop.constant = 10;
        }
    }
}


//返回cell的高度
-(CGFloat)cellHeight{
    if (self.applyCommunity.hidden == YES) {
        return 80;
    }
    return 110;
}
@end
