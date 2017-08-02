//
//  CouponListAPI.m
//  EstateBiz
//
//  Created by ly on 16/6/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CouponListAPI.h"

@interface CouponListAPI()
{
    NSString *_bid;
    NSString *_count;
    NSString *_limit;
}
@end

@implementation CouponListAPI
- (instancetype)initWithBid:(NSString *)bid Count:(NSString *)count Limit:(NSString *)limit{
    if (self = [super init]){
        _bid = bid;
        _count = count;
        _limit = limit;
    }
    return self;
}

-(NSString *)requestUrl{
    switch (self.couponType) {
        case COUPONLIST:
            return COUPON_MYLIST_URL;
            break;
        case COUPONEXPIRELIST:
            return COUPON_EXPIRELIST;
            break;
        default:
            break;
    }
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"bid" : _bid,
             @"count" : _count,
             @"limit" : _limit
             };
}


@end
