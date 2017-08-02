//
//  HotSearchAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HotSearchAPI.h"

@interface HotSearchAPI ()
{
    NSString *_limits;
}
@end

@implementation HotSearchAPI

-(instancetype)initWithLimits:(NSString *)limits{
    if (self == [super init]) {
        _limits = limits;
    }
    return self;
}

-(NSString *)requestUrl{
    return SEARCH_HOTL_LIST;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"limits":_limits};
}

@end
