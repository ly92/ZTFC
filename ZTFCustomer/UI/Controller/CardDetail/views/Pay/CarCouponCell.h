//
//  CarCouponCell.h
//  WeiTown
//
//  Created by kakatool on 15/12/2.
//  Copyright © 2015年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CarCouponCell;

@interface CarCouponCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *amount;
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UILabel *end_date;
@property (retain, nonatomic) IBOutlet UIImageView *selectedIcon;

@end
