//
//  GetPayOrderAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/21.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "GetPayOrderAPI.h"


@interface GetPayOrderAPI ()
{
    NSString *_tnum;
    NSString *_amount;
    NSString *_content;
    NSString *_memo;
    NSString *_chargeAmount;
    NSString *_userBalance;
    NSString *_couponAmount;
    NSString *_couponSn;
    
    NSString *_payparam;
}
@end
@implementation GetPayOrderAPI

-(instancetype)initWithTnum:(NSString *)tnum amount:(NSString *)amount content:(NSString *)content memo:(NSString *)memo chargeAmount:(NSString *)chargeAmount userBalance:(NSString *)userBalance couponAmount:(NSString *)couponAmount couponSn:(NSString *)couponSn orgtype:(NSString *)orgtype orgid:(NSString *)orgid orgAccount:(NSString *)orgAccount desttype:(NSString *)desttype destno:(NSString *)destno destaccount:(NSString *)destaccount{
    if (self == [super init]) {
        _tnum = tnum;
        _amount = amount;
        _content = content;
        _memo = memo;
        _chargeAmount = chargeAmount;
        _userBalance = userBalance;
        _couponAmount = couponAmount;
        _couponSn = couponSn;
        
        NSMutableDictionary *type=[NSMutableDictionary dictionary];
        [type setObject:orgtype forKey:@"orgtype"];
        [type setObject:orgid forKey:@"orgid"];
        [type setObject:orgAccount forKey:@"orgaccount"];
        [type setObject:desttype forKey:@"desttype"];
        [type setObject:destno forKey:@"destno"];
        [type setObject:destaccount forKey:@"destaccount"];
       
        _payparam = [type mj_JSONString];
        
    }
    return self;
}

-(NSString *)requestUrl{
    return PAY_GETPREPAYMENT;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}


-(id)requestArgument{
    return @{@"tnum":_tnum,
             @"Amount":_amount,
             @"content":_content,
             @"Memo":_memo,
             @"ChargeAmount":_chargeAmount,
             @"UserBalance":_userBalance,
             @"CouponAmount":_couponAmount,
             @"CouponSN":_couponSn,
             @"payparam":_payparam
             };
}
@end
