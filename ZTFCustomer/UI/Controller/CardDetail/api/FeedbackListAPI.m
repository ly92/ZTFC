//
//  FeedbackListAPI.m
//  EstateBiz
//
//  Created by ly on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "FeedbackListAPI.h"

@interface FeedbackListAPI ()
{
    NSString *_pagesize;
    NSString *_last_id;
    NSString *_bid;
}
@end

@implementation FeedbackListAPI
- (instancetype)initWithPagesize:(NSString *)pagesize LastId:(NSString *)last_id Bid:(NSString *)bid{
    if (self = [super init]){
        _pagesize = pagesize;
        _last_id = last_id;
        _bid = bid;
    }
    return self;
}


-(NSString *)requestUrl{
    return MEMBERFEEDBACK_LIST_URL;
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
