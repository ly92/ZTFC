//
//  CouponOverdueAPI.m
//  EstateBiz
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CouponOverdueAPI.h"

@interface CouponOverdueAPI ()
{
    NSString *_snid;
}
@end

@implementation CouponOverdueAPI

-(instancetype)initWithSnid:(NSString *)snid{
    if (self == [super init]) {
        _snid = snid;
    }
    return self;
}

-(NSString *)requestUrl{
    return COUPON_OVERDUE;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"snid":_snid};
}
@end
