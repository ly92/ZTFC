//
//  CouponListAPI.h
//  EstateBiz
//
//  Created by ly on 16/6/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

typedef NS_ENUM(NSInteger,COUPONTYPE) {
    COUPONLIST, //优惠券列表
    COUPONEXPIRELIST  //过期优惠券列表
};

@interface CouponListAPI : YTKRequest
- (instancetype)initWithBid:(NSString *)bid Count:(NSString *)count Limit:(NSString *)limit;
@property (nonatomic, assign) COUPONTYPE couponType;


@end

