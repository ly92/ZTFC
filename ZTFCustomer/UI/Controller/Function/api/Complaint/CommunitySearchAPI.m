//
//  CommunitySearchAPI.m
//  ztfCustomer
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CommunitySearchAPI.h"

@interface CommunitySearchAPI ()
{
    NSString *_bid;
}
@end

@implementation CommunitySearchAPI

-(instancetype)initWithBid:(NSString *)bid{
    if (self == [super init]) {
        _bid = bid;
    }
    return self;
}
-(NSString *)requestUrl{
    return COMMUNITY_SEARCH;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"keyword":_bid};
}
@end
