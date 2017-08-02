//
//  SubscribeListAPI.m
//  EstateBiz
//
//  Created by ly on 16/6/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SubscribeListAPI.h"

@interface SubscribeListAPI ()
{
    NSString *_bid;
    NSString *_last_id;
    NSString *_pagesize;
}
@end

@implementation SubscribeListAPI
- (instancetype)initWithBid:(NSString *)bid LastId:(NSString *)last_id Pagesize:(NSString *)pagesize{
    if (self = [super init]){
        _bid = bid;
        _last_id = last_id;
        _pagesize = pagesize;
    }
    return self;
}

-(NSString *)requestUrl{
    return APPOINTMENT_GETLIST_URL;
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
