//
//  CardPointAPI.m
//  EstateBiz
//
//  Created by ly on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CardPointAPI.h"
@interface CardPointAPI()
{
    NSString *_bid;
    NSString *_limits;
    NSString *_last_id;
    NSString *_last_datetime;
    NSString *_cid;
}
@end
@implementation CardPointAPI
- (instancetype)initWithBid:(NSString *)bid Limits:(NSString *)limits LastId:(NSString *)last_id LastDatetime:(NSString *)last_datetime Cid:(NSString *)cid{
    if (self = [super init]){
        _bid = bid;
        _limits = limits;
        _last_id = last_id;
        _last_datetime = last_datetime;
        _cid = cid;
    }
    return self;
}


-(NSString *)requestUrl{
    return POINTS_TRANSACTION_LIST_URL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"bid" : _bid,
             @"limits" : _limits,
             @"last_id" : _last_id,
             @"last_datetime" : _last_datetime,
             @"cid" : _cid
             };
}

@end
