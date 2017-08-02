//
//  GetPayOrderAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/21.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

//获得预支付订单
@interface GetPayOrderAPI : YTKRequest

-(instancetype)initWithTnum:(NSString *)tnum amount:(NSString *)amount content:(NSString *)content memo:(NSString *)memo chargeAmount:(NSString *)chargeAmount userBalance:(NSString *)userBalance couponAmount:(NSString *)couponAmount couponSn:(NSString *)couponSn orgtype:(NSString *)orgtype orgid:(NSString *)orgid orgAccount:(NSString *)orgAccount desttype:(NSString *)desttype destno:(NSString *)destno destaccount:(NSString *)destaccount;

@end
