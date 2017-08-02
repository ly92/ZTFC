//
//  GetMemberCardAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 17/1/10.
//  Copyright © 2017年 Magicsoft. All rights reserved.
//

#import "GetMemberCardAPI.h"

@interface GetMemberCardAPI ()
{
    NSString *_bid;
}
@end

@implementation GetMemberCardAPI

-(instancetype)initWithBid:(NSString *)bid{
    if (self = [super init]) {
        _bid = bid;
    }
    return self;
}
-(NSString *)requestUrl{
    return BIZSTORE_GET_SINGLE;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{@"bid" : _bid};
}
@end
