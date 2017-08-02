//
//  GetRechargeComboListAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/21.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "GetRechargeComboListAPI.h"

@interface GetRechargeComboListAPI ()
{
    NSString *_bid;
    NSString *_skip;
    NSString *_limit;
}
@end

@implementation GetRechargeComboListAPI

-(instancetype)initWithBid:(NSString *)bid skip:(NSString *)skip limit:(NSString *)limit{
    if (self == [super init]) {
        _bid = bid;
        _skip = skip;
        _limit = limit;
    }
    return self;
}

-(NSString *)requestUrl{
    return RECHARGE_GETCOMBO;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"bid":_bid,
             @"skip":_skip,
             @"limit":_limit
             };
}

@end
