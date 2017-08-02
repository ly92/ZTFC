//
//  SearchMemberCardAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SearchMemberCardAPI.h"

@interface SearchMemberCardAPI ()
{
    NSString *_skeys;
    NSString *_lastId;
    NSString *_pagesize;
}
@end

@implementation SearchMemberCardAPI

-(instancetype)initWithskeys:(NSString *)skeys lastId:(NSString *)lastId pagesize:(NSString *)pagesize{
    if (self == [super init]) {
        _skeys = skeys;
        _lastId = lastId;
        _pagesize = pagesize;
    }
    return self;
}

-(NSString *)requestUrl{
    return SEARCH_MEMBERCARD_URL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"skeys":_skeys,
             @"last_id":_lastId,
             @"pagesize":_pagesize};
}

@end
