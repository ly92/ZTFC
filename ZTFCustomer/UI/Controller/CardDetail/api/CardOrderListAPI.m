//
//  CardOrderListAPI.m
//  EstateBiz
//
//  Created by ly on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CardOrderListAPI.h"

@interface CardOrderListAPI ()
{
    NSString *_pagesize;
    NSString *_last_id;
    NSString *_bid;
}
@end

@implementation CardOrderListAPI
- (instancetype)initWithPagesize:(NSString *)pagesize LastId:(NSString *)last_id Bid:(NSString *)bid{
    if (self = [super init]){
        _pagesize = pagesize;
        _last_id = last_id;
        _bid = bid;
    }
    return self;
}

-(NSString *)requestUrl{
    return BIZORDER_ORDERLIST_URL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"bid" : _bid,
             @"pagesize" : _pagesize,
             @"last_id" : _last_id
             };
}
@end
