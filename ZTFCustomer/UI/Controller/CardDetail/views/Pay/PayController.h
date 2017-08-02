//
//  PayController.h
//  WeiTown
//
//  Created by mac on 15/11/26.
//  Copyright © 2015年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^payBlock)(NSString *payCallback);

//<WXApiDelegate>
@interface PayController : UIViewController

@property (nonatomic, copy) payBlock paySuccess;


@property (retain, nonatomic) IBOutlet UIView *subView1;

@property (nonatomic, retain) NSString *tnum;//交易单号
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *number;

@property (retain, nonatomic) IBOutlet UIScrollView *sv;

@property (retain, nonatomic) IBOutlet UILabel *totalMoney;//需要支付金额
@property (retain, nonatomic) IBOutlet UILabel *couponLabel;//使用的优惠卷
@property (retain, nonatomic) IBOutlet UIButton *useCouponBtn;//使用优惠卷的按钮
@property (retain, nonatomic) IBOutlet UILabel *couponMoney;//优惠卷抵用金额

@property (retain, nonatomic) IBOutlet UIView *rechargeView;//使用余额view
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *rechargeViewH;
@property (retain, nonatomic) IBOutlet UILabel *rechargeLbl;//使用余额
@property (retain, nonatomic) IBOutlet UIButton *useRechargeBtn;//使用余额的按钮

@property (retain, nonatomic) IBOutlet UILabel *amountLbl;//还需要支付的金额

@property (retain, nonatomic) IBOutlet UIView *payView;//支付方式view
@property (retain, nonatomic) IBOutlet UIView *amountView;//还需支付view
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *amountViewH;//还需支付view高度

@property (retain, nonatomic) IBOutlet UIControl *contentView;
@property (retain, nonatomic) IBOutlet UITableView *payTV;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;//高度
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *payViewH;//支付方式view的高度


- (IBAction)paySure;
- (IBAction)useCoupon;
- (IBAction)useRecharge;

- (instancetype)initWithTnum:(NSString *)tnum;

@end
