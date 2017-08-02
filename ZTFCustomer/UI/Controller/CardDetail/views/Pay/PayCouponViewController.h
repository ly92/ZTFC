//
//  PayCouponViewController.h
//  WeiTown
//
//  Created by kakatool on 15/12/2.
//  Copyright © 2015年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(NSMutableArray *array);

@interface PayCouponViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITableView *tv;

@property (retain, nonatomic) IBOutlet UIButton *conpleteBtn;


- (IBAction)back;
- (IBAction)done;
@property (nonatomic, copy) MyBlock doneChoose;
- (instancetype)initWithCarCoupons:(NSArray *)carCoupons CarCouponSns:(NSMutableArray *)carCouponSns    TotalMoney:(NSString *)totalMoney;
@end
