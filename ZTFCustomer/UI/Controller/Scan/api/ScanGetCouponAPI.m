//
//  ScanGetCouponAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/15.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ScanGetCouponAPI.h"

@interface ScanGetCouponAPI ()
{
    NSString *_couponid;
}
@end

@implementation ScanGetCouponAPI


-(instancetype)initWithCouponid:(NSString *)couponid{
    if (self == [super init]) {
        _couponid = couponid;
    }
    return self;
}


-(NSString *)requestUrl{
    switch (self.couponType) {
        case COUPONINFO:
             return COUPON_INFO_URL;
            break;
        case GETCOUPON:
            return COUPON_GET_URL;
            break;
        default:
            break;
    }
   
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"couponid":_couponid};
}

@end
