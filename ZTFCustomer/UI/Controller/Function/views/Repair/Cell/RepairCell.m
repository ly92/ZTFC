//
//  RepairCell.m
//  WeiTown
//
//  Created by Ender on 8/28/15.
//  Copyright (c) 2015 Hairon. All rights reserved.
//

#import "RepairCell.h"

@implementation RepairCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setComplaintModel:(ComplaintModel *)complaintModel{
    
    if (complaintModel) {
            
         self.lblNo.text = [NSString stringWithFormat:@"维修单号:%d",[complaintModel.id intValue]];

        
        self.lblContent.text = complaintModel.content;
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[complaintModel.modifiedtime  longLongValue]];
        self.lblDate.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
        
        //        self.lblDate.text = [TimeCharge longlongToDateTime:[item objectForKey:@"modifiedtime"]];
        //
        int status  = [complaintModel.status intValue];
        
        switch (status) {
            case 0:
                self.imgStatus.image = [UIImage imageNamed:@"repair_status_1"];
                break;
            case 1:
                self.imgStatus.image = [UIImage imageNamed:@"repair_status_2"];
                break;
            case 2:
                self.imgStatus.image = [UIImage imageNamed:@"repair_status_3"];
                break;
            case 3:
                self.imgStatus.image = [UIImage imageNamed:@"repair_status_4"];
                break;
            case 4:
                self.imgStatus.image = [UIImage imageNamed:@"repair_status_5"];
                break;
                
            default:
                self.imgStatus.image = [UIImage imageNamed:@"repair_status_1"];
                break;
        }
    }
}

//-(void)prepareData:(NSDictionary *)item{
//    
//    if (item) {
//        
//        self.lblNo.text = [NSString stringWithFormat:@"维修单号:%d",[[item objectForKey:@"id"] intValue]];
//        
//        self.lblContent.text = [item objectForKey:@"content"];
//        
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[item objectForKey:@"modifiedtime"]  longLongValue]];
//        self.lblDate.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
//
////        self.lblDate.text = [TimeCharge longlongToDateTime:[item objectForKey:@"modifiedtime"]];
////        
//        int status  = [[item objectForKey:@"status"] intValue];
//        
//        switch (status) {
//            case 0:
//                self.imgStatus.image = [UIImage imageNamed:@"repair_status_1"];
//                break;
//            case 1:
//                self.imgStatus.image = [UIImage imageNamed:@"repair_status_2"];
//                break;
//            case 2:
//                self.imgStatus.image = [UIImage imageNamed:@"repair_status_3"];
//                break;
//            case 3:
//                self.imgStatus.image = [UIImage imageNamed:@"repair_status_4"];
//                break;
//            case 4:
//                self.imgStatus.image = [UIImage imageNamed:@"repair_status_5"];
//                break;
//                
//            default:
//                self.imgStatus.image = [UIImage imageNamed:@"repair_status_1"];
//                break;
//        }
//        
//    }
//}

@end
