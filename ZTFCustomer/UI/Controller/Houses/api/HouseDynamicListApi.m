//
//  HouseDynamicListApi.m
//  ZTFCustomer
//
//  Created by 李勇 on 2017/9/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HouseDynamicListApi.h"

@interface HouseDynamicListApi ()
{
    NSString *_projectId;
    NSString *_skip;
    NSString *_limit;
}
@end

@implementation HouseDynamicListApi
-(instancetype)initWithProjectId:(NSString *)projectId skip:(NSString *)skip limit:(NSString *)limit{
    if (self == [super init]) {
        _projectId = projectId;
        _skip = skip;
        _limit = limit;
    }
    return self;
}
-(NSString *)requestUrl{
    return PROJECT_HOUSEDYNAMIC_LIST;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{@"project_id":_projectId,
             @"skip":_skip,
             @"limit":_limit};
}

@end
