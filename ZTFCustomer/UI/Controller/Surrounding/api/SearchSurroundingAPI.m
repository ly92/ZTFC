//
//  SearchSurroundingAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/31.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SearchSurroundingAPI.h"

@interface SearchSurroundingAPI ()
{
    NSString *_keyword;
    NSString *_bid;
    NSString *_radius;
    NSString *_limit;
    NSString *_skip;
    NSString *_industryid;
}
@end


@implementation SearchSurroundingAPI

-(instancetype)initSurroundingWithKeyword:(NSString *)keyword bid:(NSString *)bid radius:(NSString *)radius limit:(NSString *)limit skip:(NSString *)skip industryid:(NSString *)industryid{
    if (self == [super init]) {
        _keyword = keyword;
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
    return @{@"keyword":_keyword,
             @"bid":_bid,
             @"radius":_radius,
             @"limit":_limit,
             @"skip":_skip,
             @"industryid":_industryid};
}

@end
