//
//  HouseTypeListAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HouseTypeListAPI.h"

@interface HouseTypeListAPI ()
{
    NSString *_projectId;
    NSString *_skip;
    NSString *_limit;
}
@end

@implementation HouseTypeListAPI

-(instancetype)initWithProjectId:(NSString *)projectId skip:(NSString *)skip limit:(NSString *)limit{
    if (self == [super init]) {
        _projectId = projectId;
        _skip = skip;
        _limit = limit;
    }
    return self;
}
-(NSString *)requestUrl{
    return PROJECT_HOUSETYPE_LIST;
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
