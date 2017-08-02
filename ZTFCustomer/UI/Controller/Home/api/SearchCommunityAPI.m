//
//  SearchCommunityAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/20.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SearchCommunityAPI.h"

@interface SearchCommunityAPI ()
{
    NSString *_keyword;
}
@end

@implementation SearchCommunityAPI

-(instancetype)initWithKeyword:(NSString *)keyword{
    if (self == [super init]) {
        _keyword = keyword;
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
    return @{@"keyword":_keyword};
}

@end
