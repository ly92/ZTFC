//
//  SurroundingListAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/31.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SurroundingListAPI.h"

@interface SurroundingListAPI ()
{
    NSString *_bid;
    NSString *_radius;
    NSString *_limit;
    NSString *_skip;
    NSString *_industryid;
}
@end


@implementation SurroundingListAPI

-(instancetype)initWithBid:(NSString *)bid radius:(NSString *)radius limit:(NSString *)limit skip:(NSString *)skip industryid:(NSString *)industryid{
    if (self == [super init]) {
        _bid = bid;
        _radius = radius;
        _limit = limit;
        _skip = skip;
        _industryid = industryid;
    }
    return self;
}


-(NSString *)requestUrl{
    return SURROUNDING_NEARSHOP;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"bid":_bid,
             @"radius":_radius,
             @"limit":_limit,
             @"skip":_skip,
             @"industryid":_industryid};
}

@end
