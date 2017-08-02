//
//  SendCouponAPI.m
//  EstateBiz
//
//  Created by ly on 16/6/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SendCouponAPI.h"

@interface SendCouponAPI()
{
    NSString *_sn;
    NSString *_mobile;
}
@end

@implementation SendCouponAPI
- (instancetype)initWithSn:(NSString *)sn Mobile:(NSString *)mobile{
    if (self = [super init]){
        _sn = sn;
        _mobile = mobile;
    }
    return self;
}
-(NSString *)requestUrl{
    return COUPON_GIVEMUTISN;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"sn" : _sn,
             @"mobile" : _mobile
             };
}


@end
