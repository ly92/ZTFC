//
//  HouseTypeCollectAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HouseTypeCollectAPI.h"


@interface HouseTypeCollectAPI ()
{
    NSString *_projectId;
    NSString *_housetypeId;
}
@end

@implementation HouseTypeCollectAPI

-(instancetype)initWithProjectId:(NSString *)projectId housetypeId:(NSString *)housetypeId{
    if (self == [super init]) {
        _projectId = projectId;
        _housetypeId = housetypeId;
    }
    return self;
}

-(NSString *)requestUrl{
    switch (self.housetypeCollectType) {
        case housetypeCollectType:
            return PROJECT_HOUSETYPE_COLLECT;
            break;
        case housetypeCancelCollectType:
            return PROJECT_HOUSETYPE_CANCELCOLLECT;
            break;

        default:
            break;
    }
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"project_id" : _projectId,
             @"house_type_id" : _housetypeId};
}

@end
