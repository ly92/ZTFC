//
//  CLRechargeListCell.h
//  colourlife
//
//  Created by 吴超 on 16/1/16.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLRechargeListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end
