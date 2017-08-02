//
//  RepairCell.h
//  WeiTown
//
//  Created by Ender on 8/28/15.
//  Copyright (c) 2015 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepairCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *lblNo;
@property (retain, nonatomic) IBOutlet UILabel *lblContent;
@property (retain, nonatomic) IBOutlet UILabel *lblDate;
@property (retain, nonatomic) IBOutlet UIImageView *imgStatus;

@property (nonatomic, strong) ComplaintModel *complaintModel;

//-(void)prepareData:(NSDictionary *)item;

@end
