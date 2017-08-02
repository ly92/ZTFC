//
//  CardTransactionDetailModel.h
//  EstateBiz
//
//  Created by ly on 16/6/15.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TransactionDetailData;
@interface CardTransactionDetailModel : NSObject
@property (nonatomic, copy) NSString * reason;//""
@property (nonatomic, copy) NSString * result;//0
@property (nonatomic, strong) TransactionDetailData *data;
@end

@interface TransactionDetailData: NSObject
@property (nonatomic, copy) NSString * adminid;//""
@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSNumber * bid;//0
@property (nonatomic, copy) NSString * cardid;
@property (nonatomic, copy) NSString * charge_amount;
@property (nonatomic, copy) NSString * cid;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * coupon_amount;
@property (nonatomic, copy) NSString * coupon_sn;
@property (nonatomic, copy) NSString * creationtime;
@property (nonatomic, copy) NSString * discount;
@property (nonatomic, copy) NSString * discount_amount;
@property (nonatomic, copy) NSString * is_coupon;
@property (nonatomic, copy) NSString * is_rate;
@property (nonatomic, copy) NSString * itemlist;
@property (nonatomic, copy) NSString * maintype;
@property (nonatomic, copy) NSString * membercardid;
@property (nonatomic, copy) NSString * modifiedtime;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * need_pay;
@property (nonatomic, copy) NSString * rate;
@property (nonatomic, copy) NSString * rate_amount;
@property (nonatomic, copy) NSString * receipt;
@property (nonatomic, copy) NSString * saving_amount;
@property (nonatomic, copy) NSString * subtype;
@property (nonatomic, copy) NSString * tcid;
@property (nonatomic, copy) NSString * tid;
@property (nonatomic, copy) NSString * tmemo;
@property (nonatomic, copy) NSString * tnum;
@property (nonatomic, strong) NSArray * transaction_coupon;
@property (nonatomic, copy) NSString * tstatus;
@property (nonatomic, copy) NSString * user_balance;

@end

@interface TransactionCoupon: NSObject
@property (nonatomic, copy) NSString * biz_coupon_id;//""
@property (nonatomic, copy) NSString * biz_coupon_sn_id;
@property (nonatomic, copy) NSString * sn;
@property (nonatomic, copy) NSString * t_coupon_id;
@property (nonatomic, copy) NSString * title;
@end
