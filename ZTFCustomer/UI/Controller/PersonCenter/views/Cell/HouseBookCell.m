//
//  HouseBookCell.m
//  ZTFCustomer
//
//  Created by mac on 16/11/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HouseBookCell.h"

@interface HouseBookCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *communityLbl;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *stateImgView;

@end

@implementation HouseBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dataDidChange{
    if ([self.data isKindOfClass:[AppointmentModel class]]){
        AppointmentModel *appointmentModel = (AppointmentModel *)self.data;
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[appointmentModel.order_time longLongValue]];
        self.timeLbl.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
        
        self.communityLbl.text = appointmentModel.project.name;
        self.employeeNameLbl.text = appointmentModel.employee.name;;
        
        int status= [appointmentModel.status intValue];
        
        switch (status) {
            case 1:
                //未确认
                self.stateImgView.image = [UIImage imageNamed:@"project_state_un"];
                break;
            case 2:
                //已确认
                self.stateImgView.image = [UIImage imageNamed:@"project_state_confirm"];
                break;
                
            case 3:
                //已完成
                self.stateImgView.image = [UIImage imageNamed:@"project_state_complete"];
                break;
            case 4:
                //已取消
                self.stateImgView.image = [UIImage imageNamed:@"project_state_cancel"];
                break;
                
            default:
                //未确认
                self.stateImgView.image = [UIImage imageNamed:@"project_state_un"];
                break;
        }
    }
}

@end
