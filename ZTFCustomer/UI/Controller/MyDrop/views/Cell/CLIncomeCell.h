//
//  CLIncomeCell.h
//  colourlife
//
//  Created by 吴超 on 16/1/13.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLIncomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyLblWidth;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@end
